//
//  ViewController.swift
//  PageCollectionview
//
//  Created by Levy on 2018/3/6.
//  Copyright © 2018年 DK. All rights reserved.
//

import UIKit

fileprivate var headerAndFooter = CGFloat(40)  // Header和Footer宽度相等
fileprivate let itemSpacing = CGFloat(20)
fileprivate var itemHeight = CGFloat(200)
fileprivate var itemWidth = CGFloat(UIScreen.main.bounds.size.width - 80 - 30) // 屏幕宽 - headerAndFooter*2 - view距离边缘（15）*2

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var myLayout : UICollectionViewFlowLayout?
    var currentpage:Int = 0
    /// 模型数组
    var modelArray:Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib.init(nibName: "PageCollectionviewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "PageCollectionviewCell")
        self.initArrays()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20.0
        layout.itemSize = CGSize.init(width: itemWidth, height: self.view.bounds.size.height)
        self.myLayout = layout
        collectionView.collectionViewLayout = self.myLayout!
        collectionView.reloadData()
        
    }
    
    private func initArrays() {
        for i in 0...5 {
            let ii = "第" + "\(i)" + "个"
            self.modelArray.append(ii)
        }
    }
    
}


// MARK: - 滚动代理
extension ViewController:UIScrollViewDelegate { // 这里是分页滚动的关键代码
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth = Float((UIScreen.main.bounds.size.width - 85 - 30 - 40))
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        let contentWidth = Float(self.collectionView.contentSize.width + 80 )
        print("contentWidth:",contentWidth)
        var newPage = Float(self.currentpage)
        if velocity.x == 0 {
            newPage = floor( (targetXContentOffset - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0
        } else { // 左右滑动的时候
            newPage = Float(velocity.x > 0 ? self.currentpage + 1 : self.currentpage - 1)
            if newPage < 0 {
                newPage = 0
            }
            if (newPage > contentWidth / pageWidth) {
                newPage = ceil(contentWidth / pageWidth) - 1.0
            }
        }
        self.currentpage = Int(newPage)
        let point = CGPoint (x: CGFloat(newPage * pageWidth), y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = point
    }
    
}


//UICollectionView代理方法
extension ViewController : UICollectionViewDelegate , UICollectionViewDataSource{
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.modelArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if self.modelArray.count == 0 {
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "PageCollectionviewCell", for: indexPath) as! PageCollectionviewCell
            cell.backgroundColor = UIColor.black
            return cell
        }
        
        let name:String = self.modelArray[indexPath.row]
        
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "PageCollectionviewCell", for: indexPath) as! PageCollectionviewCell

        cell.middleLabel.text = name
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        // 界面调试
//        let vc:ShowUpAdjustCollectionFlow_VC = ShowUpAdjustCollectionFlow_VC.init(nibName:"ShowUpAdjustCollectionFlow_VC",bundle:Bundle.main)
//        vc.targetCollectionview = self.collectionView
//        vc.targetCollectionviewsFlowLayout = self.myLayout
//        vc.show()
//        return
//
//        //        self.delegate.selectAitIndex(selectedAtIndex: indexPath.row)
//    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
}
