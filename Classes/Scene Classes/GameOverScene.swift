//
//  GameOverScene.swift
//  CapGame
//
//  Created by Brandy Austin on 7/16/18.
//  Copyright © 2018 Brandy Austin. All rights reserved.
//

import SpriteKit
import GameplayKit


class GameOverScene: SKScene, SKPhysicsContactDelegate {

    var pointsLabel = SKLabelNode();
    var pointsBG = SKSpriteNode();
    var timer = Timer();
    
    var player = Player();
    let platform = PathItem(imageNamed: "startStep");
    
    var thought = Speech();
    
    override func didMove(to view: SKView) {
        initialize();
        
        pointsBG = Points.instance.getBackground();
        pointsLabel = Points.instance.getLabel();
        
        Points.instance.updatePointsDisplay(background: pointsBG, pointsLabel: pointsLabel)
        self.addChild(pointsBG);
        self.addChild(pointsLabel);
    }
    
    func initialize() {
        createStaticMountain();
        createTrees();
        
        addPlatform();
        createPlayer();
        
        delayGameOver();
        
        timer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(countDown), userInfo: nil, repeats: true);
    }
    
    @objc func countDown() {
        if Points.instance.value == 0 {
            timer.invalidate();
        }
        
        Points.instance.decrement(pointsLabel: pointsLabel);
        Points.instance.updatePointsDisplay(background: pointsBG, pointsLabel: pointsLabel)
    }
    
    func createStaticMountain() {
        let mountains = SKSpriteNode(imageNamed: "mountains");
        mountains.name = "mountains";
        mountains.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        mountains.position = CGPoint(x: 0, y: 0);
        mountains.zPosition = 0;
        self.addChild(mountains);
    }
    
    func createTrees() {
        let trees = SKSpriteNode(imageNamed: "trees");
        trees.name = "trees";
        trees.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        trees.position = CGPoint(x: 0, y:0);
        trees.zPosition = 1;
        trees.setScale(0.70);
        self.addChild(trees);
    }
    
    func addPlatform() {
        platform.initialize();
        
        let x = (self.size.width/2) - (platform.size.width/2);
        let y = -(self.frame.size.height/2) + (platform.size.height/2);
        platform.position = CGPoint(x: x, y: y);
        
        self.addChild(platform);
    }
    
    func createPlayer() {
        player = Player(imageNamed: "gameover1");
        player.initialize();
        player.position = CGPoint(x: 445, y: 200);
        
        self.addChild(player);
        player.gameOver();
    }
    
    func delayGameOver() {
        let wait = SKAction.wait(forDuration: 1);
        let addGO = SKAction.run(addGameOver);
        let sequence = SKAction.sequence([wait, addGO]);
        
        self.run(sequence);
    }
    
    func addGameOver() {
        thought = Speech(imageNamed: "thought");
        thought.initialize(type: "Thought")
        
        let position = platform.position;
        
        thought.addThought(scene: self, text: "game over", position: position)
        thought.flashThought();
    }

}