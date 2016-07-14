//
//  VodFiltViewController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/7/12.
//  Copyright © 2016年 skyworth. All rights reserved.
//

class VodFiltViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    private var picker:UIPickerView!
    private var areaLbl:UILabel!
    private var yearLbl:UILabel!
    private var cateLbl:UILabel!
    private var orderLbl:UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initUI(){
        picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        self.view.addSubview(picker)
        
        areaLbl = UILabel()
        self.view.addSubview(areaLbl)
        
        yearLbl = UILabel()
        self.view.addSubview(yearLbl)
        
        cateLbl = UILabel()
        self.view.addSubview(cateLbl)
        
        orderLbl = UILabel()
        self.view.addSubview(orderLbl)
        
        picker.snp_makeConstraints { (make) in
            make.left.equalTo(self.view)
            make.bottom.equalTo(self.view)
            make.width.equalTo(self.view).multipliedBy(0.8)
        }
        
        
        
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
 
    
}
