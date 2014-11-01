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
    enum SORT_TYPE_ENUM
    {
        SORT_AUTO,
        SORT_DATE,
        SORT_JOINCOUNT,
        SORT_TOP,
    };
    UISearchDisplayController *searchDisplayController;
    //UISearchBar *searchBar;
    
    enum SearchResultType searchType;
    
    bool isShowResult;
    NSString* keyword;
}

@property (nonatomic, retain) IBOutlet UISearchDisplayController *searchDisplayController;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;

- (void)SetSearchOrganization;
- (void)SetSearchActivity;
- (void)SetSearchOrganizationTag:(NSString*)tagstr;
- (void)SetSearchActivityTag:(NSString*)tagstr;

@end
