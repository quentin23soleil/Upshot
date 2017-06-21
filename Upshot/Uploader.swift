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
    
    enum Response {
        case success(String)
        case failure
    }
    
    var fileURL : URL
    
    init(file : URL) {
        self.fileURL = file
    }

    fileprivate class func uploadURL(fileURL: URL) -> URL {
        
        var url = SettingsManager.sharedInstance.url
        let fileNameURLSafe = fileURL.lastPathComponent.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        url = url.replacingOccurrences(of: "%%%filename%%%", with: fileNameURLSafe)
        
        return URL(string: url)!
    }
    
    func upload(callback: @escaping (Response) -> Void) {
        
        let url = Uploader.uploadURL(fileURL: fileURL)
        
        Alamofire.upload(fileURL, to: url).responseString(completionHandler: {response in
            
            if let result = response.result.value {
                callback(.success(result))
            } else {
                callback(.failure)
            }
        })
    }
}

