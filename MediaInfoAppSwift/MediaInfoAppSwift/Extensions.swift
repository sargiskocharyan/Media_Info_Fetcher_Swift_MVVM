//
//  Extensions.swift
//  TestMediaInfoApp
//
//  Created by sargis on 2/10/18.
//  Copyright © 2018 sargis. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

extension UICollectionView {
    open func cellSize() -> CGSize {
        let contentWidth = self.bounds.width - 20
        let spacing: CGFloat = 10
        if self.traitCollection.horizontalSizeClass == .regular && self.traitCollection.verticalSizeClass == .regular { //iPad
            if self.bounds.width > self.bounds.height { //landscape
                let width = (contentWidth - spacing * 3) / 2
                let height = width / 16 * 25
                return CGSize(width: width, height: height)
            } else {
                let width = (contentWidth - spacing * 3) / 4
                let height = width / 16 * 25
                return CGSize(width: width, height: height)
            }
        }
        if self.traitCollection.verticalSizeClass == .compact { //iPhone landscape
            let width = (contentWidth - spacing * 3) / 2
            let height = width
            return CGSize(width: width, height: height)
        }
        //iPhone portrait and all iPad split views
        let width = (contentWidth - spacing)
        let height = width  
        return CGSize(width: width, height: height)
    }
    
    open func cellSizeForThumbnail() -> CGSize {
        let contentWidth = self.bounds.width - 20
        let spacing: CGFloat = 10
        let width = (contentWidth - spacing) / 2
        let height = width  
        return CGSize(width: width, height: height)
    }
    
}


extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }

        return array
    }
}


