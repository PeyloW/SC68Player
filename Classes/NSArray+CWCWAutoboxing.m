//
//  NSArray+CWAdditions.m
//  SC68 Player
//
//  Created by Fredrik Olsson on 2008-11-13.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NSArray+CWAutoboxing.h"


@implementation NSArray (CWAutoboxing)

-(char)charValueAtIndex:(NSUInteger)index;
{
	NSNumber* number = [self objectAtIndex:index withExpectedClass:[NSNumber class]];
  if (number) {
  	return [number charValue];
  }
  return 0;
}

-(unsigned char)unsignedCharValueAtIndex:(NSUInteger)index;
{
	NSNumber* number = [self objectAtIndex:index withExpectedClass:[NSNumber class]];
  if (number) {
  	return [number unsignedCharValue];
  }
  return 0;
}

-(short)shortValueAtIndex:(NSUInteger)index;
{
	NSNumber* number = [self objectAtIndex:index withExpectedClass:[NSNumber class]];
  if (number) {
  	return [number shortValue];
  }
  return 0;
}

-(unsigned short)unsignedShortValueAtIndex:(NSUInteger)index;
{
	NSNumber* number = [self objectAtIndex:index withExpectedClass:[NSNumber class]];
  if (number) {
  	return [number unsignedShortValue];
  }
  return 0;
}

-(int)intValueAtIndex:(NSUInteger)index;
{
	NSNumber* number = [self objectAtIndex:index withExpectedClass:[NSNumber class]];
  if (number) {
  	return [number intValue];
  }
  return 0;
}

-(unsigned int)unsignedIntValueAtIndex:(NSUInteger)index;
{
	NSNumber* number = [self objectAtIndex:index withExpectedClass:[NSNumber class]];
  if (number) {
  	return [number unsignedIntValue];
  }
  return 0;
}

-(long)longValueAtIndex:(NSUInteger)index;
{
	NSNumber* number = [self objectAtIndex:index withExpectedClass:[NSNumber class]];
  if (number) {
  	return [number longValue];
  }
  return 0;
}

-(unsigned long)unsignedLongValueAtIndex:(NSUInteger)index;
{
	NSNumber* number = [self objectAtIndex:index withExpectedClass:[NSNumber class]];
  if (number) {
  	return [number unsignedLongValue];
  }
  return 0;
}

-(long long)longLongValueAtIndex:(NSUInteger)index;
{
	NSNumber* number = [self objectAtIndex:index withExpectedClass:[NSNumber class]];
  if (number) {
  	return [number longLongValue];
  }
  return 0;
}

-(unsigned long long)unsignedLongLongValueAtIndex:(NSUInteger)index;
{
	NSNumber* number = [self objectAtIndex:index withExpectedClass:[NSNumber class]];
  if (number) {
  	return [number unsignedLongLongValue];
  }
  return 0;
}

-(float)floatValueAtIndex:(NSUInteger)index;
{
	NSNumber* number = [self objectAtIndex:index withExpectedClass:[NSNumber class]];
  if (number) {
  	return [number floatValue];
  }
  return 0;
}

-(double)doubleValueAtIndex:(NSUInteger)index;
{
	NSNumber* number = [self objectAtIndex:index withExpectedClass:[NSNumber class]];
  if (number) {
  	return [number doubleValue];
  }
  return 0;
}

-(BOOL)boolValueAtIndex:(NSUInteger)index;
{
	NSNumber* number = [self objectAtIndex:index withExpectedClass:[NSNumber class]];
  if (number) {
  	return [number boolValue];
  }
  return NO;
}

-(NSInteger)integerValueAtIndex:(NSUInteger)index;
{
	NSNumber* number = [self objectAtIndex:index withExpectedClass:[NSNumber class]];
  if (number) {
  	return [number integerValue];
  }
  return 0;
}

-(NSUInteger)unsignedIntegerValueAtIndex:(NSUInteger)index;
{
	NSNumber* number = [self objectAtIndex:index withExpectedClass:[NSNumber class]];
  if (number) {
  	return [number unsignedIntegerValue];
  }
  return 0;
}

-(NSNumber*)numberValueAtIndex:(NSUInteger)index;
{
	return [self objectAtIndex:index withExpectedClass:[NSNumber class]];
}

-(NSString*)stringValueAtIndex:(NSUInteger)index;
{
	return [self objectAtIndex:index withExpectedClass:[NSString class]];
}

-(id)objectAtIndex:(NSUInteger)index withExpectedClass:(Class)aClass;
{
	id<NSObject> anObject = (id<NSObject>)[self objectAtIndex:index];
  if (anObject) {
  	if (![anObject isKindOfClass:aClass]) {
    	[NSException raise:NSInternalInconsistencyException format:@"Expected %@ instance, found %@", NSStringFromClass(aClass), NSStringFromClass([anObject class])];
    }
  }
  return anObject;
}

@end

@implementation NSMutableArray (CWAutoboxing)

-(void)addChar:(char)value;
{
	[self addObject:[NSNumber numberWithChar:value]];
}

-(void)addUnsignedChar:(unsigned char)value;
{
	[self addObject:[NSNumber numberWithUnsignedChar:value]];
}

-(void)addShort:(short)value;
{
	[self addObject:[NSNumber numberWithShort:value]];
}

-(void)addUnsignedShort:(unsigned short)value;
{
	[self addObject:[NSNumber numberWithUnsignedShort:value]];
}

-(void)addInt:(int)value;
{
	[self addObject:[NSNumber numberWithInt:value]];
}

-(void)addUnsignedInt:(unsigned int)value;
{
	[self addObject:[NSNumber numberWithUnsignedInt:value]];
}

-(void)addLong:(long)value;
{
	[self addObject:[NSNumber numberWithLong:value]];
}

-(void)addUnsignedLong:(unsigned long)value;
{
	[self addObject:[NSNumber numberWithUnsignedLong:value]];
}

-(void)addLongLong:(long long)value;
{
	[self addObject:[NSNumber numberWithLongLong:value]];
}

-(void)addUnsignedLongLong:(unsigned long long)value;
{
	[self addObject:[NSNumber numberWithUnsignedLongLong:value]];
}

-(void)addFloat:(float)value;
{
	[self addObject:[NSNumber numberWithFloat:value]];
}

-(void)addDouble:(double)value;
{
	[self addObject:[NSNumber numberWithDouble:value]];
}

-(void)addBool:(BOOL)value;
{
	[self addObject:[NSNumber numberWithBool:value]];
}

-(void)addInteger:(NSInteger)value;
{
	[self addObject:[NSNumber numberWithInteger:value]];
}

-(void)addUnsignedInteger:(NSUInteger)value;
{
	[self addObject:[NSNumber numberWithUnsignedInteger:value]];
}

-(void)insertChar:(char)value atIndex:(NSUInteger)index;
{
	[self insertObject:[NSNumber numberWithChar:value] atIndex:index];
}

-(void)insertUnsignedChar:(unsigned char)value atIndex:(NSUInteger)index;
{
	[self insertObject:[NSNumber numberWithUnsignedChar:value] atIndex:index];
}

-(void)insertShort:(short)value atIndex:(NSUInteger)index;
{
	[self insertObject:[NSNumber numberWithShort:value] atIndex:index];
}

-(void)insertUnsignedShort:(unsigned short)value atIndex:(NSUInteger)index;
{
	[self insertObject:[NSNumber numberWithUnsignedShort:value] atIndex:index];
}

-(void)insertInt:(int)value atIndex:(NSUInteger)index;
{
	[self insertObject:[NSNumber numberWithInt:value] atIndex:index];
}

-(void)insertUnsignedInt:(unsigned int)value atIndex:(NSUInteger)index;
{
	[self insertObject:[NSNumber numberWithUnsignedInt:value] atIndex:index];
}

-(void)insertLong:(long)value atIndex:(NSUInteger)index;
{
	[self insertObject:[NSNumber numberWithLong:value] atIndex:index];
}

-(void)insertUnsignedLong:(unsigned long)value atIndex:(NSUInteger)index;
{
	[self insertObject:[NSNumber numberWithUnsignedLong:value] atIndex:index];
}

-(void)insertLongLong:(long long)value atIndex:(NSUInteger)index;
{
	[self insertObject:[NSNumber numberWithLongLong:value] atIndex:index];
}

-(void)insertUnsignedLongLong:(unsigned long long)value atIndex:(NSUInteger)index;
{
	[self insertObject:[NSNumber numberWithUnsignedLongLong:value] atIndex:index];
}

-(void)insertFloat:(float)value atIndex:(NSUInteger)index;
{
	[self insertObject:[NSNumber numberWithFloat:value] atIndex:index];
}

-(void)insertDouble:(double)value atIndex:(NSUInteger)index;
{
	[self insertObject:[NSNumber numberWithDouble:value] atIndex:index];
}

-(void)insertBool:(BOOL)value atIndex:(NSUInteger)index;
{
	[self insertObject:[NSNumber numberWithBool:value] atIndex:index];
}

-(void)insertInteger:(NSInteger)value atIndex:(NSUInteger)index;
{
	[self insertObject:[NSNumber numberWithInteger:value] atIndex:index];
}

-(void)insertUnsignedInteger:(NSUInteger)value atIndex:(NSUInteger)index;
{
	[self insertObject:[NSNumber numberWithUnsignedInteger:value] atIndex:index];
}

-(void)replaceObjectAtIndex:(NSUInteger)index withChar:(char)value;
{
	[self replaceObjectAtIndex:index withObject:[NSNumber numberWithChar:value]];
}

-(void)replaceObjectAtIndex:(NSUInteger)index withUnsignedChar:(unsigned char)value;
{
	[self replaceObjectAtIndex:index withObject:[NSNumber numberWithUnsignedChar:value]];
}

-(void)replaceObjectAtIndex:(NSUInteger)index withShort:(short)value;
{
	[self replaceObjectAtIndex:index withObject:[NSNumber numberWithShort:value]];
}

-(void)replaceObjectAtIndex:(NSUInteger)index withUnsignedShort:(unsigned short)value;
{
	[self replaceObjectAtIndex:index withObject:[NSNumber numberWithUnsignedShort:value]];
}

-(void)replaceObjectAtIndex:(NSUInteger)index withInt:(int)value;
{
	[self replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:value]];
}

-(void)replaceObjectAtIndex:(NSUInteger)index withUnsignedInt:(unsigned int)value;
{
	[self replaceObjectAtIndex:index withObject:[NSNumber numberWithUnsignedInt:value]];
}

-(void)replaceObjectAtIndex:(NSUInteger)index withLong:(long)value;
{
	[self replaceObjectAtIndex:index withObject:[NSNumber numberWithLong:value]];
}

-(void)replaceObjectAtIndex:(NSUInteger)index withUnsignedLong:(unsigned long)value;
{
	[self replaceObjectAtIndex:index withObject:[NSNumber numberWithUnsignedLong:value]];
}

-(void)replaceObjectAtIndex:(NSUInteger)index withLongLong:(long long)value;
{
	[self replaceObjectAtIndex:index withObject:[NSNumber numberWithLongLong:value]];
}

-(void)replaceObjectAtIndex:(NSUInteger)index withUnsignedLongLong:(unsigned long long)value;
{
	[self replaceObjectAtIndex:index withObject:[NSNumber numberWithUnsignedLongLong:value]];
}

-(void)replaceObjectAtIndex:(NSUInteger)index withFloat:(float)value;
{
	[self replaceObjectAtIndex:index withObject:[NSNumber numberWithFloat:value]];
}

-(void)replaceObjectAtIndex:(NSUInteger)index withDouble:(double)value;
{
	[self replaceObjectAtIndex:index withObject:[NSNumber numberWithDouble:value]];
}

-(void)replaceObjectAtIndex:(NSUInteger)index withBool:(BOOL)value;
{
	[self replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:value]];
}

-(void)replaceObjectAtIndex:(NSUInteger)index withInteger:(NSInteger)value;
{
	[self replaceObjectAtIndex:index withObject:[NSNumber numberWithInteger:value]];
}

-(void)replaceObjectAtIndex:(NSUInteger)index withUnsignedInteger:(NSUInteger)value;
{
	[self replaceObjectAtIndex:index withObject:[NSNumber numberWithUnsignedInteger:value]];
}

@end
