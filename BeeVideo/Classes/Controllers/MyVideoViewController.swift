//
//  MyVideoViewController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/8.
//  Copyright © 2016年 skyworth. All rights reserved.
//


class MyVideoViewController: BaseHorizontalViewController,UITableViewDataSource,UITableViewDelegate {
    
    private let menuData:[LeftViewTableData] = [
        LeftViewTableData(title: "观看历史", unSelectPic: "v2_my_video_history_default", selectedPic: "v2_my_video_history_selected"),
        LeftViewTableData(title: "追剧收藏", unSelectPic: "v2_my_video_like_bg_normal", selectedPic: "v2_my_video_like_bg_favorited"),
        LeftViewTableData(title: "我的下载", unSelectPic: "v2_my_video_download_bg_normal", selectedPic: "v2_my_video_download_selected")
    ]
    
    private var menuTable:UITableView!
    private var videoCollectionView:UICollectionView!
    private var emptyImageView:UIImageView!
    
    override func viewDidLoad() {
        leftWidth = Float(self.view.frame.width * 0.2)
        super.viewDidLoad()
        
        titleLbl.text = "我的影视"
        
        menuTable = UITableView()
        menuTable.dataSource = self
        menuTable.delegate = self
        menuTable.backgroundColor = UIColor.clearColor()
        menuTable.separatorStyle = .None
        menuTable.scrollEnabled = false
        menuTable.registerClass(MyVideoMenuCell.self, forCellReuseIdentifier: "myVideoCell")
        self.leftView.addSubview(menuTable)
        menuTable.snp_makeConstraints { (make) in
            make.left.right.equalTo(leftView)
            make.top.equalTo(leftView.snp_bottom).multipliedBy(0.2)
            make.bottom.equalTo(leftView)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //uitableview
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuData.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.height * 0.12
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("myVideoCell", forIndexPath: indexPath) as! MyVideoMenuCell
        cell.setViewData(menuData[indexPath.row])
        
        return cell
    }
    
}
