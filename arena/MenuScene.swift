//
//  GameScene.swift
//  arena
//
//  Created by Logan on 7/14/20.
//  Copyright © 2020 Logan. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
	
	override func didMove(to view: SKView) {
		let titleAtlas = SKTextureAtlas(named: "title")
		var titleAnimation: [SKTexture] = []
		for i in 0...(titleAtlas.textureNames.count - 1) {
			titleAnimation.append(titleAtlas.textureNamed("arena_\(i)"))
		}
		titleAnimation.append(titleAtlas.textureNamed("arena_0"))
		let title = SKSpriteNode(texture: titleAnimation[0])
		title.position = CGPoint(x: view.center.x, y: view.center.y + 100)
		let localButton = Button(defaultButtonImage: "local", activeButtonImage: "local_active", buttonAction: startLocalMultiplayer)
		localButton.position = CGPoint(x: view.center.x, y: title.position.y - 120)
		let onlineButton = Button(defaultButtonImage: "online", activeButtonImage: "online_active", buttonAction: startLocalMultiplayer)
		onlineButton.position = CGPoint(x: view.center.x, y: localButton.position.y - 60)
		
		addChild(title)
		addChild(localButton)
		addChild(onlineButton)
		let waveMid = titleAnimation.count / 2
		let wave1 = SKAction.animate(with: Array(titleAnimation[...waveMid]), timePerFrame: 0.15)
		let wait = SKAction.wait(forDuration: 0.5)
		let wave2 = SKAction.animate(with: Array(titleAnimation[waveMid...]), timePerFrame: 0.15)
		title.run(SKAction.repeatForever(SKAction.sequence([wave1, wait, wave2, wait])))
	}
	
	func startLocalMultiplayer() {
		let scene = LocalScene(size: self.size)
		scene.scaleMode = .aspectFill
		view?.presentScene(scene, transition: SKTransition.reveal(with: .down, duration: 0.5))
	}
}
