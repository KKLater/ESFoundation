//
//  File.swift
//  
//
//  Created by 罗树新 on 2020/12/21.
//

import Foundation

public extension Array {
    
    /// 拼接数组中满足条件的所有数据，或拼接所有数组中的数据，等价于 +=
    /// - Parameters:
    ///   - elements: 需要拼接的数据数组
    ///   - shouldBeAppend: 用于校验是否满足拼接条件
    ///
    ///         var array = [1, 2, 3, 4, 5]
    ///         let array1 = [1, 3, 10, 4, 9]
    ///         array.append(elements: array1) { $0 > 5 }
    ///         // array: [1, 2, 3, 4, 5, 10, 9]
    ///
    /// 或者，不需要筛选校验
    ///
    ///         var array = [1, 2, 3, 4, 5]
    ///         let array1 = [1, 3, 10, 4, 9]
    ///         array.append(elements: array1)
    ///         // array: [1, 2, 3, 4, 5, 1, 3, 10, 4, 9]
    ///
    mutating func append(elements: [Element], where shouldBeAppend: ((Element) -> Bool)? = nil) {
        guard let shouldBeAppend = shouldBeAppend else {
            self += elements
            return
        }
        for element in elements {
            if shouldBeAppend(element) == true {
                append(element)
            }
        }
    }
    
    
    /// 获取数组中，所有满足筛选条件的数据的下标
    /// - Parameter shouldBeIndex: 筛选条件
    /// - Returns: 下标数组
    ///
    ///         var array = [1, 2, 2, 3, 4, 6]
    ///         // 找出所有偶数数据
    ///         let indexs = array.indexes { $0 % 2 == 0 }
    ///         // index: [1, 2, 4, 5]
    ///
    func indexes(where shouldBeIndex: (Element) -> Bool) -> [Int] {
        var indexes = [Int]()
        for index in 0..<count  {
            let element = self[index]
            if shouldBeIndex(element) {
                indexes.append(index)
            }
        }
        return indexes
    }
    
    /// 将数组中满足筛选条件的数据遍历执行 action 操作，并将执行后的结果，输出为新的数组
    /// - Parameters:
    ///   - action: 数组执行操作
    ///   - shouldBeEnumerated: 数据筛选条件
    /// - Returns: 数据处理后的新的数据
    ///
    ///         var array = [1, 2, 2, 3, 4, 6]
    ///         // 找出所有的偶数，并将偶数 + 10
    ///         let newArray = array.enumerated { (number) -> Int in
    ///             return number + 10
    ///         } where: { (number) -> Bool in
    ///             return number % 2 == 0
    ///         }
    ///         // newArray: [12, 12, 14, 16]
    ///
    /// 或者不需要筛选条件，全部数据都做处理
    ///
    ///         // 所有数据 + 10
    ///         let newArray = array.enumerated { $0 + 10 }
    ///
    func enumerated<T>(action: (Element) -> T, where shouldBeEnumerated: ((Element) -> Bool)? = nil) -> [T] {
        var array = [T]()
        for element in self {
            if let shouldBeEnumerated = shouldBeEnumerated {
                if shouldBeEnumerated(element) {
                    let t = action(element)
                    array.append(t)
                }
            } else {
                let t = action(element)
                array.append(t)
            }
        }
        return array
    }
    
    /// 遍历执行筛选满足条件的数据
    /// - Parameter shouldBeEnumerated: 筛选条件
    /// - Returns: 所有经过少选满足条件的数据
    ///
    ///         var array = [1, 2, 2, 3, 4, 5, 6]
    ///         // 找出所有的偶数
    ///         let newArray = array.enumberated { $0 % 2 == 0 }
    ///         // newArray: [2, 2, 4, 6]
    ///
    func enumerated(where shouldBeEnumerated: (Element) -> Bool) -> [Element] {
        var array = [Element]()
        for element in self {
            if shouldBeEnumerated(element) {
                array.append(element)
            }
        }
        return array
    }
    
    
    /// 筛选数组中满足筛选条件的数据
    /// - Parameter shouldBeFilter: 筛选条件处理
    /// - Returns: 满足筛选条件的数据
    ///
    ///         var array = [1, 2, 2, 3, 4, 5, 6]
    ///         // 找出所有偶数 等价于 array.enumberated(where:)
    ///         let newArray = array.filter { $0 % 2 == 0 }
    ///         // newArray: [2, 2, 4, 6]
    ///
    func filter(where shouldBeFilter:(Element) -> Bool) -> [Element] {
        var arrat = [Element]()
        for element in self {
            if shouldBeFilter(element) {
                arrat.append(element)
            }
        }
        return arrat
    }

    
    /// 找出数组中的重复数据，由 creatDuplicateKey 确定重复条件
    /// - Parameter creatDuplicateKey: 重复条件判定
    /// - Returns: 数组中的重复数据
    ///
    ///         var array = [1, 2, 2, 3, 4, 3, 9]
    ///         // 找出所有重复数据，条件为 其 string 值相等
    ///         let newArray = array.filterDuplicates { "\($0)" }
    ///         // newArray: [2, 3]
    ///
    func filterDuplicates<E: Equatable>(_ creatDuplicateKey:(Element) -> E) -> [Element] {
        var keys = [E]()
        var duplicates = [Element]()
        
        for value in self {
            let key = creatDuplicateKey(value)
            if keys.contains(key){
                duplicates.append(value)
            } else {
                keys.append(key)
            }
        }
        return duplicates
    }
    
    /// 清理掉数组中的重复数据，由 creatDuplicateKey 判定重复条件
    /// - Parameter creatDuplicateKey: 重复条件
    /// - Returns: 经 filter 判定为重复的数据
    ///
    ///         var array = [1, 2, 2, 3, 4, 3, 9]
    ///         // 找出所有重复数据，条件为 其 string 值相等
    ///         let newArray = array.removeDuplicates { "\($0)" }
    ///         // newArray: [1, 2, 3, 4, 9]
    ///
    func removeDuplicates<E: Equatable>(_ creatDuplicateKey:(Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = creatDuplicateKey(value)
            if !result.map({ creatDuplicateKey($0) }).contains(key){
                result.append(value)
            }
        }
        return result
    }

}


public extension Array where Element: Equatable {
    
    /// 移除数组中的所有与 element 相等的数据 等价于 removeAll { $0 == element }
    /// - Parameter element: 需要移除的数据
    ///
    ///     var array = [1, 2, 3, 4, 3, 2, 1]
    ///     array.removeAll(2)
    ///     // array: [1, 3, 4, 3, 1]
    ///
    mutating func removeAll(_ element: Element) {
        removeAll { $0 == element }
    }
    
    /// 移除数组中，与element 相等的第一个元素
    /// - Parameter element: 需要移除的数据
    ///
    ///     var array = [1, 2, 3, 3, 2, 1]
    ///     array.removeFirst(2)
    ///     // array: [1, 3, 3, 2, 1]
    ///
    mutating func removeFirst(_ element: Element) {
        if let index = firstIndex(of: element) {
            remove(at: index)
        }
    }
    
    /// 移除数组中，与element 相等的最后一个元素
    /// - Parameter element: 需要移除的数据
    ///
    ///     var array = [1, 2, 3, 3, 2, 1]
    ///     array.removeLast(2)
    ///     // array: [1, 2, 3, 3, 1]
    mutating func removeLast(_ element: Element) {
        if let index = lastIndex(of: element) {
            remove(at: index)
        }
    }
    
    /// 移除数组中，element 包含且满足移除条件的数据
    /// - Parameters:
    ///   - elements: elements 包含的数据
    ///   - shouldBeRemoved: 移除条件判定
    ///
    ///         var array = [1, 2, 3, 3, 2, 1]
    ///         array.remove(elements: [1, 5, 3]) { $0 >= 3 }
    ///         // array: [1, 2, 2, 1]
    /// 或者不需要移除筛选条件
    ///
    ///         var array = [1, 2, 3, 3, 2, 1]
    ///         array.remove(elements: [1, 5, 3])
    ///         // array: [2, 2]
    ///
    mutating func remove(elements: [Element], where shouldBeRemoved: ((Element) -> Bool)? = nil) {
        for element in elements {
            if contains(where: { $0 == element }) {
                if let shouldBeRemoved = shouldBeRemoved {
                    if shouldBeRemoved(element) == true {
                        removeAll { $0 == element }
                    }
                } else {
                    removeAll { $0 == element }
                }
            }
        }
    }
    
    /// 清理掉数组中的重复数据
    /// self =  removeDuplicates { $0 }
    mutating func removeDuplicates() {
        self = removeDuplicates { $0 }
    }


}
