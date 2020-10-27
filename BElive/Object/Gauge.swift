//
//  Gauge.swift
//  BElive
//
//  Created by ryo on 2020/10/27.
//  Copyright © 2020 fry329. All rights reserved.
//

import SpriteKit

class Gauge{
    
    var hp: SKSpriteNode!
    var exp: SKSpriteNode!
    var lv_label: SKLabelNode!
    
    var animal: Animal!
    
    func set(){
        if (animal.rootEvent != nil){
            let parsentSize = (animal.status.hp / animal.status.maxHP) * (world.size.width)
            hp.size = CGSize(width: parsentSize, height: 10)
            
            let lv = Int(animal.status.exp / animal.status.maxHP)
            let expSize = ((animal.status.exp-animal.status.maxHP*CGFloat(lv)) / animal.status.maxHP) * (world.size.width)
            exp.size = CGSize(width: expSize, height: 10)
            
            lv_label.text = "Lv " + String(lv)
        }else{
            let parsentSize = (animal.status.hp / animal.status.maxHP) * (animal.size.width * 2)
            hp = SKSpriteNode(color: UIColor.green, size: CGSize(width: parsentSize, height: 10))
            hp.anchorPoint = CGPoint(x: 0, y: 0.5)
            hp.position = animal.position + CGPoint(x: -1 * animal.size.width/2, y: -1 * animal.size.height)
            hp.zPosition = 5
            let range = SKRange(lowerLimit: animal.size.height, upperLimit: animal.size.height)
            hp.constraints = [ SKConstraint.distance(range, to: animal) ]
            hp.run( SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 1), SKAction.removeFromParent()]) )
            world.gauge.addChild(hp)
        }
    }
    init(animal:Animal){
        self.animal = animal
        
        if (animal.rootEvent != nil){
            let hpSize = (animal.status.hp / animal.status.maxHP) * (world.size.width)
            hp = SKSpriteNode(color: UIColor.green, size: CGSize(width: hpSize, height: 10))
            hp.anchorPoint = CGPoint(x: 0, y: 0)
            hp.position = CGPoint(x: 0, y: 0)
            hp.zPosition = 5
            world.gauge.addChild(hp)
            
            let lv = Int(animal.status.exp / animal.status.maxHP)
            let expSize = ((animal.status.exp-animal.status.maxHP*CGFloat(lv)) / animal.status.maxHP) * (world.size.width)
            exp = SKSpriteNode(color: UIColor.blue, size: CGSize(width: expSize, height: 10))
            exp.anchorPoint = CGPoint(x: 0, y: 0)
            exp.position = CGPoint(x: 0, y: 10)
            exp.zPosition = 5
            world.gauge.addChild(exp)
            
            lv_label = SKLabelNode()
            lv_label.text = "Lv " + String(lv)
            lv_label.fontSize = 10
            lv_label.position = CGPoint(x: world.size.width - 20, y: 30)
            lv_label.zPosition = 5
            world.gauge.addChild(lv_label)
        }
        
    }
}

