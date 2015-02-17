//
//  main.m
//  SC68 Player
//
//  Created by Fredrik Olsson on 2008-10-25.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, @"CWSC68PlayerAppDelegate");
    [pool release];
    return retVal;
}
