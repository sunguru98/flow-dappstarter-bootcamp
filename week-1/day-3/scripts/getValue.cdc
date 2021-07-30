import Hello from "../contracts/hello.cdc"

pub fun main(): Int {
  let value = Hello.getValue();
  return value
}