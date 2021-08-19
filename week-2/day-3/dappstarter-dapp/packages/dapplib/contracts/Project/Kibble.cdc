import FungibleToken from Flow.FungibleToken

pub contract Kibble: FungibleToken {
    // TokensInitialized
    //
    // The event that is emitted when the contract is created
    pub event TokensInitialized(initialSupply: UFix64)

    // TokensWithdrawn
    //
    // The event that is emitted when tokens are withdrawn from a Vault
    pub event TokensWithdrawn(amount: UFix64, from: Address?)

    // TokensDeposited
    //
    // The event that is emitted when tokens are deposited to a Vault
    pub event TokensDeposited(amount: UFix64, to: Address?)

    // TokensMinted
    //
    // The event that is emitted when new tokens are minted
    pub event TokensMinted(amount: UFix64)

    // TokensBurned
    //
    // The event that is emitted when tokens are destroyed
    pub event TokensBurned(amount: UFix64)

    // MinterCreated
    //
    // The event that is emitted when a new minter resource is created
    pub event MinterCreated(allowedAmount: UFix64)

    // Named paths
    //
    pub let VaultStoragePath: StoragePath
    pub let ReceiverPublicPath: PublicPath
    pub let BalancePublicPath: PublicPath
    pub let MinterStoragePath: StoragePath

    // Total supply of Kibbles in existence
    pub var totalSupply: UFix64

    // Vault
    pub resource Vault: FungibleToken.Provider, FungibleToken.Receiver, FungibleToken.Balance {

        // The total balance of this vault
        pub var balance: UFix64

        // initialize the balance at resource creation time
        init(balance: UFix64) {
            self.balance = balance
        }

        // withdraw
        pub fun withdraw(amount: UFix64): @FungibleToken.Vault {
            pre {
                amount <= self.balance:
                    "Kibble: Amount exceeds account kibble balance"
            }

            // 1) Take away 'amount' balance from this Vault
            self.balance = self.balance - amount;
            // 2) emit TokensWithdrawn
            emit TokensWithdrawn(amount: amount, from: self.owner?.address);
            // 3) return a new Vault with balance == 'amount'
            return <- create Vault(balance: amount);
        }

        // deposiit
        pub fun deposit(from: @FungibleToken.Vault) {
            pre {
                from.balance > 0.0:
                    "Kibble: Vault should have atleast 0.1 tokens for depositing"
            }

            // 1) Convert 'from' from a @FungibleToken.Vault to a 
            // new variable called 'vault' of type @Kibble.Vault using 'as!'
            let vault <- from as! @Kibble.Vault;
            // 2) Add the balance inside 'vault' to this Vault
            self.balance = self.balance + vault.balance;
            // 3) emit TokensDeposited
            emit TokensDeposited(amount: vault.balance, to: self.owner?.address)
            // 4) Set 'vault's balance to 0.0
            vault.balance = 0.0;
            // 4) destroy 'vault'
            destroy vault;
        }

        destroy() {
            Kibble.totalSupply = Kibble.totalSupply - self.balance
            if(self.balance > 0.0) {
                emit TokensBurned(amount: self.balance)
            }
        }
    }

    // createEmptyVault
    pub fun createEmptyVault(): @Vault {
        return <-create Vault(balance: 0.0)
    }

    // Minter
    //
    // Resource object to mint new tokens.
    //
    pub resource Minter {

        // mintTokens
        //
        // Function that mints new tokens, adds them to the total supply,
        // and returns them to the calling context.
        //
        pub fun mintTokens(amount: UFix64): @Kibble.Vault {
            // 1) Add a pre-condition to make sure 'amount' is greater than 0.0
            pre {
                amount > 0.0:
                    "Kibble: amount should be greater than 0.0"
            }
            // 2) Update Kibble.totalSupply by adding 'amount'
            Kibble.totalSupply = Kibble.totalSupply + amount;
            // 3) emit TokensMinted
            emit TokensMinted(amount: amount);
            // 4) return a Vault with balance == 'amount'
            return <- create Vault(balance: amount)
        }

        init() {
    
        }
    }

    init() {
        // Set our named paths.
        self.VaultStoragePath = /storage/kibbleVault
        self.ReceiverPublicPath = /public/kibbleReceiver
        self.BalancePublicPath = /public/kibbleBalance
        self.MinterStoragePath = /storage/kibbleMinter

        // Initialize contract state.
        self.totalSupply = 0.0

        // Create the one true Minter object and deposit it into the conttract account.
        let minter <- create Minter()
        self.account.save(<-minter, to: self.MinterStoragePath)

        // Emit an event that shows that the contract was initialized.
        emit TokensInitialized(initialSupply: self.totalSupply)
    }
}