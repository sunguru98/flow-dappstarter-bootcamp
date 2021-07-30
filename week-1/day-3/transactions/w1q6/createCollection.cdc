import Artist from "../contracts/artist.cdc"

// Create a Picture Collection for the transaction authorizer.
transaction {
  prepare(account: AuthAccount) {
    account.save(<- Artist.createCollection(), to: /storage/ArtistCollection)
    account.link<&Artist.Collection>(/public/ArtistCollection, target: /storage/ArtistCollection)
  }
}