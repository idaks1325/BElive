//
//  Trap.swift
//  BElive
//
//  Created by ryo on 2020/10/28.
//  Copyright © 2020 fry329. All rights reserved.
//

import SpriteKit

class Trap: ObjectNode {
    override func initializeBegan() {
        self.type = .Trap
    }
    override func addObject() {
        world.addNode(self, parent: type, physics: false)
    }
}

@objc(SansoBig)
class SansoBig: Trap {

    override func initializeBegan() {
        super.initializeBegan()
        
        let size = CGSize(width: 1800, height: 1800)
        self.status = Status(name: "sanso_big", size: size)
    }
    
    override func addObject() {
        super.addObject()
        self.name = "sanso1"
        self.zPosition = -3
    }

}

@objc(SansoSmall)
class SansoSmall: Trap {

    override func initializeBegan() {
        super.initializeBegan()
        
        let size = CGSize(width: 1000, height: 1000)
        self.status = Status(name: "sanso_small", size: size)
    }
    override func addObject() {
        super.addObject()
        self.name = "sanso2"
        self.zPosition = -2
    }

}
