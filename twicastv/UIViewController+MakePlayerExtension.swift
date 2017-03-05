//
//  MakePlayerExtension.swift
//  twicastv
//
//  Created by COFFEE on 2017/02/08.
//  Copyright © 2017年 tsuyoshi hyuga. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension UIViewController {
    func makePlayer(movie:TwicasMovie) -> AVPlayer {
        let mediaURL = URL(string: movie.hls_url)!
        let asset = AVAsset(url: mediaURL)
        
        /*
         Create an `AVPlayerItem` for the `AVAsset` and populate it with information
         about the video.
         */
        let playerItem = AVPlayerItem(asset: asset)
        #if os(tvOS)
            playerItem.externalMetadata = self.sampleExternalMetaData(twicasMovie: movie)
        #endif

        return AVPlayer(playerItem: playerItem)
    }
    
    func sampleExternalMetaData(twicasMovie:TwicasMovie) -> [AVMetadataItem] {
        let titleItem = AVMutableMetadataItem()
        titleItem.identifier = AVMetadataCommonIdentifierTitle
        titleItem.value = twicasMovie.title as NSString
        titleItem.extendedLanguageTag = "und"
        
        let descriptionItem = AVMutableMetadataItem()
        descriptionItem.identifier = AVMetadataCommonIdentifierDescription
        descriptionItem.value = twicasMovie.subtitle as NSString
        descriptionItem.extendedLanguageTag = "und"
        
        return [titleItem, descriptionItem]
    }
}
