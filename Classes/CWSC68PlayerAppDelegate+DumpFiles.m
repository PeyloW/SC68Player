//
//  SC68PlayerAppDelegte+DumpFiles.m
//  SC68 Player
//
//  Created by Fredrik Olsson on 2008-10-29.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CWSC68PlayerAppDelegate+DumpFiles.h"
#import "CWSC68AudioQueuePlayer.h"

static NSMutableArray* strings = nil;

static NSInteger CompareSongs(NSDictionary* a, NSDictionary* b, void* c);


@implementation CWSC68PlayerAppDelegate (DumpFiles)

-(BOOL)isLegalPath:(NSString*)path;
{
	NSString* file = [path lastPathComponent];
  return [file characterAtIndex:0] != L'.';
}

-(NSString*)goodName:(NSString*)path;
{
	return [path stringByReplacingOccurrencesOfString:@"_" withString:@" "];
}

-(NSString*)emptyIfNilString:(NSString*)str;
{
	return str ? str : @"No Title";
}

static NSInteger CompareSongs(NSDictionary* a, NSDictionary* b, void* c)
{
	return [[a objectForKey:@"title"] caseInsensitiveCompare:[b objectForKey:@"title"]];
}

-(void)dumpFiles;
{
	strings = [NSMutableArray array];
	CWSC68AudioQueuePlayer* player = [[CWSC68AudioQueuePlayer alloc] init];
	NSMutableArray* directories = [NSMutableArray array];
  NSString* path = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"dumpRoot"]; 
	NSDirectoryEnumerator* dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
	NSString* nextPath = nil;
	NSMutableArray* songs =  nil;
  NSString* goodName = nil;
  NSInteger containerIndex = -1;
  while (nextPath = [dirEnum nextObject]) {
  	if ([self isLegalPath:nextPath]) {
      NSString* fullPath = [path stringByAppendingPathComponent:nextPath];
      BOOL isDir = NO;
      [[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir];
      if (isDir) {
      	if ([[nextPath pathComponents] count] == 1) {
					songs = [NSMutableArray array];
          goodName = [self goodName:nextPath];
  	      [directories addObject:[NSArray arrayWithObjects:goodName, songs, nil]];
          containerIndex++;
        }
      } else {
      	[player stop];
        [player loadSongFile:fullPath];
        NSMutableDictionary* song = [NSMutableDictionary dictionaryWithObject:[self emptyIfNilString:player.trackTitle] forKey:@"title"];
        [song setObject:[NSNumber numberWithInteger:containerIndex] forKey:@"container"];
        if(player.author) {
	        [song setObject:player.author forKey:@"author"];
        } else {
	        [song setObject:goodName forKey:@"author"];
        }
        int trackCount = [player trackCount];
        if (trackCount != 1) {
        	[song setObject:[NSNumber numberWithInt:trackCount] forKey:@"trackCount"];
        }
        [song setObject:nextPath forKey:@"path"];
        [songs addObject:song];
      }
      [songs sortUsingFunction:CompareSongs context:nil];
    }
  }
  NSData* data = [NSPropertyListSerialization dataFromPropertyList:directories format:NSPropertyListBinaryFormat_v1_0 errorDescription:NULL];
  [data writeToFile:[path stringByAppendingPathComponent:@"directories.plist"] atomically:YES];
}

@end
