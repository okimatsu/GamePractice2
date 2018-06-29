import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let finger = SKSpriteNode(imageNamed: "finger")
    let atackFinger = SKSpriteNode(imageNamed: "finger")
    let noseMonster = SKSpriteNode(imageNamed: "nose")
   
    var countDoun = 30
    var noseDestroyed = 10
    
    
    enum PhysicsCategory {
        static let none : UInt32 = 0
        static let all : UInt32 = UInt32.max
        static let nose : UInt32 = 0b1
        static let finger : UInt32 = 0b10
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        self.addFinger()
        self.addNoseMonster()
        
        
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
    }
    
    
    
    
    func addFinger() {
        finger.position = CGPoint(x: size.width/2, y: size.height * 0.1)
        finger.size = CGSize(width: 80, height: 160)
        self.addChild(finger)
        
        let actualDuration = CGFloat(1.2)
        let actionMove1 = SKAction.moveTo(x: size.width * 0.9, duration: TimeInterval(actualDuration))
        let actionMove2 = SKAction.moveTo(x: size.width * 0.1, duration: TimeInterval(actualDuration))
        finger.run(SKAction.repeatForever(SKAction.sequence([actionMove2,actionMove1])))
        finger.physicsBody = SKPhysicsBody(rectangleOf: finger.size)
        finger.physicsBody?.categoryBitMask = PhysicsCategory.finger
        finger.physicsBody?.contactTestBitMask = PhysicsCategory.nose
        finger.physicsBody?.collisionBitMask = PhysicsCategory.none
        finger.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    
    func addNoseMonster() {
        noseMonster.size = CGSize(width: 100, height: 100)
        noseMonster.position = CGPoint(x: size.width * 0.1, y: size.height * 0.9)
        addChild(noseMonster)
        
        noseMonster.physicsBody = SKPhysicsBody(rectangleOf: noseMonster.size)
        noseMonster.physicsBody?.categoryBitMask = PhysicsCategory.nose
        noseMonster.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        
        let actualDuration = CGFloat(1.8)
        let actionMove1 = SKAction.moveTo(x: size.width * 0.9, duration: TimeInterval(actualDuration))
        let actionMove2 = SKAction.moveTo(x: size.width * 0.1, duration: TimeInterval(actualDuration))
       
        // noseMonster.run(SKAction.repeatForever(SKAction.sequence([actionMove1, actionMove2])))
        let loseAction = SKAction.run() {
            let reveal =
                SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene =
                GameOverScene(size: self.size, won: false)
            self.view?.presentScene(gameOverScene,
                                    transition: reveal)
        }
        noseMonster.run(SKAction.sequence([actionMove1, actionMove2, actionMove1, actionMove2, actionMove1, actionMove2, actionMove1, actionMove2, actionMove1, actionMove2,  actionMove1, actionMove2, actionMove1, actionMove2, actionMove1, actionMove2, actionMove1, actionMove2, actionMove1, actionMove2, actionMove1, actionMove2,actionMove1, actionMove2, actionMove1, actionMove2, actionMove1, actionMove2, loseAction]))
    }
    
    func addAtackFinger() {
       /* atackFinger.size = CGSize(width: 100, height: 180)
        atackFinger.position = finger.position
        addChild(atackFinger) */
        let atackMove = SKAction.moveTo(y: size.height * 0.8, duration: TimeInterval(1.2))
       // let atackMoveDone = SKAction.removeFromParent()
        let backMove = SKAction.moveTo(y: size.height * 0.1, duration: TimeInterval(1))
        
        
        finger.run(SKAction.sequence([atackMove, backMove]))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        addAtackFinger()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if((firstBody.categoryBitMask & PhysicsCategory.nose != 0) && (secondBody.categoryBitMask & PhysicsCategory.finger != 0)) {
            fingerDidCollideWithNose(finger: firstBody.node as! SKSpriteNode, nose: secondBody.node as! SKSpriteNode)
        }
    }
    func fingerDidCollideWithNose(finger: SKSpriteNode,
                                         nose: SKSpriteNode) {
        noseDestroyed -= 1
        if (noseDestroyed == 0) {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: true)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
        
        print("Hit")
        print(noseDestroyed)
        efect()
    }
    
    func timer() {
        let timerLavel = SKLabelNode(fontNamed: "Copperplate-Light")
        let deleteTimer = SKAction.removeFromParent()
        let actionTimer = SKAction.wait(forDuration: 1)
        
        
        timerLavel.text = "\(noseDestroyed)"
        timerLavel.fontSize = 60
        if countDoun > 15 {
            timerLavel.fontColor = SKColor.black
        } else {
            timerLavel.fontColor = SKColor.red
        }
        timerLavel.position = CGPoint(x: size.width * 0.9, y: size.height * 0.9)
        addChild(timerLavel)
        timerLavel.run(SKAction.sequence([actionTimer, deleteTimer]))
    }

    func efect() {
        let burn = SKSpriteNode(imageNamed: "burn")
        burn.position = noseMonster.position
        let burnIn = SKAction.fadeIn(withDuration: TimeInterval(1))
        let burnOut = SKAction.fadeOut(withDuration: TimeInterval(1))
        burn.run(SKAction.sequence([burnIn,burnOut]))
        
        self.addChild(burn)
        self.timer()
    }
    
}
