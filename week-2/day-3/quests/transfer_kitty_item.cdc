import NonFungibleToken from Flow.NonFungibleToken;
import KittyItems from Project.KittyItems;

// This transaction transfers a Kitty Item from one account to another.

transaction(recipient: Address, withdrawID: UInt64) {
    // local variable for a reference to the signer's Kitty Items Collection
    let signerCollectionRef: &KittyItems.Collection{NonFungibleToken.Provider}

    // local variable for a reference to the receiver's Kitty Items Collection
    let receiverCollectionRef: &{NonFungibleToken.CollectionPublic}

    prepare(signer: AuthAccount) {

        // 1) borrow a reference to the signer's Kitty Items Collection
        self.signerCollectionRef = signer.borrow<&KittyItems.Collection{NonFungibleToken.Provider}>(KittyItems.CollectionStoragePath) ?? panic("Cannot borrow signer collection resource");
        // 2) borrow a public reference to the recipient's Kitty Items Collection
        self.receiverCollectionRef = getAccount(recipient).getCapability().borrow<&{NonFungibleToken.CollectionPublic}>(KittyItems.CollectionPublicPath) ?? panic("Cannot borrow recipient collection resource");
    }

    execute {

        // 3) withdraw the Kitty Item from the signer's Collection
        let kittyItem: @NonFungibleToken.NFT <- signerCollectionRef.withdraw(withdrawID: withdrawID);
        // 4) deposit the Kitty Item into the recipient's Collection
        receiverCollectionRef.deposit(token: <- kittyItem);
    }
}