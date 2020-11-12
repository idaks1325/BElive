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

@objc(Block_Back_A)
class Block_Back_A: Block {
    
    override func initializeBegan() {
        super.initializeBegan()
        
        self.status.name = "background_block_a"
        self.status.size = CGSize(width: world.size.width * 5, height: world.size.height * 5)
    }
    
}

//---------------

@objc(Block_Bezel_tate)
class Block_Bezel_tate: Block {
    
    override func initializeBegan() {
        super.initializeBegan()
        inEvent = false
        
        self.status.name = "bezel_tate"
        self.status.size = CGSize(width: world.size.width/12/4, height: world.size.height)
    }
}

@objc(Block_Bezel_yoko)
class Block_Bezel_yoko: Block {
    
    override func initializeBegan() {
        super.initializeBegan()
        inEvent = false
        
        self.status.name = "bezel_yoko"
        self.status.size = CGSize(width: world.size.width, height: world.size.height/16/4)
    }
}
