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
@property (strong,nonatomic) NSDictionary *productBasic;
@property (strong,nonatomic) NSDictionary *productStock;
@property (strong,nonatomic) NSArray *productField;
@property (strong,nonatomic) NSArray *productImages;
@property (strong,nonatomic) PagedImageScrollView *pageScrollView;
@property (nonatomic) NSUInteger totalImageCount;
@property (strong,nonatomic) NSMutableArray *productImagesDataArray;
@property Boolean rotating;
@end

@implementation ProductDetailTableViewController

@synthesize productID = _productID;

#pragma -mark - Rotation

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    self.rotating = TRUE;
    [self.tableView reloadData];
}

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
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductDetailCell" bundle:nil] forCellReuseIdentifier:@"Product Detail Cell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Product Image Cell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 190;
    }else{
        return 150;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        static NSString *CellIdentifier = @"Product Image Cell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if(((!self.pageScrollView)||(self.rotating))&&([self.productImages count] > 0)){
            CGFloat currentpage = 0;
            if(self.pageScrollView){
                if(self.pageScrollView.pageControl.currentPage)
                    currentpage = self.pageScrollView.pageControl.currentPage;
            }
            self.totalImageCount = [self.productImages count];
            for (NSDictionary *productImageDictionary in self.productImages) {
                NSURL *thisImageUrl = [NSURL URLWithString:[productImageDictionary valueForKeyPath:@"imageurl"]];
                dispatch_queue_t fetchCategoryQueue = dispatch_queue_create("fetchImage", NULL);
                dispatch_async(fetchCategoryQueue , ^{
                    UIImage *thisReturnImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:thisImageUrl]];
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        [self updateImageSlider:thisReturnImage];
                    });
                });
            }
            //self.pageScrollView = [[PagedImageScrollView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 180)];
            
            if((currentpage > 0) &&(self.rotating)){
                [self.pageScrollView scrollToPreviousPage:currentpage];
            }
            self.rotating = FALSE;
        }
        [cell addSubview:self.pageScrollView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        return cell;
    }else{
        static NSString *CellIdentifier = @"Product Detail Cell";
        ProductDetailCell *cell = (ProductDetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        //cell.contentMode = UIViewContentModeScaleToFill;
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        return cell;
    }
}

- (void)updateImageSlider:(UIImage *)thisImage{
    if(!self.productImagesDataArray)
        self.productImagesDataArray = [[NSMutableArray alloc] init];
    [self.productImagesDataArray addObject:thisImage];
    if([self.productImagesDataArray count] == self.totalImageCount){
        self.pageScrollView = [[PagedImageScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
        [self.pageScrollView setScrollViewContents:self.productImagesDataArray];
        [self.tableView reloadData];
    }
    //self.pageScrollView = [[PagedImageScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
    //[self.pageScrollView setScrollViewContents:@[[UIImage imageNamed:@"logo1"],[UIImage imageNamed:@"logo2"]]];
    
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
