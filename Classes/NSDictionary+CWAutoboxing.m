//
//  NSDictionary+CWAdditions.m
//  SC68 Player
//
//  Created by Fredrik Olsson on 2008-11-13.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+CWAutoboxing.h"


@implementation NSDictionary (CWAutoboxing)

-(char)charValueForKey:(id)aKey;
{
	NSNumber* number = [self objectForKey:aKey withExpectedClass:[NSNumber class]];
  if (number) {
  	return [number charValue];
  }
  return 0;
}

-(unsigned char)unsignedCharValueForKey:(id)aKey;
{
	NSNumber* number = [self objectForKey:aKey withExpectedClass:[NSNumber class]];
  if (number) {
  	return [number unsignedCharValue];
  }
  return 0;
}

-(short)shortValueForKey:(id)aKey;
{
	NSNumber* number = [self objectForKey:aKey withExpectedClass:[NSNumber class]];
  if (number) {
  	return [number shortValue];
  }
  return 0;
}

-(unsigned short)unsignedShortValueForKey:(id)aKey;
{
	NSNumber* number = [self objectForKey:aKey withExpectedClass:[NSNumber class]];
  if (number) {
  	return [number unsignedShortValue];
  }
  return 0;
}

-(int)intValueForKey:(id)aKey;
{
	NSNumber* number = [self objectForKey:aKey withExpectedClass:[NSNumber class]];
  if (number) {
  	return [number intValue];
  }
  return 0;
}

-(unsigned int)unsignedIntValueForKey:(id)aKey;
{
	NSNumber* number = [self objectForKey:aKey withExpectedClass:[NSNumber class]];
  if (number) {
  	return [number unsignedIntValue];
  }
  return 0;
}

-(long)longValueForKey:(id)aKey;
{
	NSNumber* number = [self objectForKey:aKey withExpectedClass:[NSNumber class]];
  if (number) {
  	return [number longValue];
  }
  return 0;
}

-(unsigned long)unsignedLongValueForKey:(id)aKey;
{
	NSNumber* number = [self objectForKey:aKey withExpectedClass:[NSNumber class]];
  if (number) {
  	return [number unsignedLongValue];
  }
  return 0;
}

-(long long)longLongValueForKey:(id)aKey;
{
	NSNumber* number = [self objectForKey:aKey withExpectedClass:[NSNumber class]];
  if (number) {
  	return [number longLongValue];
  }
  return 0;
}

-(unsigned long long)unsignedLongLongValueForKey:(id)aKey;
{
	NSNumber* number = [self objectForKey:aKey withExpectedClass:[NSNumber class]];
  if (number) {
  	return [number unsignedLongLongValue];
  }
  return 0;
}

-(float)floatValueForKey:(id)aKey;
{
	NSNumber* number = [self objectForKey:aKey withExpectedClass:[NSNumber class]];
  if (number) {
  	return [number floatValue];
  }
  return 0;
}

-(double)doubleValueForKey:(id)aKey;
{
	NSNumber* number = [self objectForKey:aKey withExpectedClass:[NSNumber class]];
  if (number) {
  	return [number doubleValue];
  }
  return 0;
}

-(BOOL)boolValueForKey:(id)aKey;
{
	NSNumber* number = [self objectForKey:aKey withExpectedClass:[NSNumber class]];
  if (number) {
  	return [number boolValue];
  }
  return NO;
}

-(NSInteger)integerValueForKey:(id)aKey;
{
	NSNumber* number = [self objectForKey:aKey withExpectedClass:[NSNumber class]];
  if (number) {
  	return [number integerValue];
  }
  return 0;
}

-(NSUInteger)unsignedIntegerValueForKey:(id)aKey;
{
	NSNumber* number = [self objectForKey:aKey withExpectedClass:[NSNumber class]];
  if (number) {
  	return [number unsignedIntegerValue];
  }
  return 0;
}

-(NSNumber*)numberValueForKey:(id)aKey;
{
	return [self objectForKey:aKey withExpectedClass:[NSNumber class]];
}

-(NSString*)stringValueForKey:(id)aKey;
{
	return [self objectForKey:aKey withExpectedClass:[NSString class]];
}

-(id)objectForKey:(id)aKey withExpectedClass:(Class)aClass;
{
	id<NSObject> anObject = (id<NSObject>)[self objectForKey:aKey];
  if (anObject) {
  	if (![anObject isKindOfClass:aClass]) {
    	[NSException raise:NSInternalInconsistencyException format:@"Expected %@ instance, found %@", NSStringFromClass(aClass), NSStringFromClass([anObject class])];
    }
  }
  return anObject;
}


@end

@implementation NSMutableDictionary (CWAutoboxing)

-(void)setChar:(char)value forKey:(id)aKey;
{
	[self setObject:[NSNumber numberWithChar:value] forKey:aKey];
}

-(void)setUnsignedChar:(unsigned char)value forKey:(id)aKey;
{
	[self setObject:[NSNumber numberWithUnsignedChar:value] forKey:aKey];
}

-(void)setShort:(short)value forKey:(id)aKey;
{
	[self setObject:[NSNumber numberWithShort:value] forKey:aKey];
}

-(void)setUnsignedShort:(unsigned short)value forKey:(id)aKey;
{
	[self setObject:[NSNumber numberWithUnsignedShort:value] forKey:aKey];
}

-(void)setInt:(int)value forKey:(id)aKey;
{
	[self setObject:[NSNumber numberWithInt:value] forKey:aKey];
}

-(void)setUnsignedInt:(unsigned int)value forKey:(id)aKey;
{
	[self setObject:[NSNumber numberWithUnsignedInt:value] forKey:aKey];
}

-(void)setLong:(long)value forKey:(id)aKey;
{
	[self setObject:[NSNumber numberWithLong:value] forKey:aKey];
}

-(void)setUnsignedLong:(unsigned long)value forKey:(id)aKey;
{
	[self setObject:[NSNumber numberWithUnsignedLong:value] forKey:aKey];
}

-(void)setLongLong:(long long)value forKey:(id)aKey;
{
	[self setObject:[NSNumber numberWithLongLong:value] forKey:aKey];
}

-(void)setUnsignedLongLong:(unsigned long long)value forKey:(id)aKey;
{
	[self setObject:[NSNumber numberWithUnsignedLongLong:value] forKey:aKey];
}

-(void)setFloat:(float)value forKey:(id)aKey;
{
	[self setObject:[NSNumber numberWithFloat:value] forKey:aKey];
}

-(void)setDouble:(double)value forKey:(id)aKey;
{
	[self setObject:[NSNumber numberWithDouble:value] forKey:aKey];
}

-(void)setBool:(BOOL)value forKey:(id)aKey;
{
	[self setObject:[NSNumber numberWithBool:value] forKey:aKey];
}

-(void)setInteger:(NSInteger)value forKey:(id)aKey;
{
	[self setObject:[NSNumber numberWithInteger:value] forKey:aKey];
}

-(void)setUnsignedInteger:(NSUInteger)value forKey:(id)aKey;
{
	[self setObject:[NSNumber numberWithUnsignedInteger:value] forKey:aKey];
}


@end