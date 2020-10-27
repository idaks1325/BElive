//
//  World.swift
//  BElive
//
//  Created by ryo on 2020/10/27.
//  Copyright © 2020 fry329. All rights reserved.
//

import SpriteKit

struct Random {
    static func position() -> CGPoint{
        let x = world.size.width/6...world.size.width-world.size.width/6
        let y = world.size.height/8...world.size.height-world.size.height/8
        return CGPoint(x: CGFloat.random(in: x), y: CGFloat.random(in: y))
    }
}

class World:SKScene, SKPhysicsContactDelegate{
    var base: SKNode!
    var gauge: SKNode!
    
    var maps: Maps!
    
    var point = 0
    
    var believer: Animal!
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.black
        self.physicsWorld.contactDelegate = self
        self.scaleMode = .aspectFit
        
        self.initialize()
        
        self.base = SKNode()
        world.addChild(self.base)
        
        self.gauge = SKNode()
        self.addChild(self.gauge)
        
        for object in ObjectType.allCases{
            let SKBody = SKNode()
            SKBody.name = object.name()
            self.base.addChild(SKBody)
        }
        
        self.open()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self);//let touchedNode = self.atPoint(location)
            
            if(believer.rootEvent != nil){
                believer.rootEvent!.touchBegan(location: location)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self);
            let previousLocation = touch.previousLocation(in: self)
            
            if(believer.rootEvent != nil){
                self.believer.rootEvent!.touchMove(drag: location - previousLocation)
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if(believer.rootEvent != nil){
                self.believer.rootEvent!.touchEnd()
                }
        }
    }
    override func update(_ currentTime: TimeInterval) {
        if(believer.rootEvent != nil){
            self.believer.rootEvent!.update()
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if let a = (contact.bodyA.node) as? ObjectNode{
            if let b = (contact.bodyB.node) as? ObjectNode{
                a.contact(with: b)
                b.contact(with: a)
            }
        }
        
    }
    
    func initialize(){}
    
    func point_center() -> CGPoint{
        let point_xy = (x: CGFloat(point).truncatingRemainder(dividingBy: CGFloat(maps.size.x)), y: point / maps.size.x)
        return CGPoint(x: -1 * world.size.width * CGFloat(point_xy.x), y: -1 * world.size.height * CGFloat(point_xy.y))
    }
    
    func getBeliverPosition(direction d:Direction) -> CGPoint{
        let soutai = CGPoint(
            x: self.believer.position.x.truncatingRemainder(dividingBy: self.size.width),
            y: self.believer.position.y.truncatingRemainder(dividingBy: self.size.height)
        )
        var position: CGPoint!
        switch d {
        case .top:
            position = CGPoint(x: soutai.x, y: world.size.height - world.size.height/8)
        case .under:
            position = CGPoint(x: soutai.x, y: world.size.height/8)
        case .left:
            position = CGPoint(x: world.size.width/6, y: soutai.y)
        case .right:
            position = CGPoint(x: world.size.width - world.size.width/6, y: soutai.y)
        }
        
        let world_position = self.point_center()
        return CGPoint(
            x: world_position.x * -1 + position.x,
            y: world_position.y * -1 + position.y
        )
    }
    
    func run(nodeDirection d:Direction, runAction:Bool = true){
        let world_position = self.point_center()
        let beliver_position = getBeliverPosition(direction: d)
        
        if (runAction){
            self.believer.run( SKAction.move(to: beliver_position, duration: 1), withKey:"areaAction")
            self.base.run( SKAction.move(to: world_position, duration: 1), withKey:"worldAction" )
            didViewArea()
        }else{
            self.believer.position = beliver_position
            self.base.position = world_position
        }
    }
    
    func didViewArea(){
        
    }
    
    func delete(){
        //base.removeAllChildren()
        for i in base.children{
            i.removeAllChildren()
        }
    }
    
    func newGame(){
        let ud = UserDefaults.standard
        let played = ud.bool(forKey: "played")
        if(played){
            //gameover
            
            let gameover = SKLabelNode()
            gameover.fontColor = UIColor.red
            gameover.fontSize = 60
            gameover.text = "GAMEOVER"
            gameover.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            self.addChild(gameover)
            
            let action = SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 2),SKAction.removeFromParent()])
            gameover.run(action)
            
        }else{
            ud.set(true, forKey: "played")
        }
        ud.set(3, forKey: "zanki")
        
        ud.set(believer.status.maxHP, forKey: "status_hp")
        ud.set(0, forKey: "status_exp")
    }
    
    func open(){
        
        //maps展開
        let size = self.maps.size
        
        for y in 0...(size.y-1){
            for x in 0...(size.x-1){
                let c = (y * size.x) + x
                let layout = self.maps.layout[c]
                let siten = CGPoint(x: world.size.width * CGFloat(x), y: world.size.height * CGFloat(y))
                
                let thema = self.maps.thema
                
                //BLOCK
                let block = layout[0] as! [String]
                let array = [
                    "T": CGPoint(x: world.size.width/2, y: world.size.height) + siten,
                    "B": CGPoint(x: world.size.width/2, y: 0) + siten,
                    "L": CGPoint(x: 0, y: world.size.height/2) + siten,
                    "R": CGPoint(x: world.size.width, y: world.size.height/2) + siten
                ]
                for (str, point) in array{
                    var b: SKNode!
                    if block.firstIndex(of: str) != nil {
                        let classname = (str == "T" || str == "B") ? "Block_"+thema+"_yoko" : "Block_"+thema+"_tate"
                        let BlockClass = NSClassFromString( classname ) as! Block.Type
                        b = BlockClass.init()
                        b.zPosition = 2
                        b.position = point
                    }else{
                        if(str == "B" || str == "L"){
                            b = (str == "T" || str == "B") ? Block_Bezel_yoko() : Block_Bezel_tate()
                            b.zPosition = 1
                            b.position = point
                        }
                    }
                }
                
                //ENERGY
                let energy_c = layout[1] as! Int
                if energy_c > 0{
                    for _ in 0...(energy_c-1){
                        let EnergyClass = NSClassFromString( "Energy_"+thema ) as! Energy.Type
                        let e = EnergyClass.init()
                        e.position = Random.position() + siten
                    }
                }
                
                //ANIMAL
                let animals = layout[2] as! [Int]
                for n in animals{
                    let AnimalClass = NSClassFromString( self.maps.animals[n] ) as! Animal.Type
                    let a = AnimalClass.init()
                    a.position = Random.position() + siten
                }
                
                
            }
        }
    }
    
    func getNode(_ object: ObjectType) -> SKNode{
        return base.childNode(withName: object.name())!
    }
    
    //updateなどのイベントを振り分けるために分ける
        func addNode(_ node:SKNode, parent:ObjectType, physics:Bool = true){
            if(physics){
                
    //            if let sknode = node as? SKSpriteNode{
    //                if let texture = sknode.texture {
    //                    node.physicsBody = SKPhysicsBody(texture: texture, size: sknode.size)
    //                }
    //            }
                
                if let sknode = node as? SKSpriteNode{
                    node.physicsBody = SKPhysicsBody(rectangleOf: sknode.size)
                }
                node.physicsBody?.affectedByGravity = false//重力を無視
                node.physicsBody?.isDynamic = true//衝撃を無視
                node.physicsBody?.allowsRotation = false//衝撃を無視
                node.physicsBody?.usesPreciseCollisionDetection = true
                
                node.physicsBody?.contactTestBitMask = UInt32(1) | UInt32(2)
                node.physicsBody?.collisionBitMask = UInt32(1)
                node.physicsBody?.categoryBitMask = UInt32(1)
                
                if(parent == .block){
                    node.physicsBody?.isDynamic = false
                    if let blocks = node as? Block{
                        if(!blocks.inEvent){
                            node.physicsBody?.categoryBitMask = UInt32(2)
                        }
                    }
                }
                
            }
            
            getNode(parent).addChild(node)
        }
}

