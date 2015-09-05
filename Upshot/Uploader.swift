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

    func upload(success: String -> Void, errorCallback: Void -> Void) -> Void {
        let url = "http://quentin-dommerc.com/scrup/recv.php?name=" + fileURL.lastPathComponent!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        Alamofire.upload(.POST, url, file: fileURL)
            .responseString { (request, response, result) in
                switch result {
                case .Success(let responseUrl):
                    success(responseUrl)
                case .Failure(_, _):
                    errorCallback()
                }
                
        }
    }    
}
