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

@synthesize engine,textText;

#pragma mark Custom Methods

- (void)textViewDidChange:(UITextView *)textView  
{  
    //该判断用于联想输入  
    if (textView.text.length > 14)  
    {  
        textView.text = [textView.text substringToIndex:14];  
    }  
}  
//键入Done时，插入换行符，然后执行addBookmark  
- (BOOL)textView:(UITextView *)textView  
shouldChangeTextInRange:(NSRange)range   
 replacementText:(NSString *)text  
{  
    //判断加上输入的字符，是否超过界限  
    NSString *str = [NSString stringWithFormat:@"%@%@", textView.text, text];  
    if (str.length > 14)  
    {  
        textView.text = [textView.text substringToIndex:14];  
        return NO;  
    }  
    return YES;  
}  

-(IBAction) cancleAction{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction) sendAction{
    [engine sendUpdate:textText.text];
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction) changeTextAction{
    NSLog(@"sdsd");
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

@end
