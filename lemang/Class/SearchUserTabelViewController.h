//
//  SearchUserTabelViewController.h
//  LeMang
//
//  Created by LZ on 10/9/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"

@interface SearchUserTabelViewController : UITableViewController <UISearchBarDelegate>
{
    
}

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@end
