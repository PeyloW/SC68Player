//
//  PEWMasterViewController.h
//  SC68Player
//
//  Created by Fredrik Olsson on 7/28/13.
//  Copyright (c) 2013 Fredrik Olsson. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface PEWMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
