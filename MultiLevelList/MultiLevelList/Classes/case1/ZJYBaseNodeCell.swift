//
//  ZJYBaseNodeCell.swift
//  MultiLevelList
//
//  Created by 刘宏立 on 2020/7/28.
//  Copyright © 2020 刘宏立. All rights reserved.
//

import UIKit

class ZJYBaseNodeCell: ZJYBaseTableViewCell {

    // 结点
    open var node: ZJYCellNodeModel!
    
    // 展开按钮
    open lazy var expandBtn = UIButton.init(type: .custom)

}
