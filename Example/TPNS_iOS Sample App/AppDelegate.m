//
//  AppDelegate.m
//  TPNS_iOS Sample App
//
//  Created by Björn Richter on 15.02.16.
//  Copyright © 2016 Deutsche Telekom AG. All rights reserved.
//

#import "AppDelegate.h"
//#import "TPNS_iOS.h"
@import TPNS_iOS;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Register the supported interaction types.
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    NSDictionary *params = @{@"key":@"SomeAdditionalID", @"value":@(4711)};
    
    DTPushNotification *tpns = [DTPushNotification sharedInstance];
    [tpns registerWithServerURL:@"https://tpns-preprod.molutions.de/TPNS"
                         appKey:@"LoadTestApp3"
                      pushToken:deviceToken
           additionalParameters:@[params]
                      isSandbox:YES
                     completion:^(NSString * _Nullable deviceID, NSError * _Nullable error) {
                         
                         dispatch_async(dispatch_get_main_queue(), ^{
                             NSString *title = nil;
                             NSString *message = nil;
                             
                             if(error)
                             {
                                 title = @"Error";
                                 message = [NSString stringWithFormat:@"The device could not be registered with TPNS. Errormessage was \"%@\"", error.localizedDescription];
                             } else {
                                 title = @"Success";
                                 message = [NSString stringWithFormat:@"The device was successfully registered with TPNS. TPNS deviceID is is \"%@\"", deviceID];
                             }
                             
                             UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                                            message:message
                                                                                     preferredStyle:UIAlertControllerStyleAlert];
                             
                             UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                                                style:UIAlertActionStyleDefault
                                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                                  [alert removeFromParentViewController];
                                                                              }];
                             
                             [alert addAction:okAction];
                             
                             UIViewController *rootViewController = self.window.rootViewController;
                             [rootViewController showViewController:alert sender:self];
                         });
                       
                         
                         
    }];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo
{
    
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

@end