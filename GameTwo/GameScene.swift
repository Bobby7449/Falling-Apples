
//
//  GameScene.swift
//  firstGame
//
//  Created by  on 6/1/22.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var apple = SKSpriteNode()
    var basket = SKSpriteNode()
    var scoreLabel = SKLabelNode()
    var playerScore = 0
    var oldPosition: CGPoint?
    var bottom = SKSpriteNode()
    var repp = SKAction()
    //var timeLeft = 10
    
    
    
    override func didMove(to view: SKView)
        
    {
            
        basket = childNode(withName: "basket") as! SKSpriteNode
        createScoreLabel()
        createBottom()
        
        
       makeApplesfall()
      
       
        //bitmask
        basket.physicsBody?.categoryBitMask = 1
        apple.physicsBody?.categoryBitMask = 2
        bottom.physicsBody?.categoryBitMask = 3

        basket.physicsBody?.contactTestBitMask = 1 | 2 | 3
        bottom.physicsBody?.contactTestBitMask = 2 | 3

        physicsWorld.contactDelegate = self
        
    }
    
    func makeApplesfall()
    {
        //repeat falling apple
     repp = SKAction.repeatForever(SKAction.sequence([
                    SKAction.run(createApple),
        SKAction.wait(forDuration: 1.4)
                ]))

             run(repp)
    }
    
    func createBottom()
    {
        bottom = SKSpriteNode(color: UIColor.clear, size: CGSize(width: self.frame.width, height: 10))
              bottom.position = CGPoint(x: self.frame.width/2, y:0)
             
        addChild(bottom)
             
        bottom.physicsBody = SKPhysicsBody(rectangleOf: bottom.frame.size)
             
        bottom.physicsBody?.isDynamic = false
        
        bottom.physicsBody?.categoryBitMask = 3

    }
    
    
        //apple disapear when caught
        func didBegin(_ contact: SKPhysicsContact)
        {
            let location = contact.contactPoint
            print(location)


            if contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 1
                   {
                       // apple hit basket
                       print("Apple Saved")
        playerScore += 1
        updateScore()
        contact.bodyA.node?.removeFromParent()
                   }
            
            if contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 2
                   {
                       // apple hit basket
        print("Apple Saved")
        playerScore += 1
        updateScore()
        contact.bodyB.node?.removeFromParent()

                   }
            
       if contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 3
       {
        print ("gameover")
        contact.bodyA.node?.removeFromParent()
        endGame()
       }
            if contact.bodyA.categoryBitMask == 3 && contact.bodyB.categoryBitMask == 2
            {
            contact.bodyB.node?.removeFromParent()
            print ("gameover")
             endGame()
            }
        
      }
        
        
        
    
    
    //make basket move with touch
    var isTouchingBasket = false
       // this method gets called everytime i touch my screen
       override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
       {
           let location = touches.first!.location(in: self)
           if basket.frame.contains(location) {
               isTouchingBasket = true
           }
           if isTouchingBasket == true {
               basket.position = CGPoint(x: location.x, y: basket.position.y)
           }

       }
       override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
           let location = touches.first!.location(in: self)
           if isTouchingBasket == true {
               basket.position = CGPoint(x: location.x, y: basket.position.y)
           }
       }
       override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
           isTouchingBasket = false
       }
   
   
    

    //create falling apple

    func createApple()
     {
        let randomX = CGFloat.random(in: 10...frame.width-10)
        let newapple = SKSpriteNode(imageNamed: "apple")
        newapple.size = CGSize(width: 100, height: 100)
        newapple.position = CGPoint(x: randomX, y: 1280)



         addChild(newapple)


        newapple.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        newapple.physicsBody?.restitution = 1;
        newapple.physicsBody?.allowsRotation = false;
        newapple.physicsBody?.affectedByGravity = true
        newapple.physicsBody?.categoryBitMask = 2

            apple = newapple
    }
        
        //MAKE SCORE
        func createScoreLabel()
        {
            scoreLabel = SKLabelNode(text:"Apple Saved")
            scoreLabel.fontName = "Arial"
            scoreLabel.fontSize = 60
            scoreLabel.position = CGPoint(x: frame.width/2, y: 1290)
            scoreLabel.fontColor = UIColor.black
            //scoreLabel.zRotation = .pi/2
            
            addChild(scoreLabel)
        }
        
        
        func updateScore()
        {
            scoreLabel.text = "Apples Saved = \(playerScore)"
            
        }
        
        //END GAME
        func endGame()
        {
            removeAllActions()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
               
                self.makeApplesfall()
               
            })
            
            playerScore = 0
            scoreLabel.text = "GAME OVER"
            
        }

        
    
    
    
}
    
   

    









