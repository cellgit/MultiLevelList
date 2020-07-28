//
//  Optional+Extension.swift
//  MultiLevelList
//
//  Created by 刘宏立 on 2020/7/28.
//  Copyright © 2020 刘宏立. All rights reserved.
//

extension Optional where Wrapped == Double {
    var safeWrapper: Wrapped {
        switch self {
        case let .some(value):
            return value
        default:
            return 0
        }
    }
    
}

extension Optional where Wrapped == Int {
    var safeWrapper: Wrapped {
        switch self {
        case let .some(value):
            return value
        default:
            return 0
        }
    }
}

extension Optional where Wrapped == Float {
    var safeWrapper: Wrapped {
        switch self {
        case let .some(value):
            return value
        default:
            return 0
        }
    }
}

extension Optional where Wrapped == String {
    var safeWrapper: Wrapped {
        switch self {
        case let .some(value):
            return value
        default:
            return ""
        }
    }
}

