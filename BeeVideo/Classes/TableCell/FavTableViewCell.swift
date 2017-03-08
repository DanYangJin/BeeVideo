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
    func setImageView(_ url: String) {
        favImageView.sd_setImage(with: URL(string: url))
    }
    
    func setLabel(_ label:String){
        favLabel.text = label
    }
    
    
}
