//
//  AppDelegate.m
//  airdrop_custom_data
//
//  Created by Maxim Bilan on 9/14/14.
//  Copyright (c) 2014 Maxim Bilan. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url isFileURL] && [[[url absoluteString] pathExtension] isEqualToString:@"customdata"]) {
        [self copyItemAtURLtoDocumentsDirectory:url];
        return YES;
    }
    
    return NO;
}

- (BOOL)copyItemAtURLtoDocumentsDirectory:(NSURL *)url
{
    NSError *error;
    NSURL *copyToURL = [self applicationDocumentsDirectory];
    NSString *fileName = [url lastPathComponent];
    
    copyToURL = [copyToURL URLByAppendingPathComponent:fileName isDirectory:NO];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:copyToURL.path]) {
        
        NSURL *duplicateURL = copyToURL;
        copyToURL = [copyToURL URLByDeletingPathExtension];
        NSString *fileNameWithoutExtension = [copyToURL lastPathComponent];
        NSString *fileExtension = [url pathExtension];
        
        int i = 1;
        while ([[NSFileManager defaultManager] fileExistsAtPath:duplicateURL.path]) {
            copyToURL = [copyToURL URLByDeletingLastPathComponent];
            copyToURL = [copyToURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@–%i", fileNameWithoutExtension, i]];
            copyToURL = [copyToURL URLByAppendingPathExtension:fileExtension];
            duplicateURL = copyToURL;
            i++;
        }
    }
    
    BOOL ok = [[NSFileManager defaultManager] moveItemAtURL:url toURL:copyToURL error:&error];
    if (!ok) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    return ok;
}

- (NSURL *)applicationDocumentsDirectory
{
    NSString *documentsDirectory;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([paths count] > 0) {
        documentsDirectory = [paths objectAtIndex:0];
    }
    return [NSURL fileURLWithPath:documentsDirectory];
}

@end
