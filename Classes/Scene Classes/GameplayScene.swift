//
//  GameplayScene.swift
//  CapGame
//
//  Created by Brandy Austin on 6/26/18.
//  Copyright © 2018 Brandy Austin. All rights reserved.
//

import SpriteKit

class GameplayScene: SKScene {
    
    var player = Player();
    
    override func didMove(to view: SKView) {
        initialize();
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveMountains();
    }
    
    func initialize() {
        createPlayer();
        createBackground();
        createTrees();
        createPath();
    }
    
    func createBackground() {
        for i in 0...2 {
            let mountains = SKSpriteNode(imageNamed: "mountains");
            mountains.name = "mountains";
            mountains.anchorPoint = CGPoint(x: 0.5, y: 0.5);
            mountains.position = CGPoint(x: CGFloat(i) * mountains.size.width, y:0);
            mountains.zPosition = 0;
            self.addChild(mountains);
        }
    }
    
    func createTrees() {
        for i in 0...2 {
            let trees = SKSpriteNode(imageNamed: "trees");
            trees.name = "trees";
            trees.anchorPoint = CGPoint(x: 0.5, y: 0.5);
            trees.position = CGPoint(x: CGFloat(i) * trees.size.width, y:0);
            trees.zPosition = 1;
            trees.setScale(0.70);
            self.addChild(trees);
        }
    }
    
    func moveMountains() {
        
        enumerateChildNodes(withName: "mountains") {
            node, _ in
            
            node.position.x -= 3.5;
        };
    }
    
    func createPath() {
        for i in 0...2 {
            let lowAddOn = SKSpriteNode(imageNamed: "low-add-on");
            lowAddOn.name = "lowAddOn";
            lowAddOn.anchorPoint = CGPoint(x: 0.5, y: 0.5);
            lowAddOn.position = CGPoint(x: CGFloat(i) * (lowAddOn.size.width * 0.55) + -595, y: -305);
            lowAddOn.zPosition = 3;
            lowAddOn.setScale(0.55);
            self.addChild(lowAddOn);
        }
    }
    
    func createPlayer() {
        player = Player(imageNamed: "testPlayer");
        player.initialize();
        player.position = CGPoint(x: -650, y: -200);
        self.addChild(player);
    }
    
}
