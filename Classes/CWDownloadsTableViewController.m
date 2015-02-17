//
//  CWDownloadsTableViewController.m
//  SC68 Player
//
//  Created by Fredrik Olsson on 2008-10-30.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CWDownloadsTableViewController.h"
#import "CWSC68PlayerAppDelegate.h"
#import "CWItemTableViewCell.h"


@implementation CWDownloadsTableViewController

#pragma amark --- Life cycle

-(id)init;
{
	self = [super initWithStyle:UITableViewStylePlain];
  if (self) {
  	activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActionSheetStyleBlackOpaque];
    [activityView stopAnimating];
  }
  return self;
}

- (void)dealloc;
{
	[activityView release];
  [super dealloc];
}


#pragma mark --- Table view data source

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section;
{
	return [[CWSC68PlayerAppDelegate sharedAppDelegate].downloads count];
}


-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath;
{
  static NSString* cellIdentifier = @"Cell";
  
  CWItemTableViewCell* cell = (CWItemTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
  	cell = [[[CWItemTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
    cell.font = [cell.font fontWithSize:16];
  }
  if (indexPath.row == 0) {
  	cell.accessoryView = activityView;
    [activityView stopAnimating];
  } else {
  	cell.accessoryView = nil;
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  NSMutableDictionary* song = [[CWSC68PlayerAppDelegate sharedAppDelegate].downloads objectAtIndex:indexPath.row];
	cell.text = [song objectForKey:@"title"];
  cell.itemText = [song objectForKey:@"author"];
  return cell;
}


@end

