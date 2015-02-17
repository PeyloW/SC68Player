//
//  PEWDetailViewController.h
//  SC68Player
//
//  Created by Fredrik Olsson on 7/28/13.
//  Copyright (c) 2013 Fredrik Olsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEWDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
