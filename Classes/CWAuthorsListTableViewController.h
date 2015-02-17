//
//  CWPlayListTableViewController.h
//  SC68 Player
//
//  Created by Fredrik Olsson on 2008-10-26.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWContentTableViewController.h"

@interface CWAuthorsListTableViewController : CWContentTableViewController <CWContentTableViewControllerDataSource, UIActionSheetDelegate> {
@protected
  UISegmentedControl* _filterControl;
	UIBarButtonItem* _downloadAllItem;
}

@property(nonatomic, readonly) NSMutableArray* directories;
@property(nonatomic, retain) UISegmentedControl* filterControl;

-(id)init;

@end
