//
//  SearchTableViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-9-28.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultItem.h"


@interface SearchTableViewController : UITableViewController<UISearchBarDelegate,UISearchDisplayDelegate>
{
    UISearchDisplayController *searchDisplayController;
    UISearchBar *searchBar;
    NSArray *historyItems;
    NSArray *searchResults;
    
    enum SearchResultType searchType;
}

@property (nonatomic, retain) IBOutlet UISearchDisplayController *searchDisplayController;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, copy) NSArray *historyItems;
@property (nonatomic, copy) NSArray *searchResults;

- (void)SetSearchOrganization;
- (void)SetSearchActivity;

@end
