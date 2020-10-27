//
//  GenseiWorld.swift
//  BElive
//
//  Created by ryo on 2020/10/27.
//  Copyright © 2020 fry329. All rights reserved.
//

import SpriteKit

class GenseiWorld: World{
    
    var map:[String : Any] = [
            "thema": "Gensei",
            "animals": ["DeadProteo", "Proteo", "Owl", "Owl2"],
            "size": [5,5],
            "layout": [
                [ ["L","B","R"], 5, [0] ],
                [ [], 0, [] ],
                [ [], 0, [] ],
                [ [], 0, [] ],
                [ ["R"], 0, [3] ],
                
                [ ["L"], 5, [0] ],
                [ ["B"], 6, [] ],
                [ ["B"], 4, [0] ],
                [ ["B"], 0, [2] ],
                [ ["R"], 0, [] ],
                
                [ ["L"], 4, [] ],
                [ [], 2, [0] ],
                [ [], 6, [] ],
                [ ["R"], 1, [0] ],
                [ ["R","B"], 0, [] ],
                
                [ ["L"], 6, [] ],
                [ [], 6, [1] ],
                [ [], 4, [1] ],
                [ ["R"], 3, [0] ],
                [ ["R"], 0, [] ],
                
                [ ["L","T"], 3, [1] ],
                [ ["T"], 2, [] ],
                [ ["T"], 5, [2] ],
                [ ["T"], 2, [0] ],
                [ ["T","R","B"], 2, [1,1,1] ],
            ]
    ]
    
    override func initialize() {
        self.maps = Maps(map)
    }
    
    override func open() {
        super.open()
        
        self.believer = Shinkaku()
        //self.believer.root(range: 40, length: 160)
        self.believer.root()
        
        self.point = 5
        self.run(nodeDirection: .under, runAction: false)
    }
    
    override func didViewArea() {
        //hp0以下の場合もある > 消える
        //下
        if(self.point == 0){
            DinnerEvent()
            
        }
    }
    
    func DinnerEvent(){
        //delete nodes
        let animals = self.getNode(.animal)
        for a in animals.children{
            let animal = a as! Animal
            if(animal.rootEvent == nil){
                animal.removeFromParent()
            }
        }
        self.getNode(.block).removeAllChildren()
        self.getNode(.energy).removeAllChildren()
        self.gauge.removeAllChildren()
        
        //setting
        let smoke = SKSpriteNode(imageNamed: "smoke")
        smoke.position = self.point_center() + CGPoint(x: self.size.width/2, y: self.size.height/2)
        smoke.size = CGSize(width: self.size.width, height: (self.size.width / smoke.size.width) * smoke.size.height)
        self.addChild(smoke)
        let action = SKAction.sequence([SKAction.fadeAlpha(to: 0.5, duration: 2), SKAction.fadeAlpha(to: 0.8, duration: 1)])
        smoke.run( SKAction.repeatForever(action) )
        
        let alpha = SKAction.fadeAlpha(to: 0, duration: 10)
        let scale = SKAction.scale(to: 0, duration: 10)
        let move = SKAction.move(to: smoke.position, duration: 10)
        self.believer.run( SKAction.group([alpha, scale, move]) )
        self.believer.rootEvent = nil
        
        //event
        let eater = SKSpriteNode(imageNamed: "kosaikin0")
        eater.position = self.point_center() + CGPoint(x: self.size.width/2, y: self.size.height/2)
        eater.size = CGSize(width: self.size.width, height: (self.size.width / eater.size.width) * eater.size.height)
        eater.alpha = 0
        self.addChild(eater)
        
        if(self.believer.status.hp > 0){
            UserDefaults.standard.set(0, forKey: "zanki")
            
            let eventAction = SKAction.sequence([
                SKAction.wait(forDuration: 10),
                SKAction.fadeAlpha(to: 0.5, duration: 3.5),
                SKAction.fadeAlpha(to: 0, duration: 3),
                SKAction.animate(with: [SKTexture(imageNamed: "kosaikin1")], timePerFrame: 0),
                SKAction.fadeAlpha(to: 0.4, duration: 1),
                SKAction.fadeAlpha(to: 0, duration: 2),
                SKAction.animate(with: [SKTexture(imageNamed: "kosaikin2")], timePerFrame: 0),
                SKAction.fadeAlpha(to: 0.8, duration: 0.5),
                SKAction.run({
                    world = Heaven()
                    let view = self.view!
                    world.size = view.frame.size
                    view.presentScene(world)
                    let actions = [SKAction.fadeAlpha(to: 0, duration: 0), SKAction.fadeAlpha(to: 1, duration: 1)]
                    world.run( SKAction.sequence(actions) )
                })
            ])
            eater.run(eventAction)
            
        }
        
    }
}

@objc(Shinkaku)
class Shinkaku: Animal{
    override func initializeBegan() {
        super.initializeBegan()
        let size = CGSize(width: 50, height: 50)
        self.status = Status(name: "shinkaku", size: size, duration: 10, sight: 30, maxHP: 50, atk: 10)
    }
    
    override func contact(with node: ObjectNode) {
        super.contact(with: node)
    }
    
    override func contact_with(enemy: Animal){
        super.contact_with(enemy: enemy)
        
    }
}

@objc(DeadProteo)
class DeadProteo: Animal{
    override func initializeBegan() {
        super.initializeBegan()
        let size = CGSize(width: 50, height: 50)
        self.status = Status(name: "proteo", size: size, duration: 1, sight: 30, maxHP: 30, atk: 2)
    }
}

@objc(Proteo)
class Proteo: Animal{
    override func initializeBegan() {
        super.initializeBegan()
        let size = CGSize(width: 50, height: 50)
        self.status = Status(name: "proteo", size: size, duration: 50, sight: 30, maxHP: 70, atk: 5)
    }
}

@objc(Owl)
class Owl: Animal{
    override func initializeBegan() {
        super.initializeBegan()
        let size = CGSize(width: 50, height: 50)
        self.status = Status(name: "owl", size: size, duration: 4, sight: 30, maxHP: 50, atk: 5)
    }
}

@objc(Owl2)
class Owl2: Animal{
    override func initializeBegan() {
        super.initializeBegan()
        let size = CGSize(width: 50, height: 50)
        self.status = Status(name: "scorpion", size: size, duration: 4, sight: 30, maxHP: 50, atk: 5)
    }
}

@objc(Scorpion)
class Scorpion: Animal{
    override func initializeBegan() {
        super.initializeBegan()
        let size = CGSize(width: 50, height: 50)
        self.status = Status(name: "scorpion", size: size, duration: 10, sight: 30, maxHP: 50, atk: 5)
    }
}


