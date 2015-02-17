//
//  NSArray+CWMapping.h
//  SC68 Player
//
//  Created by Fredrik Olsson on 2008-11-13.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NSArray (CWMapping)

-(NSArray*)resultsFromMakingObjectsPerformSelector:(SEL)aSelector;
-(NSArray*)resultsFromMakingObjectsPerformSelector:(SEL)aSelector withObject:(id)anObject;
-(NSArray*)resultsFromMakingObjectsPerformSelector:(SEL)aSelector withObject:(id)anObject withObject:(id)anotherObject;

@end
