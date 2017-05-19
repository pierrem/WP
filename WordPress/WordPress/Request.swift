//
//  Request.swift
//  WordPress
//
//  Created by Pierre Marty on 12/05/2017.
//  Copyright © 2017 alpeslog. All rights reserved.
//

import Foundation

import Foundation

public class Request: NSObject
{

    private var baseURL:String?

    public convenience init(url: String) {
        self.init()
        self.baseURL = url
    }

    // page parameter is one based [1..[
    public func fetchLastPosts (page:Int, number:Int, completionHandler:@escaping (Array<Dictionary<String, AnyObject>>?, Error?) -> Void) {
        let requestURL = baseURL! + "/posts/?page=\(page)&per_page=\(number)"
        let url = URL(string: requestURL)!
        let urlSession = URLSession.shared

        // (Data?, URLResponse?, Error?)
        let dataTask = urlSession.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                completionHandler(nil, error);
                return;
            }
            var jsonError: Error?
            var jsonResult:Any?
            do {
                jsonResult = try JSONSerialization.jsonObject(with:data!, options:[])
            } catch let error {
                jsonError = error
                jsonResult = nil
            }
            var articles:Array<Dictionary<String, AnyObject>> = []

            if let posts = jsonResult as? [Dictionary<String, AnyObject>] {
                for post in posts {
                    if let _ = post["id"] as? Int,
                        let _ = post["title"] as? Dictionary<String, String>  {     // "title": {"rendered": "NessContact" },
                        articles.append(post)
                    }
                }
            }
            completionHandler(articles, jsonError);
        })
        
        dataTask.resume()
    }
    
}

