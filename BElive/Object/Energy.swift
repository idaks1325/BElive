//
//  Energy.swift
//  BElive
//
//  Created by ryo on 2020/10/27.
//  Copyright © 2020 fry329. All rights reserved.
//

import SpriteKit

class Energy: ObjectNode {
    override func initializeBegan() {
        self.type = .energy
    }
    
    override func contact(with node: ObjectNode) {
        let x_ram = CGFloat.random(in: 0...CGFloat(world.maps.size.x - 1))
        let y_ram = CGFloat.random(in: 0...CGFloat(world.maps.size.y - 1))
        let pos = Random.position() + CGPoint(x: world.size.width * x_ram, y: world.size.height * y_ram)
        let action = SKAction.move(to: pos, duration: 0)
        self.run(action)
    }
}

@objc(Energy_Gensei)
class Energy_Gensei: Energy {
    
    override func initializeBegan() {
        super.initializeBegan()
        let size = CGSize(width: 15, height: 15)
        self.status = Status(name: "gensei_energy", size: size)
    }
}
