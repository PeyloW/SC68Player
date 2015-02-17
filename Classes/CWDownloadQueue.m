//
//  CWDownloadQueue.m
//  SC68 Player
//
//  Created by Fredrik Olsson on 2008-10-30.
//  Copyright 2008 Jayway AB. All rights reserved.
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License. 
//  You may obtain a copy of the License at 
// 
//  http://www.apache.org/licenses/LICENSE-2.0 
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS, 
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "CWDownloadQueue.h"


@interface CWDownloadOperation : NSOperation {
	CWDownloadQueue* _downloadQueue;
  NSURL* _URL;
  NSString* _path;
	void* _context;
  BOOL tempResult;
  NSError* _error;
}

+(CWDownloadOperation*)downloadOperationWithDownloadQueue:(CWDownloadQueue*)downloadQueue URL:(NSURL*)URL path:(NSString*)path context:(void*)context;

-(void)main;

@end;


@implementation CWDownloadQueue

#pragma mark --- Properties

@synthesize delegate = _delegate;

-(NSUInteger)downloadCount;
{
	return [[_operationQueue operations] count];
}

#pragma mark --- Life cycle

-(id)initWithDelegate:(id<CWDownloadQueueDelegate>)delegate;
{
	self = [super init];
  if (self) {
  	self.delegate = delegate;
		_operationQueue = [[NSOperationQueue alloc] init];
    [_operationQueue setMaxConcurrentOperationCount:4];
  }
  return self;
}

-(void)dealloc
{
	[_operationQueue release];
  [super dealloc];
}


#pragma mark --- Manage downloads

-(BOOL)isDownloading;
{
	return ![_operationQueue isSuspended];
}

-(BOOL)downloadURL:(NSURL*)URL toFile:(NSString*)path context:(void*)context;
{
	CWDownloadOperation* downloadOperation = [CWDownloadOperation downloadOperationWithDownloadQueue:self URL:URL path:path context:context];
	[_operationQueue addOperation:downloadOperation];
  return YES;
}

@end


@implementation CWDownloadOperation

+(CWDownloadOperation*)downloadOperationWithDownloadQueue:(CWDownloadQueue*)downloadQueue URL:(NSURL*)URL path:(NSString*)path context:(void*)context;
{
	CWDownloadOperation* downloadOperation = [[CWDownloadOperation alloc] init];
	downloadOperation->_downloadQueue = downloadQueue;
  downloadOperation->_URL = [URL copy];
	downloadOperation->_path = [path copy];
  downloadOperation->_context = context;
  return [downloadOperation autorelease];  
}

-(void)dealloc;
{
	[_URL release];
  [_path release];
  [super dealloc];
}


#pragma mark --- Manage downloads

-(void)fireDelegate:(NSNumber*)selectorId;
{
	if ([NSThread isMainThread]) {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    switch ([selectorId intValue]) {
      case 0:
        tempResult = [_downloadQueue.delegate downloadQueue:_downloadQueue shouldDownloadURL:_URL toFile:_path context:_context];
        break;
      case 1:
        [_downloadQueue.delegate downloadQueue:_downloadQueue didDownloadURL:_URL toFile:_path context:_context];
        break;
      case 2:
        [_downloadQueue.delegate downloadQueue:_downloadQueue failedDownloadURL:_URL toFile:_path context:_context error:_error];
      default:
        break;
    }
    [pool release];
	} else {
    [self performSelectorOnMainThread:@selector(fireDelegate:) withObject:selectorId waitUntilDone:YES];
  }
}

-(void)ensureDirectoryExistsForFile:(NSString*)path;
{
	path = [path stringByDeletingLastPathComponent];
  [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
}

-(void)main;
{
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  BOOL shouldDownload = YES;
  if ([_downloadQueue.delegate respondsToSelector:@selector(downloadQueue:shouldDownloadURL:toFile:context:)]) {
  	[self fireDelegate:[NSNumber numberWithInt:0]];
    shouldDownload = tempResult;
  }
  if (shouldDownload) {
    NSURLRequest* request = [NSURLRequest requestWithURL:_URL];
    NSURLResponse* response = nil;
    _error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&_error];
    if (data) {
      [self ensureDirectoryExistsForFile:_path];
      if ([data writeToFile:_path options:NSAtomicWrite error:&_error]) {
        if ([_downloadQueue.delegate respondsToSelector:@selector(downloadQueue:didDownloadURL:toFile:context:)]) {
          [self fireDelegate:[NSNumber numberWithInt:1]];
        }
      }
    }
    if (_error != nil) {
      if ([_downloadQueue.delegate respondsToSelector:@selector(downloadQueue:failedDownloadURL:toFile:context:error:)]) {
        [self fireDelegate:[NSNumber numberWithInt:2]];
      }
    }
  }

  [UIApplication sharedApplication].networkActivityIndicatorVisible = _downloadQueue.downloadCount != 1;
}

@end;
