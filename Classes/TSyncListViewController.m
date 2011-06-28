//
//  TSyncListViewController.m
//  TwitterRush
//
//  Created by Ljw on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TSyncListViewController.h"
#import "SA_OAuthTwitterEngine.h"
#import "TSyncDetailViewController.h"

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

-(IBAction)logOutAction{
    NSLog(@"Log Out");
    [_engine clearAccessToken];
    UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:self];  
    
    if (controller){  
        [self presentModalViewController: controller animated: YES];  
    } 
}

#pragma mark ViewController Lifecycle

- (void)viewDidAppear: (BOOL)animated {
    //[_engine initWithDelegate:self];
    NSLog(@"ipk animated again,engine:%@",_engine);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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
    sinceID = [_engine getFollowedTimelineSinceID:sinceID startingAtPage:1 count:5];
    
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
        cell=[[[UITableViewCell alloc] initWithFrame:CGRectZero
                                     reuseIdentifier:tag] autorelease];
    }   
    if([indexPath row] == ([list count])) {
        cell.textLabel.text=@"More..";
    }else {
        cell.textLabel.text=[[list objectAtIndex:[indexPath row]] objectForKey:@"text"];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == [list count]) {
        UITableViewCell *loadMoreCell=[tableView cellForRowAtIndexPath:indexPath];
        loadMoreCell.textLabel.text=@"loading more …";
        //[self performSelectorInBackground:@selector(loadMore) withObject:nil];
        //[tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [self performSelectorOnMainThread:@selector(loadMore) withObject:Nil waitUntilDone:NO];
        
        return;
    }
    else{
        TSyncDetailViewController* detailViewController = [[TSyncDetailViewController alloc] init];
        
        detailViewController.tweet = [[list objectAtIndex:[indexPath row]] copy];
        //SA_OAuthTwitterEngine* test = _engine;
        //detailViewController.test = test;
        [self.navigationController pushViewController:detailViewController animated:YES];
        
        [detailViewController release];
        
    }
    
}

//=============================================================================================================================
#pragma mark My method
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

@end

