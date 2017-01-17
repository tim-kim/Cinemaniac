//
//  ViewController.swift
//  CollectionViewExample
//
//  Created by Tim Kim on 1/16/17.
//  Copyright © 2017 Tim Kim. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var networkError: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var movies: [NSDictionary]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkError.isHidden = true
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControlAction(refreshControl: UIRefreshControl())
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)),
                                 for: UIControlEvents.valueChanged)
        collectionView.insertSubview(refreshControl, at: 0)
    }
    
    
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url as URL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(
            configuration: .default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task: URLSessionDataTask = session.dataTask(with: request) {
            (data: Data?, response: URLResponse?, error: Error?) in
            
            guard error == nil else {
                MBProgressHUD.hide(for: self.view, animated: true)
                refreshControl.endRefreshing()
                self.networkError.isHidden = false
                print(error)
                return
            }
            
            self.networkError.isHidden = true
            MBProgressHUD.hide(for: self.view, animated: true)
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(dataDictionary)
                    
                    self.movies = dataDictionary["results"] as? [NSDictionary]
                    self.collectionView.reloadData()
                    refreshControl.endRefreshing()
                }
            }
        }
        task.resume()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        cell.alpha = 0
        
        let movie = movies![indexPath.row]
        let posterPath = movie["poster_path"] as! String
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        let imageUrl = NSURL(string: baseUrl + posterPath)
        cell.posterView?.setImageWith(imageUrl as! URL)
        
        UIView.animate(withDuration: 2, animations: { cell.alpha = 1 })
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showImage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showImage") {
            let indexPaths = self.collectionView.indexPathsForSelectedItems!
            let indexPath = indexPaths[0] as NSIndexPath
            
            let movie = movies![indexPath.row]
            let vc = segue.destination as! NewViewController
        
            
            let posterPath = movie["poster_path"] as! String
            let baseUrl = "https://image.tmdb.org/t/p/w500"
            let imageUrl = NSURL(string: baseUrl + posterPath)
            
            vc.image.setImageWith(imageUrl as! URL)
            vc.title = (movie["title"] as! String)
            vc.overview = (movie["overview"] as! String)
            vc.date = (movie["release_date"] as! String)
            vc.language = (movie["original_language"] as! String)
        }
    }
    
    
    
    
    
}

