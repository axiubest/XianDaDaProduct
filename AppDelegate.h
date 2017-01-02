//
//  AppDelegate.h
//  鲜搭搭净菜公社
//
//  Created by XIUDeveloper on 2016/12/28.
//  Copyright © 2016年 杨岫峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

