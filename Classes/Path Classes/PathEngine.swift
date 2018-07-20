//
//  PathEngine.swift
//  CapGame
//
//  Created by Brandy Austin on 7/9/18.
//  Copyright © 2018 Brandy Austin. All rights reserved.
//

import SpriteKit

var prevPathItem = SKSpriteNode();
var xValue = CGFloat(0);


// make runway span entire screen then generate subsequent pathItem objects at a slower rate instead of using 0.35 for the timer

class PathEngine {
    
    var portal = Portal();

    let pathImages = ["startLow", "startStep", "middleLow", "endLow", "aloneLow", "startHigh", "middleHigh", "endHigh", "aloneHigh"];
    var pathItem = PathItem();
    
    var spaceBefore = Int();
    
    var type = String();
    var height = String();
    var lastType = String();
    var lastHeight = String();
    
    var timer = Timer();
    var interval = 0.35;
        
    func initialize(scene: SKScene) {
        
        prevPathItem = SKSpriteNode();
        xValue = CGFloat(0);
        
        createRunway(scene: scene);
        
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(createMainPath), userInfo: scene, repeats: true);
    }

    func createRunway(scene: SKScene) {
        
        for _ in 0...2 {
            
            pathItem = PathItem(imageNamed: "\(option)middleLow");
            pathItem.initialize();
            
            pathItem.addPathItem(scene: scene, spaceBefore: Int(0), drinkFlag: false, rockFlag: false);
            
        };
        
        pathItem = PathItem(imageNamed: "\(option)endLow");
        pathItem.initialize();
        
        pathItem.addPathItem(scene: scene, spaceBefore: Int(0), drinkFlag: false, rockFlag: false);
        
        lastType = "end";
        lastHeight = "Low";
    }
    
    @objc func createMainPath(timer: Timer) {

        let scene = timer.userInfo as! SKScene;
        
        let portalFactor = 8;
        let startAloneFactor = 4;
        let lowMiddleEndFactor = 6;
        let highMiddleEndFactor = 5;
        let lowHighFactor = 6;
        
        let portalRandom = Int.random(min: 1, max: 30);
        let randomOne = Int.random(min: 1, max: 10);
        let randomTwo = Int.random(min: 1, max: 10);
        
        if lastType == "end" || lastType == "alone" {
            
            if portalRandom <= portalFactor {
                insertPortal(scene: scene);
                return;
            }
            
            if (randomOne <= startAloneFactor) {
                type = "start";
                
                if (randomTwo <= 2) {
                    height = "Low";
                    
                } else if ((3...4).contains(randomTwo)) {
                    height = "High";
                    
                } else {
                    height = "Step";
                };
                
            } else {
                type = "alone";
                
                if (randomTwo <= lowHighFactor) {
                    height = "Low";
                    
                } else {
                    height = "High";
                };
                
            }
            spaceBefore = Int.random(min: 70, max: 130);
            
        } else if (lastHeight == "Low" || lastHeight == "Step" || lastHeight == "High") {
            
            if lastHeight == "Low" || lastHeight == "Step" {
                
                height = "Low";
                
                if (1...lowMiddleEndFactor).contains(randomTwo) {
                    type = "middle";
                    
                } else {
                    type = "end";
                    
                };
                
            } else if lastHeight == "High" {
                
                height = "High";
                
                if (1...highMiddleEndFactor).contains(randomTwo) {
                    type = "middle";
                    
                } else {
                    type = "end";
                    
                };
            }
            spaceBefore = Int(0);
            
        };
        
        let drinkFlag = drinkRequired(type: type);
        let rockFlag = rockRequired(type: type);
        
        pathItem = PathItem(imageNamed: "\(option)\(type)\(height)");
        pathItem.initialize();
        
        pathItem.addPathItem(scene: scene, spaceBefore: spaceBefore, drinkFlag: drinkFlag, rockFlag: rockFlag);
        
        lastType = type;
        lastHeight = height;
    }
    
    func rockRequired(type: String) -> Bool {
        if (type != "alone" && height != "High") && height != "Step" {
            
            let rockFactor = 1;
            let rockRandom = Int.random(min: 1, max: 10);
            
            return rockRandom <= rockFactor
        } else {
            return false
        }
    }
    
    func drinkRequired(type: String) -> Bool {
        if type == "alone" || type == "middle" {
            let drinkFactor = 8;
            let drinkRandom = Int.random(min: 1, max: 10);

            return drinkRandom <= drinkFactor
        } else {
            return false
        }
    }
    
    func selectPortalType() -> String {
        let standPlaneFactor = 3;
        let standPlaneRandom = Int.random(min: 1, max: 10);

        if standPlaneRandom <= standPlaneFactor {
            return "stand";
        } else {
            return "plane";
        }
    }
    
    // refactor function to use a loop and randomization
    func insertPortal(scene: SKScene) {
        
        let portalType = selectPortalType();
    
        pathItem = PathItem(imageNamed: "\(option)startStep");
        pathItem.initialize();
        pathItem.addPathItem(scene: scene, spaceBefore: 100, drinkFlag: false, rockFlag: false);
       
        pathItem = PathItem(imageNamed: "\(option)middleLow");
        pathItem.initialize();
        pathItem.addPathItem(scene: scene, spaceBefore: 0, drinkFlag: false, rockFlag: false);
        
        pathItem = PathItem(imageNamed: "\(option)middleLow");
        pathItem.initialize();
        pathItem.addPathItem(scene: scene, spaceBefore: 0, drinkFlag: false, rockFlag: false);
        
        let midPathItemPosition = pathItem.position;
        
        pathItem = PathItem(imageNamed: "\(option)middleLow");
        pathItem.initialize();
        pathItem.addPathItem(scene: scene, spaceBefore: 0, drinkFlag: false, rockFlag: false);
        
        pathItem = PathItem(imageNamed: "\(option)endLow");
        pathItem.initialize();
        pathItem.addPathItem(scene: scene, spaceBefore: 0, drinkFlag: false, rockFlag: false);
        
        lastType = "end";
        lastHeight = "Low";
        
        if portalType == "plane" {
            portal = Portal(imageNamed: "\(portalType)");
        } else {
            portal = Portal(imageNamed: "\(option)\(portalType)");
        }
            
        // pathItem height doesn't need to be * 0.55 bc it's already initialized
        // stand height does need * 0.5 bc it's not initialized yet
        var offsetYValue = CGFloat();
        
        if portalType == "plane" {
            offsetYValue = CGFloat(500);
        } else {
            offsetYValue = CGFloat(pathItem.size.height / 2 + portal.size.height * 0.5 / 2);
        }

        portal.initialize(midPathItemPosition: midPathItemPosition, offsetYValue: offsetYValue, type: portalType);
       
        scene.addChild(portal);
        self.move(itemToMove: portal);
        
    }
    
    
    
    

    
    
    // also in PathItem.swift
    func move(itemToMove: SKSpriteNode) {

        let endpoint = CGPoint(x: -800, y: itemToMove.position.y);
        let move = SKAction.move(to: endpoint, duration: getDuration(pointA: itemToMove.position, pointB: endpoint, speed: 175.0))
        
        let remove = SKAction.removeFromParent();
        let sequence = SKAction.sequence([move, remove]);
        itemToMove.run(sequence);
    }
    
    func getDuration(pointA: CGPoint, pointB: CGPoint, speed:CGFloat)->TimeInterval {
        let xDist = (pointB.x - pointA.x)
        let yDist = (pointB.y - pointA.y)
        let distance = sqrt((xDist * xDist) + (yDist * yDist));
        let duration : TimeInterval = TimeInterval(distance/speed)
        return duration
    }

}
