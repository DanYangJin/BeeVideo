//
//  ViewController.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/18.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import MediaPlayer

class TestViewController: UIViewController, UIWebViewDelegate{
    
    var mwebview : UIWebView!
    
    override func viewDidLoad() {
        mwebview = UIWebView()
        mwebview.allowsInlineMediaPlayback = true
        mwebview.delegate = self
        self.view.addSubview(mwebview)
        mwebview.snp_makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.bottom.equalTo(self.view)
        }
        
//        let js = "window.onload = function(){document.body.style.backgroundColor = '#3333';//#3333 is your color}"
    
        let url = NSURL(string: "http://www.iqiyi.com/v_19rrllxz4g.html?fc=8b62d5327a54411b#vfrm=19-9-0-1")
        let request = NSURLRequest(URL: url!)
        
        mwebview.loadRequest(request)
        
        
    }
//    
//    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
//        //print(request.URLString)
//        
//        return true
//    }
    
//    func webViewDidFinishLoad(webView: UIWebView) {
//        let js = "window.onload = function(){document.body.style.backgroundColor = '#3333';//#3333 is your color}"
//        let result = webView.stringByEvaluatingJavaScriptFromString(js)
//        print(result)
//    }
    func webViewDidStartLoad(webView: UIWebView) {
        print(webView.request?.URLString)
    }
    
    
    func webViewDidFinishLoad(webView: UIWebView) {
        //let js = "document.documentElement.innerHTML"
       // let html = webView.stringByEvaluatingJavaScriptFromString(js)
        //print(html)
        
        
        
        let js2 = "document.getElementsByTagName(\"video\")[0]).getElementsByTagName(\"source\")[0].src"
        let m3u8 = webView.stringByEvaluatingJavaScriptFromString(js2)
        print(m3u8)
        
    }
    
}
    


