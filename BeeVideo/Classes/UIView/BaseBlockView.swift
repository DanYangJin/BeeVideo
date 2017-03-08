//
//  BaseBlockView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/26.
//  Copyright © 2016年 skyworth. All rights reserved.
//

enum BlockViewMode {
    case center
    case left
    case right
}


class BaseBlockView: UIView {

    fileprivate var blockImage:CornerImageView!
    var blockName:UILabel!
    fileprivate var clickBackgroudnImg:CornerImageView!
    
    fileprivate var blockViewMode : BlockViewMode = BlockViewMode.center
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        blockImage = CornerImageView()
       // blockImage.setCorner(4.0)
        addSubview(blockImage)
        
        blockName = UILabel()
        blockName.textAlignment = NSTextAlignment.center
        blockName.textColor = UIColor.white
        blockName.font = UIFont(name: "Helvetica", size: 12.0)
        addSubview(blockName)
        
        clickBackgroudnImg = CornerImageView()
        clickBackgroudnImg.setCorner(6.0)
        clickBackgroudnImg.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        clickBackgroudnImg.isHidden = true
        self.addSubview(clickBackgroudnImg)
        
        setConstriants()
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBlockViewMode(_ mode: BlockViewMode){
        self.blockViewMode = mode
        blockImage.snp.removeConstraints()
        blockName.snp.removeConstraints()
        setConstriants()
    }
    
    func setTitle(_ text:String){
        blockName.text = text
    }
    
    func setImage(_ url:String){

        blockImage.sd_setImage(with: URL(string:url), placeholderImage: UIImage(named: "v2_image_default_bg.9"), options: SDWebImageOptions.retryFailed) { (_, _, _, _) in
            self.blockImage.setCorner(6)
        }
        
    }
    
    
    fileprivate func setConstriants(){
        blockImage.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
        }
        
        blockName.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.height.equalTo(20)
            switch blockViewMode {
            case .center:
                make.left.equalTo(self)
                make.right.equalTo(self)
                break
            case .left:
                
                break
                
            case .right:
                make.left.equalTo(self)
                make.right.equalTo(self.snp.right).offset(-20)
                blockName.textAlignment = .right
                break
                
            }
        }
        
        clickBackgroudnImg.snp.makeConstraints { (make) in
            make.left.right.equalTo(blockImage)
            make.top.bottom.equalTo(blockImage)
        }
    }

    
    func hiddenLbl(_ hidden: Bool){
        blockName.isHidden = hidden
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        clickBackgroudnImg.isHidden = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        clickBackgroudnImg.isHidden = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point:CGPoint = (touches.first?.location(in: self))!
        let isInside = self.point(inside: point, with: event)
        if !isInside {
            //clickBackgroudnImg.hidden = true
            self.touchesCancelled(touches, with: event)
        }

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        clickBackgroudnImg.isHidden = true
    }
    
}
