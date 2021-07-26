pub struct Student {
  pub let id: Int;
  pub let name: String;
  pub let grade: String;

  init(_id: Int, _name: String, _grade: String) {
    self.id =_id;
    self.name = _name;
    self.grade = _grade;
  }
}

pub resource Bank {
  pub let balance: UInt;
  init(_balance : UInt) {
    self.balance = _balance;
  }
}

pub fun main() {
  var sundeep = Student(_id: 1, _name: "Sundeep", _grade: "A");
  let indianBank <- create Bank(_balance: 10);
  destroy indianBank;
}
