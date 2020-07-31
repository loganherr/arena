//
//  MoveButton.swift
//  arena
//
//  Created by Logan on 7/23/20.
//  Copyright © 2020 Logan. All rights reserved.
//
import SpriteKit

class DirectionalButton: Button {
	let direction: Direction
	
	init(direction: Direction, defaultButtonImage: String, activeButtonImage: String, buttonAction: @escaping () -> ()) {
		self.direction = direction
		super.init(defaultButtonImage: defaultButtonImage, activeButtonImage: activeButtonImage, buttonAction: buttonAction)
	}

	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
