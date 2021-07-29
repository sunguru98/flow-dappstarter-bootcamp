import Artist from 0x02;

transaction {
    let printerRef: &Artist.Printer;
    let collectionRef: &Artist.Collection;
    
    prepare(account: AuthAccount) {
        account.save(<- Artist.createCollection(), to: /storage/ArtistCollection)
        self.collectionRef = account.borrow<&Artist.Collection>(from: /storage/ArtistCollection) ?? panic("Collection resource not found")
        self.printerRef = getAccount(0x02).getCapability<&Artist.Printer>(/public/ArtistPicturePrinter).borrow() 
            ?? panic("Printer resource not found")
    }

    execute {
        let canvasS: Artist.Canvas = Artist.Canvas(5, 5, Artist.serializeStringArray(stringArray: 
        ["*    ",
         "*    ",
         "*    ",
         "*    ",
         "*****"])
        )

        let canvasU: Artist.Canvas = Artist.Canvas(5, 5, Artist.serializeStringArray(stringArray: 
        ["*****",
         "*   *",
         "*   *",
         "*   *",
         "*****"])
        )

        let pictureS <- self.printerRef.print(canvas: canvasS);
        let pictureU <- self.printerRef.print(canvas: canvasU);

        if pictureS != nil { 
            self.collectionRef.deposit(picture: <- pictureS!)
        } else {
            log("PICTURE ALREADY PRESENT")
            destroy pictureS
        }

        if pictureU != nil {
            self.collectionRef.deposit(picture: <- pictureU!)
        } else {
            log("PICTURE ALREADY PRESENT")
            destroy pictureU
        }
    }
}