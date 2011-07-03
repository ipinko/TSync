//
//  TSyncAppDelegate.h
//  TSync
//
//  Created by Ljw on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSyncAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UINavigationController* navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
