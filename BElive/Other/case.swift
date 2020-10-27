//
//  case.swift
//  BElive
//
//  Created by ryo on 2020/10/27.
//  Copyright © 2020 fry329. All rights reserved.
//

import SpriteKit
import GameplayKit

extension CGPoint{
    static public func -(lhs:CGPoint,rhs:CGPoint) -> CGPoint{
     return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    static public func +(lhs:CGPoint,rhs:CGPoint) -> CGPoint{
     return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    static public func -= (lhs:inout CGPoint,rhs:CGPoint){
     lhs = lhs - rhs
    }
    
    func distance(with b:CGPoint) -> Double {
        return Double(sqrt(pow(b.x - self.x, 2) + pow(b.y - self.y, 2)))
    }
}

enum Direction{
    case top
    case under
    case left
    case right
}

struct Angle {
    var degrees: Double = 0
    
    init(degrees: Double){
        self.degrees = degrees
    }
    init(node: SKNode){
        self.degrees = Double(node.zRotation.radiansToDegrees)
    }
    
    //マイナスがある場合
    init(mZrotation: CGFloat){
        let r = mZrotation.radiansToDegrees
        self.degrees = Double(r + ((r > -180 && r < -90) ? 450 : 90))
    }
    
    init(a:CGPoint, b:CGPoint) {
        var r = atan2(b.y - a.y, b.x - a.x)
        if r < 0 {
            r = r + CGFloat(2 * Double.pi)
        }
        degrees = floor(Double(r * 360) / (2 * Double.pi))
    }
    
    mutating func turnDefrees() -> Double{
        var turn = degrees + 180
        turn = turn > 360 ? turn - 360 : turn
        self.degrees = Double(turn)
        return self.degrees
    }
    
    mutating func getVector(point: CGPoint, lenght: Double = 100) -> CGVector{
        return CGVector(a: point, b: point + getXY(length: lenght))
    }
    
    func getXY(length:Double) -> CGPoint{
        return CGPoint(x: cos((degrees - 90) * Double.pi / 180) * length, y: sin((degrees - 90) * Double.pi / 180) * length)
    }
    
    func In(angle center:Double, range:Double) -> Bool{
        var start:Double = center - range
        var end:Double = center + range
        if(center - range < 0){
            start = center + range
            end = center - range + 360
        }
        if(center + range > 360){
            start = center + range - 360
            end = center - range
        }
        if(end - start > 180){
            if(degrees > end || degrees < start){
                return true
            }
        }else{
            if(degrees < end && degrees > start){
                return true
            }
        }
        return false
    }
}

extension Double {
    var degreesToRadians: CGFloat { CGFloat(self) * .pi / 180 }
    
    var toDegreesNormalized : CGFloat {
        let deg = CGFloat(self) * 180 / .pi
        return deg >= 0 ? deg : deg + 360
    }
}

extension FloatingPoint {
    var degreesToRadians: Self { self * .pi / 180 }
    var radiansToDegrees: Self { self * 180 / .pi }
}

extension Array{
    //なかったらnilを返す
    func getElement(at index: Int) -> Element? {
        let isValidIndex = index >= 0 && index < count
        return isValidIndex ? self[index] : nil
    }
    
    //[0,1,2].rotateIndex(5) -> 2   [0,1,2].rotateIndex(-2) -> 1
    func rotateIndex(index of: Int) -> Element?{
        let max = self.count
        if(of < 0){
            var index = max + of
            while (index < 0){
                index += max
            }
            return getElement(at: index)
        }
        if(of > max){
            return getElement(at: (of % max))
        }
        return getElement(at: of)
    }
}

extension Int{
    //3.centerToArray(count: 3) -> 2,3,4
    func centerToArray(count: Int) -> [Int]{
        var array:[Int] = []
        let hankei = (count - 1) / 2
        for c in 1...hankei{
            array.append( self + (-1 * (hankei - (c - 1))) )
        }
        array.append(self)
        for c in 1...hankei{
            array.append( self + c )
        }
        return array
    }
}

class monooki: SKScene {
    
    override func didMove(to view: SKView) {
        //ドラッグ移動させる
//        let dragx = location.x - previousLocation.x
//        let dragy = location.y - previousLocation.y
//        self.target.run(SKAction.moveBy(x: dragx, y: dragy, duration: 1))
        
        //移動可能エリア
//        let range_x = SKRange(lowerLimit: self.size.width/2 - self.size.width/4, upperLimit: self.size.width/2 + self.size.width/4)
//        let range_y = SKRange(lowerLimit: self.size.height/2 - self.size.width/4, upperLimit: self.size.height/2 + self.size.width/4)
//        let lockToCenter = SKConstraint.positionX(range_x, y: range_y)
//        self.target.constraints = [ lockToCenter ]
        
    }
    
}

