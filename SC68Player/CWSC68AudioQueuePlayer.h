//
//  SongPlayer.h
//  XSC
//
//  Created by Elias Mårtenson on 2005-05-28.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <AudioToolbox/AudioQueue.h>

#import "CWSC68PlayerBase.h"

#define BUFFER_SIZE 16384


@interface CWSC68AudioQueuePlayer : CWSC68PlayerBase {
@protected
	NSThread* _playerThread;
  AudioQueueRef audioQueue;      // the default device
  AudioStreamBasicDescription deviceFormat;
  AudioStreamPacketDescription* packetDescs;
  BOOL isPaused;
  
  BOOL hasBuffers;
}

@property(nonatomic, retain, readonly) NSThread* playerThread;
@property(nonatomic, readonly, getter=isPlayingSound) BOOL playingSound;

- (id)init;

- (BOOL)start;
- (BOOL)pause;
- (BOOL)resume;

@end
