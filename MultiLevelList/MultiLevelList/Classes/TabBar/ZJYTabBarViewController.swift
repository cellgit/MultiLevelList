//
//  ZJYTabBarViewController.swift
//  MultiLevelList
//
//  Created by 刘宏立 on 2020/7/28.
//  Copyright © 2020 刘宏立. All rights reserved.
//

import UIKit
import SwiftyJSON

struct ZJYTabBarModel {
    var id: Int?
    var title: String?
    var image: String?
    init() {}
    init(_ json: JSON) {
        id = json["id"].intValue
        title = json["title"].stringValue
        image = json["image"].stringValue
    }
}

/*
 可通过网络请求数据动态改变Tabbar的图片和标题, 如果不需要动态加载可通过 `tabbar.json` 配置本地数据
 注: 数据格式如 `tabbar.json` 所示
 */
class ZJYTabBarViewController: UITabBarController {
    
    let jsonlist = JSON(parseJSON: try! String(contentsOfFile: Bundle.main.path(forResource: "tabbar.json", ofType: nil)!))
    var datalist = [ZJYTabBarModel]()
    
    struct ZJYTabVCStruct {
        var title: String = ""
        var image: String = ""
        var vc: UIViewController!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialData()
        addChildViewControllers()
    }
    
    func initialData() {
        if !datalist.isEmpty { datalist.removeAll() }
        jsonlist.arrayValue.forEach({ (json) in
            let model = ZJYTabBarModel.init(json)
            datalist.append(model)
        })
    }
    
    func addChildViewControllers() {
        let home = ZJYNodeTableViewController()
        let home2 = ZJYNodeTableViewController()
        let home3 = ZJYNodeTableViewController()
        let home4 = ZJYNodeTableViewController()
        let home5 = ZJYNodeTableViewController()
        
        var arrayItem = [UIViewController]()
        for model in datalist {
            var item: ZJYTabVCStruct?
            switch model.id {
            case 1001:
                item = ZJYTabVCStruct.init(title: model.title.safeWrapper, image: model.image.safeWrapper, vc: home)
            case 1002:
                item = ZJYTabVCStruct.init(title: model.title.safeWrapper, image: model.image.safeWrapper, vc: home2)
            case 1003:
                item = ZJYTabVCStruct.init(title: model.title.safeWrapper, image: model.image.safeWrapper, vc: home3)
            case 1004:
                item = ZJYTabVCStruct.init(title: model.title.safeWrapper, image: model.image.safeWrapper, vc: home4)
            case 1005:
                item = ZJYTabVCStruct.init(title: model.title.safeWrapper, image: model.image.safeWrapper, vc: home5)
            default:
                break
            }
            if let param = item {
                arrayItem.append(self.childControllers(params: param))
            }
        }
        self.viewControllers = arrayItem
    }
    
    func childControllers(params: ZJYTabVCStruct) -> UIViewController {
        let vc: UIViewController = params.vc
        vc.title = params.title
        vc.tabBarItem = UITabBarItem(title: params.title, image: UIImage(named: params.image), selectedImage: nil)
        if params.vc.isKind(of: UISplitViewController.self) {
            return params.vc
        }
        else {
            let nav = UINavigationController.init(rootViewController: vc)
            return nav
        }
    }
    
    /**
     * 选中的TabBarItem索引
     */
    func selectedItem(_ index: Int) {
         selectedIndex = index
    }
}

