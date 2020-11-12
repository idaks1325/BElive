//
//  GameScene.swift
//  BElive
//
//  Created by ryo on 2020/10/27.
//  Copyright © 2020 fry329. All rights reserved.
//

import SpriteKit

class Heaven: World{
    
    var start_rest: SKSpriteNode!
    var gamemessage: SKSpriteNode!
    
    override func initialize() {
        let m = GenseiWorld()
        self.maps = Maps(m.map)
    }
    
    func gameset(){
        let ud = UserDefaults.standard
        let played = ud.bool(forKey: "played")
        let zanki = ud.integer(forKey: "zanki")
        
        let gamesclear = ud.integer(forKey: "gameclear")
        let gameend = ud.integer(forKey: "gameend")
        
        //ゲーム開始
        if(!played){
            newGame()
            return;
        }
        
        //ゲームクリア
        if(gamesclear == 1){
            ud.set(2, forKey: "gameclear")
            ud.set(5, forKey: "zanki")
            gamemessage.texture = SKTexture(imageNamed: "gameclear")
            ends()
            return;
        }
        
        //ゲームエンド
        if(gameend == 1){
            newGame()
            gamemessage.texture = SKTexture(imageNamed: "gameend")
            ends()
            return;
        }
        
        gamemessage.texture = SKTexture(imageNamed: "zanki"+String(zanki))
        let action = SKAction.sequence([
            SKAction.scale(to: 0.9, duration: 0.2),
            SKAction.scale(to: 1, duration: 1),
            SKAction.wait(forDuration: 1)
        ])
        gamemessage.run( SKAction.repeatForever(action) )
        //ゲームオーバー
        if(zanki <= 0){
            newGame()
            ends()
        }
        
    }
    func ends(){
        let action = SKAction.sequence([
            SKAction.scale(to: 2, duration: 2),
            SKAction.run{
                self.run(SKAction.fadeAlpha(to: 0, duration: 2))
            },
            
            SKAction.run{
                world = Heaven()
                let view = self.view!
                world.size = view.frame.size
                view.presentScene(world)
                
                let actions = [SKAction.fadeAlpha(to: 0, duration: 0), SKAction.fadeAlpha(to: 1, duration: 1)]
                world.run( SKAction.sequence(actions) )
            },
        ])
        gamemessage.run(action)
    }
    func newGame(){
        let ud = UserDefaults.standard
        ud.set(true, forKey: "played")
        ud.set(0, forKey: "gameclear")
        ud.set(0, forKey: "gameend")
        
        ud.set(self.maps.point, forKey: "point")
        ud.set(5, forKey: "zanki")
        ud.set(believer.status.maxHP, forKey: "status_hp")
        ud.set(0, forKey: "status_exp")
        ud.set(0, forKey: "sanso")
    }
    
    override func open() {
        super.open()
        
        self.believer = Shinkaku()
        self.run(nodeDirection: .under, runAction: false)
        
        gamemessage = SKSpriteNode(texture: SKTexture(imageNamed: "zanki5"))
        gamemessage.size = CGSize(
            width: gamemessage.size.width * (self.size.height/15 / gamemessage.size.height),
            height: self.size.height/15
        )
        gamemessage.position = CGPoint(x: self.size.width/2, y: self.size.height - self.size.height/6)
        gamemessage.zPosition = 5
        self.addChild(gamemessage)
        
        gameset()
        
        //map
        let size_y = self.size.height/3
        let pos = CGPoint(
            x: world.size.width * CGFloat(world.maps.size.x),
            y: world.size.height * CGFloat(world.maps.size.y)
        )
        self.base.position = point_center(area: (2, 4))
        let wariai = size_y / pos.y
        let to = CGPoint(
            x: self.size.width/2 - (pos.x/2 * wariai),
            y: self.size.height/2 - (pos.y/2 * wariai)
        )
        let actions = SKAction.sequence([
            SKAction.wait(forDuration: 1),
            SKAction.group([
                SKAction.scale(to: wariai, duration: 3),
                SKAction.move(to: to, duration: 3)
            ])
        ])
        self.base.run(actions)
        
        //button
        start_rest = SKSpriteNode(imageNamed: "start_rest")
        start_rest.size = CGSize(width: start_rest.size.width * (self.size.height/6 / start_rest.size.height), height: self.size.height/6)
        start_rest.position = CGPoint(x: self.size.width/2, y: self.size.height/6)
        start_rest.zPosition = 5
        self.addChild(start_rest)
        
        //label
        let ud = UserDefaults.standard
        let clear = ud.integer(forKey: "gameclear")
        if(clear != 0){
            let label = SKLabelNode()
            label.fontColor = UIColor.white
            label.fontSize = self.size.height/36
            label.text = "クリア済み"
            label.position = CGPoint(x: self.size.width/2, y: self.size.height - self.size.height/36)
            label.zPosition = 5
            self.addChild(label)
        }
    }
    
    var isTouched = false
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches {
            let location = touch.location(in: self);let touchedNode = self.atPoint(location)
            
            if(!isTouched){
                if (touchedNode == start_rest){
                    isTouched = true
                    
                    self.run( SKAction.sequence([
                        SKAction.fadeAlpha(to: 0, duration: 1.5),
                        SKAction.run({
                            world = GenseiWorld()
                            let view = self.view!
                            world.size = view.frame.size
                            view.presentScene(world)
                            
                            let actions = [SKAction.fadeAlpha(to: 0, duration: 0), SKAction.fadeAlpha(to: 1, duration: 1)]
                            world.run( SKAction.sequence(actions) )
                        })
                    ]) )
                    
                }
            }
            
            if (touchedNode == gamemessage){
                let ud = UserDefaults.standard
                let zanki = ud.integer(forKey: "zanki")
                ud.set(zanki - 1, forKey: "zanki")
                
                self.run( SKAction.sequence([
                    SKAction.fadeAlpha(to: 0, duration: 0.5),
                    SKAction.run({
                        world = Heaven()
                        let view = self.view!
                        world.size = view.frame.size
                        view.presentScene(world)
                    })
                ]) )
                
            }
            
        }
    }
}
