//
//  ActivityViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-7-29.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity.h"
#import "ActivityTableViewController.h"

@interface ActivityViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UIScrollViewDelegate>
{
//    IBOutlet ActivityTableViewController *ActivityList;

}
@property (strong,nonatomic) NSArray *activityArray;

@property (strong,nonatomic) NSMutableArray *filteredActivityArray;

@property IBOutlet UISearchBar *activitySearchBar;
@property IBOutlet UITableView *activityList;
@property IBOutlet UINavigationItem *question;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

-(IBAction)goToSearch:(id)sender;

-(IBAction)pageTurn:(UIPageControl *)sender;

@end
