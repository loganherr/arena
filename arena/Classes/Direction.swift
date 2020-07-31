//
//  Direction.swift
//  arena
//
//  Created by Logan on 7/22/20.
//  Copyright © 2020 Logan. All rights reserved.
//
import SpriteKit

enum Direction: CaseIterable {
	case up
	case upleft
	case upright
	case down
	case downleft
	case downright
	case left
	case right
	
	func move(_ from: CGPoint, _ distance: CGFloat) -> CGPoint {
		var newPoint = from
		switch self {
		case .up:
			newPoint.y += distance
		case .upleft:
			newPoint.x -= distance
			newPoint.y += distance
		case .upright:
			newPoint.x += distance
			newPoint.y += distance
		case .down:
			newPoint.y -= distance
		case .downleft:
			newPoint.x -= distance
			newPoint.y -= distance
		case .downright:
			newPoint.x += distance
			newPoint.y -= distance
		case .left:
			newPoint.x -= distance
		case .right:
			newPoint.x += distance
		}
		return newPoint
	}

	func rotation() -> CGFloat {
		switch self {
		case .up:
			return 0
		case .upleft:
			return CGFloat(Double.pi * 0.25)
		case .upright:
			return CGFloat(Double.pi * -0.25)
		case .down:
			return CGFloat(Double.pi)
		case .downleft:
			return CGFloat(Double.pi * 0.75)
		case .downright:
			return CGFloat(Double.pi * -0.75)
		case .left:
			return CGFloat(Double.pi * 0.5)
		case .right:
			return CGFloat(Double.pi * -0.5)
		}
	}
}
