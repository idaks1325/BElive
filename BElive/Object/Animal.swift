//
//  Animal.swift
//  BElive
//
//  Created by ryo on 2020/10/27.
//  Copyright © 2020 fry329. All rights reserved.
//

import SpriteKit

protocol AnimalEvent{
    func ready()//押した時
    func charge()//押し続けている時
    func charge_end()//離した時
    
    func doubletap(center: CGPoint)//ダブルタップ時
    func passive()//常時発動
}
class Animal: ObjectNode,AnimalEvent {
    
    var angle: Angle!
    
    var gauge: Gauge!
    
    //status更新
    override func initializeBegan() {
        self.type = .animal
        
        self.zRotation = CGFloat.random(in: 0...360).degreesToRadians
        angle = Angle(node: self)
        gauge = Gauge(animal: self)//beliverなら更新する
    }
    
    func setInitializePosition(position: CGPoint){
        self.position = position
    }
    
    func runAction() -> SKAction{
        if(self.status.duration > 0){
            let moveAction = SKAction.move(by: angle.getVector(point: self.position), duration: self.status.duration)
            return SKAction.repeatForever( moveAction )
        }else{
            return SKAction.run {}
        }
    }
    
    override func addObject() {
        super.addObject()
        self.run(runAction(), withKey:"runAction")
    }
    
    //objectイベント
    override func contact(with node: ObjectNode) {
        
        //BLOCK
        if let block = node as? Block{
            if rootEvent == nil{
                if(block.inEvent){
                    self.removeAction(forKey: "runAction")
                    angle = Angle(node: self)
                    let turns = angle.turnDefrees()
                    let rotate = SKAction.rotate(toAngle: turns.degreesToRadians, duration: 0)
                    self.run(rotate)
                    
                    self.run(runAction(), withKey:"runAction")
                }
            }else{
                if(!block.inEvent){
                    if world.base.action(forKey: "worldAction") == nil{
                        self.hpEvent(hp: -1 * self.status.hp/10, exp: self.status.hp/20)
                        self.removeAction(forKey: "runAction")
                        
                        var direction: Direction!
                        if block.status.name.range(of: "tate") != nil {
                            if(self.position.x < block.position.x){
                                world.point += 1
                                direction = .left
                            }else{
                                world.point -= 1
                                direction = .right
                            }
                        }else{
                            if(self.position.y < block.position.y){
                                world.point += world.maps.size.x
                                direction = .under
                            }else{
                                world.point -= world.maps.size.x
                                direction = .top
                            }
                        }
                        UserDefaults.standard.set(world.point, forKey: "point")
                        world.run(nodeDirection: direction)
                        
                    }
                }else{
                    //self.removeAction(forKey: "runAction")
                    //self.run(back)
                    //self.rootEvent!.stop()
                }
            }
        }
        
        //ANIMAL
        if let enemy = node as? Animal{
            
            self.removeAction(forKey: "runAction")
            
            //敵が45 + 45度以内にいれば後ろに下がる
            var me = Angle(mZrotation: self.zRotation)
            let noticed = Angle(a: self.position, b: enemy.position).In(angle: Double(me.degrees), range: 45)
            if(noticed){
                me.turnDefrees()
            }
            me.degrees += 90
            let back = SKAction.move(to: self.position + me.getXY(length: 20), duration: 0.1)
            if (self.rootEvent == nil){
                let action = SKAction.sequence([back, runAction()])
                self.run(action, withKey:"runAction")
            }else{
                self.run(back)
                self.rootEvent!.stop()
            }
            
            contact_with(enemy: enemy)
        }
        
        //ENERGY
        if let energy = node as? Energy{
            hpEvent(hp: 15, exp: 5)
        }
    }
    
    //ぶつかったとき
    func contact_with(enemy: Animal){
        enemy.hpEvent(hp: -1 * self.status.atk, exp: self.status.atk*2)
    }
    
    func hpEvent(hp: CGFloat, exp: CGFloat){
        if(self.status.hp + hp > self.status.maxHP){
            self.status.hp = self.status.maxHP
        }else{
            self.status.hp += hp
        }
        self.status.exp += exp
        
        if(self.status.hp > 0){
            gauge.set()
        }else{
            deadEvent()
        }
        
    }
    
    func deadEvent(){
        self.removeFromParent()
        if(self.rootEvent != nil){
            let ud = UserDefaults.standard
            if(status.hp <= 0){
                //status初期化
                ud.set(status.maxHP, forKey: "status_hp")
                
                //残機減らす
                let zanki = ud.integer(forKey: "zanki") - 1
                ud.set(zanki, forKey: "zanki")
                
                //暗転
                let action = SKAction.sequence([
                    SKAction.fadeAlpha(to: 0, duration: 1.5),
                    SKAction.run {
                        let view = world.view!
                        world = Heaven()
                        world.size = view.frame.size
                        view.presentScene(world)
                        
                        world.run( SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0), SKAction.fadeAlpha(to: 1, duration: 1)]) )
                    }
                ])
                world.run( action )
                
            }else{
                ud.set(status.hp, forKey: "status_hp")
                ud.set(status.exp, forKey: "status_exp")
            }
        }
    }
    
    //animalイベント
    func ready() {}
    func charge() {}
    func charge_end() {}
    func doubletap(center: CGPoint) {}
    func passive() {}
    
    //believer専用
    var rootEvent: rootEvent?
    
    func root(speed: CGFloat = 60){
        rootEvent = freeRoot(believer: self, speed: speed)
        beliveInitialize()
    }
    func root(range:Double, length: CGFloat){
        rootEvent = lockedRoot(believer: self, range: range, length: length)
        beliveInitialize()
    }
    func beliveInitialize(){
        
        let ud = UserDefaults.standard
        self.status.hp = CGFloat(ud.integer(forKey: "status_hp"))
        self.status.exp = CGFloat(ud.integer(forKey: "status_exp"))
        
        self.position = CGPoint(x: world.size.width/2, y: world.size.height/2)
        self.removeAction(forKey: "runAction")
        self.zRotation = 0.degreesToRadians
        gauge = Gauge(animal: self)
    }
}

