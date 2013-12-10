
//  ViewController.m
//  A*
//
//  Created by Carlotta Tatti on 03/07/13.
//  Copyright (c) 2013 Carlotta Tatti. All rights reserved.
//

#import "ViewController.h"

#import "PathfindingNode.h"

@interface ViewController ()

@property (strong, nonatomic) PathfindingNode *start;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UILongPressGestureRecognizer *lgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(setStartCell:)];
    [self.view addGestureRecognizer:lgr];
}

- (void)viewDidAppear:(BOOL)animated {
    self.allNodes = [NSMutableArray new];
    
    for (int x = 0; x < 10; x++) {
        for (int y = 0; y < 10; y++) {
            PathfindingNode *node = [[PathfindingNode alloc] initWithPosition:CGPointMake(x, y)];
            
            if (x==1 && y==0) {
                _start = node;
                _start.backgroundColor = [UIColor greenColor];
            }
            
            if (x==4 && y==4) {
            }
            
            if (x==0 && y==1)
                node.backgroundColor = [UIColor grayColor];
            if (x==1 && y==1)
                node.backgroundColor = [UIColor grayColor];
            if (x==2 && y==1)
                node.backgroundColor = [UIColor grayColor];
            if (x==1 && y==3)
                node.backgroundColor = [UIColor grayColor];
            if (x==2 && y==3)
                node.backgroundColor = [UIColor grayColor];
            if (x==3 && y==3)
                node.backgroundColor = [UIColor grayColor];
            if (x==4 && y==3)
                node.backgroundColor = [UIColor grayColor];
            
            [self.allNodes addObject:node];
            
            [self.view addSubview:node];
        }
    }
    
    [super viewDidAppear:animated];
}

- (IBAction)clear:(id)sender {
    for (PathfindingNode *node in self.allNodes) {
        if (![node.backgroundColor isEqual:[UIColor grayColor]]) {
            node.backgroundColor = [UIColor whiteColor];
        }
    }
}

- (void)setStartCell:(UIGestureRecognizer *)gr {
    CGPoint point = [gr locationOfTouch:0 inView:self.view];
    
    CGPoint cellPosition = CGPointMake(abs(point.x/32), abs(point.y/32));
    _start = [[PathfindingNode alloc] initWithPosition:cellPosition];
    
    [self.view setNeedsLayout];
}

#pragma mark -
#pragma mark Pathfinder

- (BOOL)findPathFromStartNode:(PathfindingNode *)startNode toTargetNode:(PathfindingNode *)targetNode {
    NSMutableSet *openSet = [NSMutableSet new];
    NSMutableSet *closedSet = [NSMutableSet new];
    
    startNode.g = 0;
    startNode.h = [self calculateManhattanDistanceBetweenStartNode:startNode targetNode:targetNode];
    startNode.f = startNode.g + startNode.h;
    
    [openSet addObject:startNode];

    while ([openSet count] > 0) {
        PathfindingNode *node = [self lowestFScoreNodeInSet:openSet];
        if ([self node:node isEqualToNode:targetNode]) {
            NSLog(@"Found path!");
            [self reversePathFromNode:targetNode];
            return YES;
        }
        
        [openSet removeObject:node];
        [closedSet addObject:node];
        for (PathfindingNode *adjacent in [self findAdjacentSquares:node]) {
            if ([closedSet containsObject:adjacent]) {
                continue;
            }
            
            int g = node.g + 1;
            BOOL isBetter;
            if (![openSet containsObject:adjacent]) {
                [openSet addObject:adjacent];
                
                isBetter = YES;
            } else if (g < adjacent.g) {
                isBetter = YES;
            } else {
                isBetter = NO;
            }
            
            if (isBetter == YES) {
                adjacent.parentNode = node;
                adjacent.g = g;
                adjacent.h = [self calculateManhattanDistanceBetweenStartNode:adjacent targetNode:targetNode];
                adjacent.f = adjacent.g + adjacent.h;
            }
        }
    }
    return NO;
}

- (void)reversePathFromNode:(PathfindingNode *)endNode {
    NSMutableArray *finalPath = [NSMutableArray new];
    PathfindingNode *node = endNode;
    do {
        NSLog(@"X: %i, Y: %i", node.x, node.y);

        node.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.3];
        [finalPath addObject:node];
        node = node.parentNode;
    } while (node.parentNode != nil);
}

- (int)calculateManhattanDistanceBetweenStartNode:(PathfindingNode *)currentNode targetNode:(PathfindingNode *)targetNode {
    int x1 = currentNode.x;
    int x0 = targetNode.x;
    int y1 = currentNode.y;
    int y0 = targetNode.y;

    int distance = abs(x1-x0) + abs(y1-y0);
    
    return distance;
}

- (PathfindingNode *)lowestFScoreNodeInSet:(NSMutableSet *)set {
    PathfindingNode *lowestScoreNode = [set anyObject];
    for (PathfindingNode *node in [set allObjects]) {
        if (node.f < lowestScoreNode.f) {
            lowestScoreNode = node;
        }
    }
    
    return lowestScoreNode;
}

- (BOOL)node:(PathfindingNode *)node1 isEqualToNode:(PathfindingNode *)node2 {
    if (node1.x == node2.x && node1.y == node2.y) {
        return YES;
    }
    
    return NO;
}

- (NSArray *)findAdjacentSquares:(PathfindingNode *)node {
    NSMutableArray *squares = @[].mutableCopy;
    
    for (PathfindingNode *n in self.allNodes) {
        if (n.x == node.x-1 && n.y == node.y) {
            if (![n.backgroundColor isEqual:[UIColor grayColor]]) {
                [squares addObject:n];
            }
        }
        if (n.x == node.x+1 && n.y == node.y) {
            if (![n.backgroundColor isEqual:[UIColor grayColor]]) {
                [squares addObject:n];
            }
        }
        if (n.y == node.y-1 && n.x == node.x) {
            if (![n.backgroundColor isEqual:[UIColor grayColor]]) {
                [squares addObject:n];
            }
        }
        if (n.y == node.y+1 && n.x == node.x) {
            if (![n.backgroundColor isEqual:[UIColor grayColor]]) {
                [squares addObject:n];
            }
        }
    }

    return squares.copy;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self clear:nil];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    CGPoint cellPosition = CGPointMake(abs(point.x/32), abs(point.y/32));
    
    for (PathfindingNode *node in self.allNodes) {
        if (node.x == cellPosition.x && node.y == cellPosition.y) {
            [self findPathFromStartNode:_start toTargetNode:node];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
