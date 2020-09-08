//
//  Action.swift
//  arena
//
//  Created by Logan on 7/27/20.
//  Copyright © 2020 Logan. All rights reserved.
//
import SpriteKit

let MAX_ACTIONS = 3

struct Action {
	let type: ActionType
	let direction: Direction
	
	init(_ action: ActionType, _ direction: Direction) {
		type = action
		self.direction = direction
	}
}

enum ActionType {
	case move
	case attack
	case dodge
	case attacked
	case die
}
