//
//  AppDelegate.m
//  eecs397_ios_demo
//
//  Created by Nick Barendt on 3/7/17.
//  Copyright © 2017 Nick Barendt. All rights reserved.
//

#import "AppDelegate.h"
#import <KeenClient/KeenClient.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

NSString *const KEEN_PROJECT_ID = @"5ab535c4c9e77c0001692fb3";
NSString *const KEEN_WRITE_KEY = @"A1659623AC19D1EC462E9E8683C301DE20D926184F88C1B321B09A81CDCC4218F4E381A26C29FBFC81CC1337FC97D178BE5878D76A302E0CBC9B9FE98DAE171D0D0FBA299E1D0533ED690F0F49BB077CF3A3495D96CEFF1864E975D3B0163D3D";


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // configure analytics
    [KeenClient authorizeGeoLocationWhenInUse];
    [KeenClient sharedClientWithProjectID:KEEN_PROJECT_ID andWriteKey:KEEN_WRITE_KEY andReadKey:nil];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    UIBackgroundTaskIdentifier taskId = [application beginBackgroundTaskWithExpirationHandler:^(void) {
        NSLog(@"Background task is being expired.");
    }];

    [[KeenClient sharedClient] uploadWithFinishedBlock:^(void) {
        [application endBackgroundTask:taskId];
    }];
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
