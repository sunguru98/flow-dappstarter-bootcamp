// WEEK 1 DAY 1 QUEST 2 (OUTPUT ON LINE NO: 94)
// Question: Create a resource that prints Picture's but only once for each unique 5x5 Canvas.



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

pub resource Printer {
  pub let history: { String: Bool };

  pub fun generateCanvasId(canvas: Canvas): String {
    return canvas.width.toString().concat("-").concat(canvas.height.toString()).concat("-").concat(canvas.pixelString);
  }

  pub fun print(canvas: Canvas): @Picture? {
    let canvasId = self.generateCanvasId(canvas: canvas)

    if self.history[canvasId] == true {
      log("CANVAS ALREADY PRINTED")
      return nil;
    }

    log("PRINTING CANVAS OF WIDTH ".concat(canvas.width.toString()).concat(" PIXELS AND HEIGHT OF ").concat(canvas.height.toString()).concat(" PIXELS."));
    self.history.insert(key: canvasId, true)
    display(canvas: canvas);
    return <- create Picture(_canvas: canvas);
  }

  init() {
    self.history = {};
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

  log(canvasS.pixelString);

  let canvasU = Canvas(_width: 5, _height: 5, _pixelString: serializeStringArray(stringArray: [
    "*   *",
    "*   *",
    "*   *",
    "*   *",
    "*****"
  ]))

  let letterS <- create Picture(_canvas: canvasS)
  destroy letterS

  // QUEST OUTPUT
  let printer <- create Printer()
  let sPicture <- printer.print(canvas: canvasS)
  log(sPicture.getType())
  let sPicture2 <- printer.print(canvas: canvasS)
  log(sPicture2.getType())
  let uPicture <- printer.print(canvas: canvasU)
  log(uPicture.getType())
  let uPicture2 <- printer.print(canvas: canvasU)
  log(uPicture.getType())

  // MEMORY CLEANUP
  destroy uPicture;
  destroy uPicture2;
  destroy sPicture;
  destroy sPicture2;
  destroy printer;
}

