import KittyItems from Project.KittyItems

pub fun main(account: Address): Bool {
  let collectionRef: &KittyItems.Collection{KittyItems.KittyItemsCollectionPublic}? = getAccount(account).getCapability(KittyItems.CollectionPublicPath).borrow<&KittyItems.Collection{KittyItems.KittyItemsCollectionPublic}>();

  if collectionRef != nil {
    return true
  }

  return false
}