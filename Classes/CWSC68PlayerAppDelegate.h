//
//  SC68_PlayerAppDelegate.h
//  SC68 Player
//
//  Created by Fredrik Olsson on 2008-10-25.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWSC68AudioQueuePlayer.h"
#import "CWDownloadQueue.h"

#define AUTHORS_TABINDEX 0
#define FAVOURITES_TABINDEX 1
#define PLAYLIST_TABINDEX 2
#define DOWNLOADS_TABINDEX 3
#define ABOUT_TABINDEX 3

@interface NSMutableDictionary (Song)

-(NSURL*)remoteURL;
-(NSString*)localPath;
-(BOOL)isProbablyDownloaded;
-(BOOL)isDownloaded;
-(BOOL)isFavourite;

@end


@interface CWSC68PlayerAppDelegate : NSObject <UIApplicationDelegate, CWSC68PlayerDelegate, CWDownloadQueueDelegate> {
	UIWindow* _window;
  UITabBarController* rootViewController;
  
  CWDownloadQueue* downloadQueue;
  
  NSMutableArray* _directories;
  NSMutableArray* _favourites;
  NSInteger _playIndex;
	NSMutableArray* _playlist;
  NSMutableArray* _downloads;
  BOOL ignoreEnd;
    
  BOOL _haveChanges;
@public
  CWSC68AudioQueuePlayer* player;
}

@property(nonatomic, retain) UIWindow* window;
@property(nonatomic, retain, readonly) NSMutableArray* directories;
@property(nonatomic, retain, readonly) NSMutableArray* favourites;
@property(nonatomic, assign) NSInteger playIndex;
@property(nonatomic, retain, readonly) NSMutableArray* playlist;
@property(nonatomic, retain, readonly) NSMutableArray* downloads;

@property(nonatomic, assign) BOOL haveChanges;

+(CWSC68PlayerAppDelegate*)sharedAppDelegate;
+(NSArray*)songSortDescriptors;

-(void)removeFavouriteSong:(NSMutableDictionary*)song;
-(void)playSong:(NSMutableDictionary*)song;
-(void)downloadSongWithoutUpdate:(NSMutableDictionary*)song;
-(void)downloadSong:(NSMutableDictionary*)song;

@end

