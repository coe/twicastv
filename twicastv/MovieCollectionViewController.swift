//
//  MovieCollectionViewController.swift
//  twicastv
//
//  Created by COFFEE on 2017/01/12.
//  Copyright © 2017年 tsuyoshi hyuga. All rights reserved.
//

import UIKit
import AVKit

private let reuseIdentifier = "Cell"

class MovieCollectionViewController: UICollectionViewController,AVPlayerViewControllerDelegate,MovieListProtocol {
    internal func searchLivesDelegate(movies: [TwicasMovie], response: HTTPURLResponse?, error: Error?) {
        self.movies = movies
    }

    
//    var datasource:TwicasDataSource!
    var _movies:[TwicasMovie] = []
    var movies:[TwicasMovie] {
        get {
            return _movies
        }
        set {
            _movies = newValue
            self.collectionView?.reloadData()
        }
    }
    
    func kind() -> String {
        return "recommend"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadProtocol()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
    }
    
    deinit {
        deinitProtocol()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        load()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count

    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Dequeue a cell from the collection view.
        let movie = movies[indexPath.row]

        let cell:MovieCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovieCollectionViewCell
        cell.setData(twicasMovie: movie)
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print(#file,#function,#line)
        let movie = movies[indexPath.row]

        let playerViewController = AVPlayerViewController()
        playerViewController.delegate = self
        
        let player = makePlayer(movie: movie)
        playerViewController.player = player
        
        self.present(playerViewController, animated: true) {
            /*
             Begin playing the media as soon as the controller has
             been presented.
             */
            player.play()
        }
    }
    
}
