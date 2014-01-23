//
//  stroyboardCategoryListTableViewController.m
//  category1
//
//  Created by Songyan on 1/16/14.
//  Copyright (c) 2014 AppBox Technology. All rights reserved.
//

#import "stroyboardCategoryListTableViewController.h"
#import "categoryListTableViewController.h"
#import "storyboardProductTableViewController.h"
#import "mainConfiguration.h"

@interface stroyboardCategoryListTableViewController ()
@property (strong, nonatomic) IBOutlet UIRefreshControl *categoryRefreshControl;
@property (strong, nonatomic) IBOutlet UITableView *categoryListTable;

@end

@implementation stroyboardCategoryListTableViewController

- (IBAction)refreshControlPull:(UIRefreshControl *)sender {
    [self fetchData];
}

- (void) fetchData{
    [self.categoryRefreshControl beginRefreshing];
    mainConfiguration *mC = [[mainConfiguration alloc] init];
    dispatch_queue_t fetchCategoryQueue = dispatch_queue_create("fetchCategoryJSON", NULL);
    dispatch_async(fetchCategoryQueue , ^{
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://crmtest.appbox.com.my/products.apps.php"]]];
        NSString *post = [NSString stringWithFormat:@"%@&action=category",[mC memberQueue]];
        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [request setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPMethod:@"POST"];
        NSError *error = nil;
        NSURLResponse *response = nil;
        NSData *contentInJSON = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSDictionary *contentPropertyList = [NSJSONSerialization JSONObjectWithData:contentInJSON options:NSJSONReadingMutableContainers error:NULL];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.categoryRefreshControl endRefreshing];
            if([contentPropertyList valueForKeyPath:@"category"] != [NSNull null])
                self.categories = [[NSArray alloc]initWithArray:[contentPropertyList valueForKeyPath:@"category"]];
        });
    });
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title = @"Category";
    self.title = @"Category";
    [super viewWillAppear:animated];
    [self fetchData];
    self.selectedRow = nil;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.categoryListTable registerClass: [UITableViewCell class] forCellReuseIdentifier:@"Category List"];
}


@end
