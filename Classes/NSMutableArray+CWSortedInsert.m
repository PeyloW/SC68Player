//
//  NSMutableArray+CWSortedInsert.m
//
//  Created by Fredrik Olsson on 2008-10-14.
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

#import "NSMutableArray+CWSortedInsert.h"


@implementation NSMutableArray (CWSortedInsert)

-(NSInteger)insertObject:(id)anObject sortedUsingDescriptors:(NSArray*)descriptors;
{
	if ([descriptors count] == 0) {
  	[NSException raise:NSInvalidArgumentException format:@"Must have at least one sort descriptor."];
  }
	NSInteger index = 0;
  for (; index < [self count]; index++) {
  	id<NSObject> currentObject = [self objectAtIndex:index];
		for (NSSortDescriptor* sortDescriptor in descriptors) {
      NSComparisonResult result = [sortDescriptor compareObject:currentObject toObject:anObject];
      switch (result) {
      	case NSOrderedAscending:
        	goto impossiblePosition;
				case NSOrderedDescending:
	        goto foundPosition;
      }
		}
impossiblePosition:;
  }
foundPosition:
  [self insertObject:anObject atIndex:index];
  return index;
}

-(NSInteger)insertObject:(id)anObject sortedUsingSelector:(SEL)comparator;
{
	NSInteger index = 0;
  for (; index < [self count]; index++) {
  	id<NSObject> currentObject = [self objectAtIndex:index];
		NSComparisonResult result = (NSComparisonResult)[currentObject performSelector:comparator withObject:anObject];
    if (result > NSOrderedSame) {
    	goto foundPosition;
    }
  }
foundPosition:
  [self insertObject:anObject atIndex:index];
  return index;
}

@end
