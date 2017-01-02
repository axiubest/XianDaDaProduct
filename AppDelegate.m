//
//  AppDelegate.m
//  鲜搭搭净菜公社
//
//  Created by XIUDeveloper on 2016/12/28.
//  Copyright © 2016年 杨岫峰. All rights reserved.
//

#import "AppDelegate.h"
#import "XIUViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.backgroundColor = [UIColor whiteColor];
    XIUViewController *root = [[XIUViewController alloc] init];
    
    self.window.rootViewController = root;
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *nCookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookiesURL = [nCookies cookiesForURL:[NSURL URLWithString:@"http://wx.hzjuym.com/xdd/mobile/index.php"]];  //这个是主页的url，不是登录页的url
    
    for (id c in cookiesURL)
    {
        if ([c isKindOfClass:[NSHTTPCookie class]])
        {
            cookie=(NSHTTPCookie *)c;
            NSLog(@"------%@", cookie.name);
            if ([cookie.name isEqualToString:@"PHPSESSID"]) {//我的cookies的名字是 "PHPSESSID"，你在上一行打个断点看看你的cookies的name是什么
                NSDate *expiresDate = [NSDate dateWithTimeIntervalSinceNow:3600*24*30*12];//当前点后，保存一年左右
                NSArray *cookies = [NSArray arrayWithObjects:cookie.name, cookie.value, expiresDate, cookie.domain, cookie.path, nil];
                
                if(cookies){
                    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
                    [cookieProperties setObject:[cookies objectAtIndex:0] forKey:NSHTTPCookieName];
                    [cookieProperties setObject:[cookies objectAtIndex:1] forKey:NSHTTPCookieValue];
                    [cookieProperties setObject:[cookies objectAtIndex:2] forKey:NSHTTPCookieExpires];
                    [cookieProperties setObject:[cookies objectAtIndex:3] forKey:NSHTTPCookieDomain];
                    [cookieProperties setObject:[cookies objectAtIndex:4] forKey:NSHTTPCookiePath];
                    
                    NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookieProperties];
                    [[NSHTTPCookieStorage sharedHTTPCookieStorage]  setCookie:cookieuser];
                }
                break;
            }
        }
    }
    

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
 }


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"_______"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
