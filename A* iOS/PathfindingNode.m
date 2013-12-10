//
//  PathfindingNode.m
//  A*
//
//  Created by Carlotta Tatti on 28/08/13.
//  Copyright (c) 2013 Carlotta Tatti. All rights reserved.
//

#import "PathfindingNode.h"

@implementation PathfindingNode

- (id)initWithPosition:(CGPoint)position {
    self = [super initWithFrame:CGRectMake(position.x * 32 , position.y * 32, 32, 32)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _x = position.x;
        _y = position.y;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
