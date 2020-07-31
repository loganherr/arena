//
//  Player.swift
//  arena
//
//  Created by Logan on 7/14/20.
//  Copyright © 2020 Logan. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
	var type: Gladiator
	let runKey: String
	var spriteAnimation: [SKTexture]
	var attackAnimation: [SKTexture]
	var nextPosition: CGPoint
	var actions: [Action]
	let moveDistance: CGFloat
	
	init(type: Gladiator, moveDistance: CGFloat) {
		self.type = type
		runKey = "\(type)_active"
		let texture = SKTexture(imageNamed: type.rawValue)
		var atlas = SKTextureAtlas(named: "\(type)_idle")
		spriteAnimation = []
		for i in 0...(atlas.textureNames.count - 1) {
			spriteAnimation.append(atlas.textureNamed("\(type)_idle_\(i)"))
		}
		atlas = SKTextureAtlas(named: "\(type)_attack")
		attackAnimation = []
		for i in 0...(atlas.textureNames.count - 1) {
			attackAnimation.append(atlas.textureNamed("\(type)_attack_\(i)"))
		}
		nextPosition = CGPoint()
		self.moveDistance = moveDistance
		actions = []
		super.init(texture: texture, color: .clear, size: texture.size())
	}
	
	func copy() -> Player {
		let player = Player(type: type, moveDistance: moveDistance)
		player.position = position
		player.nextPosition = nextPosition
		player.run(SKAction.fadeAlpha(to: 0.7, duration: 0))
		return player
	}
	
	func setPlayerActive(_ isActive: Bool) {
		if (isActive) {
			self.run(SKAction.repeatForever(SKAction.animate(with: spriteAnimation, timePerFrame: 0.25, resize: false, restore: true)), withKey: runKey)
		} else {
			self.removeAction(forKey: runKey)
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func move(direction: Direction) -> SKAction {
		nextPosition = direction.move(nextPosition, moveDistance)
		
		let move = SKAction.move(to: nextPosition, duration: 0.25)
		let wait = SKAction.wait(forDuration: 0.25)
		return SKAction.sequence([move, wait])
	}
	
	func attack(direction: Direction) -> SKAction {

		let attack = SKAction.animate(with: attackAnimation, timePerFrame: 0.25)
		return attack
	}
	
	func shadowMove(direction: Direction) {
		let newPoint = direction.move(self.position, moveDistance)
		self.run(SKAction.move(to: newPoint, duration: 0.25))
	}
	
	func addAction(_ action: Action) {
		actions.append(action)
		self.setPlayerActive(false)
		if actions.count == MAX_ACTIONS {
			performActions()
		}
	}
	
	func performActions() {
		var skactions: [SKAction] = []
		for action in actions {
			switch action.type {
			case .move:
				skactions.append(move(direction: action.direction))
			case .attack:
				skactions.append(attack(direction: action.direction))
			}
		}
		let sequence = SKAction.sequence(skactions)
		self.run(sequence, completion: {
			self.setPlayerActive(true)
		})
		actions.removeAll()
	}
}
