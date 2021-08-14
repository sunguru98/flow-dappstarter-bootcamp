access(all) contract SomeContract {
    pub var testStruct: SomeStruct

    pub struct SomeStruct {
        // 4 Variables

        pub(set) var a: String

        pub var b: String

        access(contract) var c: String

        access(self) var d: String

        // 3 Functions

        pub fun publicFunc() {}

        access(self) fun privateFunc() {}

        access(contract) fun contractFunc() {}


        pub fun structFunc() {
            // Area 1
            self.a = "f"; // Writeable
            log(self.a); // Readable

            self.b = "f"; // Writeable
            log(self.b); // Readable

            self.c = "f"; // Writeable
            log(self.c); // Readable

            self.d = "f"; // Writeable
            log(self.d); // Readable

            self.publicFunc() // Callable
            self.privateFunc() // Callable
            self.contractFunc() // Callable
        }

        init() {
            self.a = "a"
            self.b = "b"
            self.c = "c"
            self.d = "d"
        }
    }

    pub resource SomeResource {
        pub var e: Int

        pub fun resourceFunc() {
            // Area 2
            let str = SomeStruct();

            str.a = "1"; // Writeable
            log(str.a); // Readable

            // str.b = "4"; // Not writeable
            log(str.b); // Readable

            // str.c = "1" // Not writeable
            log(str.c) // Readable

            // str.d = "1" // Not writeable
            // log(str.d) // Not readable

            str.publicFunc() // Callable
            // str.privateFunc() // Not callable
            str.contractFunc() // Callable
        }

        init() {
            self.e = 17
        }
    }

    pub fun createSomeResource(): @SomeResource {
        return <- create SomeResource()
    }

    pub fun questsAreFun() {
        // Area 3

        let str = SomeStruct();

        str.a = "1"; // Writeable
        log(str.a); // Readable

        // str.b = "4"; // Not writeable
        log(str.b); // Readable

        // str.c = "1" // Not writeable
        log(str.c) // Readable

        // str.d = "1" // Not writeable
        // log(str.d) // Not readable

        str.publicFunc() // Callable
        // str.privateFunc() // Not callable
        str.contractFunc() // Callable
    }

    init() {
        self.testStruct = SomeStruct()
    }
}