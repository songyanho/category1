//
//  ProductDetailTableViewController.m
//  category1
//
//  Created by Songyan on 1/22/14.
//  Copyright (c) 2014 AppBox Technology. All rights reserved.
//

#import "ProductDetailTableViewController.h"
#import "ProductDetailCell.h"
#import "mainConfiguration.h"
#import "PagedImageScrollView.h"

@interface ProductDetailTableViewController ()
@property (strong,nonatomic) PagedImageScrollView *imageSlider;
@property (strong,nonatomic) NSDictionary *productBasic;
@property (strong,nonatomic) NSDictionary *productStock;
@property (strong,nonatomic) NSDictionary *productField;
@property (strong,nonatomic) NSDictionary *productImages;

@end

@implementation ProductDetailTableViewController

@synthesize productID = _productID;

# pragma mark - Synthesize

- (void)setProductName:(NSString *)productName{
    self.title = productName;
    self.navigationItem.title = productName;
}

- (void)setProductID:(NSString *)productID{
    if(![_productID isEqualToString:productID]){
        _productID = productID;
        [self fetchProductDetail];
    }
}

#pragma mark - fetchData / Update data
   
- (void)fetchProductDetail{
        mainConfiguration *mC = [[mainConfiguration alloc] init];
        dispatch_queue_t fetchCategoryQueue = dispatch_queue_create("fetchCategoryJSON", NULL);
        dispatch_async(fetchCategoryQueue , ^{
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://crmtest.appbox.com.my/products.apps.php"]]];
            NSString *post = [NSString stringWithFormat:@"%@action=productdetail&productid=%@", [mC memberQueue], self.productID];
            [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
            [request setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
            [request setHTTPMethod:@"POST"];
            NSError *error = nil;
            NSURLResponse *response = nil;
            NSData *contentInJSON = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            NSDictionary *contentPropertyList = [NSJSONSerialization JSONObjectWithData:contentInJSON options:NSJSONReadingMutableContainers error:NULL];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if(![contentPropertyList valueForKeyPath:@"error"]){
                    self.productBasic = [contentPropertyList valueForKeyPath:@"basic"];
                    self.productStock = [contentPropertyList valueForKeyPath:@"stock"];
                    self.productField = [contentPropertyList valueForKeyPath:@"field"];
                    self.productImages = [contentPropertyList valueForKeyPath:@"images"];
                    [self.tableView reloadData];
                }
            });
        });
    }

# pragma mark - table configuration 

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
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductDetailCell" bundle:nil] forCellReuseIdentifier:@"Product Detail Cell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)ta

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Product Detail Cell";
    if(indexPath.row == 1){
        ProductDetailCell *cell = (ProductDetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        return cell;
    }else{
        ProductDetailCell *cell = (ProductDetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.frame =
        return cell;
    }
    
    
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end