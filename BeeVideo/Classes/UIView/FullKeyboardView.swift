//
//  FullKeyboardView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/12.
//  Copyright © 2016年 skyworth. All rights reserved.
//

protocol IKeyboardDelegate {
    func onKeyboardClick(letter:String)
    func onClearBtnClick()
    func onBackspaceClick()
}


class FullKeyboardView: UIView,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var clearBtn:KeyBoardViewButton!
    var digitalSwitcherBtn:KeyBoardViewButton!
    var backspaceBtn:KeyBoardViewButton!
    var keyCollectionView:UICollectionView!
    
    var keyboardDelegate:IKeyboardDelegate!
    
    private var isAlphabet:Bool = true
    private var alphabetList:[String] = [String]()
    private var digitalList:[String] = [String]()
    private var keyList:[String]!
    
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
        digitalSwitcherBtn.textLbl.text = "123"
        digitalSwitcherBtn.addTarget(self, action: #selector(self.keySwitcherClick), forControlEvents: .TouchUpInside)
        self.addSubview(digitalSwitcherBtn)
        
        backspaceBtn = KeyBoardViewButton()
        backspaceBtn.buttonMode = .Icon
        backspaceBtn.setImage(UIImage(named: "v2_keyboard_delete_normal"), forState: .Normal)
        backspaceBtn.setImage(UIImage(named: "v2_keyboard_delete_selected"), forState: .Highlighted)
        backspaceBtn.addTarget(self, action: #selector(self.backspaceClick), forControlEvents: .TouchUpInside)
        self.addSubview(backspaceBtn)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        keyCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        keyCollectionView.backgroundColor = UIColor.clearColor()
        keyCollectionView.registerClass(KeyboardCollectionViewCell.self, forCellWithReuseIdentifier: "keyCollectionView")
        keyCollectionView.dataSource = self
        keyCollectionView.delegate = self
        self.addSubview(keyCollectionView)
        
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeConstraints(){
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
        
        keyCollectionView.snp_makeConstraints { (make) in
            make.right.left.equalTo(self)
            make.top.equalTo(clearBtn.snp_bottom)
            make.bottom.equalTo(self)
        }
    }
    
    private func initData(){
        let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let digital = "0123456789"
        
        for c in alphabet.characters{
            alphabetList.append(String(c))
        }
        
        for c in digital.characters {
            digitalList.append(String(c))
        }
        
        keyList = alphabetList
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keyList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("keyCollectionView", forIndexPath: indexPath) as! KeyboardCollectionViewCell
        cell.titleLabel.text = keyList[indexPath.row]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = (collectionView.frame.width - 10) / 6
        return CGSize(width: width, height: width)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if keyboardDelegate != nil {
            keyboardDelegate.onKeyboardClick(keyList[indexPath.row])
        }
    }
    
    //点击清理按钮
    func clearBtnClick(){
        if keyboardDelegate != nil{
            keyboardDelegate.onClearBtnClick()
        }
    }
    
    //点击切换键盘按钮
    func keySwitcherClick(){
        if isAlphabet{
            digitalSwitcherBtn.textLbl.text = "ABC"
            keyList = digitalList
        }else{
            digitalSwitcherBtn.textLbl.text = "123"
            keyList = alphabetList
        }
        isAlphabet = !isAlphabet
        keyCollectionView.reloadData()
    }
    
    //点击backspace
    func backspaceClick(){
        if keyboardDelegate != nil {
            keyboardDelegate.onBackspaceClick()
        }
    }
    
    
}
