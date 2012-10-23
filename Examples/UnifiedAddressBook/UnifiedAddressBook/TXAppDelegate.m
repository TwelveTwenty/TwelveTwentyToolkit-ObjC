//
//  TXAppDelegate.m
//  UnifiedAddressBook
//
//  Created by Eric-Paul Lecluse on 23-10-12.
//  Copyright (c) 2012 Twelve Twenty. All rights reserved.
//

#import "TXAppDelegate.h"
#import "TXRootViewController.h"

@implementation TXAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[TXRootViewController alloc]  init]];
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
