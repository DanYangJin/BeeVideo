//
//  VideoDetailBtnCell.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/24.
//  Copyright © 2016年 skyworth. All rights reserved.
//



class VideoDetailBtnCell: ZXOptionBarCell {

    var imgBtn:ImageButton!
    private var viewData:VideoDetailInfoView.Item!
    
    override init(style: ZXOptionBarCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        imgBtn = ImageButton()
        self.addSubview(imgBtn)
        imgBtn.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.right.left.equalTo(self)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViewData(viewData: VideoDetailInfoView.Item){
        self.viewData = viewData
        imgBtn.setTitle(viewData.title)
        imgBtn.setImage(viewData.icon)
    }
    
}
