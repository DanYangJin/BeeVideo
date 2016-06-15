//
//  GridViewMatrixTransformer<T>.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/13.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class GridViewMatrixTransformer {

    func multiPageTransform<T>(matrixsList: [T]?,row: Int,col: Int) -> [T]?{
        if matrixsList == nil || (matrixsList?.isEmpty)! {
            return nil
        } else if matrixsList!.count < 2{
            return matrixsList
        }
        
        if row < 1 || col < 1 {
            return nil
        }else if row < 2 || col < 2 {
            return matrixsList
        }
        
        let pageSize = row * col
        let pageNum = matrixsList!.count / pageSize
        var matrix:[T] = [T]()
        var res:[T] = [T]()
        var singleResult:[T]?
        var base = 0, baseEnd = 0
        for i in 0..<pageNum {
            matrix.removeAll()
            base = i * pageSize
            baseEnd = (i + 1) * pageSize
            for j in base..<baseEnd{
                matrix.append(matrixsList![j])
            }
            print(matrix)
            singleResult = singlePageTransform(matrix, row: row, col: col)
            if singleResult != nil {
                for item in singleResult! {
                    res.append(item)
                }
            }else{
                return nil
            }
        }
        
        base = pageNum * pageSize
        if base < matrixsList!.count {
            matrix.removeAll()
            
            for i in base..<matrixsList!.count {
                matrix.append(matrixsList![i])
            }
            let mod = (matrixsList!.count) % pageSize
            let modRow = (mod + col - 1) / col
            singleResult = singlePageTransform(matrix, row: modRow, col: col)
            if singleResult != nil {
                for item in singleResult! {
                    res.append(item)
                }
            }else{
                return nil
            }
        }
        matrix.removeAll()
        singleResult = nil
        
        return res
    }
    
    
    func singlePageTransform<T>(matrix: [T]?,row: Int,col: Int) -> [T]?{
        
        if matrix == nil || (matrix?.isEmpty)! {
            return nil
        } else if matrix!.count < 2{
            return matrix
        }
        
        if row < 1 || col < 1 {
            return nil
        }else if row < 2 || col < 2 {
            return matrix
        }else if (matrix!.count < (row - 1) * col + 1 || matrix!.count > row * col) {
            // 矩阵最后一行无数据或者数组超过矩阵大小则无法进行单个矩阵转换, 即控制矩阵大小
            return nil;
        }

        let size = matrix!.count
        var matrixIndex = 0
        var res:[T] = Array<T>(count: size,repeatedValue: matrix![0])
        for i in 0..<col {
            for j in 0..<row {
                let index = j * col + i
                if index < size && matrixIndex < size{
                    res[index] = matrix![matrixIndex]
                    matrixIndex += 1
                }
            }
        }
        
        return res
    }
    
    
}
