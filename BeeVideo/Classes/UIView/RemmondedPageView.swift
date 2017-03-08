//
//  RemmondedPageView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/3.
//  Copyright © 2016年 skyworth. All rights reserved.
//


import UIKit
import SpriteKit


class RemmondedPageView: BasePageView, UITableViewDataSource, UITableViewDelegate, BlockViewDelegate{
    
    fileprivate var cycleView : UIImageView!
    fileprivate var cycleImage:CornerImageView!
    fileprivate var cycleTableView:UITableView!
    
    fileprivate var myVideoBlock : BlockView!
    fileprivate var weekHotBlock : BlockView!
    fileprivate var newVideoBlock : BlockView!
    fileprivate var block1 : BlockView!
    fileprivate var block2 : BlockView!
    fileprivate var block3 : BlockView!
    fileprivate var block4 : BlockView!
    fileprivate var block5 : BlockView!
    
    //data
    fileprivate var cycleItems:HomeSpace!
    
    //
    fileprivate var cyclePosition:Int = 0
    fileprivate var currentPosition : Int = 0
    fileprivate var timer:Timer!
    var isCycling:Bool = false
    fileprivate var cycling:Bool {
        get{
            return self.isCycling
        }
        set{
            if newValue {
                timer = Timer.scheduledTimer(timeInterval: 3,target:self,selector:#selector(RemmondedPageView.tickDown),userInfo:nil,repeats:true)
            } else {
                if timer != nil {
                    timer.invalidate()
                    timer = nil
                }
            }
        }
        
    }
    
    /**
     *计时器每秒触发事件
     **/
    func tickDown()
    {
        if cyclePosition > cycleItems.items.count - 1 {
            cyclePosition = 0
        }
        var lastPositon = cyclePosition - 1
        if lastPositon < 0 {
            lastPositon = cycleItems.items.count - 1
        }
        
        let lastCell = cycleTableView.cellForRow(at: IndexPath(row: lastPositon, section: 0)) as! CycleTableCell
        lastCell.setMarqueeStart(isScroll: false)
//
        currentPosition = cyclePosition
        cycleImage.sd_setImage(with: URL(string: cycleItems.items[cyclePosition].icon), placeholderImage: UIImage(named: "v2_image_default_bg.9"))
        let cell = cycleTableView.cellForRow(at: IndexPath(row: cyclePosition, section: 0)) as! CycleTableCell
        cell.setMarqueeStart(isScroll: true)
        cyclePosition += 1
    }
    
    
    override func initView(){
        super.initView()
        
        cycleView = UIImageView()
        cycleView.contentMode = .scaleToFill
        cycleView.image = UIImage(named: "v2_block_home_cycle_show_bg")
        addSubview(cycleView)
        
        cycleImage = CornerImageView()
        cycleImage.setCorner(4.0)
        cycleImage.sd_setImage(with: URL(string: cycleItems.items[0].icon), placeholderImage: UIImage(named: "v2_image_default_bg.9"))
        cycleImage.addOnClickListener(self, action: #selector(RemmondedPageView.clickCycleImg))
        addSubview(cycleImage)
        cycling = true
        
        cycleTableView = UITableView()
        cycleTableView.frame = CGRect(x: 220, y: 0, width: 100, height: 150)
        cycleTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        cycleTableView.backgroundColor = UIColor.clear
        cycleTableView.dataSource = self
        cycleTableView.delegate = self
        cycleTableView.isScrollEnabled = false
        cycleTableView.register(CycleTableCell.self, forCellReuseIdentifier: "CycleCell")
        addSubview(cycleTableView)
        
        myVideoBlock = BlockView()
        myVideoBlock.setData(homeSpace[1])
        myVideoBlock.setDelegate(self)
        addSubview(myVideoBlock)
        
        weekHotBlock = BlockView()
        weekHotBlock.setData(homeSpace[2])
        weekHotBlock.setDelegate(self)
        addSubview(weekHotBlock)
        
        newVideoBlock = BlockView()
        newVideoBlock.setData(homeSpace[3])
        newVideoBlock.setDelegate(self)
        addSubview(newVideoBlock)
        
        block1 = BlockView()
        block1.setData(homeSpace[4])
        block1.hiddenLbl(true)
        block1.setDelegate(self)
        addSubview(block1)
        
        block2 = BlockView()
        block2.setData(homeSpace[5])
        block2.hiddenLbl(true)
        block2.setDelegate(self)
        addSubview(block2)
        
        block3 = BlockView()
        block3.setData(homeSpace[6])
        block3.hiddenLbl(true)
        block3.setDelegate(self)
        addSubview(block3)
        
        block4 = BlockView()
        block4.setData(homeSpace[7])
        block4.hiddenLbl(true)
        block4.setDelegate(self)
        addSubview(block4)
        
        block5 = BlockView()
        block5.setData(homeSpace[8])
        block5.hiddenLbl(true)
        block5.setDelegate(self)
        addSubview(block5)
        
        setConstraint()
        
    }
    
    //tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cycleItems.items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CycleTableCell = tableView.dequeueReusableCell(withIdentifier: "CycleCell", for: indexPath) as! CycleTableCell
        cell.backgroundColor = UIColor.clear
        //cell.selectionStyle = .None
        cell.marqueeLabel.text = cycleItems.items[indexPath.row].name
        if (indexPath as NSIndexPath).row == 0 {
            cell.setMarqueeStart(isScroll: true)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let action:String = cycleItems.items[indexPath.row].action
        if action == "com.mipt.videohj.intent.action.VOD_DETAIL_ACTION" {
            let videoDetailViewController = VideoDetailViewController()
            videoDetailViewController.extras = cycleItems.items[indexPath.row].extras;
            self.viewController.present(videoDetailViewController, animated: true, completion: nil)
        }
    }
    
    
    //约束
    fileprivate func setConstraint(){
        cycleImage.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.height.equalTo(self.snp.height).multipliedBy(0.64)
            make.width.equalTo(cycleImage.snp.height).dividedBy(0.6)
        }
        cycleTableView.snp.makeConstraints { (make) in
            make.left.equalTo(cycleImage.snp.right).multipliedBy(1.02)
            make.top.equalTo(cycleImage)
            make.height.equalTo(cycleImage)
            make.width.equalTo(cycleImage.snp.width).dividedBy(2)
        }
        cycleView.snp.makeConstraints { (make) in
            make.left.equalTo(cycleImage)
            make.right.equalTo(cycleTableView)
            make.top.bottom.equalTo(cycleImage)
        }
        myVideoBlock.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.height.equalTo(self.snp.height).multipliedBy(0.34)
            //make.top.equalTo(cycleImage.snp.bottom).offset(5)
            make.bottom.equalTo(self)
            make.width.equalTo(cycleView.snp.width).multipliedBy(0.325)
        }
        weekHotBlock.snp.makeConstraints { (make) in
            //make.right.equalTo(cycleImage)
            make.centerX.equalTo(cycleView)
            make.top.equalTo(myVideoBlock)
            make.bottom.equalTo(myVideoBlock)
            make.width.equalTo(myVideoBlock)
        }
        newVideoBlock.snp.makeConstraints { (make) in
            make.right.equalTo(cycleTableView)
            make.width.equalTo(weekHotBlock)
            make.top.bottom.equalTo(weekHotBlock)
        }
        block1.snp.makeConstraints { (make) in
            make.top.equalTo(cycleImage)
            make.height.equalTo(self.snp.height).multipliedBy(0.49)
            make.width.equalTo(block1.snp.height)
            make.left.equalTo(cycleTableView.snp.right).offset(height * 0.02)
        }
        block2.snp.makeConstraints { (make) in
            make.bottom.equalTo(newVideoBlock)
            make.height.equalTo(block1)
            make.left.equalTo(block1)
            make.right.equalTo(block1)
        }
        block3.snp.makeConstraints { (make) in
            make.top.equalTo(block1)
            make.bottom.equalTo(block1)
            make.left.equalTo(block1.snp.right).offset(height * 0.02)
            make.width.equalTo(block3.snp.height).multipliedBy(1.5)
        }
        block4.snp.makeConstraints { (make) in
            make.top.equalTo(block2)
            make.bottom.equalTo(block2)
            make.left.equalTo(block3)
            make.right.equalTo(block3)
        }
        block5.snp.makeConstraints { (make) in
            make.top.equalTo(block1)
            make.bottom.equalTo(block2)
            make.left.equalTo(block3.snp.right).offset(height * 0.02)
            make.width.equalTo(block3)
        }
        
    }
    
    
    func blockClick(_ homeSpace: HomeSpace) {
        
        let action:String = homeSpace.items[0].action
        
        if action == "com.mipt.videohj.intent.action.VOD_DETAIL_ACTION"{
            let detailViewController = VideoDetailViewController()
            detailViewController.extras = homeSpace.items[0].extras
            self.viewController.present(detailViewController, animated: true, completion: nil)
        }else if action == "com.mipt.videohj.intent.action.SPECIAL_DETAIL"{
            let categoryController = VideoCategoryController()
            categoryController.extras = homeSpace.items[0].extras
            self.viewController.present(categoryController, animated: true, completion: nil)
        }else if action == "com.mipt.videohj.intent.action.WEEKLY_RANK"{
            let weekHotController = WeekHotViewController()
            viewController.present(weekHotController, animated: true, completion: nil)
        }else if action == "com.mipt.videohj.intent.action.PRIVATE_TRACE"{
            let myVideoController = MyVideoViewController()
            viewController.present(myVideoController, animated: true, completion: nil)
        }
        
    }
    
    func clickCycleImg(){
        let action : String = cycleItems.items[currentPosition].action
        if action == "com.mipt.videohj.intent.action.VOD_DETAIL_ACTION" {
            let detailViewController = VideoDetailViewController()
            detailViewController.extras = cycleItems.items[currentPosition].extras
            self.viewController.present(detailViewController, animated: true, completion: nil)
        }else if action == "com.mipt.videohj.intent.action.SPECIAL_DETAIL"{
            let categoryController = VideoCategoryController()
            categoryController.extras = cycleItems.items[currentPosition].extras
            self.viewController.present(categoryController, animated: true, completion: nil)
        }
    }
    
    func setBlockDelegate(_ delegate: BlockViewDelegate){
        weekHotBlock.setDelegate(delegate)
        myVideoBlock.setDelegate(delegate)
        
    }
    
    override func getViewWidth() -> CGFloat {
        return 4 * height
    }
    
    override func initData(){
        self.cycleItems = super.homeSpace![0]
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
}
