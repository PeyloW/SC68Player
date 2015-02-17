//
//  CWFavouritesTableViewController.m
//  SC68 Player
//
//  Created by Fredrik Olsson on 2008-11-11.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CWFavouritesTableViewController.h"
#import "CWSC68PlayerAppDelegate.h"
#import "CWItemTableViewCell.h"
#import "UIWindow+VisualMoveQue.h"
#import "NSDictionary+CWAutoboxing.h"

@implementation CWFavouritesTableViewController

#pragma mark --- Life cycle

-(id)init;
{
	self = [super initWithStyle:UITableViewStylePlain];
  if (self) {
		self.contentDataSource = self;
  }
  return self;
}

-(void)dealloc;
{
  [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated;
{
	[self invalidateAndReloadTableData];
  [super viewWillAppear:animated];
}

#pragma mark --- Table view data source

-(NSInteger)numberOfObjectsForContentTableViewController:(CWContentTableViewController*)controller;
{
	return [[CWSC68PlayerAppDelegate sharedAppDelegate].favourites count];
}

-(id)contentTableViewController:(CWContentTableViewController*)controller objectAtIndex:(NSInteger)index;
{
	return [[CWSC68PlayerAppDelegate sharedAppDelegate].favourites objectAtIndex:index];	
}

-(UITableViewCell*)contentTableViewController:(CWContentTableViewController*)controller cellForObject:(id)anObject;
{
  static NSString* cellIdentifier = @"Cell";
  CWItemTableViewCell* cell = (CWItemTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
  	cell = [[[CWItemTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
    cell.font = [cell.font fontWithSize:16];
    cell.ignoreSelect = YES;
  }
  NSMutableDictionary* song = (NSMutableDictionary*)anObject;
	cell.text = [song objectForKey:@"title"];
  cell.itemText = [song objectForKey:@"author"];

  return cell;
}

-(BOOL)contentTableViewController:(CWContentTableViewController*)controller object:(id)anObject matchesFilter:(NSString*)filter;
{
	NSDictionary* song = (NSDictionary*)anObject;
  if (filter != nil) {
    return [(NSString*)[song objectForKey:@"title"] rangeOfString:filter options:NSCaseInsensitiveSearch].location != NSNotFound ||
    			 [(NSString*)[song objectForKey:@"author"] rangeOfString:filter options:NSCaseInsensitiveSearch].location != NSNotFound;
  }
  return YES;
}

-(NSString*)contentTableViewController:(CWContentTableViewController*)controller keyForObject:(id)anObject;
{
	NSString* key = [(NSDictionary*)anObject objectForKey:@"title"];
  return [[key substringToIndex:MIN(1, [key length])] uppercaseString];
}

#pragma mark --- Table view Delegate

-(void)contentTableViewController:(CWContentTableViewController*)controller didSelectObject:(id)anObject withIndexPath:(NSIndexPath*)indexPath;
{
  NSMutableDictionary* song = (NSMutableDictionary*)anObject;
  [[CWSC68PlayerAppDelegate sharedAppDelegate] performSelector:@selector(playSong:) withObject:song afterDelay:0.5];
  [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
  UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
  CGRect fromRect = [self.tableView rectForRowAtIndexPath:indexPath];
  fromRect = [self.tableView convertRect:fromRect toView:nil];
	CGRect toRect = CGRectMake((320 / 5) * PLAYLIST_TABINDEX, 480 - 49, 320 / 5, 49);
  [self.tableView.window displayVisualQueForMovingView:cell fromRect:fromRect toRect:toRect];
  [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)contentTableViewController:(CWContentTableViewController*)controller didGather:(NSInteger)displayCount objectsOf:(NSInteger)totCount;
{
	self.navigationItem.prompt = [NSString stringWithFormat:@"Showing %d out of %d songs", displayCount, totCount];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
{
  NSMutableDictionary* song = [self objectForIndexPath:indexPath];
  [song setBool:NO forKey:@"favourite"];
	[CWSC68PlayerAppDelegate sharedAppDelegate].haveChanges = YES;
	[[CWSC68PlayerAppDelegate sharedAppDelegate].favourites removeObject:song];
  if ([[[_tableData objectAtIndex:indexPath.section] objectAtIndex:1] count] == 1) {
		[_tableData removeObjectAtIndex:indexPath.section];
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationTop];
  } else {
  	[[[_tableData objectAtIndex:indexPath.section] objectAtIndex:1] removeObjectAtIndex:indexPath.row];
	  [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];	
  }
  [[CWSC68PlayerAppDelegate sharedAppDelegate] updateAuthorsController];
  [CWSC68PlayerAppDelegate sharedAppDelegate].haveChanges = YES;
}


@end

