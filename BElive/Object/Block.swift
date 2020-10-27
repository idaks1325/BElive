//
//  Block.swift
//  BElive
//
//  Created by ryo on 2020/10/27.
//  Copyright © 2020 fry329. All rights reserved.
//

import SpriteKit

class Block: ObjectNode {
    
    var inEvent = true
    
    override func initializeBegan() {
        self.type = .block
    }
    
    override func contact(with node: ObjectNode) {
        //print("block")
    }
}

//---------------

@objc(Block_Bezel_tate)
class Block_Bezel_tate: Block {
    
    override func initializeBegan() {
        super.initializeBegan()
        inEvent = false
        
        self.status.name = "bezel_tate"
        self.status.size = CGSize(width: world.size.width/12, height: world.size.height)
    }
}

@objc(Block_Bezel_yoko)
class Block_Bezel_yoko: Block {
    
    override func initializeBegan() {
        super.initializeBegan()
        inEvent = false
        
        self.status.name = "bezel_yoko"
        self.status.size = CGSize(width: world.size.width, height: world.size.height/16)
    }
}

//---------------

@objc(Block_Gensei_tate)
class Block_Gensei_tate: Block {
    
    override func initializeBegan() {
        super.initializeBegan()
        self.status.name = "gensei_tate"
        self.status.size = CGSize(width: world.size.width/3, height: world.size.height)
    }
}

@objc(Block_Gensei_yoko)
class Block_Gensei_yoko: Block {
    
    override func initializeBegan() {
        super.initializeBegan()
        self.status.name = "gensei_yoko"
        self.status.size = CGSize(width: world.size.width, height: world.size.height/4)
    }
}

