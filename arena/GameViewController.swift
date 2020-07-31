//
//  GameViewController.swift
//  arena
//
//  Created by Logan on 7/14/20.
//  Copyright © 2020 Logan. All rights reserved.
//

import SpriteKit

class GameViewController: UIViewController {

	override func viewDidAppear(_ animated: Bool) {
		let scene = GameScene(size: view.safeAreaLayoutGuide.layoutFrame.size)
		let skView = view as! SKView
		skView.frame = view.safeAreaLayoutGuide.layoutFrame
		scene.scaleMode = .aspectFill
		skView.presentScene(scene)
		super.viewDidAppear(animated)
    }
}
