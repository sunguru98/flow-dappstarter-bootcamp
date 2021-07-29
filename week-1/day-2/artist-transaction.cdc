import Artist from 0x02;

transaction {
    let printerRef: &Artist.Printer;
    let pixels: String;

    prepare(account: AuthAccount) {
        self.printerRef = getAccount(0x03).getCapability<&Artist.Printer>(/public/ArtistPicturePrinter).borrow() 
        ?? panic("Printer Capability not found")

        self.pixels = "******    *****    ******"
    }
    
    execute {
        let canvasS = Artist.Canvas(width: self.printerRef.width, height: self.printerRef.height, pixels: self.pixels);
        let pictureS <- self.printerRef.print(canvas: canvasS)
        if (pictureS != nil) { log("PICTURE S PRINTED SUCCESSFULLY") }
        destroy pictureS
    }
}
