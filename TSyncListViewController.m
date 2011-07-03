//
//  TSyncListViewController.m
//  TSync
//
//  Created by Ljw on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TSyncListViewController.h"
#import "SA_OAuthTwitterEngine.h"
#import "TSyncDetailViewController.h"
#import "TSyncSentViewController.h"

/* Define the constants below with the Twitter 
 Key and Secret for your application. Create
 Twitter OAuth credentials by registering your
 application as an OAuth Client here: http://twitter.com/apps/new
 */

#define kOAuthConsumerKey				@"VmHmrgPSiMJLoKbrs6OvrA"		//REPLACE With Twitter App OAuth Key  
#define kOAuthConsumerSecret			@"439Lay5HOjnStOj0A9VzhGCeFDHsQoNUAVTKWJwduc"		//REPLACE With Twitter App OAuth Secret

@implementation TSyncListViewController

@synthesize sinceID,list,listTableView; 

#pragma mark Custom Methods

-(void)logOut{
    NSLog(@"Log Out");
    [_engine clearAccessToken];
    UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:self];  
    
    if (controller){  
        [self presentModalViewController: controller animated: YES];  
    }
    self.title = nil;
    list=[[NSMutableArray alloc] initWithCapacity:0];
    [listTableView reloadData];
}
-(void)send{
    NSLog(@"send");
    TSyncSentViewController *controller = [[TSyncSentViewController alloc]init];
    if (controller){
        controller.engine = _engine;
        [self presentModalViewController: controller animated: YES];  
    } 
}

-(void) appendTableWith:(NSArray *)data
{
    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:5];
    int itemsCount = [list count];
    for (int i=0;i<[data count];i++) {
        [list addObject:[data objectAtIndex:i]];
        NSIndexPath    *newPath =  [NSIndexPath indexPathForRow:(itemsCount+i) inSection:0];
        [insertIndexPaths addObject:newPath];
    }
    [self.listTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
}
-(void)loadMore
{
    NSLog(@"loadMore");
    sinceID = [_engine getFollowedTimelineSinceID:sinceID startingAtPage:1 count:5];
}


#pragma mark ViewController Lifecycle

- (void)viewDidAppear: (BOOL)animated {
    [_engine initWithDelegate:self];
    if(self.title==nil)
    {
        self.title = [_engine username];
        [self loadMore];
    }
    
    NSLog(@"ipk viewDidAppear again,engine:%@",_engine);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem* logOutButton = [[UIBarButtonItem alloc]initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(logOut)]; 
    self.navigationItem.leftBarButtonItem = logOutButton;
    
    UIBarButtonItem* sentButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(send)]; 
    self.navigationItem.rightBarButtonItem = sentButton;
    
    list=[[NSMutableArray alloc] initWithCapacity:0];
	
	// Twitter Initialization / Login Code Goes Here
    if(!_engine){  
        _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];  
        _engine.consumerKey    = kOAuthConsumerKey;  
        _engine.consumerSecret = kOAuthConsumerSecret;  
    }  	
    
    if(![_engine isAuthorized]){  
        UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:self];  
        
        if (controller){  
            [self presentModalViewController: controller animated: YES];  
        }  
    }
    
    NSLog(@"ipk viewDidLoad again");
    
}

- (void)viewDidUnload {
    listTableView = nil;
    list = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [listTableView release];
    [list release];
    [_engine release];
    [super dealloc];
}

//=============================================================================================================================
#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
    
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

//=============================================================================================================================
#pragma mark TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier {
	NSLog(@"Request %@ succeeded", requestIdentifier);
}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
}


//=============================================================================================================================
#pragma mark MGTwitterEngineDelegate
- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)identifier  
{
    [self performSelectorOnMainThread:@selector(appendTableWith:) withObject:statuses waitUntilDone:NO];
    NSLog(@"Got statuses:\r%@", statuses);
} 



//=============================================================================================================================
#pragma mark TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = [list count];
    return  count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tag=@"tag";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tag];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tag] autorelease];
    }   
    if([indexPath row] == ([list count])) {
        cell.textLabel.text=@"More..";
        cell.imageView.image = nil;
        cell.detailTextLabel.text = nil;
    }else {
        id tweet = [list objectAtIndex:[indexPath row]];
        id user = [tweet objectForKey:@"user"];        
        NSString* imageUrl = [[user objectForKey:@"profile_image_url"]copy];
        
        cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
        [imageUrl release];
        cell.textLabel.text = [user objectForKey:@"name"];
        cell.detailTextLabel.text = [tweet objectForKey:@"text"];
        cell.detailTextLabel.numberOfLines= 10;
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == [list count]) {
        UITableViewCell *loadMoreCell=[tableView cellForRowAtIndexPath:indexPath];
        loadMoreCell.textLabel.text=@"loading more …";
        [self performSelectorOnMainThread:@selector(loadMore) withObject:Nil waitUntilDone:NO];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    else{
        
        TSyncDetailViewController* detailViewController = [[TSyncDetailViewController alloc] init];        
        detailViewController.tweet = [[list objectAtIndex:[indexPath row]] copy];

        detailViewController.engine = [_engine autorelease];
        [self.navigationController pushViewController:detailViewController animated:YES];
        
        [detailViewController release];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == ([list count])) {
        return 50;
    }
    id tweet = [list objectAtIndex:[indexPath row]];
    NSString *cellText = [tweet objectForKey:@"text"];
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    int height= labelSize.height + 20;
    
    if(height < 70){
        height = 70;
    }
    return height;
}

@end
