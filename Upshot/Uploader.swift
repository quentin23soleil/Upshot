//
//  Uploader.swift
//  Upshot
//
//  Created by Quentin Dommerc on 17/07/15.
//  Copyright © 2015 Quentin Dommerc. All rights reserved.
//

import Foundation
import Alamofire

class Uploader {
    
    var fileURL : NSURL
    
    init(file : NSURL) {
        self.fileURL = file
    }

    func upload(success : String -> Void, error : Void -> Void) -> Void {
        let url = "http://quentin-dommerc.com/scrup/recv.php?name=" + fileURL.lastPathComponent!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        Alamofire.upload(.POST, URLString: url, file: fileURL)
            .responseString { (request, response, responseUrl, error) in
                if let newUrl = responseUrl {
                    success(newUrl)
                } else {
                    error
                }

        }
    }
    
}