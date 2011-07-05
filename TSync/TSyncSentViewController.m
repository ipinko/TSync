//
//  TSyncSentViewController.m
//  TSync
//
//  Created by Ljw on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSyncSentViewController.h"
#import "SA_OAuthTwitterEngine.h"


@implementation TSyncSentViewController

@synthesize engine,textText,textCountLabel,sendButton,activityIndicator;

#pragma mark Custom Methods
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSMutableString *chatText = [[NSMutableString alloc] init];
    [chatText setString:textView.text];
    CFStringTrimWhitespace((CFMutableStringRef)chatText);
    if ([chatText isEqualToString:@""]) {
        sendButton.enabled = NO;
    }else{
        sendButton.enabled = YES;
    }
    [chatText release];
    //如果当前操作的文本控件是帐号输入框，则检测输入长度是否超过140了，如果是则不允许继续输入
    if (range.location > 140)
        return NO; // return NO to not change text
    //把还可以输入的字符数写到指定的lebel里
    textCountLabel.text = [NSString stringWithFormat:@"%i",140 -textView.text.length ];
    return YES;
}

-(IBAction) cancleAction{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction) sendAction{
    [activityIndicator startAnimating];
    [engine sendUpdate:textText.text];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [textText release];
    [textCountLabel release];
    [sendButton release];
    [activityIndicator release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    textText.delegate = self;
    [textText becomeFirstResponder];
    
    [engine initWithDelegate:self];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//=============================================================================================================================
#pragma mark TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier {
	NSLog(@"Request %@ succeeded", requestIdentifier);
    [self dismissModalViewControllerAnimated:YES];
}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
    NSString* text = [[NSString alloc]initWithString:(@"Failed with error ")];
    NSString* errorText = [error localizedDescription];
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:text message:errorText delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [activityIndicator stopAnimating];
    
    [alert show];
    [alert release];
    [text release];
    [errorText release];
}
@end
