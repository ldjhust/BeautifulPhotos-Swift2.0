//
//  MyCollectionHeaderView.swift
//  BeautifulPhotos(Swift2.0)
//
//  Created by ldjhust on 15/9/19.
//  Copyright © 2015年 example. All rights reserved.
//

import UIKit

class MyCollectionHeaderView: UICollectionReusableView {

  var backgroundImageView: UIImageView!
  
  // MARK: - Initializer
  
  override init(frame: CGRect) {
    
    super.init(frame: frame)
    
    self.layer.cornerRadius = 5
    self.layer.masksToBounds = true
    
    self.backgroundImageView = UIImageView()
    self.backgroundImageView.frame.size = self.frame.size
    self.backgroundImageView.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
    
    self.addSubview(self.backgroundImageView)
  }

  required init?(coder aDecoder: NSCoder) {
    
    super.init(coder: aDecoder)
  }
}
