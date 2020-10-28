//
//  Root.swift
//  BElive
//
//  Created by ryo on 2020/10/27.
//  Copyright © 2020 fry329. All rights reserved.
//

import SpriteKit

protocol rootEvent {
    func touchBegan(location: CGPoint)
    func touchMove(drag: CGPoint)
    func touchEnd()
    func update()
}

extension CGVector{
    init(a: CGPoint, b:CGPoint){
        let posi = a - b
        self.init(dx: posi.x, dy: posi.y)
    }
}

class lockedRoot: rootEvent{
    
    var believer: Animal!
    var point: SKSpriteNode!
    
    //方向を指す弧
    var arcNode: SKShapeNode!
    //広さ
    var viewRange:Double!
    //長さ
    var length:CGFloat!
    //向き
    var angle: Double!
    
    //updateで尾けさせる
    var canFollow = false
    
    init(believer: Animal, range: Double, length: CGFloat) {
        self.believer = believer
        
        let w = (world.size.width + world.size.height) * 0.01
        point = SKSpriteNode(color: UIColor.red, size: CGSize(width: w, height: w))
        world.addNode(point, parent: .root, physics: false)
        
        self.viewRange = range
        self.length = length
        point.position = CGPoint(x: believer.position.x, y: believer.position.y + CGFloat(length))
        
        arcNode = SKShapeNode()
        arcNode.lineCap = .round
        arcNode.lineWidth = 5
        world.addNode(arcNode, parent: .root, physics: false)
        
        let range = SKRange(lowerLimit: CGFloat(length), upperLimit: CGFloat(length))
        let distanceConstraint = SKConstraint.distance(range, to: believer)
        point.constraints = [ distanceConstraint ]
        
        angle = Angle(a: believer.position, b: point.position).degrees
        setArcPath()
    }
    
    func touchBegan(location: CGPoint) {
        //update追尾を停止
        canFollow = false
        self.believer.removeAction(forKey: "runAction")
    }
    
    func touchMove(drag: CGPoint) {
        //移動可能範囲でrootをドラッグさせる & rootの方向にbelieverを向かせる
        let dragsPosition = point.position + drag
        let dragsAngle = Angle(a: believer.position, b: dragsPosition)
        if( dragsAngle.In(angle: angle, range: viewRange) ){
            self.believer.zRotation = CGFloat(dragsAngle.degrees - 90).degreesToRadians
            
            point.position = dragsPosition
        }
    }
    
    func touchEnd() {
        //angle設定 & update追尾を開始
        angle = Angle(a: believer.position, b:  point.position).degrees
        canFollow = true
        
        //believerを移動させる
        let action = SKAction.move(by: CGVector(a: point.position, b: believer.position), duration: 2.8)
        self.believer.run(SKAction.repeatForever(action), withKey:"runAction")
    }
    
    func update(){
        if(canFollow){
            //updateで弧を更新する
            setArcPath()
        }
    }
    
    //設定した場所に弧を描く
    func setArcPath(){
        let endAngle = angle + viewRange
        let startAngle = angle - viewRange
        var clockwise = true;//左周り
        if(startAngle + 180 > 360){
            clockwise = endAngle > startAngle || endAngle < startAngle - 180
        }else{
            clockwise = endAngle > startAngle && endAngle < startAngle + 180
        }
        
        let path = UIBezierPath.init(
            arcCenter: believer.position,
            radius: length,
            startAngle: startAngle.degreesToRadians,
            endAngle: endAngle.degreesToRadians,
            clockwise: clockwise
        ).cgPath
        
        arcNode.path = path
    }
}



class freeRoot: rootEvent{
    
    var believer: Animal!
    var root: SKShapeNode!
    var path: UIBezierPath?
    
    var speed: CGFloat!
    
    init(believer: Animal, speed: CGFloat) {
        self.believer = believer
        
        self.speed = speed
        root = SKShapeNode()
        root.zPosition = 1
        world.addNode(root, parent: .root, physics: false)
    }
    
    func touchBegan(location: CGPoint) {
        
        if believer.action(forKey: "areaAction") == nil {
            self.believer.removeAction(forKey: "runAction")
            root.lineCap = .round
            root.lineWidth = 5
            
            path = UIBezierPath()
            path!.move(to: self.believer.position)
            root.path = path!.cgPath
        }else{
            path = nil
        }
        
    }
    
    func touchMove(drag: CGPoint) {
        if let p = path{
            let point = p.currentPoint + drag
            
            let node_point = CGPoint(
                x: point.x.truncatingRemainder(dividingBy: world.size.width),
                y: point.y.truncatingRemainder(dividingBy: world.size.height)
            )
            if let block = world.atPoint(node_point) as? Block{
                return;
            }
            p.addLine(to: point)
            root.path = p.cgPath
        }
    }
    
    func touchEnd() {
        if let p = path{
            let action = SKAction.follow(p.cgPath, asOffset: false, orientToPath: true, speed: speed)
            self.believer.run(action, withKey:"runAction")
        }
    }
    
    func update() {}
    
}

