//
//  Util.swift
//  BallCourts
//
//  Created by Chris Wong on 2016-03-05.
//  Copyright © 2016 Chris Wong. All rights reserved.
//

import Foundation
import UIKit

class Util {
    
    static let util = Util()
 
    func decodeToUIImage(base64String: String) -> UIImage {
        
        let decodedData = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions())
        let decodedImage = UIImage(data: decodedData!)!
        
        return decodedImage
    }
    
    func encodeToBase64String(fileName: String) -> String {
        
        let uploadImage = UIImage(named: fileName)
        let imageData = UIImageJPEGRepresentation(uploadImage!, 1.0)!
        let base64String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)

        return base64String
    }
}