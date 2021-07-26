pub fun joinFistLast(first first:String, last last:String): String {
  return first.concat(" ").concat(last)
}

pub fun main() {
  log(joinFistLast(first: "Sundeep", last: "Charan"))
  log("Hi there");
}
 