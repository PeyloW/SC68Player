//
//  CWDownloadQueue.h
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

#import <UIKit/UIKit.h>


@protocol CWDownloadQueueDelegate;


/*!
 * @abstract A CWDownloadQueue manages a queue of asynchronious downloads.
 */
@interface CWDownloadQueue : NSObject {
@protected
	id<CWDownloadQueueDelegate> _delegate;
	NSOperationQueue* _operationQueue;
}

/*!
 * @abstract Specifies the receivers delegate.
 */
@property(nonatomic, assign) id<CWDownloadQueueDelegate> delegate;

@property(nonatomic, readonly) NSUInteger downloadCount;

/*!
 * @anstract Initializes and returns a newly created download queue with speciefied delagate.
 * 
 * @param delegate The download queue's delegate, may be nil.
 * @result An initialized download queue object, or nil if the object could not be created.
 */
-(id)initWithDelegate:(id<CWDownloadQueueDelegate>)delegate;

/*!
 * @abstract Add a download to the receivers download queue.
 *
 * Downloads are started as soon as possible, and only one download is performed at any given time.
 * The client is responsible for managing the context memory; if it is an object it must be retained before
 * invocing downloadURL:toFile:context:, and should be released in a delegate callback.
 *
 * @param URL The URL to download.
 * @param path The file to download URL to.
 * @param context Arbitary data that is passed to all delegate invocations, may be NULL.
 * @result YES if a download started imidiatedly, NO if downloaded ws added tot he end of the queue.
 *
 */
-(BOOL)downloadURL:(NSURL*)URL toFile:(NSString*)path context:(void*)context;

/*!
 * @abstract Query the receiver if a downloads are ongoing.
 * 
 * @result YES if downloads are ongoing.
 */
-(BOOL)isDownloading;

@end

/*!
 * @abstract The CWDownloadQueueDelegate protocol declares the interface that a CWDownloadQueue delegate must implement.
 */
@protocol CWDownloadQueueDelegate <NSObject>
@optional

/*!
 * @abstract Sent when a download should begin, client may cancel download.
 * 
 * If a download is cancelled, the next in queue will scheduled for download.
 *
 * @param downloadQueue The sender.
 * @param URL The URL that should download.
 * @param path The file the downlod should download URL to.
 * @param context Clients context.
 * @result YES if download should begin, NO if download should be cancelled.
 */
-(BOOL)downloadQueue:(CWDownloadQueue*)downloadQueue shouldDownloadURL:(NSURL*)URL toFile:(NSString*)path context:(void*)context;

/*!
 * @abstract Sent when a download has finished.
 * 
 * The next download in queue will be scheduled for download.
 *
 * @param downloadQueue The sender.
 * @param URL The URL that did download.
 * @param path The file the downlod did download URL to.
 * @param context Clients context.
 */
-(void)downloadQueue:(CWDownloadQueue*)downloadQueue didDownloadURL:(NSURL*)URL toFile:(NSString*)path context:(void*)context;

/*!
 * @abstract Sent when a download has failed.
 * 
 * The next download in queue will be scheduled for download.
 *
 * @param downloadQueue The sender.
 * @param URL The URL that failed to download.
 * @param path The file the downlod failed to download URL to.
 * @param context Clients context.
 * @param error An URL downloading system, or file system originated NSError object.
 */
-(void)downloadQueue:(CWDownloadQueue*)downloadQueue failedDownloadURL:(NSURL*)URL toFile:(NSString*)path context:(void*)context error:(NSError*)error;

@end

