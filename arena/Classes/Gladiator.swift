//
//  Gladiator.swift
//  arena
//
//  Created by Logan on 7/17/20.
//  Copyright © 2020 Logan. All rights reserved.
//

enum Gladiator: String, CaseIterable {
	case archer = "archer"
//	case spearman = "spear"
//	case swordsman = "sword"
	case axe = "axe"
	case knight = "knight"
	
	static func random(_ gladiators: [Gladiator]) -> Gladiator {
		return gladiators.randomElement()!
	}
}
