//
//  CWPlayListTableViewController.m
//  SC68 Player
//
//  Created by Fredrik Olsson on 2008-10-26.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CWSC68PlayerAppDelegate.h"
#import "CWAuthorsListTableViewController.h"
#import "CWAuthorSongListTableViewController.h"
#import "CWItemTableViewCell.h"
#import "UIColor+EditableTextColor.h"
#import "NSDictionary+CWAutoboxing.h"

@implementation CWAuthorsListTableViewController

@dynamic directories;
@synthesize filterControl = _filterControl;

-(NSMutableArray*)directories;
{
	return [CWSC68PlayerAppDelegate sharedAppDelegate].directories;
}

#pragma mark --- Life cycle

-(id)init;
{
	self = [super init];
  if (self) {
		self.contentDataSource = self;
    _filterControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"All Authors", @"Available Authors", nil]];
    self.filterControl.segmentedControlStyle = UISegmentedControlStyleBar;
    self.filterControl.selectedSegmentIndex = 0;
    [self.filterControl addTarget:self action:@selector(changeFilter:) forControlEvents:UIControlEventValueChanged];
		self.navigationItem.titleView = self.filterControl;
    _downloadAllItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"download_all.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(showDownloadAll:)];
    self.navigationItem.rightBarButtonItem = _downloadAllItem;
  }
  return self;
}

- (void)dealloc;
{
  self.filterControl = nil;
  [super dealloc];
}

#pragma mark --- Content table view controller data source

-(NSInteger)numberOfObjectsForContentTableViewController:(CWContentTableViewController*)controller;
{
	return [self.directories count];
}

-(id)contentTableViewController:(CWContentTableViewController*)controller objectAtIndex:(NSInteger)index;
{
	return [self.directories objectAtIndex:index];	
}

-(NSInteger)numberOfDownloadedSongs:(NSArray*)songs;
{
	NSInteger count = 0;
  for (NSMutableDictionary* song in songs) {
  	if ([song isDownloaded]) {
    	count++;
    }
  }
  return count;
}

-(UITableViewCell*)contentTableViewController:(CWContentTableViewController*)controller cellForObject:(id)anObject;
{
  static NSString *cellIdentifier = @"cellIdentifier";
  CWItemTableViewCell *cell = (CWItemTableViewCell*)[controller.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[[CWItemTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
  }
	cell.text = [(NSArray*)anObject objectAtIndex:0];
  NSArray* songs = [(NSArray*)anObject objectAtIndex:1];
  int count = [self numberOfDownloadedSongs:songs];
  if (count > 0) {
  	cell.textColor = [UIColor darkTextColor];
		cell.label.textColor = [UIColor editableTextColor];
  } else {
  	cell.textColor = [UIColor grayColor];
		cell.label.textColor = [UIColor lightGrayColor];
  }
  if (count == [songs count]) {
  	cell.itemText = [NSString stringWithFormat:@"%d", count];
  } else {
	  cell.itemText = [NSString stringWithFormat:@"%d/%d", count, [songs count]];
  }
  return cell;
}

-(void)contentTableViewController:(CWContentTableViewController*)controller didSelectObject:(id)anObject withIndexPath:(NSIndexPath*)indexPath;
{
  NSString* title = [(NSArray*)anObject objectAtIndex:0];
  NSMutableArray* songs = [(NSArray*)anObject objectAtIndex:1];
	CWAuthorSongListTableViewController* songListController = [[CWAuthorSongListTableViewController alloc] initWithSongs:songs title:title];
  [self.navigationController pushViewController:songListController animated:YES];
  [songListController release];
}

-(BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath;
{
  NSMutableArray* songs = [[self objectForIndexPath:indexPath] objectAtIndex:1];
	for (NSMutableDictionary* song in songs) {
  	if ([song isDownloaded]) {
    	return YES;
    }
	}
  return NO;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath;
{
  NSMutableArray* songs = [[self objectForIndexPath:indexPath] objectAtIndex:1];
	for (NSMutableDictionary* song in songs) {
  	if ([song isDownloaded]) {
    	[song setBool:NO forKey:@"downloaded"];
      [CWSC68PlayerAppDelegate sharedAppDelegate].haveChanges = YES;
      NSString* path = [song localPath];
      [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
		}
  }
	[self.tableView reloadData];
}

-(BOOL)contentTableViewController:(CWContentTableViewController*)controller object:(id)anObject matchesFilter:(NSString*)filter;
{
	NSArray* directory = (NSArray*)anObject;
	if (_filterControl.selectedSegmentIndex == 0 || [self numberOfDownloadedSongs:[directory objectAtIndex:1]] > 0) {
  	if (filter != nil) {
    	return [(NSString*)[directory objectAtIndex:0] rangeOfString:filter options:NSCaseInsensitiveSearch].location != NSNotFound;
    }
    return YES;
  }
  return NO;
}

-(NSString*)contentTableViewController:(CWContentTableViewController*)controller keyForObject:(id)anObject;
{
	NSString* key = [(NSArray*)anObject objectAtIndex:0];
  return [[key substringToIndex:1] uppercaseString];
}

-(void)contentTableViewController:(CWContentTableViewController*)controller didGather:(NSInteger)displayCount objectsOf:(NSInteger)totCount;
{
	self.navigationItem.prompt = [NSString stringWithFormat:@"Showing %d out of %d authors", displayCount, totCount];
}

#pragma mark --- Private filter and index methods

-(void)changeFilter:(UISegmentedControl*)sender;
{
	[self invalidateAndReloadTableData];
}


-(void)downloadAll:(UIBarButtonItem*)sender;
{
	if ([NSThread isMainThread]) {
		sender.enabled = NO;
    [[CWSC68PlayerAppDelegate sharedAppDelegate] showUnknownDownloads];
  	[self performSelectorInBackground:@selector(downloadAll:) withObject:sender];
  } else {
  	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    CWSC68PlayerAppDelegate* appDelegate = [CWSC68PlayerAppDelegate sharedAppDelegate];
    for (NSArray* directory in self.directories) {
      for (NSMutableDictionary* song in (NSArray*)[directory objectAtIndex:1]) {
        if (![song isProbablyDownloaded]) {
          [appDelegate downloadSongWithoutUpdate:song];
        }
      }
    }
    [appDelegate updateDownloadsController];
    [pool release];
	}
}

-(void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
	if (buttonIndex == 0) {
		[self downloadAll:_downloadAllItem];
	}
}
-(void)showDownloadAll:(id)sender;
{
	UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"Do you want to dowload all unavailable songs?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Download All Songs", nil];
	[sheet showInView:self.tableView.window];
  [sheet release];
}

@end

