//
//  NSDictionary+CWAdditions.h
//  SC68 Player
//
//  Created by Fredrik Olsson on 2008-11-13.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (CWAutoboxing)

-(char)charValueForKey:(id)aKey;
-(unsigned char)unsignedCharValueForKey:(id)aKey;
-(short)shortValueForKey:(id)aKey;
-(unsigned short)unsignedShortValueForKey:(id)aKey;
-(int)intValueForKey:(id)aKey;
-(unsigned int)unsignedIntValueForKey:(id)aKey;
-(long)longValueForKey:(id)aKey;
-(unsigned long)unsignedLongValueForKey:(id)aKey;
-(long long)longLongValueForKey:(id)aKey;
-(unsigned long long)unsignedLongLongValueForKey:(id)aKey;
-(float)floatValueForKey:(id)aKey;
-(double)doubleValueForKey:(id)aKey;
-(BOOL)boolValueForKey:(id)aKey;
-(NSInteger)integerValueForKey:(id)aKey;
-(NSUInteger)unsignedIntegerValueForKey:(id)aKey;
-(NSNumber*)numberValueForKey:(id)aKey;
-(NSString*)stringValueForKey:(id)aKey;
-(id)objectForKey:(id)aKey withExpectedClass:(Class)aClass;

@end

@interface NSMutableDictionary (CWAutoboxing)

-(void)setChar:(char)value forKey:(id)aKey;
-(void)setUnsignedChar:(unsigned char)value forKey:(id)aKey;
-(void)setShort:(short)value forKey:(id)aKey;
-(void)setUnsignedShort:(unsigned short)value forKey:(id)aKey;
-(void)setInt:(int)value forKey:(id)aKey;
-(void)setUnsignedInt:(unsigned int)value forKey:(id)aKey;
-(void)setLong:(long)value forKey:(id)aKey;
-(void)setUnsignedLong:(unsigned long)value forKey:(id)aKey;
-(void)setLongLong:(long long)value forKey:(id)aKey;
-(void)setUnsignedLongLong:(unsigned long long)value forKey:(id)aKey;
-(void)setFloat:(float)value forKey:(id)aKey;
-(void)setDouble:(double)value forKey:(id)aKey;
-(void)setBool:(BOOL)value forKey:(id)aKey;
-(void)setInteger:(NSInteger)value forKey:(id)aKey;
-(void)setUnsignedInteger:(NSUInteger)value forKey:(id)aKey;

@end