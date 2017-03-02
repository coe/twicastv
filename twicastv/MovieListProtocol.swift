//
//  MovieListProtocol.swift
//  watchube
//
//  Created by COFFEE on 2017/02/05.
//  Copyright © 2017年 tsuyoshi hyuga. All rights reserved.
//

import Foundation

protocol MovieListProtocol {
    
//    var movies:[TwicasMovie] { get set }
    
    func kind() -> String
    
    func load(limit:Int)
    
    func searchLivesDelegate(movies:[TwicasMovie], response:HTTPURLResponse?, error:Error?)
    
    /// viewDidLoadで呼ぶべきもの
    func viewDidLoadProtocol()
    
    /// deinitで呼ぶべきもの
    func deinitProtocol()
    
    
    
}

extension MovieListProtocol {
    
    func viewDidLoadProtocol()
    {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationDidBecomeActive, object: nil, queue: nil) { (notification) in
            self.load()
        }
        
    }
    
    func deinitProtocol()
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    func load(limit:Int = 50){
        TwicasApi.searchLives(limit: limit, type: kind(), context: nil, lang: "ja", callback: { (movies, response, error) in
            print(#file,#function,#line,"movies \(movies)")
            self.searchLivesDelegate(movies: movies, response: response, error: error)
        })
    }
}
