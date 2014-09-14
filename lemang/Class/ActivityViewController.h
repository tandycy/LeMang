//
//  ActivityViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-7-29.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity.h"
#import "UserManager.h"
#import "ASIHTTPRequest.h"

@interface ActivityViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UIScrollViewDelegate>
{
//    IBOutlet ActivityTableViewController *ActivityList;
   // NSMutableData *receivedData;
   // NSArray* activityData;

    int currentPage;
    int nextPage;
    int pageSize;
    int maxPage;
    
    UIImage* bussinessIcon;
    UIImage* schoolIcon;
    UIImage* groupIcon;
    UIImage* privateIcon;
    
}
@property (strong,nonatomic) NSMutableArray *activityArray;

@property (strong,nonatomic) NSMutableArray *filteredActivityArray;

@property IBOutlet UISearchBar *activitySearchBar;
@property IBOutlet UITableView *activityList;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

-(IBAction)pageTurn:(UIPageControl *)sender;

@end
