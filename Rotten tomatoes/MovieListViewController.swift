//
//  MovieListViewController.swift
//  Rotten tomatoes
//
//  Created by Scott Woody on 9/13/14.
//  Copyright (c) 2014 Scott Woody. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var listNavigationItem: UINavigationItem!
    var moviesArray: NSArray?
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MMProgressHUD.setPresentationStyle(MMProgressHUDPresentationStyle.None)
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict
        listNavigationItem.hidesBackButton = true
        
        // Set up the pull to refresh control
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.movieTableView.addSubview(refreshControl)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let userMovies = userDefaults.objectForKey("movies") as NSArray?

        if userMovies == nil{
            refresh(self)
        } else {
            moviesArray = userMovies
            self.movieTableView.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    func refresh(sender: AnyObject){
        // TODO: add loader
        MMProgressHUD.showWithTitle("Loading movies please wait ...")
        let YourApiKey = "kzfxytvgu7feujaph7vxbssb"
        let RottenTomatoesURLString = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=" + YourApiKey
        let request = NSMutableURLRequest(URL: NSURL.URLWithString(RottenTomatoesURLString))
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
            MMProgressHUD.dismiss()
            self.refreshControl.endRefreshing()
            var errorValue: NSError? = nil
            if error != nil{
                    CSNotificationView.showInViewController(self, tintColor: UIColor.redColor(), image: nil, message: "Network Error!", duration: 5.0)
                
                
            } else{
                let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as NSDictionary
                self.moviesArray = dictionary["movies"] as? NSArray
                self.movieTableView.reloadData()
                NSUserDefaults.standardUserDefaults().setObject(self.moviesArray, forKey: "movies")
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if moviesArray != nil {
            return moviesArray!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = movieTableView.dequeueReusableCellWithIdentifier("com.codepath.rottentomatoes.moviecell") as MovieTableViewCell
        let movieDictionary = moviesArray![indexPath.row] as NSDictionary
        cell.titleLabel.text = movieDictionary["title"] as NSString
        let poster_url_string = (movieDictionary["posters"] as NSDictionary)["thumbnail"] as NSString
        let poster_url = NSURL.URLWithString(poster_url_string)
        cell.posterImageView.setImageWithURL(poster_url)
        cell.posterImageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        cell.synopsisLabel.text = movieDictionary["synopsis"] as NSString
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as MovieDetailsViewController
        let movieDictionary = sender as NSDictionary
        vc.movieSynopsis = movieDictionary["synopsis"] as? NSString
        vc.movieTitle = movieDictionary["title"] as? NSString
        let poster_url = (movieDictionary["posters"] as NSDictionary)["thumbnail"] as NSString
        let large_poster_url = poster_url.stringByReplacingOccurrencesOfString("tmb", withString: "ori")
        vc.posterURLString = large_poster_url
        vc.movieRating = movieDictionary["mpaa_rating"] as? NSString
        vc.movieYear = String(movieDictionary["year"] as Int)
        let ratings = movieDictionary["ratings"] as NSDictionary
        let critics_rating = ratings["critics_rating"] as? String
        let critics_score = (ratings["critics_score"] as? Int)
        vc.movieScore = "Critics: \(critics_rating!) (\(String(critics_score!)))"
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let movieDictionary = moviesArray![indexPath.row] as NSDictionary
        performSegueWithIdentifier("movieDetailsSegue", sender: movieDictionary)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
