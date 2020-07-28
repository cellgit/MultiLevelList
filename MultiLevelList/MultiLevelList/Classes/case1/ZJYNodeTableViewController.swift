//
//  ZJYNodeTableViewController.swift
//  MultiLevelList
//
//  Created by 刘宏立 on 2020/7/28.
//  Copyright © 2020 刘宏立. All rights reserved.
//

import UIKit

//最大的层级数
let MaxLevel: Int = 4

class ZJYNodeTableViewController: ZJYBaseGroupedTableViewController {
    
    var datalist = [ZJYCellNodeModel]()
    
    var selectedDatalist = [ZJYCellNodeModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        initData()
        initialBaseTableView()
        initial()
    }
    
    
    
    func initial() {
        tableView.dataSource = self
        tableView.register(ZJYNodeCell.self, forCellReuseIdentifier: "ZJYNodeCell")
        
    }
    
    // 获取并初始化 树根结点数组
    func initData() {
//        if !datalist.isEmpty { datalist.removeAll() }
        for _ in 0..<4 {
            let node = ZJYCellNodeModel.init()
            node.parentID = ""
            node.childrenID = ""
            node.level = 1
            node.name = "第\(node.level)级结点"
            node.leaf = false // true,则结点下面没有结点
            node.root = true // true,则parentID = nil
            node.expand = false
            node.selected = false
            datalist.append(node)
        }
    }
    
}

extension ZJYNodeTableViewController {
    /**
    获取并展开父结点的子结点数组 数量随机产生
    @param level 父结点的层级
    @param indexPath 父结点所在的位置
    */
    func expandChildrenNodesLevel(_ level: Int, _ indexPath: IndexPath) {
        let nodeModel = datalist[indexPath.row]
        var insertNodeRows = [IndexPath]()
        let insertLocation = indexPath.row + 1
        for i in 0..<arc4random()%9 {
            let node = ZJYCellNodeModel.init()
            node.parentID = ""
            node.childrenID = ""
            node.level = level + 1
            node.name = "第\(node.level)级结点"
            node.leaf = (node.level < MaxLevel) ? false : true
            node.root = false
            node.expand = false
            node.selected = nodeModel.selected
            datalist.insert(node, at: insertLocation+Int(i))
            insertNodeRows.append(IndexPath.init(row: insertLocation + Int(i), section: 0))
        }
        
        // insert cell
        tableView.beginUpdates()
        tableView.insertRows(at: insertNodeRows, with: .none)
        tableView.endUpdates()
        //更新新insert的元素之后的所有cell的cellIndexPath
        var reloadRows = [IndexPath]()
        
        let reloadLocation: Int = insertLocation + insertNodeRows.count
        for i in reloadLocation..<datalist.count {
            reloadRows.append(IndexPath.init(row: i, section: 0))
        }
        tableView.reloadRows(at: reloadRows, with: .none)
    }
}

extension ZJYNodeTableViewController {
    /**
    获取并隐藏父结点的子结点数组
    @param level 父结点的层级
    @param indexPath 父结点所在的位置
    */
    func hiddenChildrenNodesLevel(_ level: Int, _ indexPath: IndexPath) {
        var deleteNodeRows = [IndexPath]()
        var length: Int = 0
        let deleteLocation: Int = indexPath.row + 1
        for i in deleteLocation..<datalist.count {
            let node = datalist[i]
            if node.level > level {
                deleteNodeRows.append(IndexPath.init(row: i, section: 0))
                length = length + 1
            }
            else {
                break
            }
        }
//        datalist.removeSubrange(deleteLocation..<deleteLocation+length)
        datalist.removeSubrange(deleteLocation..<deleteLocation+length)
        tableView.beginUpdates()
        tableView.deleteRows(at: deleteNodeRows, with: .none)
        tableView.endUpdates()
        //更新删除的元素之后的所有cell的cellIndexPath
        var reloadRows = [IndexPath]()
        let reloadLocation: Int = deleteLocation
        
        for i in reloadLocation..<datalist.count {
            reloadRows.append(IndexPath.init(row: i, section: 0))
        }
        tableView.reloadRows(at: reloadRows, with: .none)
    }
}

extension ZJYNodeTableViewController {
    /**
    更新当前结点下所有子结点的选中状态
    @param level 选中的结点层级
    @param selected 是否选中
    @param indexPath 选中的结点位置
    */
    func selectedChildrenNodes(_ level: Int, _ selected: Bool, _ indexPath: IndexPath) {
        var selectedNodeRows = [IndexPath]()
        let deleteLocation = indexPath.row + 1
        for i in deleteLocation..<datalist.count {
            let node = datalist[i]
            if node.level > level {
                node.selected = selected
                selectedNodeRows.append(IndexPath.init(row: i, section: 0))
            }
            else {
                break
            }
        }
        tableView.reloadRows(at: selectedNodeRows, with: .none)
    }
}


extension ZJYNodeTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell1 = tableView.dequeueReusableCell(withIdentifier: "ZJYNodeCell")
        if cell1 == nil {
            cell1 = ZJYNodeCell.init(style: .value1, reuseIdentifier: "ZJYNodeCell")
        }
        let cell = cell1 as! ZJYNodeCell
        
//        let cell = tableView.dequeueReusableCell(ZJYNodeCell.self, indexPath)
        let node: ZJYCellNodeModel = datalist[indexPath.row]
        cell.node = node
        cell.delegate = self
        cell.cellSize = CGSize(width: self.view.frame.width, height: 55)
        cell.cellIndexPath = indexPath
        cell.refreshCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        reloadSelectedCell(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    /**
     * 这里要求本类的cell都继承于 ZJYBaseNodeCell,便于使用 ZJYBaseNodeCell 的公共属性: 如 isExpand
     */
    func reloadSelectedCell(_ indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ZJYBaseNodeCell
        cell.node.expand == false ? cell.expandBtn.setImage(UIImage.init(named: "expand"), for: .normal) : cell.expandBtn.setImage(UIImage.init(named: "noExpand"), for: .normal)
        cell.node.expand = !cell.node.expand
        if cell.node.expand == true && cell.node.level < MaxLevel {
            self.expandChildrenNodesLevel(cell.node.level, indexPath)
        }
        else if cell.node.expand == false && cell.node.level < MaxLevel {
            self.hiddenChildrenNodesLevel(cell.node.level, indexPath)
        }
    }
}


extension ZJYNodeTableViewController: ZJYNodeCellDelegate {
    func nodeCellSelected(cell: ZJYNodeCell, selected: Bool, indexPath: IndexPath) {
        self.selectedChildrenNodes(cell.node.level, selected, indexPath)
    }
    
    func nodeCellExpand(cell: ZJYNodeCell, expand: Bool, indexPath: IndexPath) {
//        expand == true ? self.expandChildrenNodesLevel(cell.node.level, indexPath) : self.hiddenChildrenNodesLevel(cell.node.level, indexPath)
        if expand == true {
            self.expandChildrenNodesLevel(cell.node.level, indexPath)
        }else{
            self.hiddenChildrenNodesLevel(cell.node.level, indexPath)
        }
    }
}

