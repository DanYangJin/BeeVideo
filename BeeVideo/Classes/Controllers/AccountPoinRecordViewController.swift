//
//  AccountPoinRecordViewController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/21.
//  Copyright © 2016年 skyworth. All rights reserved.
//



class AccountPoinRecordViewController: BaseBackViewController,UITableViewDelegate,UITableViewDataSource {

    private var mTableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = "我的帐户"
     
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell(style: .Default, reuseIdentifier: "11")
    }
    
}
