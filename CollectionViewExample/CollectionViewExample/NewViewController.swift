//
//  NewViewController.swift
//  CollectionViewExample
//
//  Created by Tim Kim on 1/16/17.
//  Copyright © 2017 Tim Kim. All rights reserved.
//

import UIKit
import AFNetworking

class NewViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var overviewLabel: UITextView!

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    
    
    var image = UIImageView()
    var overview = ""
    var date = ""
    var language = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: scrollView.frame.size.height + infoView.frame.size.height)
        
        self.imageView.image = self.image.image
        self.overviewLabel.text = self.overview
        self.titleLabel.text = self.title
        self.dateLabel.text = self.date
        
        if (self.language == "en") {
            self.languageLabel.text = "English"
        } else {
            self.languageLabel.text = "International"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
