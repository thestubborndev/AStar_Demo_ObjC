//
//  PathfindingNode.h
//  A*
//
//  Created by Carlotta Tatti on 28/08/13.
//  Copyright (c) 2013 Carlotta Tatti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PathfindingNode : UIView

@property (nonatomic) int x;
@property (nonatomic) int y;

@property (nonatomic) int h;
@property (nonatomic) int g;
@property (nonatomic) int f;

@property (strong, nonatomic) PathfindingNode *parentNode;
@property (strong, nonatomic) UILabel *costLabel;

- (id)initWithPosition:(CGPoint)position;

@end
