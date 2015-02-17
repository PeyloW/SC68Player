//
//  CWContentTableViewController.m
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

#import "CWContentTableViewController.h"

#define INDEX_KEY 0
#define INDEX_DATA 1

@interface CWContentTableViewController () <UISearchBarDelegate>

@property(nonatomic, retain, readonly) UISearchBar* searchBar;
@property(nonatomic, retain) NSMutableArray* tableData;
@property(nonatomic, retain) NSString* currentFilter;

-(NSMutableArray*)dataForSection:(NSInteger)section;
-(NSMutableArray*)newTableData;

@end


@implementation CWContentTableViewController

#pragma mark --- Properties

@dynamic contentDataSource;
@synthesize sectionThreshold = _sectionThreshold;
@synthesize hiddenIndex = _hiddenIndex;
@synthesize currentFilter = _currentFilter;

@dynamic searchBarPlaceholder;

-(NSString*)searchBarPlaceholder;
{
	return self.searchBar.placeholder;
}

-(void)setSearchBarPlaceholder:(NSString*)placeholder;
{
	self.searchBar.placeholder = placeholder;
}

-(id<CWContentTableViewControllerDataSource>)contentDataSource;
{
	return _contentDataSource;
}

-(void)setContentDataSource:(id<CWContentTableViewControllerDataSource>)dataSource;
{
  objectAtIndex = NULL;
  cellForObject = NULL;
  objectMatchesFilter = NULL;
  keyForObject = NULL;
	if (dataSource) {
		objectAtIndex = [(NSObject*)dataSource methodForSelector:@selector(contentTableViewController:objectAtIndex:)];
    cellForObject = [(NSObject*)dataSource methodForSelector:@selector(contentTableViewController:cellForObject:)];
		if ([dataSource respondsToSelector:@selector(contentTableViewController:object:matchesFilter:)]) {
	    objectMatchesFilter = [(NSObject*)dataSource methodForSelector:@selector(contentTableViewController:object:matchesFilter:)];
 		}
		if ([dataSource respondsToSelector:@selector(contentTableViewController:keyForObject:)]) {
    	keyForObject = [(NSObject*)dataSource methodForSelector:@selector(contentTableViewController:keyForObject:)];
    }
  } else {
    if (_searchBar) {
      [_searchBar release];
      _searchBar = nil;
    }
  }
  _contentDataSource = dataSource;  
}

@dynamic searchBar;

-(UISearchBar*)searchBar;
{
	if (_searchBar == nil) {
    if (_searchBar == nil) {
    	_searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
      _searchBar.delegate = self;
      _searchBar.tintColor = [UIColor lightGrayColor];
    }
  }
  return _searchBar;
}

@dynamic tableData;

-(NSMutableArray*)tableData;
{
	if (_tableData == nil) {
		_tableData = [self newTableData];
  }
  return _tableData;
}

-(void)setTableData:(NSMutableArray*)data;
{
	if (_tableData != data) {
    if (_tableData) {
      [_tableData release];
    }
    if (data) {
      [data retain];
    }
    _tableData = data;
	}
}


#pragma mark --- Life cycle

-(id)initWithStyle:(UITableViewStyle)style;
{
	self = [super initWithStyle:style];
  if (self) {
  	self.sectionThreshold = 20;
  }
  return self;
}

-(void)viewDidLoad;
{
	[super viewDidLoad];
  hasTabBar = (self.tabBarController != nil);
  if (objectMatchesFilter != NULL) {
  	self.tableView.tableHeaderView = self.searchBar;
  }
}

-(void)dealloc;
{
	self.contentDataSource = nil;
  self.tableData = nil;
	[super dealloc];
}

#pragma mark --- Public methods

-(BOOL)shouldDisplayIndex;
{
	return !(self.hiddenIndex || totalCount < self.sectionThreshold || (_searchBar && [_searchBar isFirstResponder]));
}

-(void)invalidateTableData;
{
	self.tableData = nil;
}

-(void)invalidateAndReloadTableData;
{
	[self invalidateTableData];
  [self.tableView reloadData];
}

-(id)objectForIndexPath:(NSIndexPath*)indexPath;
{
	return [[self dataForSection:indexPath.section] objectAtIndex:indexPath.row];
}

#pragma mark --- Data source helpers

-(NSString*)keyForSection:(NSInteger)section;
{
	NSString* key = [[self.tableData objectAtIndex:section] objectAtIndex:INDEX_KEY];
	return [key isEqualToString:@""] ? nil : key;
}

-(NSMutableArray*)dataForSection:(NSInteger)section;
{
	return [[self.tableData objectAtIndex:section] objectAtIndex:INDEX_DATA];
}

#pragma mark --- Data source methods

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView;
{
	return MAX([self.tableData count], 1);
}

-(NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView;
{
	if ([self shouldDisplayIndex]) {
  	NSMutableArray* titles = [NSMutableArray arrayWithCapacity:[self.tableData count]];
    for (NSArray* section in self.tableData) {
    	NSString* key = [section objectAtIndex:INDEX_KEY];
      [titles addObject:key];
    }
	  return titles;
  }
  return nil;
}

-(NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section;
{
	if (!isSearching && [self.tableData count] > 0 && totalCount >= self.sectionThreshold) {
		return [self keyForSection:section];
  }
  return nil;
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section;
{
	if ([self.tableData count] > 0) {
  	return [[self dataForSection:section] count];
  }
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	id anObject = [self objectForIndexPath:indexPath];
  return [self.contentDataSource contentTableViewController:self cellForObject:anObject];
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath;
{
	id anObject = [self objectForIndexPath:indexPath];
	[self.contentDataSource contentTableViewController:self didSelectObject:anObject withIndexPath:indexPath];
}

#pragma mark --- Search bar delegate

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	isSearching = YES;
	[UIView beginAnimations:@"begin" context:NULL];
  if (hasTabBar) {
	  [UIView setAnimationDelay:0.1]; // Time it takes to cover toolbar
  }
	self.searchBar.showsCancelButton = YES;
  CGRect frame = self.tableView.frame;
  frame.size.height -= 216 - (hasTabBar ? 49 : 0);
  self.tableView.frame = frame;
  [UIView commitAnimations];
	[self invalidateAndReloadTableData];
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText;
{
	NSString* filter = self.searchBar.text;
  if (filter && [filter isEqualToString:@""]) {
    filter = nil;
  }
  self.currentFilter = filter;
	[self invalidateAndReloadTableData];
}

-(void)searchBarCancelButtonClicked:(UISearchBar*)searchBar;
{
	isSearching = NO;
  [searchBar resignFirstResponder];
  searchBar.text = nil;
	[UIView beginAnimations:@"end" context:NULL];
	self.searchBar.showsCancelButton = NO;
  CGRect frame = self.tableView.frame;
  frame.size.height += 216 - (hasTabBar ? 49 : 0);
  self.tableView.frame = frame;
  [UIView commitAnimations];
	self.currentFilter = nil;
	[self invalidateAndReloadTableData];
}


#pragma mark --- Section data creation

-(NSMutableArray*)newTableData;
{
  NSInteger displayCount = 0;
  totalCount = [self.contentDataSource numberOfObjectsForContentTableViewController:self];
  NSMutableArray* tableData = [[NSMutableArray alloc] init];
  NSMutableArray* sectionData = nil;
  NSString* key = nil;
	if (isSearching) {
    sectionData = [NSMutableArray array];
    [tableData addObject:[NSArray arrayWithObjects:@"", sectionData, nil]];
  }
  IMP localizedCaseInsensitiveCompare = [NSString instanceMethodForSelector:@selector(localizedCaseInsensitiveCompare:)];
	for (NSInteger index = 0 ; index < totalCount; index++) {
  	id anObject = objectAtIndex(_contentDataSource, @selector(contentTableViewController:objectAtIndex:), self, index);
    if (objectMatchesFilter == nil || objectMatchesFilter(_contentDataSource, @selector(contentTableViewController:object:matchesFilter:), self, anObject, _currentFilter)) {
    	displayCount++;
			if (isSearching) {
        [sectionData addObject:anObject];
			} else {
        NSString* newKey = (keyForObject ? keyForObject(_contentDataSource, @selector(contentTableViewController:keyForObject:), self, anObject) : @"");
        if (key != nil && localizedCaseInsensitiveCompare(newKey, @selector(localizedCaseInsensitiveCompare:), key) == NSOrderedSame) {
          [sectionData addObject:anObject];
        } else {
          sectionData = [NSMutableArray arrayWithObject:anObject];
          [tableData addObject:[NSArray arrayWithObjects:newKey, sectionData, nil]];
          key = newKey;
        }
      }
    }
  }
	if ([self.contentDataSource respondsToSelector:@selector(contentTableViewController:didGather:objectsOf:)]) {
  	[self.contentDataSource contentTableViewController:self didGather:displayCount objectsOf:totalCount];
  }
	return tableData;
}

@end

