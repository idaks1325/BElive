//
//  Maps.swift
//  BElive
//
//  Created by ryo on 2020/10/27.
//  Copyright © 2020 fry329. All rights reserved.
//

import SpriteKit

struct Maps {
    var animals:[String] = []
    var layout:[[Any]] = []
    var thema = ""
    var size: (x:Int, y:Int) = (0, 0)
    init(_ data: [String : Any]){
        self.animals = data["animals"]! as! [String]
        self.layout = data["layout"]! as! [[Any]]
        self.thema = data["thema"]! as! String
        
        let s = data["size"]! as! [Int]
        self.size = (s[0], s[1])
    }
    
}
