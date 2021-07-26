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

  log(canvasS.pixelString)
  let letterS <- create Picture(_canvas: canvasS)
  log(letterS.canvas)
  destroy letterS
}

