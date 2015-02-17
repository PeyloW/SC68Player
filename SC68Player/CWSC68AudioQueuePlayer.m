//
//  SongPlayer.m
//  XSC
//
//  Created by Elias Mårtenson on 2005-05-28.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "CWSC68AudioQueuePlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface CWSC68AudioQueuePlayer ()

static void AudioQueueCallback(void* inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer);
-(BOOL)setupAudioQueue;
- (BOOL)writeFrame:(AudioQueueBufferRef)outBuffer;
- (void)displaySongStartFailed;
- (void)displaySongStopFailed;

@end


@implementation CWSC68AudioQueuePlayer

@synthesize  playerThread = _playerThread;
@dynamic playingSound;
-(BOOL)isPlayingSound;
{
	return (api68_seek(sc68, -1, 0) != -1) && !isPaused;
}

#pragma mark --- Life cycle
-(id)init;
{
  self = [super init];
  if( self != nil ) {
    AVAudioSession* session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:NULL];
  /*
    if (![self setupAudioQueue]) {
    	[self release];
      self = nil;
    }
  */
  	[self performSelectorInBackground:@selector(setupAudioQueue) withObject:nil];
	}
  return self;
}

-(void)dealloc;
{
  [super dealloc];
}


#pragma mark --- Manage player

-(BOOL)start;
{
  if ([self isPlayingSound]) {
    return NO;
  }

  [self resetPlayer];

  OSStatus err = noErr;
  if (!hasBuffers) {
		AudioQueueBufferRef mBuffers[3];
		for (int i = 0; i < 3; ++i) {
			err = AudioQueueAllocateBuffer(audioQueue, BUFFER_SIZE, &mBuffers[i]);
      if (err != noErr) {
				break;
      }
			AudioQueueCallback(self, audioQueue, mBuffers[i]);
		}
    hasBuffers = YES;
	}

	if (err == noErr) {
  	err = AudioQueueStart(audioQueue, NULL);
	}

  isPaused = (err != noErr);

  return (err == noErr);
}

-(BOOL)pause;
{
  if (![self isPlayingSound]) {
    return NO;
  }

  isPaused = YES;

  OSStatus err = AudioQueuePause(audioQueue);
  [self resetPlayer];

  return err == noErr;
}

- (BOOL)resume;
{
	if ([self isSongLoaded]) {
  	isPaused = NO;
  	return AudioQueueStart(audioQueue, NULL) == noErr;
  }
  return NO;
}

#pragma mark -- Private audio queue methods

static void AudioQueueCallback(void* inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer) {
	[(CWSC68AudioQueuePlayer*)inUserData writeFrame:inBuffer];
}

-(BOOL)setupAudioQueue;
{
	_playerThread = [NSThread currentThread];
  OSStatus err = noErr;

  deviceFormat.mSampleRate = 44100;
  deviceFormat.mFormatID = kAudioFormatLinearPCM;
  deviceFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger;
  deviceFormat.mBytesPerPacket = 4;
  deviceFormat.mFramesPerPacket = 1;
  deviceFormat.mBytesPerFrame = 4;
  deviceFormat.mChannelsPerFrame = 2;
  deviceFormat.mBitsPerChannel = 16;
  deviceFormat.mReserved = 0;

  err = AudioQueueNewOutput(&deviceFormat, AudioQueueCallback, self, CFRunLoopGetCurrent(), kCFRunLoopCommonModes, 0, &audioQueue);

	[NSThread setThreadPriority:1.0];

	CFRunLoopRun();

  return (err == noErr);
}

-(BOOL)writeFrame:(AudioQueueBufferRef)outBuffer;
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  if( ![self fillNextFrameBuffer:outBuffer->mAudioData size:outBuffer->mAudioDataBytesCapacity] ) {
		NSLog( @"Error when calling api68_process" );
    [pool release];
		return NO;
  }
	outBuffer->mAudioDataByteSize = outBuffer->mAudioDataBytesCapacity;

	OSStatus err = AudioQueueEnqueueBuffer(audioQueue, outBuffer, 0, NULL);

  [pool release];
  return err == noErr;
}

#pragma mark -- Private audio queue methods

-(void)displaySongStartFailed;
{
	if (self.delegate) {
    [self.delegate displayErrorWithMessage:NSLocalizedString(@"Error when playing song", "Title in error message")
                          description:NSLocalizedString(@"The sound system could not started", "Content in error message")];
	}
}

-(void)displaySongStopFailed;
{
	if (self.delegate) {
    [self.delegate displayErrorWithMessage:NSLocalizedString(@"Error when stopping song", "Title in error message")
                          description:NSLocalizedString(@"The sound system could not be stopped", "Text in error message")];
	}
}

@end
