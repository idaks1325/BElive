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
            "animals": ["DeadProteo", "Proteo", "BigProteo", "Shiano"],
            "size": [5,5],
            "point": 0,
            "layout": [
                [ ["L","B","R"], 5, [] ],
                [ [], 0, [] ],
                [ [], 0, [] ],
                [ [], 0, [] ],
                [ ["R","B"], 0, [] ],
                
                [ ["L"], 5, [0] ],
                [ ["B"], 6, [] ],
                [ ["B","R"], 4, [0] ],
                [ [], 0, [2] ],
                [ ["R"], 0, [] ],
                
                [ ["L"], 4, [] ],
                [ [], 2, [0] ],
                [ [], 6, [] ],
                [ ["B","R"], 1, [0] ],
                [ ["R"], 0, [] ],
                
                [ ["L"], 6, [] ],
                [ [], 6, [1] ],
                [ [], 4, [1] ],
                [ ["R"], 3, [0] ],
                [ ["R"], 0, [] ],
                
                [ ["L","T"], 6, [1] ],
                [ ["T"], 7, [] ],
                [ ["T"], 8, [3] ],
                [ ["T"], 7, [0] ],
                [ ["T","R"], 9, [1,1,1] ],
            ]
    ]
    
    override func initialize() {
        self.maps = Maps(map)
    }
    
    func stressDamage(){
        let actions = SKAction.sequence([
            SKAction.wait(forDuration: 1),
            SKAction.run{
                let node_point = CGPoint(
                    x: self.believer.position.x.truncatingRemainder(dividingBy: world.size.width),
                    y: self.believer.position.y.truncatingRemainder(dividingBy: world.size.height)
                )
                
                var traps:[Trap] = []
                for atnode in world.nodes(at: node_point){
                    if let trap = atnode as? Trap{
                        traps.append(trap)
                    }
                }
                
                var sansodamage:Double = 0
                if(!traps.isEmpty){
                    for trap in traps {
                        
                        if(trap.name == "sanso2"){
                            sansodamage = 5
                        }else if(trap.name == "sanso1"){
                            sansodamage = 2
                        }
                        
                        if let node = self.believer as? Shinkaku{
                            sansodamage -= (node.addTaisei(val: 0.1) / 10)
                        }
                        
                        self.believer.hpEvent(hp: CGFloat(-1 * sansodamage), exp: 2)
                    }
                }
                
                self.believer.hpEvent(hp: -3, exp: 0)
            }
        ])
        believer.run(SKAction.repeatForever(actions))
    }
    
    override func open() {
        super.open()
        
        self.believer = Shinkaku()
        //self.believer.root(range: 40, length: 160)
        self.believer.root(speed: 90)
        
        self.run(nodeDirection: .under, runAction: false)
        
        stressDamage()
    }
    
    override func didViewArea() {
        //hp0以下の場合もある > 消える
        //下
        if(self.point == 3){
            DinnerEvent()
        }
        
    }
    
    func DinnerEvent(){
        if(self.believer.status.hp > 0){
            UserDefaults.standard.set(1, forKey: "gameend")
            self.believer.rootEvent = nil
            
            self.run(SKAction.sequence([
                SKAction.wait(forDuration: 1),
                SKAction.run{
                    //delete nodes
                    let animals = self.getNode(.animal)
                    for a in animals.children{
                        let animal = a as! Animal
                        if (animal != self.believer){
                            animal.removeFromParent()
                        }
                    }
                    self.getNode(.energy).removeAllChildren()
                    self.gauge.removeAllChildren()
                    self.getNode(.block).run(SKAction.fadeAlpha(to: 0, duration: 5))
                    
                    //setting
                    let smoke = SKSpriteNode(imageNamed: "smoke")
                    smoke.position = world.getPointPosition(position: CGPoint(x: world.size.width/2, y: world.size.height/2))
                    smoke.size = CGSize(width: self.size.width, height: (self.size.width / smoke.size.width) * smoke.size.height)
                    smoke.alpha = 0
                    self.base.addChild(smoke)
                    let action = SKAction.sequence([SKAction.fadeAlpha(to: 0.8, duration: 1), SKAction.fadeAlpha(to: 0.5, duration: 2)])
                    smoke.run( SKAction.repeatForever(action) )
                    
                    //beliver
                    let alpha = SKAction.fadeAlpha(to: 0, duration: 10)
                    let scale = SKAction.scale(to: 0, duration: 10)
                    let move = SKAction.move(to: smoke.position, duration: 10)
                    self.believer.run( SKAction.group([alpha, scale, move]) )
                    
                    //event
                    let eater = SKSpriteNode(imageNamed: "kosaikin0")
                    eater.position = world.getPointPosition(position: CGPoint(x: world.size.width/2, y: world.size.height/2))
                    eater.size = CGSize(width: self.size.width, height: (self.size.width / eater.size.width) * eater.size.height)
                    eater.alpha = 0
                    self.base.addChild(eater)
                    
                    let eventAction = SKAction.sequence([
                        SKAction.wait(forDuration: 10),
                        SKAction.fadeAlpha(to: 0.5, duration: 3.5),
                        SKAction.fadeAlpha(to: 0, duration: 3),
                        SKAction.animate(with: [SKTexture(imageNamed: "kosaikin1")], timePerFrame: 0),
                        SKAction.fadeAlpha(to: 0.5, duration: 0.6),
                        SKAction.wait(forDuration: 0.6),
                        SKAction.fadeAlpha(to: 0, duration: 1.6),
                        SKAction.wait(forDuration: 0.5),
                        SKAction.animate(with: [SKTexture(imageNamed: "kosaikin2")], timePerFrame: 0),
                        SKAction.fadeAlpha(to: 0.8, duration: 0.4),
                        SKAction.wait(forDuration: 0.2),
                        SKAction.run{
                            world = Heaven()
                            let view = self.view!
                            world.size = view.frame.size
                            view.presentScene(world)
                            let actions = [SKAction.fadeAlpha(to: 0, duration: 0), SKAction.fadeAlpha(to: 1, duration: 1)]
                            world.run( SKAction.sequence(actions) )
                        }
                    ])
                    eater.run(eventAction)
                }
            ]))
            
        }
        
    }
}

@objc(Shinkaku)
class Shinkaku: Animal{
    override func initializeBegan() {
        super.initializeBegan()
        let size = CGSize(width: 50, height: 50)
        self.status = Status(name: "shinkaku", size: size, duration: 10, sight: 30, maxHP: 100, atk: 10)
    }
    
    override func addObject(){
        super.addObject()
        addTaisei(val: 1)
    }
    
    override func contact(with node: ObjectNode) {
        super.contact(with: node)
        
        if (node is DeadProteo){
            addTaisei(val: 2)
        }
        if (node is Proteo){
            addTaisei(val: 5)
        }
        if (node is Shiano){
            addTaisei(val: -5)
        }
    }
    
    func addTaisei(val: Double) -> Double{
        let ud = UserDefaults.standard
        let taisei = ud.double(forKey: "sanso") + val
        ud.set(taisei, forKey: "sanso")
        
        var scale = 1 + taisei / 100
        if(scale > 2){
            scale = 2
        }
        
        self.run(SKAction.scale(to: CGFloat(scale), duration: 0))
        return taisei
    }
}

@objc(DeadProteo)
class DeadProteo: Animal{
    override func initializeBegan() {
        super.initializeBegan()
        let size = CGSize(width: 50, height: 50)
        self.status = Status(name: "proteo", size: size, duration: 0, sight: 30, maxHP: 30, atk: 5)
    }
    override func addObject(){
        super.addObject()
        self.removeAction(forKey: "animation")
        self.texture = SKTexture(imageNamed: "proteo0")
    }
}

@objc(Proteo)
class Proteo: Animal{
    override func initializeBegan() {
        super.initializeBegan()
        let size = CGSize(width: 50, height: 50)
        self.status = Status(name: "proteo", size: size, duration: 20, sight: 30, maxHP: 200, atk: 20)
    }
}

@objc(BigProteo)
class BigProteo: Animal{
    override func initializeBegan() {
        super.initializeBegan()
        let size = CGSize(width: 400, height: 200)
        self.status = Status(name: "proteo", size: size, duration: 0, sight: 30, maxHP: 500, atk: 10)
    }
    override func addObject(){
        super.addObject()
        self.removeAction(forKey: "animation")
        self.texture = SKTexture(imageNamed: "proteo2")
    }
//    override func setInitializePosition(position: CGPoint){
//        self.position = world.getWorldPosition(node: self, direction: .under, area: (1, 1))
//    }
}

@objc(Shiano)
class Shiano: Animal{
    override func initializeBegan() {
        super.initializeBegan()
        let size = CGSize(width: 70, height: 70)
        self.status = Status(name: "shiano", size: size, duration: 0, sight: 30, maxHP: 200, atk: 5)
    }
    
    override func setInitializePosition(position: CGPoint){
        super.setInitializePosition(position: position)
        
        let sanso = SansoBig()
        sanso.position = self.position
        
        let sanso2 = SansoSmall()
        sanso2.position = self.position
    }
    
    override func deadEvent() {
        super.deadEvent()
        
        UserDefaults.standard.set(1, forKey: "gameclear")
        world.believer.rootEvent = nil
        
        for i in 0...150{
            let energy = SKSpriteNode(imageNamed: "gensei_energy0")
            energy.zRotation = CGFloat.random(in: 135...225).degreesToRadians
            var angle = Angle(node: energy)
            
            let p = CGPoint(
                x: CGFloat.random(in: 0...world.size.width),
                y: CGFloat.random(in: world.size.height...world.size.height*2)
            )
            energy.position = world.getPointPosition(position: p)
            let s = Status(size: CGSize(width: 20, height: 20))
            energy.size = s.size
            world.base.addChild(energy)
            
            energy.setScale(CGFloat.random(in: 0.5...2))
            
            let rotate = SKAction.rotate(byAngle: CGFloat.pi * 2, duration: 2)
            let move = SKAction.move(by: angle.getVector(point: energy.position), duration: 2)
            energy.run( SKAction.repeatForever(SKAction.group([rotate, move])) )
        }
        
        let action = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.4, duration: 3),
            SKAction.fadeAlpha(to: 1, duration: 1),
            SKAction.fadeAlpha(to: 0.4, duration: 2),
            SKAction.fadeAlpha(to: 0.6, duration: 1.5),
            SKAction.fadeAlpha(to: 0, duration: 4),
            SKAction.run {
                let view = world.view!
                world = Heaven()
                world.size = view.frame.size
                view.presentScene(world)
                
                world.run( SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0), SKAction.fadeAlpha(to: 1, duration: 0.7)]) )
            }
        ])
        world.run( action )
    }
}
