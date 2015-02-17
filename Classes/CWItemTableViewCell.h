//
//  CWItemTableViewCell.h
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

#import <UIKit/UIKit.h>


@interface CWItemTableViewCell : UITableViewCell {
	UILabel* label;
  BOOL _ignoreSelect;
}

@property(retain, readonly, nonatomic) UILabel* label;
@property(retain, nonatomic) NSString* itemText;
@property(retain, nonatomic) UIColor* itemTextColor; 
@property(nonatomic, assign) BOOL ignoreSelect;

@end
