//
//  MasterViewController.swift
//  WP
//
//  Created by Pierre Marty on 12/05/2017.
//  Copyright © 2017 alpeslog. All rights reserved.
//

import UIKit
import WordPress

class MasterViewController: UITableViewController {

    var PostViewController: PostViewController? = nil
    // var objects = [Any]()

    var posts = Array<WordPress.Post>()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // navigationItem.leftBarButtonItem = editButtonItem

        if let split = splitViewController {
            let controllers = split.viewControllers
            PostViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? PostViewController
        }

        self.title = "Posts"
    }

    override func viewWillAppear(_ animated: Bool) {
        fetchLastPosts()
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }


    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedPost = posts[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! PostViewController
                controller.post = selectedPost
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let post = posts[indexPath.row]
        cell.textLabel!.text = String(htmlEncodedString:post.title)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }


    func fetchLastPosts() {
//        let siteURL = "https://demo.wp-api.org/wp-json/wp/v2"
//        let postRequest = WordPress.PostRequest(url:siteURL, page:1, perPage:20)

        let siteURL = "https://alpeslog.com/wp-json/wp/v2"
//        let postRequest = WordPress.PostRequest(url:siteURL, page:1, perPage:10, search:"Swift")
        let postRequest = WordPress.PostRequest(url:siteURL, page:1, perPage:10)

        postRequest.fetchLastPosts(completionHandler: { posts, error in
            // print ("posts: \(String(describing: posts)))")
            if let newposts = posts {
                DispatchQueue.main.async {
                    self.posts = newposts
                    self.tableView.reloadData()
                }
            }
        })

    }

}



