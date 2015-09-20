//
//  File.swift
//  BeautifulPhotos(Swift2.0)
//
//  Created by ldjhust on 15/9/19.
//  Copyright © 2015年 example. All rights reserved.
//

import UIKit

class MyImageDataModel {
  var imageURLString: String
  var imageId: String // 图片唯一标识
  
  init(URLString: String, id: String) {
    self.imageURLString = URLString  // 目前我们只对图片感兴趣，对其他信息不感冒
    self.imageId = id
  }
}