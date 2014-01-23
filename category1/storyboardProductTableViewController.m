//
//  storyboardProductTableViewController.m
//  category1
//
//  Created by Songyan on 1/19/14.
//  Copyright (c) 2014 AppBox Technology. All rights reserved.
//

#import "storyboardProductTableViewController.h"
#import "productTableViewController.h"
#import "mainConfiguration.h"

@interface storyboardProductTableViewController ()

@property (strong, nonatomic) IBOutlet UIRefreshControl *productListRefreshControll;
@property (strong, nonatomic) IBOutlet UITableView *productListTable;

@end

@implementation storyboardProductTableViewController

#define SITE_URL @"http://crmtest.appbox.com.my/"

@synthesize categoryIdentifier = _categoryIdentifier;
@synthesize categoryName = _categoryName;

- (void)setCategoryName:(NSString *)categoryName{
    _categoryName = categoryName;
    self.title = _categoryName;
    self.navigationItem.title = _categoryName;
}

- (void)setCategoryIdentifier:(NSString *)categoryIdentifier{
    _categoryIdentifier = categoryIdentifier;
    [self fetchProductListData];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)fetchProductListData{
    mainConfiguration *mC = [[mainConfiguration alloc] init];
    [self.productListRefreshControll beginRefreshing];
    dispatch_queue_t fetchCategoryQueue = dispatch_queue_create("fetchCategoryJSON", NULL);
    dispatch_async(fetchCategoryQueue , ^{
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://crmtest.appbox.com.my/products.apps.php"]]];
        NSString *post = [NSString stringWithFormat:@"%@action=productwithcategory&category=%@", [mC memberQueue], self.categoryIdentifier];
        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [request setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPMethod:@"POST"];
        NSError *error = nil;
        NSURLResponse *response = nil;
        NSData *contentInJSON = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSDictionary *contentPropertyList = [NSJSONSerialization JSONObjectWithData:contentInJSON options:NSJSONReadingMutableContainers error:NULL];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.productListRefreshControll endRefreshing];
            if(![contentPropertyList valueForKeyPath:@"error"])
                self.productListArray = [[NSArray alloc]initWithArray:[contentPropertyList valueForKeyPath:@"products"]];
        });
    });
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.productListTable registerClass: [UITableViewCell class] forCellReuseIdentifier:@"Product List"];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title = self.categoryName;
    self.title = self.categoryName;
    [super viewWillAppear:animated];
    [self fetchProductListData];
    self.selectedIndexPath = nil;
}



@end
