//
//  SC68_PlayerAppDelegate.m
//  SC68 Player
//
//  Created by Fredrik Olsson on 2008-10-25.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "CWSC68PlayerAppDelegate.h"
#import "CWAuthorsListTableViewController.h"
#import "CWAuthorSongListTableViewController.h"
#import "CWFavouritesTableViewController.h"
#import "CWPlaylistTableViewController.h"
#import "CWDownloadsTableViewController.h"
#import "CWAboutTableViewController.h"
#import "CWItemTableViewCell.h"
#import "NSDictionary+CWAutoboxing.h"

static CWSC68PlayerAppDelegate* gSharedAppDelegate = nil;

@implementation NSMutableDictionary (Song)

-(NSURL*)remoteURL;
{
	NSString* path = [self objectForKey:@"path"];
	NSString* remoteRoot = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"remoteRoot"];
	NSURL* remoteURL = [NSURL URLWithString:[remoteRoot stringByAppendingPathComponent:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	return remoteURL;
}

-(NSString*)localPath;
{
	NSString* path = [self objectForKey:@"path"];
	NSString* localPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	localPath = [localPath stringByAppendingPathComponent:path];
	return localPath;
}

-(BOOL)isProbablyDownloaded;
{
	return [self boolValueForKey:@"downloaded"];
}

-(BOOL)isDownloaded;
{
	NSNumber* downloaded = [self objectForKey:@"downloaded"];
	if (downloaded) {
  	return [downloaded boolValue];
  } else {
		BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:[self localPath]];
    [self setBool:exists forKey:@"downloaded"];
    return exists;
  }
}

-(BOOL)isFavourite;
{
	NSNumber* favourite = [self objectForKey:@"favourite"];
	if (favourite) {
  	return [favourite boolValue];
  } else {
  	[self setBool:NO forKey:@"favourite"];
    return NO;
  }
}


@end



@interface CWSC68PlayerAppDelegate ()
-(UIViewController*)createAuthorController;
-(UIViewController*)createFavouritesController;
-(UIViewController*)createPlaylistController;
-(UIViewController*)createDownloadsController;
-(UIViewController*)createAboutController;

@property(nonatomic, retain, readonly) CWAuthorsListTableViewController* authorsController;
@property(nonatomic, retain, readonly) CWAuthorSongListTableViewController* authorSongController;
@property(nonatomic, retain, readonly) CWFavouritesTableViewController* favouritesController;
@property(nonatomic, retain, readonly) CWPlaylistTableViewController* playlistController;
@property(nonatomic, retain, readonly) CWDownloadsTableViewController* downloadsController;

-(void)markUpdates;
-(void)updateAuthorsController;
-(void)updatePlayListController;
-(void)updateDownloadsController;

@end

@implementation CWSC68PlayerAppDelegate

#pragma mark --- Properties

@synthesize window = _window;
@synthesize directories = _directories;
@dynamic playIndex;
@synthesize favourites = _favourites;
@synthesize playlist = _playlist;
@synthesize downloads = _downloads;
@synthesize haveChanges = _haveChanges;

-(NSInteger)playIndex;
{
	return _playIndex;
}

-(void)setPlayIndex:(NSInteger)index;
{
	if (index < [self.playlist count]) {
    while (index > 2) {
      [self.playlist removeObjectAtIndex:0];
      index--;
    }
    _playIndex = index;
    if (_playIndex < [self.playlist count]) {
      NSString* path = [[self.playlist objectAtIndex:_playIndex] localPath];
      [player performSelector:@selector(loadSongFile:) onThread:player.playerThread withObject:path waitUntilDone:YES];
			[player performSelector:@selector(start) onThread:player.playerThread withObject:nil waitUntilDone:NO];
    }
	}
  [self performSelector:@selector(updatePlayListController) withObject:nil afterDelay:0.2];
}

@dynamic authorsController;
@dynamic authorSongController;
@dynamic playlistController;
@dynamic downloadsController;

-(CWAuthorsListTableViewController*)authorsController;
{
  UINavigationController* navController = (UINavigationController*)[rootViewController.viewControllers objectAtIndex:AUTHORS_TABINDEX];
  CWAuthorsListTableViewController* tableController = (CWAuthorsListTableViewController*)[navController.viewControllers objectAtIndex:0];
	return tableController;
}

-(CWAuthorSongListTableViewController*)authorSongController;
{
  UINavigationController* navController = (UINavigationController*)[rootViewController.viewControllers objectAtIndex:AUTHORS_TABINDEX];
  CWAuthorSongListTableViewController* tableController = (CWAuthorSongListTableViewController*)navController.topViewController;
	if ((id)tableController == (id)self.authorsController) {
  	return nil;
  }
	return tableController;
}

-(CWFavouritesTableViewController*)favouritesController;
{
  UINavigationController* navController = (UINavigationController*)[rootViewController.viewControllers objectAtIndex:FAVOURITES_TABINDEX];
  CWFavouritesTableViewController* tableController = (CWFavouritesTableViewController*)[navController.viewControllers objectAtIndex:0];
	return tableController;
}

-(CWPlaylistTableViewController*)playlistController;
{
  UINavigationController* navController = (UINavigationController*)[rootViewController.viewControllers objectAtIndex:PLAYLIST_TABINDEX];
  CWPlaylistTableViewController* tableController = (CWPlaylistTableViewController*)[navController.viewControllers objectAtIndex:0];
	return tableController;
}

-(CWDownloadsTableViewController*)downloadsController;
{
  UINavigationController* navController = (UINavigationController*)[rootViewController.viewControllers objectAtIndex:DOWNLOADS_TABINDEX];
  CWDownloadsTableViewController* tableController = (CWDownloadsTableViewController*)[navController.viewControllers objectAtIndex:0];
	return tableController;
}

#pragma mark --- Life cycle

- (void)dealloc;
{
  [_window release];
  [super dealloc];
}


#pragma mark --- Public methods

+(NSArray*)songSortDescriptors;
{
	static NSArray* descriptors = nil;
  if (descriptors == nil) {
  	NSSortDescriptor* title = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
  	NSSortDescriptor* author = [[NSSortDescriptor alloc] initWithKey:@"author" ascending:YES];
    descriptors = [[NSArray alloc] initWithObjects:title, author, nil];
    [title release];
    [author release];
  }
  return descriptors;
}

+(CWSC68PlayerAppDelegate*)sharedAppDelegate;
{
	return gSharedAppDelegate;
}

-(void)removeFavouriteSong:(NSMutableDictionary*)song;
{
	[self.favourites removeObject:song];
  self.favouritesController.navigationController.tabBarItem.badgeValue = @"-1";
  [self performSelector:@selector(removeFavouriteBadge:) withObject:self afterDelay:1.0];
}

-(void)addFavouriteSong:(NSMutableDictionary*)song;
{
	[self.favourites insertObject:song sortedUsingDescriptors:[CWSC68PlayerAppDelegate songSortDescriptors]];
  self.favouritesController.navigationController.tabBarItem.badgeValue = @"+1";
  [self performSelector:@selector(removeFavouriteBadge:) withObject:self afterDelay:1.0];
}

-(void)removeFavouriteBadge:(id)sender;
{
  self.favouritesController.navigationController.tabBarItem.badgeValue = nil;
}

-(void)playSong:(NSMutableDictionary*)song;
{
	[self.playlist addObject:song];
  if ([self.playlist count] == 1) {
  	self.playIndex = 0;
  } else {
  	[self performSelector:@selector(updatePlayListController) withObject:nil afterDelay:0.05];
  }
}

-(void)downloadSongWithoutUpdate:(NSMutableDictionary*)song;
{
  NSURL* URL = [song remoteURL];
  NSString* path = [song localPath];
  [downloadQueue downloadURL:URL toFile:path context:song];
  [_downloads addObject:song];
}

-(void)downloadSong:(NSMutableDictionary*)song;
{
  NSURL* URL = [song remoteURL];
  NSString* path = [song localPath];
  [downloadQueue downloadURL:URL toFile:path context:song];
  [_downloads addObject:song];
  [self updateDownloadsController];
}

#pragma mark --- Player delagate

-(void)pauseOrResume:(UIBarButtonItem*)item;
{
  if ([player isPlayingSound]) {
	  [player performSelector:@selector(pause) onThread:player.playerThread withObject:nil waitUntilDone:NO];
  } else if ([self.playlist count] > 0 && ![player resume]) {
  	self.playIndex = 0;
  }
  [self performSelector:@selector(updatePlayListController) withObject:nil afterDelay:0.2];
}

-(void)trackChange:(UIBarButtonItem*)item;
{
	if (item.tag == 0 && [player isPlayingSound]) {
  	if (player.currentTrack > 1) {
    	ignoreEnd = YES;
    	player.currentTrack--;
    } else {
	  	self.playIndex--;
    }
  } else {
  	if (player.trackCount > player.currentTrack) {
    	ignoreEnd = YES;
    	player.currentTrack++;
    } else {
	  	self.playIndex++;
    }
  }
  [self performSelector:@selector(updatePlayListController) withObject:nil afterDelay:0.2];
}

-(void)clearPlayList:(id)sender;
{
	NSMutableDictionary* song = nil;
	if ([player isPlayingSound]) {
		song = [self.playlist objectAtIndex:self.playIndex];
  }
  [self.playlist removeAllObjects];
  if (song) {
  	[self.playlist addObject:song];
  }
  _playIndex = 0;
	[self updatePlayListController];
}

-(void)sc68PlayerSongDidEnd:(CWSC68PlayerBase*)player;
{
	if (!ignoreEnd) {
		self.playIndex++;
  }
  ignoreEnd = YES;
}

#pragma mark --- Download queue delegate

-(BOOL)downloadQueue:(CWDownloadQueue*)downloadQueue shouldDownloadURL:(NSURL*)URL toFile:(NSString*)path context:(void*)context;
{
	NSMutableDictionary* song = (NSMutableDictionary*)context;
	if ([song isDownloaded]) {
		[self.downloads removeObject:(NSObject*)context];
    [self updateAuthorsController];
    [self updateDownloadsController];
    return NO;
  }
  return YES;
}

-(void)downloadQueue:(CWDownloadQueue*)downloadQueue didDownloadURL:(NSURL*)URL toFile:(NSString*)path context:(void*)context;
{
	NSMutableDictionary* song = (NSMutableDictionary*)context;
  [song setBool:YES forKey:@"downloaded"];
	[self.downloads removeObject:(NSObject*)context];
  [self markUpdates];
  [self updateAuthorsController];
  [self updateDownloadsController];
}

#pragma mark --- Store restore state

-(NSString*)dataPath;
{
	NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	path = [path stringByAppendingPathComponent:@"directories.alist"];
	return path;
}

-(void)fillArray:(NSMutableArray*)array withSongIndexPaths:(NSArray*)indexPaths;
{
  if (indexPaths) {
  	for(NSArray* indexPath in indexPaths) {
    	int section = [[indexPath objectAtIndex:0] intValue];
    	int row = [[indexPath objectAtIndex:1] intValue];
    	NSArray* songs = [[self.directories objectAtIndex:section] objectAtIndex:1];
      NSMutableDictionary* song = [songs objectAtIndex:row];
    	[array addObject:song];
    }
  }
}

-(void)restoredFavourites;
{
	_favourites = [[NSMutableArray alloc] init];
	NSArray* playlist = [[NSUserDefaults standardUserDefaults] arrayForKey:@"favourites"];
  [self fillArray:_favourites withSongIndexPaths:playlist];
}

-(void)restoredPlaylist;
{
	_playlist = [[NSMutableArray alloc] init];
	NSArray* playlist = [[NSUserDefaults standardUserDefaults] arrayForKey:@"playlist"];
  [self fillArray:_playlist withSongIndexPaths:playlist];
}

-(void)applicationDidFinishLaunching:(UIApplication*)application;
{
	gSharedAppDelegate = self;
    #ifdef DUMP_FILES
	[self dumpFiles];
    #endif
	NSData* data = [NSData dataWithContentsOfFile:[self dataPath]];
  if (data == nil) {
  	data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"directories" ofType:@"plist"]];
	}
  _directories = [[NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListMutableContainers format:NULL errorDescription:NULL] retain];

	player = [[CWSC68AudioQueuePlayer alloc] init];
  player.delegate = self;
  downloadQueue = [[CWDownloadQueue alloc] initWithDelegate:self];

	[self restoredFavourites];
	[self restoredPlaylist];
  _downloads = [NSMutableArray new];

  _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  rootViewController = [[UITabBarController alloc] init];
  [rootViewController setViewControllers:[NSArray arrayWithObjects:[self createAuthorController], [self createFavouritesController], [self createPlaylistController], [self createDownloadsController], [self createAboutController], nil]];
  [_window addSubview:rootViewController.view];
	rootViewController.selectedIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"selectedTab"];

  [self updatePlayListController];
	[self updateDownloadsController];

	[_window makeKeyAndVisible];
}

-(NSArray*)indexPathForSong:(NSDictionary*)song;
{
	NSInteger section = [[song objectForKey:@"container"] integerValue];
  NSInteger row = [[[self.directories objectAtIndex:section] objectAtIndex:1] indexOfObject:song];
  return [NSArray arrayWithObjects:[NSNumber numberWithInteger:section], [NSNumber numberWithInteger:row], nil];
}

-(NSArray*)indexPathArrayForSongs:(NSArray*)songs;
{
	NSMutableArray* array = [NSMutableArray arrayWithCapacity: [songs count]];
  for (NSDictionary* song in songs) {
  	NSArray* indexPath = [self indexPathForSong:song];
    [array addObject:indexPath];
  }
  return array;
}

-(void)storeFavourites;
{
	NSArray* indexPaths = [self indexPathArrayForSongs:_favourites];
  [[NSUserDefaults standardUserDefaults] setObject:indexPaths forKey:@"favourites"];
}

-(void)storePlaylist;
{
	NSArray* indexPaths = [self indexPathArrayForSongs:_playlist];
  [[NSUserDefaults standardUserDefaults] setObject:indexPaths forKey:@"playlist"];
}


-(void)applicationWillEnterForeground:(UIApplication *)application;
{
  NSLog(@"I am back");
}

-(void)applicationDidEnterBackground:(UIApplication*)application;
{
	if (self.haveChanges) {
    NSData* data = [NSPropertyListSerialization dataFromPropertyList:self.directories format:NSPropertyListBinaryFormat_v1_0 errorDescription:NULL];
    if (data) {
      [data writeToFile:[self dataPath] atomically:YES];
    }
	}
	[self storeFavourites];
  [self storePlaylist];
  [[NSUserDefaults standardUserDefaults] setInteger:rootViewController.selectedIndex forKey:@"selectedTab"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)applicationWillTerminate:(UIApplication*)application;
{
	if (self.haveChanges) {
    NSData* data = [NSPropertyListSerialization dataFromPropertyList:self.directories format:NSPropertyListBinaryFormat_v1_0 errorDescription:NULL];
    if (data) {
      [data writeToFile:[self dataPath] atomically:YES];
    }
	}
	[self storeFavourites];
  [self storePlaylist];
  [[NSUserDefaults standardUserDefaults] setInteger:rootViewController.selectedIndex forKey:@"selectedTab"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark --- Controller creation

-(UIViewController*)createAuthorController;
{
	CWAuthorsListTableViewController* authorController = [[CWAuthorsListTableViewController alloc] init];
	authorController.title = @"Authors";
  UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:authorController];
  [authorController release];
  UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Authors" image:[UIImage imageNamed:@"authors.png"] tag:1];
  navController.tabBarItem = tabBarItem;
  [tabBarItem release];
  return [navController autorelease];
}

-(UIViewController*)createFavouritesController;
{
	CWFavouritesTableViewController* favouritesController = [[CWFavouritesTableViewController alloc] init];
	favouritesController.title = @"Favourites";
  UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:favouritesController];
  [favouritesController release];
	UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:2];
  navController.tabBarItem = tabBarItem;
  [tabBarItem release];
  return [navController autorelease];
}

-(UIViewController*)createPlaylistController;
{
	CWPlaylistTableViewController* playlistController = [[CWPlaylistTableViewController alloc] init];
	playlistController.title = @"Playlist";
  UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:playlistController];
  navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
  [playlistController release];
  UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Playlist" image:[UIImage imageNamed:@"playlist.png"] tag:2];
  navController.tabBarItem = tabBarItem;
  [tabBarItem release];
  return [navController autorelease];
}

-(UIViewController*)createDownloadsController;
{
	CWDownloadsTableViewController* authorController = [[CWDownloadsTableViewController alloc] init];
	authorController.title = @"Downloads";
  UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:authorController];
  [authorController release];
  UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemDownloads tag:3];
  navController.tabBarItem = tabBarItem;
  [tabBarItem release];
  return [navController autorelease];
}

-(UIViewController*)createAboutController;
{
	CWAboutTableViewController* authorController = [[CWAboutTableViewController alloc] init];
	authorController.title = @"About";
  UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:authorController];
  [authorController release];
  UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:@"About" image:[UIImage imageNamed:@"about.png"] tag:4];
  navController.tabBarItem = tabBarItem;
  [tabBarItem release];
  return [navController autorelease];
}

-(void)markUpdates;
{
	_haveChanges = YES;
}


#pragma mark --- Table controller updates

-(void)updateAuthorsController;
{
	[self.authorsController.tableView reloadData];
  if (self.authorSongController) {
		[self.authorSongController.tableView reloadData];
  }
}

-(void)updatePlayListController;
{
  [self.playlistController.tableView reloadData];
  NSInteger count = [self.playlist count];
  NSString* badge = nil;
  if (count > 0) {
  	badge = [NSString stringWithFormat:@"%d", count];
  }
  self.playlistController.navigationController.tabBarItem.badgeValue = badge;
  NSString* title = @"Playlist";
  if ([player isPlayingSound]) {
  	title = [NSString stringWithFormat:@"Track %d of %d", player.currentTrack, player.trackCount];
    BOOL enabled = [self.playlist count] > 0;
    [self.playlistController->play setEnabled:enabled];
    [self.playlistController->pause setEnabled:enabled];
    enabled &= (player.currentTrack > 1) || self.playIndex > 0;
    [self.playlistController->prev setEnabled:enabled];
  	enabled = (player.currentTrack < player.trackCount) || self.playIndex < ([self.playlist count] - 1);
    [self.playlistController->next setEnabled:enabled];
  }
  [self.playlistController setIsPlayingSound:[player isPlayingSound]];
  self.playlistController.title = title;
}

-(void)showUnknownDownloads;
{
	self.downloadsController.navigationController.tabBarItem.badgeValue = @"?";
}

-(void)updateDownloadsController;
{
	[self.downloadsController.tableView reloadData];
  NSInteger count = [self.downloads count];
  NSString* badge = nil;
  if (count > 0) {
  	badge = [NSString stringWithFormat:@"%d", count];
  }
  self.downloadsController.navigationController.tabBarItem.badgeValue = badge;
}

@end
