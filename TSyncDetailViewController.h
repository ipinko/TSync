//
//  TSyncDetailViewController.h
//  TSync
//
//  Created by Ljw on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SA_OAuthTwitterEngine;


@interface TSyncDetailViewController : UIViewController {
    
    SA_OAuthTwitterEngine*        engine;
    id                      tweet;
    
    IBOutlet UILabel*       textLabel;
    IBOutlet UILabel*       userNameLabel;
    IBOutlet UILabel*       userScreenNameLabel;
    IBOutlet UIImageView*   userImageView;
}

@property (nonatomic,retain) SA_OAuthTwitterEngine*       engine;
@property (nonatomic,retain) id                     tweet;

@property(nonatomic, retain) UILabel*               textLabel;
@property(nonatomic, retain) UILabel*               userNameLabel;
@property(nonatomic, retain) UILabel*               userScreenNameLabel;
@property(nonatomic, retain) UIImageView*           userImageView;

@end
