//
//  GameScene.swift
//  arena
//
//  Created by Logan on 7/14/20.
//  Copyright © 2020 Logan. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
	let player: Player
	var playerShadows: [Player]
	var attackMarks: [SKSpriteNode]
	let boardSize = 5
	let board: Board
	let startPosition: CGPoint
	let bottomPosition: CGPoint
	var moveButtons: [DirectionalButton]
	var attackButtons: [DirectionalButton]
	
	override init(size: CGSize) {
		board = Board(size: size, gridSize: boardSize)
		let moveDistance = board.boardTiles[0][0].frame.height
		player = Player(type: .axe, moveDistance: moveDistance)
		startPosition = board.boardTiles[2][2].position
		bottomPosition = board.boardTiles[0][boardSize - 1].position
		player.setPlayerActive(true)
		moveButtons = []
		attackButtons = []
		playerShadows = []
		attackMarks = []
		super.init(size: size)
		createMoveButtons()
		createAttackButtons()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func didMove(to view: SKView) {
		player.position = startPosition
		player.nextPosition = startPosition
		board.zPosition = -1
		addChild(board)
		addChild(player)
		let moveButton = Button(defaultButtonImage: "move_card", activeButtonImage: "move_card_active", buttonAction: displayMoveButtons)
		moveButton.position = CGPoint(x: view.frame.width / 4, y: view.frame.origin.y + 40)
		let attackButton = Button(defaultButtonImage: "\(player.type)_attack_card", activeButtonImage: "\(player.type)_attack_card_active", buttonAction: displayAttackButtons)
		attackButton.position = CGPoint(x: (view.frame.width / 4) * 2, y: view.frame.origin.y + 40)
		addChild(moveButton)
		addChild(attackButton)
	}
	
	func createMoveButtons() {
		let moveImage = "move_card"
		let moveImageActive = "move_card_active"
		func buttonAction(direction: Direction) -> () -> () {
			return {
				self.player.addAction(Action(.move, direction))
				self.createShadow(direction: direction)
				self.hideButtons(self.moveButtons)
			}
		}
		for direction in Direction.allCases {
			let button = DirectionalButton(direction: direction, defaultButtonImage: moveImage, activeButtonImage: moveImageActive, buttonAction: buttonAction(direction: direction))
			button.zRotation = button.direction.rotation()
			moveButtons.append(button)
		}
		self.hideButtons(self.moveButtons)
		for button in self.moveButtons {
			addChild(button)
		}
	}
	
	func createAttackButtons() {
		let defaultButtonImage = "\(player.type.rawValue)_attack_card"
		let activeButtonImage = "\(player.type.rawValue)_attack_card_active"
		func buttonAction(direction: Direction) -> () -> () {
			return {
				self.player.addAction(Action(.attack, direction))
				self.createAttackShadow(direction: direction)
				self.hideButtons(self.attackButtons)
			}
		}
		for direction in Direction.allCases {
			let button = DirectionalButton(direction: direction, defaultButtonImage: defaultButtonImage, activeButtonImage: activeButtonImage, buttonAction: buttonAction(direction: direction))
			button.zRotation = button.direction.rotation()
			attackButtons.append(button)
		}
		self.hideButtons(attackButtons)
		for button in self.attackButtons {
			addChild(button)
		}
	}
	
	func displayMoveButtons() {
		hideButtons(attackButtons)
		displayButtons(moveButtons)
	}
	
	func displayAttackButtons() {
		hideButtons(moveButtons)
		displayButtons(attackButtons)
	}
	
	func displayButtons(_ buttons: [DirectionalButton]) {
		for button in buttons {
			let activePlayer = playerShadows.count > 0 ? playerShadows[playerShadows.count - 1] : player
			let moveAction = SKAction.move(to: button.direction.move(activePlayer.position, player.moveDistance), duration: 0)
			button.run(moveAction)
			button.zPosition = 99
			switch button.direction {
			case .down, .downright, .downleft:
				hideDownButton(button)
			default:
				button.isHidden = false
			}
		}
	}
	
	func hideButtons(_ buttons: [Button]) {
		for button in buttons {
			button.isHidden = true
			button.zPosition = -1
		}
		if (playerShadows.count + attackMarks.count) == MAX_ACTIONS {
			for shadow in playerShadows {
				shadow.removeFromParent()
			}
			for attack in attackMarks {
				attack.removeFromParent()
			}
			attackMarks.removeAll()
			playerShadows.removeAll()
		}
	}
	
	func hideDownButton(_ button: Button) {
		let activePlayer = playerShadows.count > 0 ? playerShadows[playerShadows.count - 1] : player
		if activePlayer.position.y < bottomPosition.y {
			button.isHidden = true
		} else {
			button.isHidden = false
		}
	}
	
	func createShadow(direction: Direction) {
		let shadowPlayer = playerShadows.count > 0 ? playerShadows[playerShadows.count - 1].copy() : player.copy()
		shadowPlayer.position = playerShadows.count > 0 ? playerShadows[playerShadows.count - 1].position : player.position
		shadowPlayer.setPlayerActive(true)
		playerShadows.append(shadowPlayer)
		addChild(shadowPlayer)
		shadowPlayer.run(SKAction.fadeAlpha(to: 0.6, duration: 0))
		shadowPlayer.shadowMove(direction: direction)
	}
	
	func createAttackShadow(direction: Direction) {
		let attackMark = SKSpriteNode(imageNamed: "attack_mark")
		attackMark.position = playerShadows.count > 0 ? playerShadows[playerShadows.count - 1].position : player.position
		attackMarks.append(attackMark)
		addChild(attackMark)
		attackMark.run(SKAction.move(to: direction.move(attackMark.position, player.moveDistance), duration: 0.25))
	}
}
