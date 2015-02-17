//
//  CWAuthorSongListTableViewController.h
//  SC68 Player
//
//  Created by Fredrik Olsson on 2008-10-29.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWContentTableViewController.h"
#import "CWFavouritesButton.h"
@interface CWAuthorSongListTableViewController : CWContentTableViewController <CWContentTableViewControllerDataSource> {
@protected
	NSMutableArray* _songs;
}

@property(nonatomic, retain) NSMutableArray* songs;

-(id)initWithSongs:(NSMutableArray*)songs title:(NSString*)title;

@end
