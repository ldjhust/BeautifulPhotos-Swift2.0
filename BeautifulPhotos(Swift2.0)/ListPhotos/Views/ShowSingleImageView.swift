//
//  ShowSingleImageView.swift
//  BeautifulPhotos(Swift2.0)
//
//  Created by ldjhust on 15/9/19.
//  Copyright © 2015年 example. All rights reserved.
//

import UIKit
import BDKNotifyHUD

class ShowSingleImageView: UIView, UIScrollViewDelegate {
  
  var windowKey: UIWindow!
  var saveBtn: UIButton!
  var backgroundView: UIScrollView!
  var imageView: UIImageView!
  var imageOldCenter: CGPoint!
  var imageOldSize: CGSize!
  var imageOrignalFrame: CGRect!

  func showImageView(targetImageView: UIImageView, startCenter: CGPoint) {
    windowKey = UIApplication.sharedApplication().keyWindow!
    
    imageOldCenter = startCenter  // 设置
    imageOldSize = targetImageView.frame.size
    imageView = UIImageView()
    imageView.frame.size = imageOldSize
    imageView.center = imageOldCenter
    imageView.image = targetImageView.image
    
    saveBtn = UIButton(frame: CGRectMake(UIScreen.mainScreen().bounds.width - 50, UIScreen.mainScreen().bounds.height - 50, 40, 40))
    saveBtn.setBackgroundImage(UIImage(named: "saveIcon"), forState: UIControlState.Normal)
    saveBtn.addTarget(self, action: "saveImage:", forControlEvents: UIControlEvents.TouchUpInside)
    
    backgroundView = UIScrollView(frame: UIScreen.mainScreen().bounds)
    backgroundView.backgroundColor = UIColor.blackColor()
    backgroundView.alpha = 0
    backgroundView.minimumZoomScale = 1.0
    backgroundView.maximumZoomScale = 3.0
    backgroundView.showsHorizontalScrollIndicator = false
    backgroundView.showsVerticalScrollIndicator = false
    backgroundView.bounces = true
    backgroundView.bouncesZoom = true
    backgroundView.delegate = self
    
    // 点击后返回
    let tap = UITapGestureRecognizer(target: self, action: "hideImage:")
    tap.numberOfTapsRequired = 1
    tap.numberOfTouchesRequired = 1
    
    backgroundView.addGestureRecognizer(tap)
    backgroundView.addSubview(imageView)
    windowKey.addSubview(backgroundView)
    windowKey.addSubview(saveBtn)
    
    UIView.animateWithDuration(0.3) {
      
      self.backgroundView.alpha = 1
      let width = UIScreen.mainScreen().bounds.width
      let height = self.imageOldSize.height * width / self.imageOldSize.width
      self.imageView.frame = CGRectMake(0, (UIScreen.mainScreen().bounds.height - height)/2, width, height)
      self.imageOrignalFrame = self.imageView.frame  // 保存原来的frame方便恢复
    }
  }
  
  // MARK: - Event Response
  
  func hideImage(gesture: UITapGestureRecognizer) {
    
    let view = gesture.view
    self.saveBtn.removeFromSuperview()
    
    UIView.animateWithDuration(0.3, animations: { () -> Void in
      
      self.imageView.frame.size = self.imageOldSize
      self.imageView.center = self.imageOldCenter
      self.imageView.alpha = 0
      view?.alpha = 0
      }) { (finished) in
        // 返回后，移除backview
        view?.removeFromSuperview()
    }
  }
  
  func saveImage(sender: UIButton) {
    
    // 保存图片值相册
    UIImageWriteToSavedPhotosAlbum(imageView.image!, self, "image:didFinishSavingWithError:contextInfo:", nil)
  }
  
  func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
    
    if error == nil {
      let hud = BDKNotifyHUD.notifyHUDWithImage(UIImage(named: "checkmark")!, text: "保存成功") as! BDKNotifyHUD
      hud.center = windowKey.center
      self.windowKey.addSubview(hud)
      hud.presentWithDuration(1.0, speed: 0.5, inView: self.windowKey) {
        hud.removeFromSuperview()
      }
    } else {
      let hud = BDKNotifyHUD.notifyHUDWithImage(UIImage(named: "XXX")!, text: "保存失败") as! BDKNotifyHUD
      hud.center = windowKey.center
      self.windowKey.addSubview(hud)
      hud.presentWithDuration(1.0, speed: 0.5, inView: self.windowKey) {
        hud.removeFromSuperview()
      }
    }
  }
  
  // MARK: - UIScrollViewDelegate
  
  func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
    
    return self.imageView
  }
  
  func scrollViewDidZoom(scrollView: UIScrollView) {
    
    // 在这里面保证图片始终处于content的中心位置
    var xcenter = scrollView.center.x
    var ycenter = scrollView.center.y
    
    // 如果当前的contentSize的width是否大于原scrollView的contentSize，如果大于，设置imageView中心x为contentSize的一半，否则x继续为屏幕中心即可，对y同理
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter
    
    self.imageView.center = CGPointMake(xcenter, ycenter)
  }
}
