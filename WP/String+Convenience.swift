//
//  String+Convenience.swift
//  WP
//
//  Created by Pierre Marty on 23/05/2017.
//  Copyright © 2017 alpeslog. All rights reserved.
//

import UIKit


// idea from https://stackoverflow.com/questions/25607247/how-do-i-decode-html-entities-in-swift

extension String {
    init(htmlEncodedString: String) {
        self.init()
        if let attributedString = htmlEncodedString.htmlToAttributedString() {
            self = attributedString.string
        }
        else {
            self = htmlEncodedString
        }
    }

    func htmlToAttributedString() -> NSAttributedString? {
        if let data = self.data(using:.utf8) {
            let options:[String : Any] = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                          NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue]
            if let attributedString = try? NSAttributedString(data:data, options:options, documentAttributes:nil) {
                return attributedString
            }
        }
        return nil
    }
    
}


