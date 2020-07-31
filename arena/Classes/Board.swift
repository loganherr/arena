//
//  Board.swift
//  arena
//
//  Created by Logan on 7/15/20.
//  Copyright © 2020 Logan. All rights reserved.
//

import SpriteKit

class Board: SKNode {
	
	var boardTiles: [[SKSpriteNode]] = []
	
	init(size: CGSize, gridSize: Int) {
		super.init()
		for i in 0 ..< gridSize {
			boardTiles.append([])
			for j in 0 ..< gridSize {
				let boardTile = SKSpriteNode(imageNamed: "floor_tile")
				boardTile.size = CGSize(width: size.width / CGFloat(gridSize),
										height: size.width / CGFloat(gridSize))
				let xPosition = (Int(size.width) / gridSize) * i + (Int(boardTile.size.width) / 2)
				let yPosition = Int(size.height) - ((Int(boardTile.size.height) * j) + (Int(boardTile.size.height) / 2))
				boardTile.position = CGPoint(x: xPosition,
											 y: yPosition)
				boardTile.zPosition = -1
				boardTiles[i].append(boardTile)
				addChild(boardTile)
			}
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
//	func getBoardTilePosition(point: CGPoint) -> CGPoint {
//		return boardTiles[Int(point.x)][Int(point.y)].position
//	}
}
