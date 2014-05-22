//
//  HAWAppDelegate.m
//  LeftMenuViewExample
//
//  Created by Jerry Wong on 5/22/14.
//  Copyright (c) 2014 HowAboutWe. All rights reserved.
//

#import "HAWAppDelegate.h"
#import "HAWLeftMenuViewController.h"
#import "HAWLeftViewController.h"
#import "HAWViewController.h"

@implementation HAWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    HAWLeftMenuViewController *slideController = [[HAWLeftMenuViewController alloc] init];
    slideController.leftViewOpenSize = 0.6 * [[UIScreen mainScreen] bounds].size.width;
    slideController.leftViewController = [[HAWLeftViewController alloc] init];
    slideController.mainViewController = [[HAWViewController alloc] init];
    
    self.window.rootViewController = slideController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
