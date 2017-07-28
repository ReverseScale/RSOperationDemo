//
//  Item.swift
//  RSOperationDemo
//
//  Created by WhatsXie on 2017/7/28.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

import Foundation

class Item {
    let count: Int
    
    init(number: Int) {
       count = number
    }
    
   static func creatItems(count: Int) -> [Item] {
        var items = [Item]()
        
        for index in 1...count {
            items.append(Item(number: index))
        }
        return items
    }
    
    func imageUrl() -> URL? {
        return URL(string:"https://placeholdit.imgix.net/~text?txtsize=33&txt=image+\(count)&w=300&h=300")
    }
}
