//
//  TSyncListViewController.h
//  TSync
//
//  Created by Ljw on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SA_OAuthTwitterController.h"
#import "MGTwitterEngine.h"
@class SA_OAuthTwitterEngine;

@interface TSyncListViewController : UIViewController <SA_OAuthTwitterControllerDelegate,MGTwitterEngineDelegate>
{ 
    
    SA_OAuthTwitterEngine*  _engine;
    unsigned long           sinceID;
    NSMutableArray*         list; 
    IBOutlet UITableView*   listTableView;
	
}

@property (nonatomic,assign) unsigned long      sinceID;
@property (nonatomic,retain) NSMutableArray*    list;
@property (nonatomic,retain) UITableView*       listTableView;

@end
