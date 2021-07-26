// WEEK 1 DAY 1 QUEST 1 (OUTPUT ON LINE NO: 94)

pub struct Canvas {
  pub let width: UInt;
  pub let height: UInt;
  pub let pixelString: String;

  init(_width: UInt, _height: UInt, _pixelString: String) {
    self.width = _width;
    self.height = _height;
    self.pixelString = _pixelString
  }
}

pub resource Picture {
  pub let canvas: Canvas;

  init(_canvas: Canvas) {
    self.canvas = _canvas;
  }
}


/** Generates integer array of length n 
 @dev param length: Int
 @dev returns: [Int]
*/
pub fun generateUIntArray(length: UInt): [Int] {
  let intArr: [Int] = [];
  var counter: Int = 1;

  while counter <= Int(length) {
    intArr.append(counter);
    counter = counter + 1;
  }
  
  return intArr;
}

/** Generates frame edge border for n width 
 @dev param width: Int
 @dev returns: String
*/
pub fun generateEdgeBorder(width: UInt): String {
  var border: String = "+";
  for column in generateUIntArray(length: width) {
    border = border.concat("-");
  }
  border = border.concat("+");
  return border;
}

/** Generates frame border for a canvas
 @dev param canvas: Canvas
 @dev returns: Void
*/
pub fun display(canvas: Canvas): Void {
  // Top border
  log(generateEdgeBorder(width: canvas.width))
  // Content
  let pixels = deserializePixelString(serializedString: canvas.pixelString, width: canvas.width)
  for row in pixels {
    log("|".concat(row).concat("|"))
  }
  // Bottom border
  log(generateEdgeBorder(width: canvas.width))
}


/** Deserializes a string into a string array based on it's width
 @dev param serializedString: String
 @dev param width: UInt
 @dev returns: [String]
*/
pub fun deserializePixelString(serializedString: String, width: UInt): [String] {
  let pixelStringArr: [String] = [];
  for counter in generateUIntArray(length: width) {
    pixelStringArr.append(serializedString.slice(from: (counter - 1) * Int(width), upTo: ((counter - 1) * Int(width)) + Int(width)))
  }
  return pixelStringArr
}

pub fun serializeStringArray(stringArray: [String]): String {
  var serializedString: String = "";
  for element in stringArray {
    serializedString = serializedString.concat(element == nil ? "" : element)
  }
  return serializedString
}

pub fun main() {
  let canvasS = Canvas(_width: 5, _height: 5, _pixelString: serializeStringArray(stringArray: [
    "*****",
    "*    ",
    "*****",
    "    *",
    "*****"
  ]))

  let letterS <- create Picture(_canvas: canvasS)
  destroy letterS

  // QUEST OUTPUT
  display(canvas: canvasS)
}

