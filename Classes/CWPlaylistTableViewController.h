//
//  CWPlaylistTableViewController.h
//  SC68 Player
//
//  Created by Fredrik Olsson on 2008-10-29.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CWPlaylistTableViewController : UITableViewController {
@protected
	UIBarButtonItem* trashItem;
  UIBarButtonItem* flex;
	UIBarButtonItem* fixedA;
	UIBarButtonItem* fixedB;
@public
  UIToolbar* cw_toolbar;
  UIBarButtonItem* prev;
  UIBarButtonItem* play;
  UIBarButtonItem* pause;
  UIBarButtonItem* next;
}

-(id)init;

-(void)setIsPlayingSound:(BOOL)playing;

@end
