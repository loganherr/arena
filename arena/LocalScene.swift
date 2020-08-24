//
//  GameScene.swift
//  arena
//
//  Created by Logan on 7/14/20.
//  Copyright © 2020 Logan. All rights reserved.
//

import SpriteKit

class LocalScene: SKScene {
	var turn = 0
	var players: [Player] = []
	var playerShadows: [Player] = []
	var attackMarks: [SKSpriteNode] = []
	let boardSize = 5
	let board: Board
	var startPositions: [CGPoint]
	let bottomPosition: CGPoint
	var moveButtons: [DirectionalButton] = []
	var attackButtons: [DirectionalButton] = []
	
	var activePlayer: Player {
		return players[turn]
	}
	var currentPlayer: Player {
		return playerShadows.count > 0 ? playerShadows[playerShadows.count - 1] : activePlayer
	}
	
	// MARK: INIT
	override init(size: CGSize) {
		board = Board(size: size, gridSize: boardSize)
		startPositions = [board.boardTiles[1][1].position, board.boardTiles[1][3].position, board.boardTiles[3][1].position, board.boardTiles[3][3].position]
		bottomPosition = board.boardTiles[0][boardSize - 1].position
		super.init(size: size)
		createMoveButtons()
		createAttackButtons()
	}
	
	func createMoveButtons() {
		let moveImage = "move_card"
		let moveImageActive = "move_card_active"
		func buttonAction(direction: Direction) -> () -> () {
			return {
				self.players[self.turn].addAction(Action(.move, direction))
				self.createShadow(direction: direction)
				self.hideButtons(self.moveButtons)
			}
		}
		for direction in Direction.allCases {
			let button = DirectionalButton(direction: direction,
										   defaultButtonImage: moveImage,
										   activeButtonImage: moveImageActive,
										   buttonAction: buttonAction(direction: direction))
			button.zRotation = button.direction.rotation()
			moveButtons.append(button)
		}
		self.hideButtons(self.moveButtons)
		for button in self.moveButtons {
			addChild(button)
		}
	}
	
	func createAttackButtons() {
		let attackImage = "attack_card"
		let attackImageActive = "attack_card_active"
		func buttonAction(direction: Direction) -> () -> () {
			return {
				self.activePlayer.addAction(Action(.attack, direction))
				self.createAttackShadow(direction: direction)
				self.hideButtons(self.attackButtons)
			}
		}
		for direction in Direction.allCases {
			let button = DirectionalButton(direction: direction,
										   defaultButtonImage: attackImage,
										   activeButtonImage: attackImageActive,
										   buttonAction: buttonAction(direction: direction))
			button.zRotation = button.direction.rotation()
			attackButtons.append(button)
		}
		self.hideButtons(attackButtons)
		for button in self.attackButtons {
			addChild(button)
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: TURN HANDLING
	
	override func didMove(to view: SKView) {
		for i in 1...4 {
			let button = Button(defaultButtonImage: "\(i)P", activeButtonImage: "\(i)P_active", buttonAction: {
				for node in self.children {
					node.run(SKAction.move(to: CGPoint(x: node.position.x, y: -40), duration: 0.25))
				}
				 
				self.startGame(i)
			})
			button.position = CGPoint(x: view.frame.width / 2.0, y: (view.frame.height / 5.0) * (5.0 - CGFloat(i)))
			addChild(button)
		}
//		let moveButton = Button(defaultButtonImage: "move_card",
//								activeButtonImage: "move_card_active",
//								buttonAction: displayMoveButtons)
//		moveButton.position = CGPoint(x: view.frame.width / 4, y: view.frame.origin.y + 40)
//		let attackButton = Button(defaultButtonImage: "\(players[turn].gladiator)_attack_card", activeButtonImage: "\(players[turn].gladiator)_attack_card_active", buttonAction: displayAttackButtons)
//		attackButton.position = CGPoint(x: (view.frame.width / 4) * 2, y: view.frame.origin.y + 40)
//		addChild(moveButton)
//		addChild(attackButton)
	}
	
	func startGame(_ numPlayers: Int) {
		board.zPosition = -1
		addChild(board)
		
		func addPlayers(_ availableGladiators: [Gladiator]) {
			if players.count == numPlayers { return }
			let gladiator = availableGladiators.randomElement()!
			let player = Player(gladiator: gladiator, moveDistance: board.boardTiles[0][0].frame.height, type: .human)
			player.setPlayerActive(true)
			player.position = startPositions[players.count]
			players.append(player)
			addChild(player)
			addPlayers(availableGladiators.filter({ $0 != gladiator }))
		}
		addPlayers(Gladiator.allCases)
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
			
			let moveAction = SKAction.move(to: button.direction.move(activePlayer.position, activePlayer.moveDistance), duration: 0)
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
		if activePlayer.position.y < bottomPosition.y {
			button.isHidden = true
		} else {
			button.isHidden = false
		}
	}
	
	func createShadow(direction: Direction) {
		let shadowPlayer: Player = playerShadows.count > 0 ? playerShadows[playerShadows.count - 1].copy() : activePlayer.copy()
		shadowPlayer.setPlayerActive(true)
		playerShadows.append(shadowPlayer)
		addChild(shadowPlayer)
		shadowPlayer.run(SKAction.fadeAlpha(to: 0.6, duration: 0))
		shadowPlayer.move(direction: direction)
	}
	
	func createAttackShadow(direction: Direction) {
		let attackMark = SKSpriteNode(imageNamed: "attack_mark")
		attackMark.position = activePlayer.position
		attackMarks.append(attackMark)
		addChild(attackMark)
		attackMark.run(SKAction.move(to: direction.move(attackMark.position, activePlayer.moveDistance), duration: 0.25))
	}
}
