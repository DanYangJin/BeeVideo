//
//  BaseBlockView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/26.
//  Copyright © 2016年 skyworth. All rights reserved.
//

enum BlockViewMode {
    case Center
    case Left
    case Right
}


class BaseBlockView: UIView {

    private var blockImage:CornerImageView!
    var blockName:UILabel!
    private var blockViewMode : BlockViewMode = BlockViewMode.Center
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initImage()
        initLabel()
        setConstriants()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func initImage(){
        // blockImage = CornerImageView(frame: CGRectMake(0, 0, width, height))
        blockImage = CornerImageView()
        blockImage.setCorner(4.0)
        addSubview(blockImage)
    }
    
    private func initLabel(){
        blockName = UILabel()
        //blockName.frame = CGRectMake(0, height - 20, width, 20)
        blockName.textAlignment = NSTextAlignment.Center
        blockName.textColor = UIColor.whiteColor()
        blockName.font = UIFont(name: "Helvetica", size: 12.0)
        addSubview(blockName)
    }
    
    func setBlockViewMode(mode: BlockViewMode){
        self.blockViewMode = mode
        blockImage.snp_removeConstraints()
        blockName.snp_removeConstraints()
        setConstriants()
    }
    
    func setTitle(text:String){
        blockName.text = text
    }
    
    func setImage(url:String){
        blockImage.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "v2_image_default_bg.9")!)
    }
    
    
    private func setConstriants(){
        blockImage.snp_makeConstraints { (make) in
            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
        }
        
        blockName.snp_makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.height.equalTo(20)
            switch blockViewMode {
            case .Center:
                make.left.equalTo(self)
                make.right.equalTo(self)
                break
            case .Left:
                
                break
                
            case .Right:
                make.left.equalTo(self)
                make.right.equalTo(self.snp_right).inset(20)
                blockName.textAlignment = .Right
                break
                
            }
        }
    }

    
    func hiddenLbl(hidden: Bool){
        blockName.hidden = hidden
    }
    
}
