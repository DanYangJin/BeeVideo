//
//  UIColor+Extension.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/6.
//  Copyright © 2016年 skyworth. All rights reserved.
//

//将十六进制颜色转为uicolor

extension UIColor{
    
    static func colorWithHexString(hexString: String) -> UIColor{
        return colorWithHexString(hexString, alpha: CGFloat(1))
    }
    
    static func colorWithHexString(hexString: String,alpha: CGFloat) -> UIColor{
        
        var cString = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString as NSString
        
        if cString.hasPrefix("#") {
            cString = cString.substringFromIndex(1)
        }
        
        let rString = cString.substringToIndex(2)
        let gString = (cString.substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = (cString.substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0,g:CUnsignedInt = 0,b:CUnsignedInt = 0
        
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
    }
    
}

extension UIColor{
    
    class func textBlueColor() -> UIColor{
        return colorWithHexString("0d9aff")
    }
    
}
