//
//  Post.swift
//  WordPress
//
//  Created by Pierre Marty on 19/05/2017.
//  Copyright © 2017 alpeslog. All rights reserved.
//

import Foundation

public struct Post : CustomStringConvertible
{
//    public let id: Int
//    public let date: Date
//    public let dateGMT: Date
    public let title: String
//    public let content: String


    public var description: String { return "\n\(title)" }


    init?(data: Dictionary<String, AnyObject>)
    {
        guard
            let titleDictionary = data["title"] as? Dictionary<String, String>,
            let title = titleDictionary["rendered"]
            else {
                return nil
        }

        self.title = title
    }

}
