//
//  MovieCollectionViewCell.swift
//  twicastv
//
//  Created by COFFEE on 2017/01/12.
//  Copyright © 2017年 tsuyoshi hyuga. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // These properties are also exposed in Interface Builder.
//        imageView.adjustsImageWhenAncestorFocused = true
//        imageView.clipsToBounds = false
        
        title.alpha = 0.0
    }
    
    // MARK: UICollectionReusableView
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Reset the label's alpha value so it's initially hidden.
//        label.alpha = 0.0
    }
    
    // MARK: UIFocusEnvironment
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        /*
         Update the label's alpha value using the `UIFocusAnimationCoordinator`.
         This will ensure all animations run alongside each other when the focus
         changes.
         */
        coordinator.addCoordinatedAnimations({
            if self.isFocused {
                self.title.alpha = 1.0
            }
            else {
                self.title.alpha = 0.0
            }
        }, completion: nil)
    }
    
    func setData(twicasMovie:TwicasMovie){
        self.imageView.af_setImage(withURL: URL(string: twicasMovie.large_thumbnail)!)
        self.title.text = twicasMovie.title
    }
    
    
}
