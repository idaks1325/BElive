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
    
    override func open() {
        super.open()
        
        self.believer = Shinkaku()
        self.run(nodeDirection: .under, runAction: false)
        
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
        var zanki = ud.integer(forKey: "zanki")
        if(zanki <= 0){
            self.newGame()
            zanki = ud.integer(forKey: "zanki")
        }
        zanki = ud.integer(forKey: "zanki")
        
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
