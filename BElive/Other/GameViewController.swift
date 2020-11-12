//
//  GameViewController.swift
//  BElive
//
//  Created by ryo on 2020/10/27.
//  Copyright © 2020 fry329. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

var world: World!

class GameViewController: UIViewController {
    
    var viewInitiated: Bool = false
    
    override func loadView() {
        let skView = SKView()
        self.view = skView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        if(!viewInitiated){
            super.viewWillLayoutSubviews()
            
            world = Heaven()
            let view = self.view as! SKView
            world.size = view.frame.size
            view.presentScene(world)
            
//            view.ignoresSiblingOrder = true
//            view.showsFPS = true
//            view.showsNodeCount = true
            //view.showsPhysics = true;
            
            self.viewInitiated = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
