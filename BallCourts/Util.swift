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
 
    func decodeToUIImage(let base64String: String) -> UIImage {
        let decodedData = NSData(base64EncodedString: base64String, options:NSDataBase64DecodingOptions(rawValue: 0))
        if let convertedData = decodedData {
            let decodedImage = UIImage(data: convertedData)
            return decodedImage!
        }
        return UIImage()
    }
    
    func encodeToBase64String(fileName: String) -> String {
        if let uploadImage = UIImage(named: fileName) {
            if let imageData = UIImageJPEGRepresentation(uploadImage, 1.0){
                let base64String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
                
                return base64String
            }
        }
        return ""
        
    }
}