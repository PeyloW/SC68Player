//
//  UIColor+EditableTextColor.m
//  Skanetrafiken
//
//  Created by Fredrik Olsson on 2008-07-22.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "UIColor+EditableTextColor.h"


static UIColor* editableTextColor = nil;

@implementation UIColor (EditableTextColor)

+(UIColor*)editableTextColor;
{
	if (!editableTextColor) {
		editableTextColor = [[UIColor alloc] initWithRed:50.0/255.0 green:79.0/255.0 blue:133.0/255.0 alpha:1.0];
	}
	return editableTextColor;
}

@end
