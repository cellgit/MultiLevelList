//
//  ZJYNodeCell.swift
//  MultiLevelList
//
//  Created by 刘宏立 on 2020/7/28.
//  Copyright © 2020 刘宏立. All rights reserved.
//

import UIKit

@objc
protocol ZJYNodeCellDelegate: NSObjectProtocol {
    //选中的代理
    func nodeCellSelected(cell: ZJYNodeCell, selected: Bool, indexPath: IndexPath)
    //展开的代理
    func nodeCellExpand(cell: ZJYNodeCell, expand: Bool, indexPath: IndexPath)
}


class ZJYNodeCell: ZJYBaseNodeCell {
    // cell的位置
    open var cellIndexPath: IndexPath!
    // cell的宽高
    open var cellSize: CGSize = .zero
    
    open weak var delegate: ZJYNodeCellDelegate?
    
    // 选中按钮
    private lazy var selectedBtn = UIButton.init(type: .custom)
    // 名字
    private lazy var nameLabel = UILabel.init()
    // 细线
    private lazy var line = UIView.init()
    
    override func initial() {
        contentView.addSubview(selectedBtn)
        contentView.addSubview(expandBtn)
        contentView.addSubview(nameLabel)
        
        selectedBtn.addTarget(self, action: #selector(selectedClicked(sender:)), for: .touchUpInside)
        expandBtn.addTarget(self, action: #selector(expandBtnClicked(sender:)), for: .touchUpInside)
    }
    
    @objc func selectedClicked(sender: UIButton) {
        node.selected == false ? selectedBtn.setImage(UIImage.init(named: "selected"), for: .normal) : selectedBtn.setImage(UIImage.init(named: "disSelected"), for: .normal)
        node.selected = !node.selected
        
        guard let delegate = delegate else { return }
        if delegate.responds(to: #selector(ZJYNodeCellDelegate.nodeCellSelected(cell: selected: indexPath:))) {
            delegate.nodeCellSelected(cell: self, selected: node.selected, indexPath: cellIndexPath)
        }
    }
    @objc func expandBtnClicked(sender: UIButton) {
        node.expand == false ? expandBtn.setImage(UIImage.init(named: "expand"), for: .normal) : expandBtn.setImage(UIImage.init(named: "noExpand"), for: .normal)
        node.expand = !node.expand
        guard let delegate = delegate else { return }
        if delegate.responds(to: #selector(ZJYNodeCellDelegate.nodeCellExpand(cell: expand: indexPath:))) {
            delegate.nodeCellExpand(cell: self, expand: node.expand, indexPath: cellIndexPath)
        }
        
        
    }
}

extension ZJYNodeCell {
    func refreshCell() {
        node.selected == true ? selectedBtn.setImage(UIImage.init(named: "selected"), for: .normal): selectedBtn.setImage(UIImage.init(named: "selected"), for: .normal)
        node.expand == true ? expandBtn.setImage(UIImage.init(named: "expand"), for: .normal) : expandBtn.setImage(UIImage.init(named: "noExpand"), for: .normal)
        
        let selectedSize = CGSize(width: 20, height: 20)
        let expandSize = CGSize(width: 20, height: 20)
        
        let selectedBtn_x = 8 + CGFloat(node.level - 1) * selectedSize.width
        let selectedBtn_y = (self.cellSize.height - selectedSize.height)/2.0
        selectedBtn.frame = CGRect(x: selectedBtn_x, y: selectedBtn_y, width: selectedSize.width, height: selectedSize.height)
        
        let expand_x = cellSize.width - 8 - expandSize.width + 8
        let expand_y = (cellSize.height - expandSize.height)/2.0
        let expand_width = selectedSize.width
        let expand_height = selectedSize.height
        expandBtn.frame = CGRect(x: expand_x, y: expand_y, width: expand_width, height: expand_height)
        
        let nameLabel_x = selectedBtn.frame.origin.x + selectedSize.width + 8
        let nameLabel_y: CGFloat = 0.0
        let nameLabel_width = expandBtn.frame.origin.x - 8 - (selectedBtn.frame.origin.x + selectedSize.width + 8)
        let nameLabel_height = cellSize.height
        nameLabel.frame = CGRect(x: nameLabel_x, y: nameLabel_y, width: nameLabel_width, height: nameLabel_height)
        nameLabel.text = node.name
        
        node.leaf == true ? (expandBtn.isHidden = true) : (expandBtn.isHidden = false)
    }
}

