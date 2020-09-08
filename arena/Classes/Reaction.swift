//
//  Reaction.swift
//  arena
//
//  Created by Logan on 9/7/20.
//  Copyright © 2020 Logan. All rights reserved.
//

import SpriteKit

struct Reaction {
	let type: ReactionType
	
	init(_ reaction: ReactionType) {
		type = reaction
	}
}

enum ReactionType {
	case dodge
	case attacked
	case die
}



