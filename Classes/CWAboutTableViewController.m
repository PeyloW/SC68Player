//
//  CWAboutTableViewController.m
//  SC68 Player
//
//  Created by Fredrik Olsson on 2008-10-30.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CWAboutTableViewController.h"


@implementation CWAboutTableViewController

-(id)init;
{
	return [super initWithStyle:UITableViewStyleGrouped];
}

-(void)dealloc; 
{
  [super dealloc];
}

-(void)viewDidLoad;
{
	[super viewDidLoad];
  UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 128 + 16)];
  UIImageView* largeIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"large_icon.png"]];
  largeIconView.frame = CGRectMake((320 - 128) / 2, 16, 128, 128);
  [view addSubview:largeIconView];
  self.tableView.tableHeaderView = view;
  [largeIconView release];
  [view release];
}


-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section;
{
  return 0;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath;
{
	return nil;
}

-(NSString*)tableView:(UITableView*)tableView titleForFooterInSection:(NSInteger)section;
{
	return @"©2008 Fredrik Olsson, all rights served.\n\nUses sc68 ©2001-2003 Benjamin Gerard\n\nCore Audio replay based on XSC ©2005-2008 Anders Eriksson & Elias Mårtensson\n\nSC68 Player, sc68 and XSC are released under GPL-license. Sourcecode is available from http://www.peylow.se/sc68player.html";
}


@end

