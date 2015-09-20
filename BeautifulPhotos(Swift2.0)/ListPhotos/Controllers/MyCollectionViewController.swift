//
//  ViewController.swift
//  BeautifulPhotos(Swift2.0)
//
//  Created by ldjhust on 15/9/19.
//  Copyright © 2015年 example. All rights reserved.
//

import UIKit
import MJRefresh
import SDWebImage
import ReachabilitySwift
import BDKNotifyHUD

let cellReuseId: String = "reuseCellId"
let headerReuseId: String = "reuseHeaderId"

class MyCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
  
  var titleView: MyTitleView!
  var detailImageView: ShowSingleImageView!
  var reachbility: Reachability!
  var isNetworking: Bool = true
  var isRefreshing: Bool = false
  var currentPage: Int = 1
  var kingImageString: String = "壁纸" {
    
    didSet {
      // 更换显示的壁纸种类
      self.currentPage = 1
      self.imageDatas = nil
      self.collectionView?.header.beginRefreshing()
    }
  }
  var imageDatas: [MyImageDataModel]? {
    
    didSet {
      //  获取数据后，刷新collectionView数据
      self.collectionView?.reloadData()
      self.collectionView?.header.endRefreshing()
      self.collectionView?.footer.endRefreshing()
      self.isRefreshing = false
    }
  }
  
  // MARK: - Lifecycle
  
  // MARK: - Initializers
  
  override init(collectionViewLayout layout: UICollectionViewLayout) {
    
    super.init(collectionViewLayout: layout)
  }

  required init?(coder aDecoder: NSCoder) {
    
    super.init(coder: aDecoder)
  }
  
  // MARK: - View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.collectionView?.backgroundColor = UIColor.whiteColor()
    self.collectionView?.contentInset.top = 44
    
    // 注册可重用的cell
    self.collectionView?.registerClass(MyCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseId)
    // 注册可重用header
    self.collectionView?.registerClass(MyCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseId)
    
    self.titleView = MyTitleView(frame: CGRect(x: 0, y: 0, width: self.collectionView!.frame.width, height: 44))
    
    // MARK: - 监听网络状态
    
    self.reachbility = Reachability.reachabilityForInternetConnection()
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityChanged:", name: ReachabilityChangedNotification, object: self.reachbility)
    
    self.reachbility.startNotifier() // 启动监听
    
    // MARK: - add subviews
    
    self.view?.addSubview(self.titleView)
    
    // MARK: - 设置下拉刷新、上拉加载更多
    self.collectionView?.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "pullDwonToRefresh")
    self.collectionView?.footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "pullUpToRefresh")
    
    // MARK: - 程序一开始就要进入下拉刷新获取数据
    self.collectionView?.header.beginRefreshing()
  }
  
  override func prefersStatusBarHidden() -> Bool {
    
    // 隐藏statusBar
    return true
  }
  
  // MARK: - Event Responder
  
  func pullDwonToRefresh() {
    
    if self.reachbility.currentReachabilityStatus == Reachability.NetworkStatus.NotReachable {
      // 没有网络
      self.collectionView?.header.endRefreshing()
      self.collectionView?.footer.endRefreshing()
      self.isRefreshing = false
      
      let hud = BDKNotifyHUD.notifyHUDWithImage(UIImage(named: "XXX")!, text: "没有网络，请检查！") as! BDKNotifyHUD
      hud.center = UIApplication.sharedApplication().keyWindow!.center
      UIApplication.sharedApplication().keyWindow!.addSubview(hud)
      hud.presentWithDuration(1.0, speed: 0.5, inView: UIApplication.sharedApplication().keyWindow!) {
        hud.removeFromSuperview()
      }
    } else {
      if !isRefreshing {
        isRefreshing = true  // 设置collectionView正在刷新
        
        // 从百度图片获取图片, 刷新永远从第一页开始取
        NetworkPersistent.requestDataWithURL(self, url: self.makeURLString(self.kingImageString, pageNumber: 1), parameters: nil, action: "pullDwon")
      }
    }
  }
  
  func pullUpToRefresh() {
    
    if self.reachbility.currentReachabilityStatus == Reachability.NetworkStatus.NotReachable {
      // 没有网络
      self.collectionView?.header.endRefreshing()
      self.collectionView?.footer.endRefreshing()
      self.isRefreshing = false
      
      let hud = BDKNotifyHUD.notifyHUDWithImage(UIImage(named: "XXX")!, text: "没有网络，请检查！") as! BDKNotifyHUD
      hud.center = UIApplication.sharedApplication().keyWindow!.center
      UIApplication.sharedApplication().keyWindow!.addSubview(hud)
      hud.presentWithDuration(1.0, speed: 0.5, inView: UIApplication.sharedApplication().keyWindow!) {
        hud.removeFromSuperview()
      }
    } else {
      if !isRefreshing {
        isRefreshing = true // 设置collectionView正在刷新
        self.currentPage++  // 获取下一页
        self.collectionView?.footer.beginRefreshing()
        
        
        NetworkPersistent.requestDataWithURL(self, url: self.makeURLString(self.kingImageString, pageNumber: self.currentPage), parameters: nil, action: "pullUp")
      }
    }
  }
  
  // 监听网络状态
  
  func reachabilityChanged(note: NSNotification) {
    
    // 网络发生切换，可以做相应的处理
  }
  
  // MARK: - private methods
  func makeURLString(kindImageString: String, pageNumber: Int) -> String {
    return "http://image.baidu.com/data/imgs?col=\(kindImageString)&tag=全部&pn=\(pageNumber)&p=channel&rn=30&from=1".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
  }

  // MARK: - UICollectionViewDataSource
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    if self.imageDatas == nil {
      return 0
    } else {
      return self.imageDatas!.count - 1 // 第一张图片用来放在Header里面
    }
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    let cell = self.collectionView?.dequeueReusableCellWithReuseIdentifier(cellReuseId, forIndexPath: indexPath) as? MyCollectionViewCell
    
    // Config Cell...
    cell?.backgroundImageView.sd_setImageWithURL(NSURL(string: self.imageDatas![indexPath.row+1].imageURLString))
    
    return cell!
  }
  
  override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    
    // 因为只有header，所以不需要判断kind是header还是footer
    let headerView = self.collectionView?.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseId, forIndexPath: indexPath) as? MyCollectionHeaderView
    
    // Config header...
    if self.imageDatas != nil {
      headerView?.backgroundImageView.sd_setImageWithURL(NSURL(string: self.imageDatas![0].imageURLString))
    }
    
    return headerView!
  }
  
  // MARK: - UICollectionViewDelegate
  
  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
    let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MyCollectionViewCell
    let locationTap = CGPointMake(cell.center.x, cell.center.y - collectionView.contentOffset.y) // 随着滚动cell的垂直坐标一直在增加，所以要获取准确相对于屏幕上方的y值，需减去滚动的距离
    
    self.detailImageView = nil // 清楚之前的值
    self.detailImageView = ShowSingleImageView()
    self.detailImageView.showImageView(cell.backgroundImageView!, startCenter: locationTap)
  }
  
  // MARK: - UICollectionViewDelegateFlowLayout
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
    
    // Margin
    return UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
    
    // cell水平最小间距
    return 1.0
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
    
    // cell行最小间距
    return 1.0
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    
    // cell的尺寸
    let width = (self.collectionView!.frame.width - 2) / 3
    
    return CGSize(width: width, height: width)
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    
    let width = self.collectionView!.frame.width
    
    return CGSize(width: width, height: width)
  }
}

