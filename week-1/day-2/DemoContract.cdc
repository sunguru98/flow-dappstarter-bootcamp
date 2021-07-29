pub contract DemoContract {
    pub var value: UInt;

    init() {
        self.value = 0;
    }

    pub fun sayHi(): String {
        return "Hi there";
    }

    pub fun sayMyName(_name: String): String {
        return "HOLA ".concat(_name);
    }

    pub fun setValue(_value: UInt) {
        self.value = _value;
    }

    pub fun getValue(): UInt {
        return self.value
    }
}