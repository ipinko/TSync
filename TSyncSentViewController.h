//
//  TSyncSentViewController.h
//  TSync
//
//  Created by Ljw on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SA_OAuthTwitterEngine;


@interface TSyncSentViewController : UIViewController {
    SA_OAuthTwitterEngine*      engine;
    IBOutlet UITextView*        textText;
}

@property (nonatomic,retain) SA_OAuthTwitterEngine*     engine;
@property(nonatomic, retain) UITextView*                textText;

-(IBAction) cancleAction;
-(IBAction) sendAction;

-(IBAction) changeTextAction;
- (void)textViewDidChange:(UITextView *)textView;

@end
