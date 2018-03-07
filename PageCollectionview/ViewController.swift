//
//  ViewController.swift
//  PageCollectionview
//
//  Created by Levy on 2018/3/6.
//  Copyright © 2018年 DK. All rights reserved.
//

import UIKit

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
        
        self.steper.value = Double(itemSpacing)
        self.cellSpaceing_Label.text = "\(self.steper.value)"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.topCollectionViewFlow() // 不能在viewdidload里调用，因为self.collectionView的高度未确定
    }
    
    private func topCollectionViewFlow() {
        itemHeight = self.collectionView.bounds.size.height
        self.myLayout?.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.myLayout?.itemSize = CGSize(width: itemWidth, height: itemHeight)
        self.myLayout?.headerReferenceSize = CGSize(width: headerAndFooter, height: 0)
        self.myLayout?.footerReferenceSize = CGSize(width: headerAndFooter, height: 0)
        self.myLayout?.minimumLineSpacing = itemSpacing
        self.myLayout?.scrollDirection = .horizontal
        
        self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        self.collectionView.reloadData()
    }
    private func initArrays() {
        for i in 0...5 {
            let ii = "第" + "\(i)" + "个"
            self.modelArray.append(ii)
        }
    }
    
    
    @IBOutlet weak var cellSpaceing_Label: UILabel!
    @IBOutlet weak var steper: UIStepper!
    @IBAction func steping(_ sender: UIStepper) {
        itemSpacing = CGFloat(sender.value)
        
        headerAndFooter = itemSpacing*2
        itemWidth = CGFloat(UIScreen.main.bounds.size.width - headerAndFooter*2 - 16)
        self.topCollectionViewFlow()
        self.cellSpaceing_Label.text = "\(self.steper.value)"
        self.collectionView.reloadData()
        
    }
    
    
    
}


fileprivate var itemSpacing = CGFloat(20) // cell之间的间距
fileprivate var headerAndFooter = itemSpacing*2  // 必须为itemSpacing的2倍，否则不能居中显示。Header和Footer宽度相等
fileprivate var itemHeight = CGFloat(100)
fileprivate var itemWidth = CGFloat(UIScreen.main.bounds.size.width - headerAndFooter*2 - 16) // 屏幕宽 - headerAndFooter*2 - view距离边缘（8）*2

// MARK: - 滚动代理
extension ViewController:UIScrollViewDelegate { // 这里是分页滚动的关键代码
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth = Float((itemWidth + headerAndFooter/2))
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        let contentWidth = Float(self.collectionView.contentSize.width + headerAndFooter*2 )
        var newPage = Float(self.currentpage)
        if velocity.x == 0 {
            newPage = floor( (targetXContentOffset - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0
        } else { // 左右滑动的时候
            newPage = Float(velocity.x > 0 ? self.currentpage + 1 : self.currentpage - 1)
            if newPage < 0 {
                newPage = 0
            }else{
                if (newPage >= floor(contentWidth / pageWidth)) { // 滑到底的时候
                    newPage = floor(contentWidth / pageWidth) - 1.0
                }else{
                    newPage = Float(velocity.x > 0 ? self.currentpage + 1 : self.currentpage - 1)

                }
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
