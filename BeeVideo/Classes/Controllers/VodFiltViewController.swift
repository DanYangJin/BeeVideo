//
//  VodFiltViewController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/7/12.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import PopupController

@objc protocol FiltViewClickDelegate {
    func confirmClickListener(_ row_0: Int,row_1: Int,row_2: Int,row_3: Int )
}

class VodFiltViewController: UIViewController, PopupContentViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var gather:VodFiltrateCategoryGather!
    weak var delegate:FiltViewClickDelegate!
    
    fileprivate var picker:UIPickerView!
    fileprivate var areaLbl:UILabel!
    fileprivate var areaBg:UIImageView!
    fileprivate var yearLbl:UILabel!
    fileprivate var yearBg:UIImageView!
    fileprivate var cateLbl:UILabel!
    fileprivate var cateBg:UIImageView!
    fileprivate var orderLbl:UILabel!
    fileprivate var orderBg:UIImageView!
    fileprivate var bgImg:UIImageView!
    fileprivate var clearBtn:UIButton!
    fileprivate var confirmBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initUI(){
        bgImg = UIImageView(image: UIImage(named: "v2_choose_drama_dlg_bg")?.resizableImage(withCapInsets: UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5), resizingMode: .stretch))
        self.view.addSubview(bgImg)
        
        let image = UIImage(named: "v2_vod_filtrate_category_title")?.resizableImage(withCapInsets: UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5), resizingMode: .stretch)
        
        picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.contentMode = .top
        self.view.addSubview(picker)
        
        areaBg = UIImageView(image: image)
        self.view.addSubview(areaBg)
        
        areaLbl = UILabel()
        areaLbl.textColor = UIColor.white
        areaLbl.textAlignment = .center
        areaLbl.text = "地区"
        self.view.addSubview(areaLbl)
        
        yearBg = UIImageView(image: image)
        self.view.addSubview(yearBg)
        
        yearLbl = UILabel()
        yearLbl.text = "年代"
        yearLbl.textColor = UIColor.white
        yearLbl.textAlignment = .center
        self.view.addSubview(yearLbl)
        
        cateBg = UIImageView(image: image)
        self.view.addSubview(cateBg)
        
        cateLbl = UILabel()
        cateLbl.text = "类型"
        cateLbl.textColor = UIColor.white
        cateLbl.textAlignment = .center
        self.view.addSubview(cateLbl)
        
        orderBg = UIImageView(image: image)
        self.view.addSubview(orderBg)
        
        orderLbl = UILabel()
        orderLbl.textColor = UIColor.white
        orderLbl.textAlignment = .center
        orderLbl.text = "排序"
        self.view.addSubview(orderLbl)
        
        confirmBtn = UIButton()
        confirmBtn.setTitle("确认筛选", for: UIControlState())
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        confirmBtn.setBackgroundImage(UIImage(named: "normal_bg"), for: UIControlState())
        confirmBtn.addTarget(self, action: #selector(self.confirmClick), for: .touchUpInside)
        self.view.addSubview(confirmBtn)
        
        areaLbl.snp.makeConstraints { (make) in
            make.left.equalTo(self.view)
            make.top.equalTo(self.view)
            make.width.equalTo(self.view).multipliedBy(0.2)
            make.height.equalTo(self.view).multipliedBy(0.25)
        }
        
        areaBg.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(areaLbl)
            make.left.right.equalTo(areaLbl)
        }
        
        cateLbl.snp.makeConstraints { (make) in
            make.left.equalTo(areaLbl.snp.right)
            make.top.equalTo(areaLbl)
            make.width.equalTo(areaLbl)
            make.height.equalTo(areaLbl)
        }
        
        cateBg.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(cateLbl)
            make.left.right.equalTo(cateLbl)
        }
        
        yearLbl.snp.makeConstraints { (make) in
            make.left.equalTo(cateLbl.snp.right)
            make.top.equalTo(areaLbl)
            make.width.equalTo(areaLbl)
            make.height.equalTo(areaLbl)
        }
        
        yearBg.snp.makeConstraints { (make) in
            make.left.right.equalTo(yearLbl)
            make.top.bottom.equalTo(yearLbl)
        }
        
        orderLbl.snp.makeConstraints { (make) in
            make.left.equalTo(yearLbl.snp.right)
            make.top.equalTo(areaLbl)
            make.width.equalTo(areaLbl)
            make.height.equalTo(areaLbl)
        }
        
        orderBg.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(orderLbl)
            make.left.right.equalTo(orderLbl)
        }
        
        picker.snp.makeConstraints { (make) in
            make.left.equalTo(self.view)
            make.bottom.equalTo(self.view)
            make.top.equalTo(areaLbl.snp.bottom)
            make.width.equalTo(self.view).multipliedBy(0.8)
        }
        
        bgImg.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.bottom.equalTo(self.view)
        }
        
        confirmBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.right).multipliedBy(0.9)
            //make.right.equalTo(self.view)
            make.width.equalTo(self.view).multipliedBy(0.1)
            make.centerY.equalTo(self.view)
            make.height.equalTo(self.view).multipliedBy(0.2)
        }
    }
    
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        return CGSize(width: screenWidth,height: screenHeight * 0.4)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return gather.areaList.count
        }else if component == 1{
            return gather.categoryList.count
        }else if component == 2{
            return gather.yearList.count
        }else if component == 3{
            return gather.orderList.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = PickerCell()
        
        if component == 0 {
            view.label.text = gather.areaList[row].name
            
        }else if component == 1{
            view.label.text = gather.categoryList[row].name
            
        }else if component == 2{
            view.label.text = gather.yearList[row].name
            
        }else if component == 3{
            view.label.text = gather.orderList[row].name
        }
        return view
    }
    
    
    func confirmClick(){
        let row_0 = self.picker.selectedRow(inComponent: 0)
        let row_1 = self.picker.selectedRow(inComponent: 1)
        let row_2 = self.picker.selectedRow(inComponent: 2)
        let row_3 = self.picker.selectedRow(inComponent: 3)
        if self.delegate != nil {
            delegate.confirmClickListener(row_0, row_1: row_1, row_2: row_2, row_3: row_3)
        }
    }
    
}
