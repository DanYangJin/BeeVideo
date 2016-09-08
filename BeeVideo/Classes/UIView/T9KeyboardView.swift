//
//  T9KeyboardView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/8/9.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class T9KeyboardView: UIView,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var clearBtn:KeyBoardViewButton!
    var digitalSwitcherBtn:KeyBoardViewButton!
    var backspaceBtn:KeyBoardViewButton!
    var mCollectionView:UICollectionView!
    // var t9PopupView:T9PopupView!
    
    weak var keyboardDelegate : IKeyboardDelegate!
    private var pupView:[UIView] = [UIView]()
    
    let data = [
        ["1"],
        ["2","ABC"],
        ["3","DEF"],
        ["4","GHI"],
        ["5","JKL"],
        ["6","MNO"],
        ["7","PQRS"],
        ["8","TUV"],
        ["9","WXYZ"]
    ]
    
    private var digitalList:[String] = [String]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initData()
        
        clearBtn = KeyBoardViewButton()
        clearBtn.buttonMode = .Icon
        clearBtn.setImage(UIImage(named: "v2_keyboard_clean_normal"), forState: .Normal)
        clearBtn.setImage(UIImage(named: "v2_keyboard_clean_selected"), forState: .Highlighted)
        clearBtn.addTarget(self, action: #selector(self.clearBtnClick), forControlEvents: .TouchUpInside)
        self.addSubview(clearBtn)
        
        digitalSwitcherBtn = KeyBoardViewButton()
        digitalSwitcherBtn.buttonMode = .Text
        digitalSwitcherBtn.textLbl.text = "0"
        digitalSwitcherBtn.addTarget(self, action: #selector(self.keySwitcherClick), forControlEvents: .TouchUpInside)
        self.addSubview(digitalSwitcherBtn)
        
        backspaceBtn = KeyBoardViewButton()
        backspaceBtn.buttonMode = .Icon
        backspaceBtn.setImage(UIImage(named: "v2_keyboard_delete_normal"), forState: .Normal)
        backspaceBtn.setImage(UIImage(named: "v2_keyboard_delete_selected"), forState: .Highlighted)
        backspaceBtn.addTarget(self, action: #selector(self.backspaceClick), forControlEvents: .TouchUpInside)
        self.addSubview(backspaceBtn)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        mCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        mCollectionView.backgroundColor = UIColor.clearColor()
        mCollectionView.delegate = self
        mCollectionView.dataSource = self
        mCollectionView.registerClass(T9KeyCollectionViewCell.self, forCellWithReuseIdentifier: "t9CollectionView")
        self.addSubview(mCollectionView)
        
        clearBtn.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.height.equalTo(30)
            make.width.equalTo(self).multipliedBy(0.32)
        }
        
        digitalSwitcherBtn.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self)
            make.width.height.equalTo(clearBtn)
        }
        
        backspaceBtn.snp_makeConstraints { (make) in
            make.right.equalTo(self)
            make.top.equalTo(self)
            make.height.width.equalTo(clearBtn)
        }
        
        mCollectionView.snp_makeConstraints { (make) in
            make.right.left.equalTo(self)
            make.top.equalTo(clearBtn.snp_bottom)
            make.bottom.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initData(){
        let digital = "123456789"
        for c in digital.characters {
            digitalList.append(String(c))
        }
    }
    
    //CollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return digitalList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("t9CollectionView", forIndexPath: indexPath) as! T9KeyCollectionViewCell
        
        cell.titleLbl.text = digitalList[indexPath.row]
        if indexPath.row > 0{
            cell.subTitleLbl.text = data[indexPath.row][1]
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width
        let cellWidth = collectionWidth / 3.3
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! T9KeyCollectionViewCell
        
        let  window = UIApplication.sharedApplication().delegate?.window
        let rect = cell.convertRect((cell.bounds), toView: window!)
        
        if keyboardDelegate != nil {
            if indexPath.row > 0{
                var charaDatas = [String]()
                let dataString = data[indexPath.row][1]
                charaDatas.append(data[indexPath.row][0])
                for c in dataString.characters {
                    charaDatas.append(String(c))
                }
                keyboardDelegate.onDigitalBtnClick!(rect, data:charaDatas)
            }else{
                keyboardDelegate.onKeyboardClick(cell.titleLbl.text!)
            }
        }
        
    }
    
    //点击清理按钮
    func clearBtnClick(){
        if keyboardDelegate != nil{
            keyboardDelegate.onClearBtnClick()
        }
    }
    
    //0键
    func keySwitcherClick(){
        if keyboardDelegate != nil {
            keyboardDelegate.onKeyboardClick("0")
        }
    }
    
    //点击backspace
    func backspaceClick(){
        if keyboardDelegate != nil {
            keyboardDelegate.onBackspaceClick()
        }
    }
    
    
    
}