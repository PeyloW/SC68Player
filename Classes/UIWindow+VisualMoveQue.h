//
//  UIWindow+VisualMoveQue.h
//  SC68 Player
//
//  Created by Fredrik Olsson on 2008-11-10.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIWindow (VisualMoveQue)

-(void)displayVisualQueForMovingView:(UIView*)fromView fromRect:(CGRect)fromRect toRect:(CGRect)toRect;

@end
