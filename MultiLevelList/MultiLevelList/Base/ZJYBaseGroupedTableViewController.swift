//
//  ZJYBaseGroupedTableViewController.swift
//  MultiLevelList
//
//  Created by 刘宏立 on 2020/7/28.
//  Copyright © 2020 刘宏立. All rights reserved.
//

import UIKit
import SnapKit

class ZJYBaseGroupedTableViewController: UIViewController, UITableViewDelegate {

    open var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initialBaseTableView() {
        tableView = UITableView.init(frame: self.view.frame, style: .grouped)
        
        initialTableView()
        layoutTableView()
    }
    
    func initialTableView() {
        view.addSubview(tableView)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 55
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
    }
    
    func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
}

