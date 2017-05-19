//
//  PostRequest.swift
//  WordPress
//
//  Created by Pierre Marty on 12/05/2017.
//  Copyright © 2017 alpeslog. All rights reserved.
//

//
// a request returning posts
//

import Foundation

import Foundation

public class PostRequest: NSObject
{
    private var baseURL = ""
    private var page:Int? = nil
    private var perPage:Int? = nil
    private var search:String? = nil

    private var requestURL = ""
    private var isFirstParameter = true       // for building the http request

    public convenience init(url: String, page:Int?=nil, perPage:Int?=nil, search:String?=nil) {
        self.init()
        self.baseURL = url
        self.page = page            // page parameter is one based [1..[
        self.perPage = perPage
        self.search = search
    }


    public func fetchLastPosts (completionHandler:@escaping (Array<Post>?, Error?) -> Void) {
        requestURL = baseURL + "/posts"
        isFirstParameter = true
        if let page = self.page {
            self.addParameter("page", page)
        }

        if let perPage = self.perPage {
            self.addParameter("per_page", perPage)
        }

        if let search = self.search {
            self.addParameter("search", search)
        }

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
            //var articles:Array<Dictionary<String, AnyObject>> = []

            var posts:Array<Post> = []

            if let postArray = jsonResult as? [Dictionary<String, AnyObject>] {
                for postDictionary in postArray {
                    if let post = Post(data:postDictionary) {
                        posts.append(post)
                    }
//                    if let _ = post["id"] as? Int,
//                        let _ = post["title"] as? Dictionary<String, String>  {     // "title": {"rendered": "NessContact" },
//                        articles.append(post)
//                    }
                }
            }
            completionHandler(posts, jsonError);
        })

        dataTask.resume()
    }

    private func addParameter (_ name:String, _ value:Any) {
        if isFirstParameter {
            requestURL += "?\(name)=\(value)"
            isFirstParameter = false
        }
        else {
            requestURL += "&\(name)=\(value)"
        }
    }
}

