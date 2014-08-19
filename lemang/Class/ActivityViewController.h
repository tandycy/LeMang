//
//  ActivityViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-7-29.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity.h"

@interface ActivityViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UIScrollViewDelegate>
{
//    IBOutlet ActivityTableViewController *ActivityList;
     NSMutableData *receivedData; 

}
@property (strong,nonatomic) NSArray *activityArray;

@property (strong,nonatomic) NSMutableArray *filteredActivityArray;

@property IBOutlet UISearchBar *activitySearchBar;
@property IBOutlet UITableView *activityList;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

-(IBAction)pageTurn:(UIPageControl *)sender;

@end
