//
//  ZJYCellNodeModel.swift
//  MultiLevelList
//
//  Created by 刘宏立 on 2020/7/28.
//  Copyright © 2020 刘宏立. All rights reserved.
//

import Foundation

//每个结点信息，采用的是树状结构模型 关于树状结构不了解的可以看看这篇文章 https://www.jianshu.com/p/c545c93f2585

class ZJYCellNodeModel: NSObject {
    // 父结点ID 即当前结点所属的的父结点ID
    var parentID: String?
    //子结点ID 即当前结点的ID
    var childrenID: String?
    //结点名字
    var name: String?
    // 结点层级 从1开始
    var level: Int = 1
    // 树叶(Leaf) If YES：此结点下边没有结点咯；
    var leaf: Bool = false
    // 树根((Root) If YES: parentID = nil
    var root: Bool = false
    // 是否展开
    var expand: Bool = false
    // 是否选中
    var selected: Bool = false
}

