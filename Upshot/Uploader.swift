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

    private class func uploadURL(fileURL fileURL: NSURL) -> NSURL {
        
        var url = SettingsManager.sharedInstance.url
        let fileNameURLSafe = fileURL.lastPathComponent!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        
        url = url.stringByReplacingOccurrencesOfString("%%%filename%%%", withString: fileNameURLSafe)
        
        return NSURL(string: url)!
    }
    
    func upload(success: String -> Void, errorCallback: Void -> Void) -> Void {
        
        let url = Uploader.uploadURL(fileURL: fileURL)
        
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

