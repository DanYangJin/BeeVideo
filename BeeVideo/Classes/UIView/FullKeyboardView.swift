//
//  FullKeyboardView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/12.
//  Copyright © 2016年 skyworth. All rights reserved.
//

@objc protocol IKeyboardDelegate {
    func onKeyboardClick(_ letter:String)
    func onClearBtnClick()
    func onBackspaceClick()
    @objc optional func onDigitalBtnClick(_ point:CGRect,data: [String])
}


class FullKeyboardView: UIView,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var clearBtn:KeyBoardViewButton!
    var digitalSwitcherBtn:KeyBoardViewButton!
    var backspaceBtn:KeyBoardViewButton!
    var keyCollectionView:UICollectionView!
    
    weak var keyboardDelegate:IKeyboardDelegate!
    
    fileprivate var isAlphabet:Bool = true
    fileprivate var alphabetList:[String] = [String]()
    fileprivate var digitalList:[String] = [String]()
    fileprivate var keyList:[String]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initData()
        
        clearBtn = KeyBoardViewButton()
        clearBtn.buttonMode = .icon
        clearBtn.setImage(UIImage(named: "v2_keyboard_clean_normal"), for: UIControlState())
        clearBtn.setImage(UIImage(named: "v2_keyboard_clean_selected"), for: .highlighted)
        clearBtn.addTarget(self, action: #selector(self.clearBtnClick), for: .touchUpInside)
        self.addSubview(clearBtn)
        
        digitalSwitcherBtn = KeyBoardViewButton()
        digitalSwitcherBtn.buttonMode = .text
        digitalSwitcherBtn.textLbl.text = "123"
        digitalSwitcherBtn.addTarget(self, action: #selector(self.keySwitcherClick), for: .touchUpInside)
        self.addSubview(digitalSwitcherBtn)
        
        backspaceBtn = KeyBoardViewButton()
        backspaceBtn.buttonMode = .icon
        backspaceBtn.setImage(UIImage(named: "v2_keyboard_delete_normal"), for: UIControlState())
        backspaceBtn.setImage(UIImage(named: "v2_keyboard_delete_selected"), for: .highlighted)
        backspaceBtn.addTarget(self, action: #selector(self.backspaceClick), for: .touchUpInside)
        self.addSubview(backspaceBtn)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        keyCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        keyCollectionView.backgroundColor = UIColor.clear
        keyCollectionView.register(KeyboardCollectionViewCell.self, forCellWithReuseIdentifier: "keyCollectionView")
        keyCollectionView.delaysContentTouches = false
        keyCollectionView.dataSource = self
        keyCollectionView.delegate = self
        self.addSubview(keyCollectionView)
        
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func makeConstraints(){
        clearBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.height.equalTo(30)
            make.width.equalTo(self).multipliedBy(0.32)
        }
        
        digitalSwitcherBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self)
            make.width.height.equalTo(clearBtn)
        }
        
        backspaceBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self)
            make.top.equalTo(self)
            make.height.width.equalTo(clearBtn)
        }
        
        keyCollectionView.snp.makeConstraints { (make) in
            make.right.left.equalTo(self)
            make.top.equalTo(clearBtn.snp.bottom)
            make.bottom.equalTo(self)
        }
    }
    
    fileprivate func initData(){
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keyList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "keyCollectionView", for: indexPath) as! KeyboardCollectionViewCell
        cell.titleLabel.text = keyList[(indexPath as NSIndexPath).row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 10) / 6
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if keyboardDelegate != nil {
            keyboardDelegate.onKeyboardClick(keyList[(indexPath as NSIndexPath).row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! KeyboardCollectionViewCell
        cell.backgroundView?.isHidden = false
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! KeyboardCollectionViewCell
        cell.backgroundView?.isHidden = true
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
