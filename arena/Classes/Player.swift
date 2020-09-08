//
//  Player.swift
//  arena
//
//  Created by Logan on 7/14/20.
//  Copyright © 2020 Logan. All rights reserved.
//

import SpriteKit

let PLAYER_HAND_SIZE = 4
let FRAME_DURATION = 0.25
let ANIMATION_DURATION = 1.0

class Player: SKSpriteNode {
	enum type {
		case human
		case bot
		case shadow
//		case remote
	}
	
	var gladiator: Gladiator
	let runKey: String
	var spriteAnimation: [SKTexture]
	var attackAnimation: [SKTexture]
	var actions: [Action]
	private var actionDeck: [ActionType] = []
	let moveDistance: CGFloat
	var currentDirection =  Direction.left
	var moveLocations: [CGPoint] = []
	var health = 3
	let type: type
	
	init(gladiator: Gladiator, moveDistance: CGFloat, type: type) {
		self.gladiator = gladiator
		runKey = "\(gladiator)_active"
		var atlas = SKTextureAtlas(named: "\(gladiator)_idle")
		spriteAnimation = []
		for i in 0..<atlas.textureNames.count {
			spriteAnimation.append(atlas.textureNamed("\(gladiator)_idle_\(i)"))
		}
		atlas = SKTextureAtlas(named: "\(gladiator)_attack")
		attackAnimation = []
		for i in 0..<atlas.textureNames.count {
			attackAnimation.append(atlas.textureNamed("\(gladiator)_attack_\(i)"))
		}
		self.moveDistance = moveDistance
		actions = []
		self.type = type
		super.init(texture: spriteAnimation[0], color: .clear, size: spriteAnimation[0].size())
		self.xScale = 1.1
		self.yScale = 1.1
	}
	
	func resetDeck() {
		while actionDeck.count < 7 {
			actionDeck.insert(.move, at: Int.random(in: 0...actionDeck.endIndex))
		}
		while actionDeck.count < 14 {
			actionDeck.insert(.attack, at: Int.random(in: 0...actionDeck.endIndex))
		}
	}
	
	func returnAction(_ action: ActionType) {
		actionDeck.insert(action, at: 0)
	}
	
	func getActionFromDeck() -> ActionType {
		if actionDeck.count == 0 { resetDeck() }
		return actionDeck.removeFirst()
	}
	
	func copy() -> Player {
		let player = Player(gladiator: gladiator, moveDistance: moveDistance, type: .shadow)
		player.position = position
		if let turn = player.face(currentDirection) { player.run(turn) }
		player.run(SKAction.fadeAlpha(to: 0.7, duration: 0))
		return player
	}
	
	func setPlayerActive(_ isActive: Bool) {
		if (isActive) {
			self.run(SKAction.repeatForever(SKAction.animate(with: spriteAnimation, timePerFrame: FRAME_DURATION, resize: false, restore: true)), withKey: runKey)
		} else {
			self.removeAction(forKey: runKey)
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func animations() -> SKAction {
		var actions: [SKAction] = []
		var point = self.position
		for action in self.actions {
			var group: [SKAction] = []
			if let turn = face(action.direction) { group.append(turn) }
			group.append(SKAction.wait(forDuration: ANIMATION_DURATION))
			switch action.type {
			case .move:
				point = action.direction.move(point, self.moveDistance)
				group.append(SKAction.move(to: point, duration: FRAME_DURATION))
			case .attack:
				group.append(SKAction.animate(with: attackAnimation, timePerFrame: FRAME_DURATION))
			case .attacked:
				group.append(SKAction.animate(with: attackAnimation, timePerFrame: FRAME_DURATION / 4))
			default:
				break
			}
			actions.append(SKAction.group(group))
		}
		return SKAction.sequence(actions)
	}
	
	func addAction(_ action: Action) {
		actions.append(action)
	}
	
	func clearActions() {
		actions.removeAll()
		moveLocations.removeAll()
	}
	
	func face(_ direction: Direction) -> SKAction? {
		let turn: SKAction
		let newDirection: Direction
		switch direction {
		case .left, .upleft, .downleft:
			turn = SKAction.scaleX(to: 1, duration: 0)
			newDirection = .left
		case .right, .upright, .downright:
			turn = SKAction.scaleX(to: -1, duration: 0)
			newDirection = .right
		default:
			return nil
		}
		if newDirection != currentDirection {
			currentDirection = newDirection
			return turn
		}
		return nil
	}
}
