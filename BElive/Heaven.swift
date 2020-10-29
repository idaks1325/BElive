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
    var start_begin: SKSpriteNode!
    
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
        }
        
        //ゲームクリア
        if(gamesclear == 1){
            let gameover = SKLabelNode()
            gameover.fontColor = UIColor.red
            gameover.fontSize = 60
            gameover.text = "クリア！"
            gameover.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            self.addChild(gameover)
            
            let action = SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 2),SKAction.removeFromParent()])
            gameover.run(action)
            
            ud.set(2, forKey: "gameclear")
            ud.set(5, forKey: "zanki")
        }
        
        //ゲームエンド
        if(gameend == 1){
            let gameover = SKLabelNode()
            gameover.fontColor = UIColor.red
            gameover.fontSize = 60
            gameover.text = "終わり！"
            gameover.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            self.addChild(gameover)
            
            let action = SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 2),SKAction.removeFromParent()])
            gameover.run(action)
            
            newGame()
        }
        
        //ゲームオーバー
        if(zanki <= 0){
            let gameover = SKLabelNode()
            gameover.fontColor = UIColor.red
            gameover.fontSize = 60
            gameover.text = "GAMEOVER"
            gameover.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            self.addChild(gameover)
            
            let action = SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 2),SKAction.removeFromParent()])
            gameover.run(action)
            
            newGame()
        }
        
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
        
        gameset()
        
        //map
        let size_y = self.size.height/3
        let pos = CGPoint(
            x: world.size.width * CGFloat(world.maps.size.x),
            y: world.size.height * CGFloat(world.maps.size.y)
        )
        let wariai = size_y / pos.y
        self.base.setScale( wariai )
        self.base.position = CGPoint(x: self.size.width/2 - (pos.x/2 * wariai), y: self.size.height/2 - (pos.y/2 * wariai))
        
        //button
        start_rest = SKSpriteNode(imageNamed: "start_rest")
        start_rest.size = CGSize(width: start_rest.size.width * (self.size.height/6 / start_rest.size.height), height: self.size.height/6)
        start_rest.position = CGPoint(x: self.size.width/2, y: self.size.height/6)
        self.addChild(start_rest)
        
        start_begin = SKSpriteNode(imageNamed: "start_begin")
        start_begin.size = CGSize(width: start_begin.size.width * (self.size.height/18 / start_begin.size.height), height: self.size.height/18)
        start_begin.anchorPoint = CGPoint(x: 0, y: 1)
        start_begin.position = CGPoint(x: 0, y: self.size.height)
        self.addChild(start_begin)
        
        //label
        let ud = UserDefaults.standard
        let zanki = ud.integer(forKey: "zanki")
        let label = SKLabelNode()
        label.fontColor = UIColor.white
        label.fontSize = self.size.height/18
        label.text = "残り"+String(zanki)+"回"
        label.position = CGPoint(x: self.size.width/2, y: self.size.height - self.size.height/18)
        self.addChild(label)
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
            
            if (touchedNode == start_begin){
                
            }
            
        }
    }
}
