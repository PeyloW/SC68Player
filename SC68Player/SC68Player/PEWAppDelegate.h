//
//  PEWAppDelegate.h
//  SC68Player
//
//  Created by Fredrik Olsson on 7/28/13.
//  Copyright (c) 2013 Fredrik Olsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEWAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
