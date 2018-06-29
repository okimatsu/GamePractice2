import Foundation
import SpriteKit

class GameOverScene: SKScene {
    init(size: CGSize, won: Bool) {
        super.init(size: size)
        backgroundColor = SKColor.white
        let message = won ? "YOU WIN!" : "YOU LOSE"
        
        let lavel = SKLabelNode(fontNamed: "Chlkduster")
        lavel.text = message
        lavel.fontSize = 40
        lavel.fontColor = SKColor.black
        lavel.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(lavel)
        run(SKAction.sequence([SKAction.wait(forDuration: 3.0), SKAction.run(){
            let reveal =
                SKTransition.flipHorizontal(withDuration: 0.5)
            let scene = GameScene(size: size)
            self.view?.presentScene(scene, transition:reveal)
            }
            ]))
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
