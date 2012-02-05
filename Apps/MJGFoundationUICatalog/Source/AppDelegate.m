//
//  AppDelegate.m
//  MJGFoundationUICatalog
//
//  Created by Matt Galloway on 07/01/2012.
//  Copyright (c) 2012 Matt Galloway. All rights reserved.
//

#import "AppDelegate.h"

#import "MainViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize splitViewController = _splitViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        MainViewController *mainViewController = [[MainViewController alloc] init];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
        self.window.rootViewController = self.navigationController;
    } else {
        MainViewController *mainViewController = [[MainViewController alloc] init];
        UINavigationController *mainNavigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
        
        self.splitViewController = [[UISplitViewController alloc] init];
        self.splitViewController.viewControllers = [NSArray arrayWithObjects:mainNavigationController, nil];
        
        self.window.rootViewController = self.splitViewController;
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
