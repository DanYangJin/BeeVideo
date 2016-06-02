//
//  DataFactory.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/19.
//  Copyright © 2016年 skyworth. All rights reserved.
//

class DataFactory{
    
    static var cycleItems:[CycleItemInfo] = [
        CycleItemInfo(desp: "刘欢上演婚孕保卫战", picUrl: "cycle1"),
        CycleItemInfo(desp: "两男一女的纠缠恋爱", picUrl: "cycle2"),
        CycleItemInfo(desp: "生二胎是否搞定老大", picUrl: "cycle3"),
        CycleItemInfo(desp: "冰封60年的人鬼情未", picUrl: "cycle4"),
        CycleItemInfo(desp: "余明家诠释温情之作", picUrl: "cycle5")
    ]
    
    //图片集合
    static var blockItems:[CycleItemInfo] = [
        CycleItemInfo(desp: "我的影视", picUrl: "http://img.beevideo.tv/filestore/906/baaneoda2.webp"),
        CycleItemInfo(desp: "周热播", picUrl: "http://img.beevideo.tv/filestore/1161/baanojd7a.webp"),
        CycleItemInfo(desp: "院线新片", picUrl: "http://img.beevideo.tv/filestore/1162/baanok386.webp"),
    ]
    
    static var aboutItems:[CycleItemInfo] = [
        CycleItemInfo(desp: "www.beevideo.tv", picUrl: "v2_setting_about_web_icon"),
        CycleItemInfo(desp: "@蜜蜂视频", picUrl: "v2_setting_about_weibo_icon"),
        CycleItemInfo(desp: "QQ群:290127149", picUrl: "v2_setting_about_qq_icon")
    ]

    static var weekHotItems:[LeftViewTableData] = [
        LeftViewTableData(title: "电影", unSelectPic: "v2_week_hot_film_default_img", selectedPic: "v2_week_hot_film_selected_img"),
        LeftViewTableData(title: "电视剧", unSelectPic: "v2_week_hot_tvplay_default_img", selectedPic: "v2_week_hot_tvplay_selected_img"),
        LeftViewTableData(title: "综艺", unSelectPic: "v2_week_hot_tvshow_default_img", selectedPic: "v2_week_hot_tvshow_selected_img"),
        LeftViewTableData(title: "动漫", unSelectPic: "v2_week_hot_cartoon_default_img", selectedPic: "v2_week_hot_cartoon_selected_img")
    ]
    
}
