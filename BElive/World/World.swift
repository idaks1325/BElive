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
    
    var noPhysics = false
    
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
    
    func initialize(){
    }
    
    func getPointPosition(position: CGPoint, point getpoint:CGFloat? = nil) -> CGPoint{
        var point_xy: (x: CGFloat, y: CGFloat)!
        if(getpoint != nil){
            point_xy = (x: CGFloat(getpoint!).truncatingRemainder(dividingBy: CGFloat(maps.size.x)), y: CGFloat(Int(getpoint!) / maps.size.x))
        }else{
            point_xy = (x: CGFloat(point).truncatingRemainder(dividingBy: CGFloat(maps.size.x)), y: CGFloat(point / maps.size.x))
        }
        let siten = CGPoint(x: world.size.width * point_xy.x, y: world.size.height * point_xy.y)
        return siten + position
    }
    
    func point_center(area: (x:CGFloat, y:Int)? = nil) -> CGPoint{
        var point_xy: (x: CGFloat, y: Int)!
        if(area != nil){
            point_xy = area!
        }else{
            point_xy = (x: CGFloat(point).truncatingRemainder(dividingBy: CGFloat(maps.size.x)), y: point / maps.size.x)
        }
        return CGPoint(x: -1 * world.size.width * CGFloat(point_xy.x), y: -1 * world.size.height * CGFloat(point_xy.y))
    }

    
    func getWorldPosition(node: SKSpriteNode, direction d:Direction, area: (x:CGFloat, y:Int)? = nil) -> CGPoint{
        let soutai = CGPoint(
            x: node.position.x.truncatingRemainder(dividingBy: self.size.width),
            y: node.position.y.truncatingRemainder(dividingBy: self.size.height)
        )
        var position: CGPoint!
        switch d {
        case .top:
            position = CGPoint(x: soutai.x, y: world.size.height - world.size.height/8 - node.size.height/2)
        case .under:
            position = CGPoint(x: soutai.x, y: world.size.height/8 + node.size.height/2)
        case .left:
            position = CGPoint(x: world.size.width/6 + node.size.width/2, y: soutai.y)
        case .right:
            position = CGPoint(x: world.size.width - world.size.width/6 - node.size.width/2, y: soutai.y)
        }
        
        let world_position = self.point_center(area: area)
        return CGPoint(x: world_position.x * -1, y: world_position.y * -1) + position
    }
    
    func run(nodeDirection d:Direction, runAction:Bool = true){
        let world_position = self.point_center()
        let beliver_position = getWorldPosition(node: self.believer, direction: d)
        
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
    
    func open(){
        
        //maps展開
        let size = self.maps.size
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = CGSize(width: world.size.width * 5, height: world.size.height * 5)
        background.position = CGPoint(x: background.size.width / 2, y: background.size.height / 2)
        background.zPosition = -10
        self.base.addChild(background)
        
        let blockA = Block_Back_A()
        blockA.position = CGPoint(x: blockA.size.width / 2, y: blockA.size.height / 2)
        blockA.zPosition = -5
        
        for y in 0...(size.y-1){
            for x in 0...(size.x-1){
                let thispoint = (y * size.x) + x
                let layout = self.maps.layout[thispoint]
                let siten = CGPoint(x: world.size.width * CGFloat(x), y: world.size.height * CGFloat(y))
                
                let thema = self.maps.thema
                
                //BLOCK Bezel
                let bezel_b = Block_Bezel_yoko()
                bezel_b.zPosition = -5
                bezel_b.position = CGPoint(x: world.size.width/2, y: 0) + siten
                
                let bezel_l = Block_Bezel_tate()
                bezel_l.zPosition = -5
                bezel_l.position = CGPoint(x: 0, y: world.size.height/2) + siten
                
                //ENERGY
                let energy_c = layout[1] as! Int
                if energy_c > 0{
                    for _ in 0...(energy_c-1){
                        let EnergyClass = NSClassFromString( "Energy_"+thema ) as! Energy.Type
                        let e = EnergyClass.init()
                        e.position = Random.position() + siten
                    }
                }
                
                let gameclear = UserDefaults.standard.integer(forKey: "gameclear")
                if(gameclear != 0 && (thispoint == 4 || thispoint == 8 || thispoint == 9 || thispoint == 14 || thispoint == 19)){
                    let c = Int(CGFloat.random(in: 1...4))
                    for i in 0...c{
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
                    a.setInitializePosition(position: Random.position() + siten)
                }
                
            }
        }
        self.point = UserDefaults.standard.integer(forKey: "point")
    }
    
    func getNode(_ object: ObjectType) -> SKNode{
        return base.childNode(withName: object.name())!
    }
    
    //updateなどのイベントを振り分けるために分ける
        func addNode(_ node:SKNode, parent:ObjectType, physics:Bool = true){
            if(physics && !noPhysics){
                let sknode = node as! SKSpriteNode
                
                var isDeepPhysics = false
                if let block = sknode as? Block{
                    if (block.inEvent){
                        isDeepPhysics = true
                    }
                }
//                if sknode is Animal{
//                    isDeepPhysics = true
//                }
                if(isDeepPhysics){
                    sknode.physicsBody = SKPhysicsBody(texture: sknode.texture!.pristineCopy(), size: sknode.size)
                }else{
                    sknode.physicsBody = SKPhysicsBody(rectangleOf: sknode.size)
                }
                
                sknode.physicsBody?.affectedByGravity = false//重力を無視
                sknode.physicsBody?.isDynamic = true//衝撃を無視
                sknode.physicsBody?.allowsRotation = false//衝撃を無視
                sknode.physicsBody?.usesPreciseCollisionDetection = true
                
                sknode.physicsBody?.contactTestBitMask = UInt32(1) | UInt32(2)
                sknode.physicsBody?.collisionBitMask = UInt32(1)
                sknode.physicsBody?.categoryBitMask = UInt32(1)
                
                if(parent == .block){
                    sknode.physicsBody?.isDynamic = false
                    if let blocks = sknode as? Block{
                        if(!blocks.inEvent){
                            sknode.physicsBody?.categoryBitMask = UInt32(2)
                        }
                    }
                }
                
            }
            
            getNode(parent).addChild(node)
        }
}


extension SKTexture{
  func pristineCopy() -> SKTexture{
    return SKTexture(cgImage:self.cgImage())
  }
}
