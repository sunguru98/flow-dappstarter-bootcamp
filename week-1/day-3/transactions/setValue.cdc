import Hello from "../contracts/hello.cdc";

transaction {
  prepare(account: AuthAccount) {
    log("SIGNER ACCOUNT".concat(account.address.toString()));
  }

  execute {
    Hello.setValue(value: 15);
    log("VALUE SET SUCCESSFULLY")
  }
}