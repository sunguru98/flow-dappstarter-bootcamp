
import SomeContract from 0x01;

pub fun main() {
  // Area 4

  let str = SomeContract.SomeStruct();

  str.a = "1"; // Writeable
  log(str.a); // Readable

  // str.b = "4"; // Not writeable
  log(str.b); // Readable

  // str.c = "1" // Not writeable
  // log(str.c) // Not readable

  // str.d = "1" // Not writeable
  // log(str.d) // Not readable

  str.publicFunc() // Callable
  // str.privateFunc() // Not callable
  // str.contractFunc() // Not Callable
}