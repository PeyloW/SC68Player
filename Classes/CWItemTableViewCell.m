//
//  CWItemTableViewCell.m
//
//  Created by Fredrik Olsson on 2008-07-22.
//  Copyright 2008 Jayway AB. All rights reserved.
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License. 
//  You may obtain a copy of the License at 
// 
//  http://www.apache.org/licenses/LICENSE-2.0 
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS, 
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "CWItemTableViewCell.h"
#import "UIColor+EditableTextColor.h"

@implementation CWItemTableViewCell

@synthesize label;
@synthesize ignoreSelect = _ignoreSelect;


-(void)setEditing:(BOOL)editing animated:(BOOL)animated;
{
	if (animated) {
  	[UIView beginAnimations:@"beginEdit" context:NULL];
  }
	label.alpha = editing ? 0.0 : 1.0;
	if (animated) {
  	[UIView commitAnimations];
  }
	[super setEditing:editing animated:animated];
}

-(NSString*)itemText;
{
	return label.text;
}

-(void)setItemText:(NSString*)itemText;
{
	label.text = itemText;
}

-(UIColor*)itemTextColor;
{
	return label.textColor;
}

-(void)setItemTextColor:(UIColor*)itemTextColor;
{
	label.textColor = itemTextColor;
}


- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		label = [[UILabel alloc] initWithFrame:CGRectZero];
    [label setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
    label.textAlignment = UITextAlignmentRight;
    label.adjustsFontSizeToFitWidth = YES;
    label.textColor = [UIColor editableTextColor];
    label.highlightedTextColor = [UIColor whiteColor];
    [self addSubview:label];
    label.text = nil;
    [label release];
	}
	return self;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated;
{
	if (self.ignoreSelect == NO) {
  	[super setSelected:selected animated:animated];
  }
}

- (void)layoutSubviews;
{
	[super layoutSubviews];
  [label sizeToFit];
  CGFloat width = label.frame.size.width;
  CGRect frame = CGRectMake(CGRectGetMaxX(self.contentView.bounds) - width - 5.0, 6.0, width, 32.0);
	label.frame = frame;
}

- (void)dealloc {
	[super dealloc];
}


@end
