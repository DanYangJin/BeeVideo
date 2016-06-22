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
    
    private var cycleView : UIImageView!
    private var cycleImage:CornerImageView!
    private var cycleTableView:UITableView!
    
    private var myVideoBlock : BlockView!
    private var weekHotBlock : BlockView!
    private var newVideoBlock : BlockView!
    private var block1 : BlockView!
    private var block2 : BlockView!
    private var block3 : BlockView!
    private var block4 : BlockView!
    private var block5 : BlockView!
    
    //data
    private var cycleItems:HomeSpace!
    
    //
    private var cyclePosition:Int = 0
    private var currentPosition : Int = 0
    private var timer:NSTimer!
    private var isCycling:Bool {
        get{
            return self.isCycling
        }
        set{
            if newValue {
                timer = NSTimer.scheduledTimerWithTimeInterval(3,
                                                               target:self,selector:#selector(RemmondedPageView.tickDown),
                                                               userInfo:nil,repeats:true)
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
        
        let lastCell = cycleTableView.cellForRowAtIndexPath(NSIndexPath(forRow: lastPositon, inSection: 0)) as! CycleTableCell
        lastCell.setMarqueeStart(false)
        
        currentPosition = cyclePosition
        cycleImage.sd_setImageWithURL(NSURL(string: cycleItems.items[cyclePosition].icon), placeholderImage: UIImage(named: "v2_image_default_bg.9")?.resizableImageWithCapInsets(UIEdgeInsets(top: 140,left: 10,bottom: 66,right: 200), resizingMode: .Stretch))
        let cell = cycleTableView.cellForRowAtIndexPath(NSIndexPath(forRow: cyclePosition, inSection: 0)) as! CycleTableCell
        cell.setMarqueeStart(true)
        cyclePosition += 1
    }
    
    
    override func initView(){
        super.initView()
        
        cycleView = UIImageView()
        cycleView.contentMode = .ScaleToFill
        cycleView.image = UIImage(named: "v2_block_home_cycle_show_bg")
        addSubview(cycleView)
        
        cycleImage = CornerImageView()
        cycleImage.setCorner(4.0)
        cycleImage.sd_setImageWithURL(NSURL(string: cycleItems.items[0].icon), placeholderImage: UIImage(named: "v2_image_default_bg.9"))
        cycleImage.addOnClickListener(self, action: #selector(RemmondedPageView.clickCycleImg))
        addSubview(cycleImage)
        isCycling = true
        
        cycleTableView = UITableView()
        cycleTableView.frame = CGRect(x: 220, y: 0, width: 100, height: 150)
        cycleTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        cycleTableView.backgroundColor = UIColor.clearColor()
        cycleTableView.dataSource = self
        cycleTableView.delegate = self
        cycleTableView.scrollEnabled = false
        cycleTableView.registerClass(CycleTableCell.self, forCellReuseIdentifier: "CycleCell")
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
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cycleItems.items.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cycleImage.frame.height / 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:CycleTableCell = tableView.dequeueReusableCellWithIdentifier("CycleCell", forIndexPath: indexPath) as! CycleTableCell
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = .None
        cell.marqueeLabel.text = cycleItems.items[indexPath.row].name
        if indexPath.row == 0 {
            cell.setMarqueeStart(true)
        }
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
        //print(cycleItems.items[indexPath.row].action)
        
        let action:String = cycleItems.items[indexPath.row].action
        
        if action == "com.mipt.videohj.intent.action.VOD_DETAIL_ACTION" {
            let videoDetailViewController = VideoDetailViewController()
            videoDetailViewController.extras = cycleItems.items[indexPath.row].extras;
            self.viewController.presentViewController(videoDetailViewController, animated: true, completion: nil)
        }
    }
    
    //约束
    private func setConstraint(){
        cycleImage.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.height.equalTo(self.snp_height).multipliedBy(0.64)
            make.width.equalTo(cycleImage.snp_height).dividedBy(0.6)
        }
        cycleTableView.snp_makeConstraints { (make) in
            make.left.equalTo(cycleImage.snp_right).multipliedBy(1.02)
            make.top.equalTo(cycleImage)
            make.height.equalTo(cycleImage)
            make.width.equalTo(cycleImage.snp_width).dividedBy(2)
        }
        cycleView.snp_makeConstraints { (make) in
            make.left.equalTo(cycleImage)
            make.right.equalTo(cycleTableView)
            make.top.bottom.equalTo(cycleImage)
        }
        myVideoBlock.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.height.equalTo(self.snp_height).multipliedBy(0.32)
            //make.top.equalTo(cycleImage.snp_bottom).offset(5)
            make.bottom.equalTo(self)
            make.width.equalTo(cycleImage.snp_width).multipliedBy(0.48)
        }
        weekHotBlock.snp_makeConstraints { (make) in
            make.right.equalTo(cycleImage)
            make.top.equalTo(myVideoBlock)
            make.bottom.equalTo(myVideoBlock)
            make.width.equalTo(myVideoBlock)
        }
        newVideoBlock.snp_makeConstraints { (make) in
            make.right.equalTo(cycleTableView)
            make.width.equalTo(weekHotBlock)
            make.top.bottom.equalTo(weekHotBlock)
        }
        block1.snp_makeConstraints { (make) in
            make.top.equalTo(cycleImage)
            make.height.equalTo(self.snp_height).multipliedBy(0.48)
            make.width.equalTo(block1.snp_height)
            make.left.equalTo(cycleTableView.snp_right).offset(10)
        }
        block2.snp_makeConstraints { (make) in
            make.bottom.equalTo(newVideoBlock)
            make.height.equalTo(block1)
            make.left.equalTo(block1)
            make.right.equalTo(block1)
        }
        block3.snp_makeConstraints { (make) in
            make.top.equalTo(block1)
            make.bottom.equalTo(block1)
            make.left.equalTo(block1.snp_right).offset(5)
            make.width.equalTo(block3.snp_height).multipliedBy(1.5)
        }
        block4.snp_makeConstraints { (make) in
            make.top.equalTo(block2)
            make.bottom.equalTo(block2)
            make.left.equalTo(block3)
            make.right.equalTo(block3)
        }
        block5.snp_makeConstraints { (make) in
            make.top.equalTo(block1)
            make.bottom.equalTo(block2)
            make.left.equalTo(block3.snp_right).offset(5)
            make.width.equalTo(block3)
        }
        
    }
    
    
    func blockClick(homeSpace: HomeSpace) {
        
        let action:String = homeSpace.items[0].action
        
        if action == "com.mipt.videohj.intent.action.VOD_DETAIL_ACTION"{
            let detailViewController = VideoDetailViewController()
            detailViewController.extras = homeSpace.items[0].extras
            self.viewController.presentViewController(detailViewController, animated: true, completion: nil)
        }else if action == "com.mipt.videohj.intent.action.SPECIAL_DETAIL"{
            let categoryController = VideoCategoryController()
            categoryController.extras = homeSpace.items[0].extras
            self.viewController.presentViewController(categoryController, animated: true, completion: nil)
        }else if action == "com.mipt.videohj.intent.action.WEEKLY_RANK"{
            let weekHotController = WeekHotViewController()
            viewController.presentViewController(weekHotController, animated: true, completion: nil)
        }else if action == "com.mipt.videohj.intent.action.PRIVATE_TRACE"{
            let myVideoController = MyVideoViewController()
            viewController.presentViewController(myVideoController, animated: true, completion: nil)
        }
        
    }
    
    func clickCycleImg(){
        let action : String = cycleItems.items[currentPosition].action
        if action == "com.mipt.videohj.intent.action.VOD_DETAIL_ACTION" {
            let detailViewController = VideoDetailViewController()
            detailViewController.extras = cycleItems.items[currentPosition].extras
            self.viewController.presentViewController(detailViewController, animated: true, completion: nil)
        }else if action == "com.mipt.videohj.intent.action.SPECIAL_DETAIL"{
            let categoryController = VideoCategoryController()
            categoryController.extras = cycleItems.items[currentPosition].extras
            self.viewController.presentViewController(categoryController, animated: true, completion: nil)
        }
    }
    
    override func getViewWidth() -> CGFloat {
        return 4 * height
    }
    
    override func initData(){
        self.cycleItems = super.homeSpace![0]
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
}
