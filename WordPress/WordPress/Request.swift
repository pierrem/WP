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
    public func fetchLastPosts (page:Int, number:Int, completionHandler:@escaping (Array<Dictionary<String, AnyObject>>?, NSError?) -> Void) {
        let requestURL = baseURL! + "/posts/?page=\(page)&number=\(number)&fields=ID,title,date,featured_image"
        let url = URL(string: requestURL)!
        let urlSession = URLSession.shared

        let dataTask = urlSession.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                completionHandler(nil, error as NSError?);
                return;
            }
            var jsonError: NSError?
            var jsonResult:Any?
            do {
                jsonResult = try JSONSerialization.jsonObject(with: data!, options: [])
            } catch let error as NSError {
                jsonError = error
                jsonResult = nil
            } catch {
                fatalError()
            }
            var articles:Array<Dictionary<String, AnyObject>> = []

            if let resultDictionary = jsonResult as? Dictionary<String, AnyObject>,
                let posts = resultDictionary["posts"] as? [Dictionary<String, AnyObject>] {
                for post in posts {
                    if let _ = post["ID"] as? Int,
                        let _ = post["title"] as? String  {
                        articles.append(post)
                    }
                }
            }
            completionHandler(articles, jsonError);
        })
        
        dataTask.resume()
    }
    
}

