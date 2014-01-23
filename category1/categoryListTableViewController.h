//
//  categoryListTableViewController.h
//  category1
//
//  Created by Songyan on 1/16/14.
//  Copyright (c) 2014 AppBox Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface categoryListTableViewController : UITableViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) NSArray *categories;
@property (strong,nonatomic) NSNumber *totalCategory;
@property (strong,nonatomic) NSNumber *currentPage;
@property (weak,nonatomic) NSIndexPath *selectedRow;
@end
