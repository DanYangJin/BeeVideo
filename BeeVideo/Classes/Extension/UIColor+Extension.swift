//
//  UIColor+Extension.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/6.
//  Copyright © 2016年 skyworth. All rights reserved.
//

//将十六进制颜色转为uicolor

extension UIColor{
    
    static func colorWithHexString(_ hexString: String) -> UIColor{
        return colorWithHexString(hexString, alpha: CGFloat(1))
    }
    
    static func colorWithHexString(_ hexString: String,alpha: CGFloat) -> UIColor{
        
        var cString = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased() as NSString
        
        if cString.hasPrefix("#") {
            cString = cString.substring(from: 1) as NSString
        }
        
        let rString = cString.substring(to: 2)
        let gString = (cString.substring(from: 2) as NSString).substring(to: 2)
        let bString = (cString.substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0,g:CUnsignedInt = 0,b:CUnsignedInt = 0
        
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
    }
    
}

extension UIColor{
    
    class func textBlueColor() -> UIColor{
        return colorWithHexString("0d9aff")
    }
    
}
