//
//  NSArray+CWMapping.m
//  SC68 Player
//
//  Created by Fredrik Olsson on 2008-11-13.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NSArray+CWMapping.h"


@implementation NSArray (CWMapping)

-(NSArray*)resultsFromMakingObjectsPerformSelector:(SEL)aSelector;
{
	NSMutableArray* results = [NSMutableArray arrayWithCapacity:[self count]];
  for (id<NSObject>member in self) {
  	id result = [member performSelector:aSelector];
    if (result == nil) {
    	result = [NSNull null];
    }
    [results addObject:result];
  }
	return [[results copy] autorelease];
}


-(NSArray*)resultsFromMakingObjectsPerformSelector:(SEL)aSelector withObject:(id)anObject;
{
	NSMutableArray* results = [NSMutableArray arrayWithCapacity:[self count]];
  for (id<NSObject>member in self) {
  	id result = [member performSelector:aSelector withObject:anObject];
    if (result == nil) {
    	result = [NSNull null];
    }
    [results addObject:result];
  }
	return [[results copy] autorelease];
}

-(NSArray*)resultsFromMakingObjectsPerformSelector:(SEL)aSelector withObject:(id)anObject withObject:(id)anotherObject;
{
	NSMutableArray* results = [NSMutableArray arrayWithCapacity:[self count]];
  for (id<NSObject>member in self) {
  	id result = [member performSelector:aSelector withObject:anObject withObject:anotherObject];
    if (result == nil) {
    	result = [NSNull null];
    }
    [results addObject:result];
  }
	return [[results copy] autorelease];
}

@end
