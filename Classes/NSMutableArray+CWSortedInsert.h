//
//  NSMutableArray+CWSortedInsert.h
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

#import <Foundation/Foundation.h>


@interface NSMutableArray (CWSortedInsert)

/*!
 * @abstract Insert an object into the mutable array at a sorted position determined by an array of descriptors. 
 *
 * The first descriptor specifies the primary key path to be used in sorting the receiver’s contents. Any subsequent 
 * descriptors are used to further refine sorting of objects with duplicate values. 
 * See NSSortDescriptor for additional information.
 * 
 * @param anObject The object to add to the receiver's content. This value must not be nil.
 * @param descriptors An array of NSSortDescriptor objects.
 * @result The index where anObject has been inserted.
 */
-(NSInteger)insertObject:(id)anObject sortedUsingDescriptors:(NSArray*)descriptors;

/*!
 * Insert an object into the mutable array at a sorted position determined by the comparison method specified by a given selector.
 * 
 * @param anObject The object to add to the receiver's content. This value must not be nil.
 * @param comparator A selector that specifies the comparison method to use to compare elements in the receiver.
 *        The comparator message is sent to each object in the receiver and has as its single argument anObject.
 * @result The index where anObject has been inserted.
 */
-(NSInteger)insertObject:(id)anObject sortedUsingSelector:(SEL)comparator;

@end
