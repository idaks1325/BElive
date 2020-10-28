//
//  Object.swift
//  BElive
//
//  Created by ryo on 2020/10/27.
//  Copyright © 2020 fry329. All rights reserved.
//

import SpriteKit
import GameplayKit

struct AnimalTextureAtlas {
    var textures: [SKTexture] = []
    var first: SKTexture!
    
    init(named: String){
        let atlas = SKTextureAtlas(named: named)
        for c in 0...(atlas.textureNames.count-1){
            textures.append(atlas.textureNamed( named + String(c) ))
        }
        
        first = SKTexture(imageNamed: named + "0")
    }
}

struct Status {
    var name: String
    var size: CGSize
    var duration: TimeInterval
    
    var sight: Int
    var maxHP: CGFloat//80%が経験値にもなる
    var hp: CGFloat//残りHPの10%を自然回復したり
    var atk: CGFloat//相手に与えるダメージ
    var exp: CGFloat
    
    init(
        name:String = "",
        size:CGSize = CGSize(width: 0, height: 0),
        duration:TimeInterval = 4,
        sight:Int = 0, maxHP:CGFloat = 0, atk:CGFloat = 0, exp:CGFloat = 0
    ){
        self.name = name
        self.size = CGSize(
            width: size.width / 375 * world.size.width,
            height: size.height / 667 * world.size.height
        )
        self.duration = duration
        self.sight = sight
        self.maxHP = maxHP
        self.hp = CGFloat.random(in: maxHP/2...maxHP)
        self.atk = atk
        self.exp = exp
    }
}

enum ObjectType: String, CaseIterable {
    case animal//常に行動を続け周囲にアクションを起こすもの
    case root//believerのroot
    case energy//行動せず一定のエネルギーだけを保持するもの
    
    case block//マップ内の障害やエリア遷移などのイベントを発生させるもの
    func name() -> String{
        return "bodyname" + String(self.rawValue)
    }
}

protocol Event {
    func contact(with node: ObjectNode)//オブジェクト同士でぶつかった時
}

class ObjectNode: SKSpriteNode,Event {
    var type: ObjectType!
    
    var status: Status!
    
    required convenience init(){
        self.init(texture: nil, color: UIColor.black, size: CGSize(width: 0, height: 0))
        
        self.status = Status()
        initializeBegan()
        
        let AnimalAtlas = AnimalTextureAtlas(named: status.name)
        self.texture = AnimalAtlas.first
        self.size = status.size
        
        let animation = SKAction.animate(with: AnimalAtlas.textures, timePerFrame: 0.3, resize: false, restore: true)
        self.run(SKAction.repeatForever(animation), withKey: "animation")
        
        world.addNode(self, parent: type)
        
        initializeEnd()
    }
    //イベント
    func contact(with node: ObjectNode) {}
    
    //statusやtextureを設定する
    func initializeBegan(){}
    
    func initializeEnd(){}
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

