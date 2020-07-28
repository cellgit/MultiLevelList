//
//  ZJYBaseGroupedTableViewController.swift
//  MultiLevelList
//
//  Created by 刘宏立 on 2020/7/28.
//  Copyright © 2020 刘宏立. All rights reserved.
//

import Foundation
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
        requestData()
        fixEdgePanGestureRecognizer()
    }
    
    func initialTableView() {
        view.addSubview(tableView)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 55
        tableView.showsVerticalScrollIndicator = false
//        tableView.register(UITableViewCell.self)
        tableView.delegate = self
    }
    
    func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    func requestData() {
        
    }

}

extension ZJYBaseGroupedTableViewController {
    /**
     * 修正可能的侧滑手势冲突
     * 注意: 这里只写了UITableView的和BaseViewController侧滑手势冲突处理,
     *     ScrollView,TableView,CollectionView都是需要处理的, 以为它们都自带 panGestureRecognizer
     */
    func fixEdgePanGestureRecognizer() {
        //获取所有的手势
        let gestureList = self.navigationController?.view.gestureRecognizers
        gestureList?.forEach({ [weak self](gesture) in
            if gesture.isKind(of: UIScreenEdgePanGestureRecognizer.self) {
                //当是侧滑手势的时候设置panGestureRecognizer需要UIScreenEdgePanGestureRecognizer失效才生效即可
                self?.tableView.panGestureRecognizer.require(toFail: gesture)
            }
        })
    }
}

