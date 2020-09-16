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
	var actionButtons: [Button] = []
	var moveButtons: [DirectionalButton] = []
	var attackButtons: [DirectionalButton] = []
	var availableActions: [ActionType] = []
	
	var activePlayer: Player {
		return players[turn]
	}
	var currentPlayer: Player {
		return playerShadows.count > 0 ? playerShadows[playerShadows.count - 1] : activePlayer
	}
	
	// MARK: INIT
	override init(size: CGSize) {
		board = Board(size: size, gridSize: boardSize)
		startPositions = [board.tiles[1][1].position, board.tiles[1][3].position, board.tiles[3][1].position, board.tiles[3][3].position]
		bottomPosition = board.tiles[0][boardSize - 1].position
		super.init(size: size)
	}
	
	func createMoveButtons() {
		let moveImage = "move_card"
		let moveImageActive = "move_card_active"
		func buttonAction(direction: Direction) -> () -> () {
			return {
				self.activePlayer.addAction(Action(.move, direction))
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
			button.zPosition = 99
			button.isHidden = true
			addChild(button)
			moveButtons.append(button)
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
			button.zPosition = 99
			button.isHidden = true
			addChild(button)
			attackButtons.append(button)
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
					node.run(SKAction.move(to: CGPoint(x: node.position.x, y: node.position.y - view.frame.height), duration: 0.5)) {
						node.removeFromParent()
						if (self.children.count == 0) {
							self.startGame(i)
						}
					}
				}
				
			})
			button.position = CGPoint(x: view.frame.width / 2.0, y: (view.frame.height / 5.0) * (5.0 - CGFloat(i)))
			addChild(button)
		}
	}
	
	func startGame(_ numPlayers: Int) {
		board.zPosition = -1
		addChild(board)
		createMoveButtons()
		createAttackButtons()
		func addPlayers(_ availableGladiators: [Gladiator]) {
			if players.count == numPlayers {
				takeTurn()
			} else {
				let gladiator = availableGladiators.randomElement()!
				let player = Player(gladiator: gladiator, moveDistance: board.tiles[0][0].frame.height, type: .human)
				player.position = startPositions[players.count]
				players.append(player)
				addChild(player)
				addPlayers(availableGladiators.filter({ $0 != gladiator }))
			}
		}
		addPlayers(Gladiator.allCases)
	}
	
	func takeTurn() {
		if turn == players.count {
			// all players have gone, perform the actions
			applyActions()
			turn = 0
			clearForNextTurn()
			// then reset turn counter and start turns again
		} else if activePlayer.actions.count == MAX_ACTIONS {
			// activePlayer's turn is done
			activePlayer.setPlayerActive(false)
			clearForNextTurn()
			turn += 1
			takeTurn()
		} else if activePlayer.actions.count == 0 {
			activePlayer.setPlayerActive(true)
			// activePlayer needs to select another action
			// display activePlayer's actions if not already displayed
			(0..<PLAYER_HAND_SIZE).forEach { (i) in
				switch activePlayer.getActionFromDeck() {
				case .move:
					let mbutton = Button(defaultButtonImage: "move_card", activeButtonImage: "move_card_active", buttonAction: {
						self.hideButtons(self.attackButtons)
						self.displayButtons(self.moveButtons)
					})
					mbutton.position = CGPoint(x: self.board.tiles[i][4].position.x + (self.board.tiles[i][4].frame.width / 2),
											  y: self.board.tiles[i][4].frame.origin.y - self.board.tiles[i][4].frame.height)
					actionButtons.append(mbutton)
					self.addChild(mbutton)
				case .attack:
					let abutton = Button(defaultButtonImage: "attack_card", activeButtonImage: "attack_card_active", buttonAction: {
						self.hideButtons(self.moveButtons)
						self.displayButtons(self.attackButtons)
					})
					abutton.position = CGPoint(x: self.board.tiles[i][4].position.x + (self.board.tiles[i][4].frame.width / 2),
											  y: self.board.tiles[i][4].frame.origin.y - self.board.tiles[i][4].frame.height)
					actionButtons.append(abutton)
					self.addChild(abutton)
				}
			}
		}
	}
	
	func applyActions() {
		let playerCopies = players.map { (player) -> Player in
			let copy: Player = player.copy()
			copy.actions = player.actions
			return copy
		}
		for i in 0..<MAX_ACTIONS {
			let movePlayers = playerCopies.filter { $0.actions[i].type == .move }
			let atkPlayers = playerCopies.filter { $0.actions[i].type == .attack }
			for player in movePlayers {
				playerCopies.filter { $0.gladiator == player.gladiator }[0].position = player.actions[i].direction.move(player.position, player.moveDistance)
			}
			for atkdPlayer in playerCopies {
				players.filter { $0.gladiator == atkdPlayer.gladiator }[0].addReaction(.dodge)
				for player in atkPlayers {
					let atkPosition = player.actions[i].direction.move(player.position, player.moveDistance)
					if checkIfAttackHit(atkdPlayer.position, atkPosition) {
						players.filter { $0.gladiator == atkdPlayer.gladiator }[0].addReaction(.attacked)
						players.filter { $0.gladiator == atkdPlayer.gladiator }[0].loseHealth()
					}
				}
			}
		}
		for (index, player) in players.enumerated() {
			let animations = player.animations()
			player.clearActions()
			player.clearReactions()
			player.run(animations) {
				if index == self.players.endIndex - 1 {
					self.takeTurn()
				}
			}
		}
	}
	
	func clearForNextTurn() {
		for button in actionButtons {
			button.isHidden = true
			button.removeFromParent()
		}
		actionButtons.removeAll()
	}
	
	func displayButtons(_ buttons: [DirectionalButton]) {
		for button in buttons {
			let moveAction = SKAction.move(to: button.direction.move(currentPlayer.position, activePlayer.moveDistance), duration: 0)
			button.run(moveAction)
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
			takeTurn()
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
		shadowPlayer.addAction(Action(.move, direction))
		playerShadows.append(shadowPlayer)
		addChild(shadowPlayer)
		shadowPlayer.run(SKAction.fadeAlpha(to: 0.6, duration: 0))
		shadowPlayer.run(shadowPlayer.animations())
	}
	
	func createAttackShadow(direction: Direction) {
		let attackMark = SKSpriteNode(imageNamed: "attack_mark")
		attackMark.position = currentPlayer.position
		attackMarks.append(attackMark)
		addChild(attackMark)
		attackMark.run(SKAction.move(to: direction.move(attackMark.position, activePlayer.moveDistance), duration: 0.25))
	}
	
	func checkIfAttackHit(_ pointA: CGPoint, _ pointB: CGPoint) -> Bool {
		let hitRange = -2.0...2.0
		let xDelta = pointA.x - pointB.x
		let yDelta = pointA.y - pointB.y
		if hitRange ~= Double(xDelta) && hitRange ~= Double(yDelta) {
			return true
		} else {
			return false
		}
	}
}
