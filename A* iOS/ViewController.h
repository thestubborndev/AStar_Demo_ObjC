//
//  ViewController.h
//  A*
//
//  Created by Carlotta Tatti on 03/07/13.
//  Copyright (c) 2013 Carlotta Tatti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PathfindingNode.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *allNodes;

- (IBAction)clear:(id)sender;

@end
