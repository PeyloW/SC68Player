//
//  CWFavouritesButton.m
//  SC68 Player
//
//  Created by Fredrik Olsson on 2008-11-11.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CWFavouritesButton.h"
#import <objc/runtime.h>

@implementation CWFavouritesButton

+(CWFavouritesButton*)favouritesButtonWithTarget:(id)target action:(SEL)action;
{
	CWFavouritesButton* button = [self buttonWithType:UIButtonTypeCustom];
	if (button) {
	  [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
  	button.frame = CGRectMake(0, 0, 29, 31);
    button.backgroundColor = [UIColor clearColor];
    [button setImage:[UIImage imageNamed:@"star-deselected.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"star-selected.png"] forState:UIControlStateSelected];
  }
  return button;
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event;
{
	CGRect bounds = self.bounds;
  bounds = CGRectInset(bounds, -32, 0);
  return CGRectContainsPoint(bounds, point);
}

@end
