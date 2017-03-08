//
//  LeftViewCell.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/30.
//  Copyright © 2016年 skyworth. All rights reserved.
//


class LeftViewCell: UITableViewCell {

    fileprivate var lineView:UIImageView!
    fileprivate var bottomLine:UIImageView!
    var icon : UIImageView!
    var titleLbl : UILabel!
    fileprivate var viewData : LeftViewTableData!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        
        lineView = UIImageView()
        lineView.contentMode = .scaleToFill
        lineView.image = UIImage(named: "v2_search_input_panel_divider")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0,left: 1,bottom: 0,right: 1))
        self.contentView.addSubview(lineView)
        
        icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        self.contentView.addSubview(icon)
        
        titleLbl = UILabel()
        titleLbl.font = UIFont.systemFont(ofSize: 14)
        titleLbl.textColor = UIColor.white
        self.contentView.addSubview(titleLbl)
        
        bottomLine = UIImageView()
        bottomLine.contentMode = .scaleToFill
        bottomLine.image = UIImage(named: "v2_search_input_panel_divider")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0,left: 1,bottom: 0,right: 1))
        self.contentView.addSubview(bottomLine)
        
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self).offset(-0.5)
            make.top.equalTo(self)
            make.height.equalTo(0.5)
        }
        
        icon.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView.snp.right).dividedBy(4)
            make.width.height.equalTo(18)
        }
        
        titleLbl.snp.makeConstraints { (make) in
            make.centerY.equalTo(icon)
            make.left.equalTo(icon.snp.right).offset(3)
        }
        
        bottomLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(self).offset(-0.5)
            make.bottom.equalTo(self).offset(0.5)
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViewData(_ data: LeftViewTableData){
        self.viewData = data
        icon.image = UIImage(named: viewData.unSelectPic)
        titleLbl.text = viewData.title
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if viewData != nil{
            if selected{
                titleLbl.textColor = UIColor.textBlueColor()
                icon.image = UIImage(named: viewData.selectedPic)
            }else{
                titleLbl.textColor = UIColor.white
                icon.image = UIImage(named: viewData.unSelectPic)
            }
        }
    }
    
}
