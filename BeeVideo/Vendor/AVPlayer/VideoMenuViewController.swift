//
//  VideoMenuViewController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/8/26.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit
import PopupController

protocol VideoMenuDelegate:class {
    func changeDrama(index:Int)
    func popupDidDismiss()
}


class VideoMenuViewController: UIView,UITableViewDelegate,UITableViewDataSource {
    
    private let CATEGORY_TABLE = 2
    private let CONTENT_TABLE = 3
    
    var categoryTableView:UITableView!
    var contentTableView:UITableView!
    var videoDetailInfo:VideoDetailInfo!
    var currentDramaIndex = 0
    
    weak var delegate:VideoMenuDelegate!
    
    private var bgView:UIView!
    private var contentBgView:UIView!
    
    private var categoryRow = 0

    lazy var menuData:[LeftViewTableData] = [
        LeftViewTableData(title: "选择剧集", unSelectPic: "video_menu_category_drama_normal", selectedPic: "video_menu_category_drama_selected"),
        LeftViewTableData(title: "视频源", unSelectPic: "video_menu_category_source_normal", selectedPic: "video_menu_category_source_selected"),
        LeftViewTableData(title: "清晰度", unSelectPic: "video_menu_category_resolution_normal", selectedPic: "video_menu_category_resolution_selected"),
        LeftViewTableData(title: "画面比例", unSelectPic: "video_menu_category_resolution_ratio_normal", selectedPic: "video_menu_category_resolution_ratio_selected")
    ]
    
    private let clearness = ["超清","高清","标清"]
    private var clearIndex = 0
    private var scale = ["等比拉伸","强制全屏","16:9","4:3"]
    
    init(frame: CGRect,data:VideoDetailInfo,currentIndex:Int = 0) {
        super.init(frame: frame)
        self.videoDetailInfo = data
        self.currentDramaIndex = currentIndex
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI(){
        bgView = UIView()
        self.addSubview(bgView)
        bgView.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.right.equalTo(self)
        }
        
        contentBgView = UIView()
        self.addSubview(contentBgView)
        contentBgView.snp_makeConstraints { (make) in
            make.center.equalTo(self)
            make.height.equalTo(self).dividedBy(2)
            make.width.equalTo(self).dividedBy(3)
        }
        
        
        categoryTableView = UITableView()
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.tag = CATEGORY_TABLE
        categoryTableView.separatorStyle = .None
        categoryTableView.backgroundColor = UIColor.clearColor()
        categoryTableView.backgroundView = UIImageView(image: UIImage(named: "v2_dlg_bg")?.resizableImageWithCapInsets(UIEdgeInsets(top: 20,left: 20,bottom: 20,right: 20), resizingMode: .Stretch))
        categoryTableView.selectRowAtIndexPath(NSIndexPath(forItem: 0,inSection: 0), animated: false, scrollPosition: .None)
        contentBgView.addSubview(categoryTableView)
        
        contentTableView = UITableView()
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.tag = CONTENT_TABLE
        contentTableView.separatorStyle = .None
        contentTableView.backgroundColor = UIColor.clearColor()
        contentTableView.backgroundView = UIImageView(image: UIImage(named: "v2_dlg_bg")?.resizableImageWithCapInsets(UIEdgeInsets(top: 20,left: 20,bottom: 20,right: 20), resizingMode: .Stretch))
        contentTableView.selectRowAtIndexPath(NSIndexPath(forRow:currentDramaIndex,inSection:0), animated: false, scrollPosition: .Middle)
        contentBgView.addSubview(contentTableView)
        
        categoryTableView.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(contentBgView)
            make.left.equalTo(contentBgView)
            make.width.equalTo(contentBgView).multipliedBy(0.66)
        }
        
        contentTableView.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(contentBgView)
            make.right.equalTo(contentBgView)
            make.width.equalTo(contentBgView).multipliedBy(0.33)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == CATEGORY_TABLE{
            return menuData.count
        }else if tableView.tag == CONTENT_TABLE{
            if categoryRow == 0 {
               // print(Constants.URLS.count)
                return Constants.URLS.count
            }else if categoryRow == 1{
                return videoDetailInfo.currentDrama!.sources.count
            }else if categoryRow == 2{
                return clearness.count
            }else if categoryRow == 3{
                return scale.count
            }
        }
        return 0
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView.tag == CATEGORY_TABLE{

            var cell:VideoMenuCategoryCell? = tableView.dequeueReusableCellWithIdentifier("category") as? VideoMenuCategoryCell
            if cell == nil {
                cell = VideoMenuCategoryCell(style: .Default, reuseIdentifier: "category", data: menuData[indexPath.row])
            }
            cell?.titleLbl.text = menuData[indexPath.row].title
            cell?.subTitleLbl.text = "高清"
            if indexPath.row == 0 {
                cell?.subTitleLbl.text = "\(currentDramaIndex + 1)"
            }else if indexPath.row == 1{
                cell?.subTitleLbl.text = videoDetailInfo.currentDrama!.currentUsedSourceInfo!.source?.name
            }else if indexPath.row == 2{
                cell?.subTitleLbl.text = clearness[1]
            }else if indexPath.row == 3{
                cell?.subTitleLbl.text = scale[0]
            }
            
            
            return cell!
        }else if tableView.tag == CONTENT_TABLE{
            var cell:VideoMenuContentCell? = tableView.dequeueReusableCellWithIdentifier("content") as? VideoMenuContentCell
            if  cell == nil {
                cell = VideoMenuContentCell(style: .Default, reuseIdentifier: "content")
            }

            switch categoryRow {
            case 0:
                cell?.titleLbl.text = "\(indexPath.row + 1)"
                break
            case 1:
                cell?.titleLbl.text = "\(videoDetailInfo.currentDrama!.sources[indexPath.row].source!.name)"
                break
            case 2:
                cell?.titleLbl.text = clearness[indexPath.row]
                break
            case 3:
                cell?.titleLbl.text = scale[indexPath.row]
                break
            default:
                break
            }
            return cell!
        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.bounds.height/4
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.tag == CATEGORY_TABLE{
            categoryRow = indexPath.row
            contentTableView.reloadData()
        }else if tableView.tag == CONTENT_TABLE{
            if categoryRow == 0 {
                if delegate != nil {
                    delegate.changeDrama(indexPath.row)
                    self.hidden = true
                }
            }
        }
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let location = touches.first?.locationInView(self)
        if !self.contentBgView.frame.contains(location!) {
            self.hidden = true
            self.delegate.popupDidDismiss()
        }
    }

}
