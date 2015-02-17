//
//  CWPlaylistTableViewController.m
//  SC68 Player
//
//  Created by Fredrik Olsson on 2008-10-29.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CWPlaylistTableViewController.h"
#import "CWSC68PlayerAppDelegate.h"
#import "CWItemTableViewCell.h"
#import "UIColor+EditableTextColor.h"
#import "CWFavouritesButton.h"
#import "UIWindow+VisualMoveQue.h"
#import "NSMutableArray+CWSortedInsert.h"
#import "NSDictionary+CWAutoboxing.h"

@implementation CWPlaylistTableViewController

#pragma mark --- Life cycle

-(id)init;
{
	self = [super initWithStyle:UITableViewStylePlain];
  if (self) {
    trashItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:[CWSC68PlayerAppDelegate sharedAppDelegate] action:@selector(clearPlayList:)];
    self.navigationItem.leftBarButtonItem = trashItem;
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
  }
  return self;
}

-(BOOL)canBecomeFirstResponder {
  return YES;
}

-(void)dealloc;
{
  [super dealloc];
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event;
{
	if (event.type == UIEventTypeRemoteControl) {
    id target = [CWSC68PlayerAppDelegate sharedAppDelegate];
  	switch (event.subtype) {
			case UIEventSubtypeRemoteControlPause:
      case UIEventSubtypeRemoteControlPlay:
      case UIEventSubtypeRemoteControlStop:
        [target performSelector:@selector(pauseOrResume:) withObject:pause];
        break;
      case UIEventSubtypeRemoteControlPreviousTrack:
        [target performSelector:@selector(trackChange:) withObject:prev];
        break;
      case UIEventSubtypeRemoteControlNextTrack:
        [target performSelector:@selector(trackChange:) withObject:next];
        break;
    }
  }
}

-(void)setIsPlayingSound:(BOOL)playing;
{
	if (playing) {
    self.toolbarItems = [NSArray arrayWithObjects:flex, prev, fixedA, pause, fixedB, next, flex, nil];
  } else {
		self.toolbarItems = [NSArray arrayWithObjects:flex, prev, fixedA, play, fixedA, next, flex, nil];
  }
}

-(void)viewDidLoad;
{
	[super viewDidLoad];
  cw_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
	cw_toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
  [self setIsPlayingSound:NO];
  [self.navigationController setToolbarHidden:NO];
  self.navigationController.toolbar.barStyle = UIBarStyleBlackTranslucent;
//  toolbar.barStyle = UIBarStyleBlackOpaque;
//  toolbar.tintColor = [UIColor grayColor];
  cw_toolbar.barStyle = UIBarStyleBlackTranslucent;
	id target = [CWSC68PlayerAppDelegate sharedAppDelegate];
  fixedA = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:NULL];
  fixedA.width = 16;
  fixedB = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:NULL];
	fixedB.width = 17;
  flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
  prev = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:target action:@selector(trackChange:)];
  play = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:target action:@selector(pauseOrResume:)];
	play.width = 60;
  pause = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:target action:@selector(pauseOrResume:)];
	pause.width = 60;
  next = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:target action:@selector(trackChange:)];
	next.tag = 1;
}

-(void)viewDidAppear:(BOOL)animated;
{
	static BOOL didShow = NO;
  if (!didShow) {
    [super viewWillAppear:animated];
    CGRect frame = self.tableView.frame;
		self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    frame.origin.y += frame.size.height - 44;
    frame.size.height = 44;
    cw_toolbar.frame = frame;
//    UIView* superview = self.tableView.superview;
//    [superview addSubview:cw_toolbar];
		didShow = YES;
	}
}

#pragma mark --- Table view data source

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section;
{
	return [[CWSC68PlayerAppDelegate sharedAppDelegate].playlist count];
}


-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath;
{
  static NSString* cellIdentifier = @"Cell";

  CWItemTableViewCell* cell = (CWItemTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
  	cell = [[[CWItemTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
    cell.font = [cell.font fontWithSize:16];
    cell.ignoreSelect = YES;
  }
	if (indexPath.row >= [CWSC68PlayerAppDelegate sharedAppDelegate].playIndex) {
  	cell.textColor = [UIColor darkTextColor];
		cell.label.textColor = [UIColor editableTextColor];
  } else {
  	cell.textColor = [UIColor grayColor];
		cell.label.textColor = [UIColor lightGrayColor];
  }
  NSMutableDictionary* song = [[CWSC68PlayerAppDelegate sharedAppDelegate].playlist objectAtIndex:indexPath.row];
  cell.ignoreSelect = NO;
  [cell setSelected:(indexPath.row == [CWSC68PlayerAppDelegate sharedAppDelegate].playIndex && [[CWSC68PlayerAppDelegate sharedAppDelegate]->player isPlayingSound]) animated:NO];
  cell.ignoreSelect = YES;

	cell.text = [song objectForKey:@"title"];
  cell.itemText = [song objectForKey:@"author"];

  CWFavouritesButton* button = [CWFavouritesButton favouritesButtonWithTarget:self action:@selector(favouriteButtonTapped:event:)];
  button.selected = [song isFavourite];
  cell.accessoryView = button;

  return cell;
}


#pragma mark --- Table view Delegate

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath;
{
  [CWSC68PlayerAppDelegate sharedAppDelegate].playIndex = indexPath.row;
}

-(BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath;
{
	return indexPath.row > [CWSC68PlayerAppDelegate sharedAppDelegate].playIndex;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
{
	[[CWSC68PlayerAppDelegate sharedAppDelegate].playlist removeObjectAtIndex:indexPath.row];
  [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
	[[CWSC68PlayerAppDelegate sharedAppDelegate] updateAuthorsController];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;
{
  NSMutableDictionary* song = [[CWSC68PlayerAppDelegate sharedAppDelegate].playlist objectAtIndex:indexPath.row];
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

@end

