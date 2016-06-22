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
    private var clickBackgroudnImg:CornerImageView!
    
    private var blockViewMode : BlockViewMode = BlockViewMode.Center
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        blockImage = CornerImageView()
        blockImage.setCorner(4.0)
        addSubview(blockImage)
        
        blockName = UILabel()
        blockName.textAlignment = NSTextAlignment.Center
        blockName.textColor = UIColor.whiteColor()
        blockName.font = UIFont(name: "Helvetica", size: 12.0)
        addSubview(blockName)
        
        clickBackgroudnImg = CornerImageView()
        clickBackgroudnImg.setCorner(4.0)
        clickBackgroudnImg.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        clickBackgroudnImg.hidden = true
        self.addSubview(clickBackgroudnImg)
        
        setConstriants()
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        clickBackgroudnImg.snp_makeConstraints { (make) in
            make.left.right.equalTo(blockImage)
            make.top.bottom.equalTo(blockImage)
        }
    }

    
    func hiddenLbl(hidden: Bool){
        blockName.hidden = hidden
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        clickBackgroudnImg.hidden = false
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        clickBackgroudnImg.hidden = true
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let point:CGPoint = (touches.first?.locationInView(self))!
        let x = point.x
        let y = point.y
        let width = self.frame.width
        let height = self.frame.height
        if x < 0 || x > width || y < 0 || y > height{
            clickBackgroudnImg.hidden = true
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        clickBackgroudnImg.hidden = true
    }
    

    
}
