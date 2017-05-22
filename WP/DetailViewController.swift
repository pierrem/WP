//
//  DetailViewController.swift
//  WP
//
//  Created by Pierre Marty on 12/05/2017.
//  Copyright © 2017 alpeslog. All rights reserved.
//

import UIKit
import WordPress

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    func configureView() {
        // Update the user interface for the detail item.
        if let post = post {
            if let label = detailDescriptionLabel {
                label.text = post.title
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var post: WordPress.Post? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

