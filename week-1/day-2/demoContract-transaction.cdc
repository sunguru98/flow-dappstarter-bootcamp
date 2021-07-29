import DemoContract from 0x01;

transaction {
    let name: String;

    prepare(account: AuthAccount) {
        let accountAddress: String = account.address.toString();
        log("SIGNER: ".concat(accountAddress))
        self.name = accountAddress
    }

    execute {
        DemoContract.setValue(_value: 16)
    }
}