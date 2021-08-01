import React, { useReducer, useEffect, useCallback } from 'react';
import * as fcl from '@onflow/fcl';
import * as FlowTypes from '@onflow/types';

import Picture from '../model/Picture.js';

const Context = React.createContext({});

function reducer(state, action) {
  switch (action.type) {
    case 'setUser': {
      return {
        ...state,
        user: action.payload,
      };
    }
    case 'setBalance': {
      return {
        ...state,
        balance: action.payload,
      };
    }
    case 'setCollection': {
      if (action.payload) {
        return {
          ...state,
          collection: action.payload,
        };
      } else {
        return {
          ...state,
          collection: action.payload,
        };
      }
    }
    default:
      return state;
  }
}

function Provider(props) {
  const [state, dispatch] = useReducer(reducer, {
    user: null,
    balance: null,
    collection: undefined,
  });

  const isReady = state.balance !== null && state.collection !== undefined;

  const fetchBalance = useCallback(async () => {
    if (state.user.addr && state.user.addr !== '0xLocalArtist') {
      // A sample script execution.
      // Query for the account's FLOW token balance.
      const balance = await fcl
        .send([
          fcl.script`
            import FungibleToken from 0x9a0766d93b6608b7
            import FlowToken from 0x7e60df042a9c0868
  
            pub fun main(address: Address): UFix64 {
              let vaultRef = getAccount(address)
                .getCapability(/public/flowTokenBalance)
                .borrow<&FlowToken.Vault{FungibleToken.Balance}>()
                ?? panic("Could not borrow Balance reference to the Vault");
  
              return vaultRef.balance;
            }
          `,
          fcl.args([fcl.arg(state.user.addr, FlowTypes.Address)]),
        ])
        .then(fcl.decode);

      dispatch({ type: 'setBalance', payload: balance });
    } else {
      return dispatch({ type: 'setBalance', payload: -42 });
    }
  }, [state.user]);

  const createCollection = useCallback(async () => {
    console.log(
      'CREATE COLLECTION FROM CONTRACT',
      process.env.REACT_APP_ARTIST_CONTRACT_HOST
    );

    console.log(fcl.authz);

    const transactionId = await fcl.decode(
      await fcl.send([
        fcl.transaction`
          import LocalArtist from ${process.env.REACT_APP_ARTIST_CONTRACT_HOST};
          transaction {
            prepare(account: AuthAccount) {
              let collection: @LocalArtist.Collection <- LocalArtist.createCollection();

              account.save(<-collection, to: /storage/LocalArtistPictureCollection);
              account.link<&LocalArtist.Collection>(/public/LocalArtistPictureReceiver, target: /storage/LocalArtistPictureCollection);
            }
          }
        `,
        fcl.payer(fcl.authz),
        fcl.proposer(fcl.authz),
        fcl.authorizations([fcl.authz]),
        fcl.limit(9999),
      ])
    );
    console.log(transactionId);
    return fcl.tx(transactionId).onceSealed();
  }, []);

  const destroyCollection = useCallback(async () => {
    const signer = fcl.authz;
    return fcl
      .tx(
        await fcl.decode(
          await fcl.send([
            fcl.transaction(`
        import LocalArtist from ${process.env.REACT_APP_ARTIST_CONTRACT_HOST}

        transaction {
          let collectionRef: @LocalArtist.Collection
          prepare(account: AuthAccount) {
            account.unlink<&LocalArtist.Collection>(/public/LocalArtistCollectionReceiver)

            self.collectionRef <- account.load<@LocalArtist.Collection>(from: /storage/LocalArtistPictureCollection)
          }

          execute {
            destroy self.collectionRef
          }
        }
      `),
            fcl.payer(signer),
            fcl.proposer(signer),
            fcl.authorizations[signer],
          ])
        )
      )
      .onceSealed();
  }, []);

  const fetchCollection = useCallback(
    async (address) => {
      if (address || state.user.addr) {
        try {
          let args = fcl.args([
            fcl.arg(address || state.user.addr, FlowTypes.Address),
          ]);

          const collection = await fcl
            .send([
              fcl.script`
              import LocalArtist from ${process.env.REACT_APP_ARTIST_CONTRACT_HOST}
      
              pub fun main(address: Address): [LocalArtist.Canvas] {
                let account = getAccount(address)
                let pictureReceiverRef = account
                  .getCapability<&LocalArtist.Collection>(/public/LocalArtistPictureReceiver)
                  .borrow()
                  ?? panic("Couldn't borrow picture receiver reference.")
              
                return pictureReceiverRef.getCanvases()
              }
            `,
              args,
            ])
            .then(fcl.decode);

          console.log(collection);

          const mappedCollection = collection.map(
            (serialized) =>
              new Picture(
                serialized.pixels,
                serialized.width,
                serialized.height
              )
          );

          if (address) {
            return mappedCollection;
          } else {
            dispatch({ type: 'setCollection', payload: mappedCollection });
          }
        } catch (error) {
          console.log(error);
          if (address) {
            return null;
          } else {
            dispatch({ type: 'setCollection', payload: null });
          }
        }
      }
    },
    [state.user]
  );
  const printPicture = useCallback(async (picture) => {
    const txId = await fcl.decode(
      await fcl.send([
        fcl.transaction`
        import LocalArtist from ${process.env.REACT_APP_ARTIST_CONTRACT_HOST}

        transaction {
          let printerRef: &LocalArtist.Printer;
          let collectionRef: &LocalArtist.Collection;

          prepare(account: AuthAccount) {
            let deployerAccount: PublicAccount = getAccount(${process.env.REACT_APP_ARTIST_CONTRACT_HOST})

            self.printerRef = deployerAccount.getCapability<&LocalArtist.Printer>(/public/LocalArtistPicturePrinter).borrow() ?? panic("Printer reference does not exist")

            self.collectionRef = account.getCapability<&LocalArtist.Collection>(/public/LocalArtistPictureReceiver).borrow() ?? panic("Collection reference does not exist")
          }

          execute {
            let picture <- self.printerRef.print(width: ${picture.width}, height: ${picture.height}, pixels: "${picture.pixels}")

            if picture != nil {
              self.collectionRef.deposit(picture: <- picture!)
            } else {
              destroy picture
            }
          }
        }
        `,
        fcl.payer(fcl.authz),
        fcl.proposer(fcl.authz),
        fcl.authorizations([fcl.authz]),
        fcl.limit(9999),
      ])
    );

    return fcl.tx(txId).onceSealed();
  }, []);

  const setUser = (user) => {
    dispatch({ type: 'setUser', payload: user });
  };
  const logIn = async () => {
    try {
      fcl.logIn();
    } catch (err) {
      console.error(err);
    }
  };

  const logOut = () => {
    fcl.unauthenticate();
  };

  useEffect(() => {
    fcl.currentUser().subscribe((e) =>
      setUser({
        loggedIn: e.loggedIn,
        addr: e.addr,
      })
    );
  }, []);

  useEffect(() => {
    if (state.user && state.user.addr) {
      fetchBalance();
      fetchCollection();
    }
  }, [state.user, fetchBalance, fetchCollection]);

  return (
    <Context.Provider
      value={{
        state,
        isReady,
        dispatch,
        logIn,
        logOut,
        fetchBalance,
        fetchCollection,
        createCollection,
        destroyCollection,
        printPicture,
      }}
    >
      {props.children}
    </Context.Provider>
  );
}

export { Context as default, Provider };
