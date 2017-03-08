//
//  AccountPoinRecordViewController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/21.
//  Copyright © 2016年 skyworth. All rights reserved.
//



class AccountPoinRecordViewController: BaseBackViewController,UITableViewDelegate,UITableViewDataSource {

    fileprivate var mTableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = "我的帐户"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell(style: .default, reuseIdentifier: "11")
    }
    
}
