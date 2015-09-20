//
//  MyTitleView.swift
//  BeautifulPhotos(Swift2.0)
//
//  Created by ldjhust on 15/9/19.
//  Copyright © 2015年 example. All rights reserved.
//

import UIKit
import KxMenu

class MyTitleView: UIView {

  var titleLabelLeft: UILabel!
  var titleLabelRight: UILabel!
  var titleImageView: UIImageView!
  var menuButton: UIButton!
  var backgroundImageView: UIImageView!
  
  override init(frame: CGRect) {
    
    super.init(frame: frame)
    
    self.titleLabelLeft = UILabel(frame: CGRectMake(0, 10, bounds.width/2 - 16, 37))
    self.titleLabelLeft.font = UIFont.boldSystemFontOfSize(20)
    self.titleLabelLeft.text = "Bai"
    self.titleLabelLeft.textAlignment = NSTextAlignment.Right
    self.titleLabelLeft.textColor = UIColor.redColor()
    
    self.titleImageView = UIImageView(frame: CGRectMake((bounds.width-30)/2, 7, 30, 30))
    self.titleImageView.image = UIImage(named: "baidu_logo")
    
    self.titleLabelRight = UILabel(frame: CGRectMake(bounds.width/2 + 16, 10, bounds.width/2 - 16, 37))
    self.titleLabelRight.font = UIFont.boldSystemFontOfSize(20)
    self.titleLabelRight.text = "图片"
    self.titleLabelRight.textAlignment = NSTextAlignment.Left
    self.titleLabelRight.textColor = UIColor.redColor()
    
    self.menuButton = UIButton(frame: CGRectMake(UIScreen.mainScreen().bounds.width - 75, 10, 70, 30))
    self.menuButton.setTitle("分类", forState: UIControlState.Normal)
    self.menuButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
    self.menuButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
    self.menuButton.layer.borderColor = UIColor.blueColor().CGColor
    self.menuButton.layer.borderWidth = 1
    self.menuButton.addTarget(self, action: "showMenu:", forControlEvents: UIControlEvents.TouchUpInside)
    
    self.backgroundImageView = UIImageView()
    self.backgroundImageView.frame.size = self.frame.size
    self.backgroundImageView.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
    self.backgroundImageView.image = UIImage(named: "titile_bg")
    
    self.addSubview(self.backgroundImageView)
    self.addSubview(self.titleLabelLeft)
    self.addSubview(self.titleImageView)
    self.addSubview(self.titleLabelRight)
    self.addSubview(self.menuButton)
  }
  
  required init?(coder aDecoder: NSCoder) {
    
    super.init(coder: aDecoder)
  }
  
  // MARK: - Event Response
  
  func showMenu(sender: UIButton) {
    
    KxMenu.showMenuInView(self.superview, fromRect: sender.frame, menuItems: [
      KxMenuItem("明星", image: nil, target: self, action: "pushMenuItem:"),
      KxMenuItem("美女", image: nil, target: self, action: "pushMenuItem:"),
      KxMenuItem("壁纸", image: nil, target: self, action: "pushMenuItem:"),
      KxMenuItem("摄影", image: nil, target: self, action: "pushMenuItem:"),
      KxMenuItem("设计", image: nil, target: self, action: "pushMenuItem:"),
      KxMenuItem("宠物", image: nil, target: self, action: "pushMenuItem:"),
      KxMenuItem("汽车", image: nil, target: self, action: "pushMenuItem:")]
    )
  }
  
  func pushMenuItem(sender: KxMenuItem) {
    
    // 改变类别
    (UIApplication.sharedApplication().keyWindow?.rootViewController as? MyCollectionViewController)?.kingImageString = sender.title
  }
}
