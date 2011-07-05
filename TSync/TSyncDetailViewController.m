//
//  TSyncDetailViewController.m
//  TSync
//
//  Created by Ljw on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TSyncDetailViewController.h"
#import "TSyncListViewController.h"


@implementation TSyncDetailViewController

@synthesize engine;
@synthesize tweet,textLabel,userNameLabel,userScreenNameLabel,userImageView; 


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
    //[test release];
    NSLog(@"ipk Detail dealloc");
    [textLabel release];
    [userNameLabel release];
    [userScreenNameLabel release];
    [userImageView release];
    [tweet release];
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
    
    [engine initWithDelegate:self];
    
    [engine getFollowedTimelineSinceID:0 startingAtPage:1 count:10];
    if(tweet){
        textLabel.text=[tweet objectForKey:@"text"];
        
        [textLabel sizeToFit];
        
        id user = [tweet objectForKey:@"user"];
        userNameLabel.text = [[user objectForKey:@"name"] copy];
        userScreenNameLabel.text = [[@"@" stringByAppendingString:[user objectForKey:@"screen_name"]]copy];
        
        NSString* imageUrl = [[user objectForKey:@"profile_image_url"]copy];
        
        [user release];
        
        userImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
        
        [imageUrl release];
    }
    else{
        NSLog(@"error,tweet:%@",tweet);
    }
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
#pragma mark MGTwitterEngineDelegate
- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)identifier  
{
    NSLog(@"Got ipk detail statuses:\r%@", statuses);
} 


@end
