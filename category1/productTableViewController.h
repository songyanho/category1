//
//  productTableViewController.h
//  category1
//
//  Created by Songyan on 1/19/14.
//  Copyright (c) 2014 AppBox Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface productTableViewController : UITableViewController <UITableViewDelegate,UITableViewDataSource>
@property (retain,nonatomic) NSString *categoryIdentifier;
@property (retain,nonatomic) NSString *categoryName;
@property (strong,nonatomic) NSArray *productListArray;
@property (weak,nonatomic) NSIndexPath *selectedIndexPath;
@end
