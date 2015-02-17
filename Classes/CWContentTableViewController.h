//
//  CWContentTableViewController.h
//  SC68 Player
//
//  Created by Fredrik Olsson on 2008-10-29.
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


@protocol CWContentTableViewControllerDataSource;

/*!
 * @abstract A CWContentTableViewController manages a table view with automatic content filter and/or grouping.
 *
 * The resulting table view is similiar to the built in Contacts application.
 */
@interface CWContentTableViewController : UITableViewController {
@protected
	id<CWContentTableViewControllerDataSource> _contentDataSource;
  NSInteger totalCount;
  NSInteger _sectionThreshold;
  BOOL _hiddenIndex;
  NSString* _currentFilter;
  BOOL hasTabBar;
	BOOL isSearching;
  UISearchBar* _searchBar;
  NSMutableArray* _tableData;
	IMP objectAtIndex;
  IMP cellForObject;
  IMP objectMatchesFilter;
  IMP keyForObject;
}

/*!
 * @abstract The object that acts as the data source for the receiving content table view controller.
 */
@property(nonatomic, assign) id<CWContentTableViewControllerDataSource> contentDataSource;

/*!
 * @abstract The threshold count for number of object before section headers and index is used. Default is 0, allways shows sections headers.
 */
@property(nonatomic, assign) NSInteger sectionThreshold;

/*!
 * @abstract Should the index be shown.
 */
@property(nonatomic, assign, getter=isHiddenIndex) BOOL hiddenIndex;

/*!
 * @abstract Is the content filtered.
 */
@property(nonatomic, retain, readonly) NSString* currentFilter;

/*!
 * @abstract
 */
@property(nonatomic, copy) NSString* searchBarPlaceholder;

/*!
 * @abstract
 */
-(BOOL)shouldDisplayIndex;

/*!
 * @abstract Invalidate table data.
 */
-(void)invalidateTableData;

/*!
 * @abstract Invalidate table data, and force a relead.
 */
-(void)invalidateAndReloadTableData;

/*!
 * @abstract Get the object acting as content for a row at index path.
 *
 * @param indexPath An index path.
 * @result An object.
 */
-(id)objectForIndexPath:(NSIndexPath*)indexPath;

@end


/*!
 * @abstract The CWContentTableViewControllerDataSource protocol is implemented by an object that mediates as the
 * 					 model for a content table view controller.
 */ 
@protocol CWContentTableViewControllerDataSource <NSObject>
@required

/*!
 * @abstract Asks the data source to return the total number of objects in the model.
 * 
 * @param controller The sender.
 * @result The total number of objects.
 */
-(NSInteger)numberOfObjectsForContentTableViewController:(CWContentTableViewController*)controller;

/*!
 * @abstract Asks the data source for the object at index from the data source. 
 *					 If grouping is to be used the objects must be sorted.
 *
 * @param controller The sender.
 * @param index Index of object.
 * @result The object at index.
 */
-(id)contentTableViewController:(CWContentTableViewController*)controller objectAtIndex:(NSInteger)index;

/*!
 * @abstract Asks the data source for a cell to insert for a particular object in the table view.
 * 
 * @param controller The sender.
 * @param anObject An object.
 * @result An object inheriting from UITableViewCell that the table view can use for the specified row.
 */
-(UITableViewCell*)contentTableViewController:(CWContentTableViewController*)controller cellForObject:(id)anObject;

/*!
 * @abstract Informs the data source that the user has selected a row with an object.
 *
 * @param controller The sender.
 * @param anObject An object.
 * @param indexPath The current index path of the selected object.
 */
-(void)contentTableViewController:(CWContentTableViewController*)controller didSelectObject:(id)anObject withIndexPath:(NSIndexPath*)indexPath;

@optional

/*!
 * @abstract Asks the data source if an object matches the current string filter. This method is optional.
 *					 A search bar will not be displayed in the table view if the data source do not implement this method.
 *
 * @param controller The sender.
 * @param anObject An object.
 * @param filter A string filter.
 * @result YES if an object matches the string filter and should be displayed.
 */
-(BOOL)contentTableViewController:(CWContentTableViewController*)controller object:(id)anObject matchesFilter:(NSString*)filter;

/*!
 * @abstract Asks the data source for a key string representing the an object. All objects witht he same key will
 *           be grouped in the same section. Objects in the model must be sorted. Key must not be nil.
 *					 This method is optional.
 *
 * @param controller The sender.
 * @param anObject An object.
 * @result A string key.
 */
-(NSString*)contentTableViewController:(CWContentTableViewController*)controller keyForObject:(id)anObject;

/*!
 * @param Informs the data source that processing of the model has finished.
 *
 * @param controller The sender.
 * @param displayCount Number of objects that are being displayed.
 * @param totalCount Total number of objects in model. 
 */
-(void)contentTableViewController:(CWContentTableViewController*)controller didGather:(NSInteger)displayCount objectsOf:(NSInteger)totalCount;

@end
