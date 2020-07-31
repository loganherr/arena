//
//  Button.swift
//  arena
//
//  Created by Logan on 7/15/20.
//  Copyright © 2020 Logan. All rights reserved.
//
import SpriteKit

class Button: SKNode {
      let defaultButton: SKSpriteNode
      let activeButton: SKSpriteNode
      var action: () -> ()

	init(defaultButtonImage: String, activeButtonImage: String, buttonAction: @escaping () -> ()) {
           defaultButton = SKSpriteNode(imageNamed: defaultButtonImage)
           activeButton = SKSpriteNode(imageNamed: activeButtonImage)
           activeButton.isHidden = true
           action = buttonAction

           super.init()

           isUserInteractionEnabled = true
           addChild(defaultButton)
           addChild(activeButton)
     }

     required init(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
     }

     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeButton.isHidden = false
        defaultButton.isHidden = true
     }

     override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
             let location = touch.location(in: self)

             if defaultButton.contains(location) {
                  activeButton.isHidden = false
                  defaultButton.isHidden = true
             } else {
                   activeButton.isHidden = true
                   defaultButton.isHidden = false
             }
        }
     }

     override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
          for touch in touches {
             let location = touch.location(in: self)

             if defaultButton.contains(location) {
                 action()
             }

             activeButton.isHidden = true
             defaultButton.isHidden = false
         }
    }
}
