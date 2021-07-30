pub contract Hello {
  pub var value: Int;
  pub event ValueSet(newValue: Int);

  init() {
    self.value = 0;
  }

  pub fun setValue(value: Int) {
    self.value = value;
    emit ValueSet(newValue: value);
  }

  pub fun getValue(): Int {
    return self.value;
  }
}