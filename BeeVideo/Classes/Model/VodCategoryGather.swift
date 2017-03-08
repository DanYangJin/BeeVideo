//
//  VodCategoryGather.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/19.
//  Copyright © 2016年 skyworth. All rights reserved.
//



/**
 点播列表分类的所有分类的集合的数据结构（展示在点播列表界面的左边的分类列表）
 
 */
class VodCategoryGather{
    
    var defVodCategory : VodCategory!
    var vodCategoryList : Array<VodCategory> = Array<VodCategory>()
    
    //拼接本地默认的分类
    func assembleLocalCategory(_ channelId: String){
        var cate : VodCategory = VodCategory()
        cate.channelId = channelId
        cate.id = VodCategory.ID_FILTER_CATEGORY_VIDEO
        cate.name = "筛选"
        vodCategoryList.insert(cate, at: 0)
        
        cate = VodCategory()
        cate.channelId = channelId
        cate.name = "搜索"
        cate.id = VodCategory.ID_SEARCH
        vodCategoryList.insert(cate, at: 1)
        
        var title : String = ""
        for category in vodCategoryList{
            if category.id == VodCategory.ID_ALL_CATEGORY_VIDEO {
                title = category.title
                break
            }
        }
        
        for category in vodCategoryList {
            if category.id == VodCategory.ID_FILTER_CATEGORY_VIDEO {
                category.title = title
                continue
            }
            if category.id == VodCategory.ID_SEARCH {
                category.title = title
                continue
            }
        }
    }
}
