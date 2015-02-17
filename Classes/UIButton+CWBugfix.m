//
//  UIButton+CWBugfix.m
//  SC68 Player
//
//  Created by Fredrik Olsson on 2008-12-17.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "UIButton+CWBugfix.h"
#import <objc/runtime.h>

@implementation UIButton (CWBugfix)

+(void)load;
{
	Method oldMethod = class_getClassMethod(self, @selector(buttonWithType:));
  Method newMethod = class_getClassMethod(self, @selector(__buttonWithType:));
	method_exchangeImplementations(oldMethod, newMethod);
}

+(UIButton*)__buttonWithType:(UIButtonType)type;
{
	// Calling new by name will call the old implementation.
	UIButton* button = [self __buttonWithType:type];
	if (button && [button class] != self) {
		size_t oldSize = class_getInstanceSize([button class]);
    size_t newSize = class_getInstanceSize(self);
    button->isa = self;
    if (oldSize < newSize) {
 			UIButton* newButton = [self alloc];
      memcpy(newButton, button, oldSize);
      button = [newButton autorelease];
    }
  }
  return button;
}

@end
