//
//  VodFiltrateCategoryGather.swift
//  BeeVideo
//
//  Created by JinZhang on 16/7/19.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class VodFiltrateCategoryGather: NSObject {
    var areaList = [VodFiltrateCategory]()
    var yearList = [VodFiltrateCategory]()
    var categoryList = [VodFiltrateCategory]()
    var orderList = [VodFiltrateCategory]()

    override init() {
        super.init()
        configOrderList()
    }
    
    
    func addFiltCategory(_ filtCategory:VodFiltrateCategory){
        switch filtCategory.type {
        case FiltType.year:
            yearList.append(filtCategory)
            break
        case FiltType.area:
            areaList.append(filtCategory)
            break
        case FiltType.category:
            categoryList.append(filtCategory)
            break
        case FiltType.order:
            orderList.append(filtCategory)
            break
        default:
            break
            
        }
    }
    
    func configOrderList(){
        let allCate = VodFiltrateCategory()
        allCate.id = Int(VodFiltrateCategory.ID_VOD_FILTRATE_ALL)
        allCate.type = FiltType.area
        allCate.name = "全部"
        
        var cate = VodFiltrateCategory(filt: allCate)
        areaList.append(cate)
        
        cate = VodFiltrateCategory(filt: allCate)
        cate.type = FiltType.category
        categoryList.append(cate)
        
        cate = VodFiltrateCategory(filt: allCate)
        cate.type = FiltType.year
        yearList.append(cate)
        
        cate = VodFiltrateCategory(filt: allCate)
        cate.id = VodFiltrateCategory.ID_VOD_FILTRATE_LAST_UPDATE
        cate.name = "最新"
        cate.type = FiltType.order
        orderList.append(cate)
        
        cate = VodFiltrateCategory(filt: allCate)
        cate.id = VodFiltrateCategory.ID_VOD_FILTRATE_MOST_POPULE
        cate.name = "最热"
        cate.type = FiltType.order
        orderList.append(cate)
        
    }
    
}
