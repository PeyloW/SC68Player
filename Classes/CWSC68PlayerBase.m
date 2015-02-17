//
//  SongFile.m
//  XSC
//
//  Created by Elias Mårtenson on 2005-05-02.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "CWSC68PlayerBase.h"

@interface CWSC68PlayerBase ()

-(api68_t*)setupSc68;
-(void)updateTrackInfo;

-(NSString*)stringOrNilWithUTF8String:(const char*)bytes;

@property(nonatomic, retain) NSString* trackTitle;
@property(nonatomic, retain) NSString* author;
@property(nonatomic, retain) NSString* converterName;
@property(nonatomic, retain) NSString* ripperName;
@property(nonatomic) int playTime;
@property(nonatomic) int trackCount;

@end


@implementation CWSC68PlayerBase

#pragma mark --- Life cycle

-(id)init
{
  self = [super init];
  if (self) {
		lock = [[NSRecursiveLock alloc] init];
    sc68 = [self setupSc68];
		if (sc68 == NULL) {
    	[self release];
      self = nil;
    }
	}
  return self;
}

-(void)dealloc;
{
	[lock release];
	self.trackTitle = nil;
  self.author = nil;
  self.converterName = nil;
  self.ripperName = nil;
	[super dealloc];
}

@synthesize delegate = _delegate;


#pragma mark --- Manage SC68 player

-(void)loadSongFile:(NSString*)fileName
{
	_currentTrack = 1;
  if ([self isPlayingSound]) {
  	NSLog( @"resetting when loading" );
		[self resetPlayer];
  }

  [lock lock];
  if ([self isSongLoaded]) {
		api68_close(sc68);
  }
  _songLoaded = NO;
	BOOL loadFail = api68_load_file(sc68, [fileName UTF8String]); 
  [lock unlock];
  
  if (loadFail) {
  	if (self.delegate) {
			[self.delegate displayErrorWithMessage:NSLocalizedString(@"Failed to load song", nil)
				      description:[NSString stringWithFormat:NSLocalizedString(@"An error occurred while loading the file: %@", nil), fileName]];
			}        
    return;
  }

  [self updateTrackInfo];
  _songLoaded = YES;
}

-(BOOL)resetPlayer;
{
  if (![self isSongLoaded] || ![self isPlayingSound]) {
		return NO;
  }

  [lock lock];
  api68_stop( sc68 );
  _playingSound = NO;
  [lock unlock];

  return YES;
}

- (BOOL)fillNextFrameBuffer:(void *)buf size:(int)n
{
	int code = 0;
    
  if (![self isSongLoaded]) {
		return NO;
  }

  [lock lock];
  if (![self isPlayingSound]) {
		code = api68_play( sc68, self.currentTrack, 0 );
		_playingSound = YES;
  }
	if (code >= 0) {
	  code = api68_process( sc68, buf, n >> 2 );
	}
  [lock unlock];

  if ((code & API68_END) && (self.delegate) && [self.delegate respondsToSelector:@selector(sc68PlayerSongDidEnd:)]) {
  	[self.delegate	sc68PlayerSongDidEnd:self];
  }
  if ((code & API68_LOOP) && (self.delegate) && [self.delegate respondsToSelector:@selector(sc68PlayerTrackDidLoop:)]) {
  	[self.delegate	sc68PlayerTrackDidLoop:self];
  }
  if ((code & API68_CHANGE) && (self.delegate) && [self.delegate respondsToSelector:@selector(sc68PlayerTrackDidChange:)]) {
  	[self.delegate	sc68PlayerTrackDidChange:self];
  }
  return code != API68_MIX_ERROR;
}


#pragma mark --- Property synthesizeing

@synthesize songLoaded = _songLoaded;

@synthesize trackTitle = _trackTitle;
@synthesize author = _author;
@synthesize converterName = _converterName;
@synthesize ripperName = _ripperName;
@synthesize playTime = _playTime;
@synthesize trackCount = _trackCount;

@dynamic currentTrack;

-(int)currentTrack
{
  return _currentTrack;
}

-(void)setCurrentTrack:(int)track
{
  if (track < 1 ) {
		_currentTrack = 1;
  } else if (track > self.trackCount) {
		_currentTrack = self.trackCount;
  } else {
		_currentTrack = track;
  }
  [self resetPlayer];
}

#pragma mark --- Private SC68 methods

-(api68_t*)setupSc68
{
  api68_init_t init68;

  NSBundle *bundle = [NSBundle mainBundle];
  NSString *path = [bundle bundlePath];
  NSMutableString *argData = [NSMutableString stringWithString:@"--sc68_data="];
  [argData appendString:path];
  [argData appendString:@"/Contents/Resources/sc68"];

  char *t = (char *)[argData UTF8String];
  char *args[] = { "sc68", t, NULL };

  memset(&init68, 0, sizeof(init68));
  init68.alloc = (void *(*)(unsigned int))malloc;
  init68.free = free;
  init68.argc = 2;
  init68.argv = args;
#ifdef _DEBUG
  init68.debug = (debugmsg68_t)vfprintf;
  init68.debug_cookie = stderr;
#endif

	[lock lock];
  api68_t* api = api68_init(&init68);
	[lock unlock];
  
	return api;
}

- (void)updateTrackInfo
{
  api68_music_info_t info;
	[lock lock];
  api68_music_info( sc68, &info, self.currentTrack, NULL );
	[lock unlock];

  self.trackTitle = [self stringOrNilWithUTF8String:info.title];
  self.author = [self stringOrNilWithUTF8String:info.author];
  self.converterName = [self stringOrNilWithUTF8String:info.converter];
  self.ripperName = [self stringOrNilWithUTF8String:info.ripper];
  self.trackCount = info.tracks;
  self.playTime = info.time_ms;
  
  self.currentTrack = 1;
}

#pragma mark --- Private helper methods

-(NSString*)stringOrNilWithUTF8String:(const char*)bytes;
{
	if (bytes) {
  	return [NSString stringWithUTF8String:bytes];
  }
  return nil;
}

@end
