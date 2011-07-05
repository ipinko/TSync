//
//  TSyncSentViewController.h
//  TSync
//
//  Created by Ljw on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SA_OAuthTwitterEngine;


@interface TSyncSentViewController : UIViewController<UITextViewDelegate> {
    SA_OAuthTwitterEngine*      engine;
    IBOutlet UITextView*        textText;
    IBOutlet UILabel*           textCountLabel;
    IBOutlet UIBarButtonItem*   sendButton;
    IBOutlet UIActivityIndicatorView* activityIndicator;
}

@property (nonatomic,retain) SA_OAuthTwitterEngine*     engine;
@property(nonatomic, retain) UITextView*                textText;
@property(nonatomic,retain) UILabel*                    textCountLabel;
@property(nonatomic,retain) UIBarButtonItem*            sendButton;
@property(nonatomic,retain) UIActivityIndicatorView*    activityIndicator;

-(IBAction) cancleAction;
-(IBAction) sendAction;

@end
