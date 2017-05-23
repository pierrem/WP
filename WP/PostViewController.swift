//
//  PostViewController.swift
//  WP
//
//  Created by Pierre Marty on 12/05/2017.
//  Copyright © 2017 alpeslog. All rights reserved.
//

// View displaying one post.
// Content is displayed using an UITextView and NSAttributedString, but we could also use a WebView for that.


import UIKit
import WordPress

class PostViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!

    var post: WordPress.Post? {
        didSet {
            updateView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        contentTextView.isScrollEnabled = false     // to avoid scrolling to bottom of text
        updateView()
        if let id = post?.id {
            self.title = "Post \(id)"
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentTextView.isScrollEnabled = true
    }

    func updateView() {
        if let post = post,
            let titleLabel = titleLabel,
            let contentTextView = contentTextView {   // may be called before outlets are set
            titleLabel.text = String(htmlEncodedString:post.title)

            if let attributedString = post.content.htmlToAttributedString() {
                contentTextView.attributedText = attributedString
            }

        }
    }
}


