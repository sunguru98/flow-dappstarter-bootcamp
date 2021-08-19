import KittyItems from Project.KittyItems
import NonFungibleToken from Flow.NonFungibleToken

transaction {
  prepare(account: AuthAccount) {
    destroy account.load<@KittyItems.Collection>(from: KittyItems.CollectionStoragePath) ?? panic("Cannot borrow kitty item collection resource")
  }
}