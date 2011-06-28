//
//  TSyncDetailViewController.h
//  TwitterRush
//
//  Created by Ljw on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGTwitterEngine.h"


@interface TSyncDetailViewController : UIViewController {
    
   // MGTwitterEngine*        test;
    id                      tweet;
    
    IBOutlet UILabel*       textLabel;
    IBOutlet UILabel*       userNameLabel;
    IBOutlet UILabel*       userScreenNameLabel;
    IBOutlet UIImageView*   userImageView;
}

//@property (nonatomic,retain) MGTwitterEngine*       test;
@property (nonatomic,retain) id                     tweet;

@property(nonatomic, retain) UILabel*               textLabel;
@property(nonatomic, retain) UILabel*               userNameLabel;
@property(nonatomic, retain) UILabel*               userScreenNameLabel;
@property(nonatomic, retain) UIImageView*           userImageView;

@end
