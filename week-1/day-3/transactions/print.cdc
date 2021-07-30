import Artist from "../contracts/artist.cdc"

// Print a Picture and store it in the authorizing account's Picture Collection.
transaction(width: UInt8, height: UInt8, pixels: String) {
  let printerRef: &Artist.Printer;
  let collectionRef: &Artist.Collection;

  prepare(account: AuthAccount) {
    self.printerRef = getAccount(0x01cf0e2f2f715450).getCapability<&Artist.Printer>(/public/ArtistPicturePrinter).borrow() ?? panic("Cannot get Printer resource");

    self.collectionRef = account.getCapability<&Artist.Collection>(/public/ArtistCollection).borrow() ?? panic("Cannot get Collection resource");
  }

  execute {
    let canvasL = Artist.Canvas(width: width, height: height, pixels: pixels);
    let pictureL <- self.printerRef.print(canvas: canvasL);
    
    if pictureL != nil { self.collectionRef.deposit(picture: <- pictureL!); }
    else { destroy pictureL; }
  }
}
