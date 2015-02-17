//
//  CWAuthorSongListTableViewController.m
//  SC68 Player
//
//  Created by Fredrik Olsson on 2008-10-29.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CWSC68PlayerAppDelegate.h"
#import "CWAuthorSongListTableViewController.h"
#import "CWItemTableViewCell.h"
#import "UIColor+EditableTextColor.h"
#import "UIWindow+VisualMoveQue.h"
#import "NSMutableArray+CWSortedInsert.h"
#import "NSDictionary+CWAutoboxing.h"

@implementation CWAuthorSongListTableViewController

#pragma mark --- Properties

@synthesize songs = _songs;


#pragma mark --- Life cycle

-(id)initWithSongs:(NSMutableArray*)songs title:(NSString*)title;
{
	self = [super init];
  if (self) {
  	self.contentDataSource = self;
  	self.title = title;
  	self.songs = songs;
    UIBarButtonItem* downloadAllItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"download_all.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(downloadAll:)];
    self.navigationItem.rightBarButtonItem = downloadAllItem;
    [downloadAllItem release];
  }
  return self;
}

-(void)dealloc;
{
	self.songs = nil;
  [super dealloc];
}


#pragma mark --- Table view data source

-(NSInteger)numberOfObjectsForContentTableViewController:(CWContentTableViewController*)controller;
{
	return [self.songs count];
}

-(id)contentTableViewController:(CWContentTableViewController*)controller objectAtIndex:(NSInteger)index;
{
	return [self.songs objectAtIndex:index];	
}


-(UITableViewCell*)contentTableViewController:(CWContentTableViewController*)controller cellForObject:(id)anObject;
{
  static NSString* cellIdentifier = @"cellIdentifies";
  
  CWItemTableViewCell* cell = (CWItemTableViewCell*)[controller.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[[CWItemTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
    cell.font = [cell.font fontWithSize:16];
    cell.userInteractionEnabled = YES;
  }
  NSMutableDictionary* song = (NSMutableDictionary*)anObject;
	cell.text = [song objectForKey:@"title"];
  NSNumber* trackCount = [song objectForKey:@"trackCount"];
  if (trackCount) {
  	cell.itemText = [NSString stringWithFormat:@"%d tracks", [trackCount intValue]];
  }
  CWFavouritesButton* button = [CWFavouritesButton favouritesButtonWithTarget:self action:@selector(favouriteButtonTapped:event:)];
  button.selected = [song isFavourite];
  if ([self shouldDisplayIndex]) {
  	button.contentMode = UIViewContentModeTopLeft;
    CGRect frame = button.frame;
    frame.size.width += 16;
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 8);
    button.frame = frame;
  }
  if ([song isDownloaded]) {
  	cell.textColor = [UIColor darkTextColor];
		cell.label.textColor = [UIColor editableTextColor];
    button.enabled = YES;
  } else {
  	cell.textColor = [UIColor grayColor];
		cell.label.textColor = [UIColor lightGrayColor];
    button.enabled = NO;
  }
  cell.accessoryView = button;
  return cell;
}

-(void)contentTableViewController:(CWContentTableViewController*)controller didSelectObject:(id)anObject withIndexPath:(NSIndexPath*)indexPath;
{
  NSMutableDictionary* song = (NSMutableDictionary*)anObject;
  int tabIndex = 0;
	if ([song isDownloaded]) {
		[[CWSC68PlayerAppDelegate sharedAppDelegate] performSelector:@selector(playSong:) withObject:song afterDelay:0.5];
    tabIndex = PLAYLIST_TABINDEX;
  } else {
		[[CWSC68PlayerAppDelegate sharedAppDelegate] performSelector:@selector(downloadSong:) withObject:song afterDelay:0.5];
    tabIndex = DOWNLOADS_TABINDEX;
  }
  [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
  UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
  CGRect fromRect = [self.tableView rectForRowAtIndexPath:indexPath];
  fromRect = [self.tableView convertRect:fromRect toView:nil];
	CGRect toRect = CGRectMake((320 / 5) * tabIndex, 480 - 49, 320 / 5, 49);
  [self.tableView.window displayVisualQueForMovingView:cell fromRect:fromRect toRect:toRect];
  [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath;
{
  NSMutableDictionary* song = [self objectForIndexPath:indexPath];
	return [song isDownloaded];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
{
  NSMutableDictionary* song = [self objectForIndexPath:indexPath];
  [song setBool:NO forKey:@"downloaded"];
  [CWSC68PlayerAppDelegate sharedAppDelegate].haveChanges = YES;
  NSString* path = [song localPath];
  [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
	[self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;
{
	NSMutableDictionary* song = [self objectForIndexPath:indexPath];
  BOOL selected = ![song isFavourite];
  [song setBool:selected forKey:@"favourite"];
	if (selected) {
  	[[CWSC68PlayerAppDelegate sharedAppDelegate] performSelector:@selector(addFavouriteSong:) withObject:song afterDelay:0.5];
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    CGRect fromRect = [self.tableView rectForRowAtIndexPath:indexPath];
    fromRect = [self.tableView convertRect:fromRect toView:nil];
    CGRect toRect = CGRectMake((320 / 5) * FAVOURITES_TABINDEX, 480 - 49, 320 / 5, 49);
    [self.tableView.window displayVisualQueForMovingView:cell fromRect:fromRect toRect:toRect];
  } else {
  	[[CWSC68PlayerAppDelegate sharedAppDelegate] removeFavouriteSong:song];
  }
	[CWSC68PlayerAppDelegate sharedAppDelegate].haveChanges = YES;
}

- (void)favouriteButtonTapped:(CWFavouritesButton*)sender event:(id)event
{
	sender.selected = !sender.selected;
	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:self.tableView];
	NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
	if (indexPath != nil)
	{
		[self tableView: self.tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
	}
}

-(BOOL)contentTableViewController:(CWContentTableViewController*)controller object:(id)anObject matchesFilter:(NSString*)filter;
{
	NSDictionary* song = (NSDictionary*)anObject;
  if (filter != nil) {
    return [(NSString*)[song objectForKey:@"title"] rangeOfString:filter options:NSCaseInsensitiveSearch].location != NSNotFound;
  }
  return YES;
}

-(NSString*)contentTableViewController:(CWContentTableViewController*)controller keyForObject:(id)anObject;
{
	NSString* key = [(NSDictionary*)anObject objectForKey:@"title"];
  return [[key substringToIndex:MIN(1, [key length])] uppercaseString];
}

-(void)contentTableViewController:(CWContentTableViewController*)controller didGather:(NSInteger)displayCount objectsOf:(NSInteger)totCount;
{
	self.navigationItem.prompt = [NSString stringWithFormat:@"Showing %d out of %d songs", displayCount, totCount];
}

-(void)downloadAll:(id)sender;
{
  CWSC68PlayerAppDelegate* appDelegate = [CWSC68PlayerAppDelegate sharedAppDelegate];
	for (NSMutableDictionary* song in self.songs) {
		[appDelegate downloadSongWithoutUpdate:song];
  }
  [appDelegate updateDownloadsController];
}

@end

