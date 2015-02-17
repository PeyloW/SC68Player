//
//  SongFile.h
//  XSC
//
//  Created by Elias Mårtenson on 2005-05-02.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "api68.h"

@protocol CWSC68PlayerDelegate;


@interface CWSC68PlayerBase : NSObject {
@protected
  NSRecursiveLock* lock;
  id<CWSC68PlayerDelegate> _delegate;
  api68_t *sc68;

  NSString* _trackTitle;
  NSString* _author;
  NSString* _converterName;
  NSString* _ripperName;
  int _playTime;
  int _trackCount;
  int _currentTrack;

  BOOL _songLoaded;
  BOOL _playingSound;
}

-(id)init;

@property(nonatomic, assign) id<CWSC68PlayerDelegate> delegate;

-(void)loadSongFile:(NSString*)fileName;
-(BOOL)resetPlayer;
-(BOOL)fillNextFrameBuffer:(void *)buf size:(int)n;

@property(nonatomic, readonly, getter=isSongLoaded) BOOL songLoaded;
@property(nonatomic) int currentTrack;

@property(nonatomic, retain, readonly) NSString* trackTitle;
@property(nonatomic, retain, readonly) NSString* author;
@property(nonatomic, retain, readonly) NSString* converterName;
@property(nonatomic, retain, readonly) NSString* ripperName;
@property(nonatomic, readonly) int playTime;
@property(nonatomic, readonly) int trackCount;

@end


@protocol CWSC68PlayerDelegate <NSObject>

@optional
-(void)displayErrorWithMessage:(NSString *)messageIn 
		    description:(NSString *)descriptionIn;

-(void)sc68PlayerSongDidEnd:(CWSC68PlayerBase*)player;
-(void)sc68PlayerTrackDidLoop:(CWSC68PlayerBase*)player;
-(void)sc68PlayerTrackDidChange:(CWSC68PlayerBase*)player;

@end
