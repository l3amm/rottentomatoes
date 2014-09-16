//
//  MovieDetailsViewController.swift
//  Rotten tomatoes
//
//  Created by Scott Woody on 9/13/14.
//  Copyright (c) 2014 Scott Woody. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    var movieRating: NSString?
    var movieScore: NSString?
    var movieSynopsis: NSString?
    var movieTitle: NSString?
    var movieYear: NSString?
    var posterURLString: NSString?

    @IBOutlet weak var detailsNavigationItem: UINavigationItem!
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieDescriptionTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        detailsNavigationItem.title = movieTitle
        movieDescriptionTextView.text = movieSynopsis
        
        let poster_url = NSURL.URLWithString(posterURLString!)
        let request = NSURLRequest(URL: poster_url)
        posterImageView.setImageWithURLRequest(request, placeholderImage: nil, success: {  (req: NSURLRequest!, resp: NSHTTPURLResponse!, image: UIImage!) -> Void in
                println(self.posterImageView.frame)
                self.posterImageView.image = image
            }, failure: nil)
        
        
        let titleLabel = UILabel(frame: CGRectMake(4, -60, 300, 20))
        var titleText = ""
        if movieTitle != nil{
            titleText = movieTitle!
        }
        if movieYear != nil{
            titleText = titleText + " (\(movieYear!))"
        }
        titleLabel.text = titleText
        titleLabel.font = UIFont(name: "Arial-BoldMT", size: 18)
        titleLabel.textColor = UIColor.whiteColor()
        let scoreLabel = UILabel(frame: CGRectMake(4, -40, 300, 20))
        scoreLabel.text = "\(movieScore!)"
        scoreLabel.textColor = UIColor.whiteColor()
        let ratingLabel = UILabel(frame: CGRectMake(4, -20, 300, 20))
        ratingLabel.text = "\(movieRating!)"
        ratingLabel.textColor = UIColor.whiteColor()
        
        movieDescriptionTextView.addSubview(titleLabel)
        movieDescriptionTextView.addSubview(ratingLabel)
        movieDescriptionTextView.addSubview(scoreLabel)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resizeMovieDescription(sender: AnyObject) {
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
