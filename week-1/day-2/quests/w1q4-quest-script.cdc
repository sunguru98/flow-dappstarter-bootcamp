import Artist from 0x02

/** Generates integer array of length n 
 @dev param length: Int
 @dev returns: [Int]
*/
pub fun generateUIntArray(length: UInt8): [Int] {
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
pub fun generateEdgeBorder(width: UInt8): String {
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
pub fun display(canvas: Artist.Canvas): Void {
  // Top border
  log(generateEdgeBorder(width: canvas.width))
  // Content
  let pixels = deserializePixelString(serializedString: canvas.pixels, width: canvas.width)
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
pub fun deserializePixelString(serializedString: String, width: UInt8): [String] {
  let pixelStringArr: [String] = [];
  for counter in generateUIntArray(length: width) {
    pixelStringArr.append(serializedString.slice(from: (counter - 1) * Int(width), upTo: ((counter - 1) * Int(width)) + Int(width)))
  }
  return pixelStringArr
}


pub fun main(): Bool {
    let addresses: [Address] = [0x01, 0x02, 0x03, 0x04, 0x05]
    for address in addresses {
      let collectionRef: &Artist.Collection? = getAccount(address).getCapability<&Artist.Collection>(/public/ArtistCollection).borrow()
      if collectionRef != nil {
        log("YAY")
        let collection = collectionRef!
        let collectionLength = collection.collections.length

        for counter in generateUIntArray(length: UInt8(collectionLength)) {
          let canvas: Artist.Canvas = collection.collections[counter - 1].canvas
          log("COLLECTION CANVAS PRINTING")
          display(canvas: canvas)
        }
      } else {
        log(address.toString().concat(" HAS NO COLLECTION"))
      }
    }
    return true;
}