//
//  VodFiltViewController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/7/12.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import PopupController

@objc protocol FiltViewClickDelegate {
    func confirmClickListener(row_0: Int,row_1: Int,row_2: Int,row_3: Int )
}

class VodFiltViewController: UIViewController, PopupContentViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var gather:VodFiltrateCategoryGather!
    weak var delegate:FiltViewClickDelegate!
    
    private var picker:UIPickerView!
    private var areaLbl:UILabel!
    private var areaBg:UIImageView!
    private var yearLbl:UILabel!
    private var yearBg:UIImageView!
    private var cateLbl:UILabel!
    private var cateBg:UIImageView!
    private var orderLbl:UILabel!
    private var orderBg:UIImageView!
    private var bgImg:UIImageView!
    private var clearBtn:UIButton!
    private var confirmBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initUI(){
        bgImg = UIImageView(image: UIImage(named: "v2_choose_drama_dlg_bg")?.resizableImageWithCapInsets(UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5), resizingMode: .Stretch))
        self.view.addSubview(bgImg)
        
        let image = UIImage(named: "v2_vod_filtrate_category_title")?.resizableImageWithCapInsets(UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5), resizingMode: .Stretch)
        
        picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.contentMode = .Top
        self.view.addSubview(picker)
        
        areaBg = UIImageView(image: image)
        self.view.addSubview(areaBg)
        
        areaLbl = UILabel()
        areaLbl.textColor = UIColor.whiteColor()
        areaLbl.textAlignment = .Center
        areaLbl.text = "地区"
        self.view.addSubview(areaLbl)
        
        yearBg = UIImageView(image: image)
        self.view.addSubview(yearBg)
        
        yearLbl = UILabel()
        yearLbl.text = "年代"
        yearLbl.textColor = UIColor.whiteColor()
        yearLbl.textAlignment = .Center
        self.view.addSubview(yearLbl)
        
        cateBg = UIImageView(image: image)
        self.view.addSubview(cateBg)
        
        cateLbl = UILabel()
        cateLbl.text = "类型"
        cateLbl.textColor = UIColor.whiteColor()
        cateLbl.textAlignment = .Center
        self.view.addSubview(cateLbl)
        
        orderBg = UIImageView(image: image)
        self.view.addSubview(orderBg)
        
        orderLbl = UILabel()
        orderLbl.textColor = UIColor.whiteColor()
        orderLbl.textAlignment = .Center
        orderLbl.text = "排序"
        self.view.addSubview(orderLbl)
        
        confirmBtn = UIButton()
        confirmBtn.setTitle("确认筛选", forState: .Normal)
        confirmBtn.titleLabel?.font = UIFont.systemFontOfSize(12)
        confirmBtn.setBackgroundImage(UIImage(named: "normal_bg"), forState: .Normal)
        confirmBtn.addTarget(self, action: #selector(self.confirmClick), forControlEvents: .TouchUpInside)
        self.view.addSubview(confirmBtn)
        
        areaLbl.snp_makeConstraints { (make) in
            make.left.equalTo(self.view)
            make.top.equalTo(self.view)
            make.width.equalTo(self.view).multipliedBy(0.2)
            make.height.equalTo(self.view).multipliedBy(0.25)
        }
        
        areaBg.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(areaLbl)
            make.left.right.equalTo(areaLbl)
        }
        
        cateLbl.snp_makeConstraints { (make) in
            make.left.equalTo(areaLbl.snp_right)
            make.top.equalTo(areaLbl)
            make.width.equalTo(areaLbl)
            make.height.equalTo(areaLbl)
        }
        
        cateBg.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(cateLbl)
            make.left.right.equalTo(cateLbl)
        }
        
        yearLbl.snp_makeConstraints { (make) in
            make.left.equalTo(cateLbl.snp_right)
            make.top.equalTo(areaLbl)
            make.width.equalTo(areaLbl)
            make.height.equalTo(areaLbl)
        }
        
        yearBg.snp_makeConstraints { (make) in
            make.left.right.equalTo(yearLbl)
            make.top.bottom.equalTo(yearLbl)
        }
        
        orderLbl.snp_makeConstraints { (make) in
            make.left.equalTo(yearLbl.snp_right)
            make.top.equalTo(areaLbl)
            make.width.equalTo(areaLbl)
            make.height.equalTo(areaLbl)
        }
        
        orderBg.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(orderLbl)
            make.left.right.equalTo(orderLbl)
        }
        
        picker.snp_makeConstraints { (make) in
            make.left.equalTo(self.view)
            make.bottom.equalTo(self.view)
            make.top.equalTo(areaLbl.snp_bottom)
            make.width.equalTo(self.view).multipliedBy(0.8)
        }
        
        bgImg.snp_makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.bottom.equalTo(self.view)
        }
        
        confirmBtn.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp_right).multipliedBy(0.9)
            //make.right.equalTo(self.view)
            make.width.equalTo(self.view).multipliedBy(0.1)
            make.centerY.equalTo(self.view)
            make.height.equalTo(self.view).multipliedBy(0.2)
        }
    }
    
    func sizeForPopup(popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        let screenWidth = UIScreen.mainScreen().bounds.width
        let screenHeight = UIScreen.mainScreen().bounds.height
        
        return CGSize(width: screenWidth,height: screenHeight * 0.4)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
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
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
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
        let row_0 = self.picker.selectedRowInComponent(0)
        let row_1 = self.picker.selectedRowInComponent(1)
        let row_2 = self.picker.selectedRowInComponent(2)
        let row_3 = self.picker.selectedRowInComponent(3)
        if self.delegate != nil {
            delegate.confirmClickListener(row_0, row_1: row_1, row_2: row_2, row_3: row_3)
        }
    }
    
}
