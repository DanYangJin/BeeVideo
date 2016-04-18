//
//  FavTableViewCell.swift
//  BeeVideo
//
//  Created by DanBin on 16/4/18.
//  Copyright © 2016年 skyworth. All rights reserved.
//

class FavTableViewCell: UITableViewCell {

    @IBOutlet var favImageView: UIImageView!
    @IBOutlet var favLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //设置图片
    func setImageView(url: String) {
        favImageView.sd_setImageWithURL(NSURL(string: url))
    }
    
    func setLabel(label:String){
        favLabel.text = label
    }
    
    
}
