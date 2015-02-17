//
//  NSArray+CWAdditions.h
//  SC68 Player
//
//  Created by Fredrik Olsson on 2008-11-13.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray (CWAutoboxing)

-(char)charValueAtIndex:(NSUInteger)index;
-(unsigned char)unsignedCharValueAtIndex:(NSUInteger)index;
-(short)shortValueAtIndex:(NSUInteger)index;
-(unsigned short)unsignedShortValueAtIndex:(NSUInteger)index;
-(int)intValueAtIndex:(NSUInteger)index;
-(unsigned int)unsignedIntValueAtIndex:(NSUInteger)index;
-(long)longValueAtIndex:(NSUInteger)index;
-(unsigned long)unsignedLongValueAtIndex:(NSUInteger)index;
-(long long)longLongValueAtIndex:(NSUInteger)index;
-(unsigned long long)unsignedLongLongValueAtIndex:(NSUInteger)index;
-(float)floatValueAtIndex:(NSUInteger)index;
-(double)doubleValueAtIndex:(NSUInteger)index;
-(BOOL)boolValueAtIndex:(NSUInteger)index;
-(NSInteger)integerValueAtIndex:(NSUInteger)index;
-(NSUInteger)unsignedIntegerValueAtIndex:(NSUInteger)index;
-(NSNumber*)numberValueAtIndex:(NSUInteger)index;
-(NSString*)stringValueAtIndex:(NSUInteger)index;
-(id)objectAtIndex:(NSUInteger)index withExpectedClass:(Class)aClass;

@end

@interface NSMutableArray (CWAutoboxing)

-(void)addChar:(char)value;
-(void)addUnsignedChar:(unsigned char)value;
-(void)addShort:(short)value;
-(void)addUnsignedShort:(unsigned short)value;
-(void)addInt:(int)value;
-(void)addUnsignedInt:(unsigned int)value;
-(void)addLong:(long)value;
-(void)addUnsignedLong:(unsigned long)value;
-(void)addLongLong:(long long)value;
-(void)addUnsignedLongLong:(unsigned long long)value;
-(void)addFloat:(float)value;
-(void)addDouble:(double)value;
-(void)addBool:(BOOL)value;
-(void)addInteger:(NSInteger)value;
-(void)addUnsignedInteger:(NSUInteger)value;

-(void)insertChar:(char)value atIndex:(NSUInteger)index;
-(void)insertUnsignedChar:(unsigned char)value atIndex:(NSUInteger)index;
-(void)insertShort:(short)value atIndex:(NSUInteger)index;
-(void)insertUnsignedShort:(unsigned short)value atIndex:(NSUInteger)index;
-(void)insertInt:(int)value atIndex:(NSUInteger)index;
-(void)insertUnsignedInt:(unsigned int)value atIndex:(NSUInteger)index;
-(void)insertLong:(long)value atIndex:(NSUInteger)index;
-(void)insertUnsignedLong:(unsigned long)value atIndex:(NSUInteger)index;
-(void)insertLongLong:(long long)value atIndex:(NSUInteger)index;
-(void)insertUnsignedLongLong:(unsigned long long)value atIndex:(NSUInteger)index;
-(void)insertFloat:(float)value atIndex:(NSUInteger)index;
-(void)insertDouble:(double)value atIndex:(NSUInteger)index;
-(void)insertBool:(BOOL)value atIndex:(NSUInteger)index;
-(void)insertInteger:(NSInteger)value atIndex:(NSUInteger)index;
-(void)insertUnsignedInteger:(NSUInteger)value atIndex:(NSUInteger)index;

-(void)replaceObjectAtIndex:(NSUInteger)index withChar:(char)value;
-(void)replaceObjectAtIndex:(NSUInteger)index withUnsignedChar:(unsigned char)value;
-(void)replaceObjectAtIndex:(NSUInteger)index withShort:(short)value;
-(void)replaceObjectAtIndex:(NSUInteger)index withUnsignedShort:(unsigned short)value;
-(void)replaceObjectAtIndex:(NSUInteger)index withInt:(int)value;
-(void)replaceObjectAtIndex:(NSUInteger)index withUnsignedInt:(unsigned int)value;
-(void)replaceObjectAtIndex:(NSUInteger)index withLong:(long)value;
-(void)replaceObjectAtIndex:(NSUInteger)index withUnsignedLong:(unsigned long)value;
-(void)replaceObjectAtIndex:(NSUInteger)index withLongLong:(long long)value;
-(void)replaceObjectAtIndex:(NSUInteger)index withUnsignedLongLong:(unsigned long long)value;
-(void)replaceObjectAtIndex:(NSUInteger)index withFloat:(float)value;
-(void)replaceObjectAtIndex:(NSUInteger)index withDouble:(double)value;
-(void)replaceObjectAtIndex:(NSUInteger)index withBool:(BOOL)value;
-(void)replaceObjectAtIndex:(NSUInteger)index withInteger:(NSInteger)value;
-(void)replaceObjectAtIndex:(NSUInteger)index withUnsignedInteger:(NSUInteger)value;

@end
