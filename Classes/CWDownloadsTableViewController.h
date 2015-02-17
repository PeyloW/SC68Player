//
//  CWDownloadsTableViewController.h
//  SC68 Player
//
//  Created by Fredrik Olsson on 2008-10-30.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CWDownloadsTableViewController : UITableViewController {
@private
	UIActivityIndicatorView* activityView;
}

-(id)init;

@end
