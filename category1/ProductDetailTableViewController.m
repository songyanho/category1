//
//  ProductDetailTableViewController.m
//  category1
//
//  Created by Songyan on 1/22/14.
//  Copyright (c) 2014 AppBox Technology. All rights reserved.
//

#import "ProductDetailTableViewController.h"
#import "ProductDetailCell.h"
#import "ProductFieldCell.h"
#import "mainConfiguration.h"
#import "PagedImageScrollView.h"
#import "imagePreviewViewController.h"

@interface ProductDetailTableViewController ()
@property (strong,nonatomic) NSDictionary *productBasic;
@property (strong,nonatomic) NSDictionary *productStock;
@property (strong,nonatomic) NSArray *productField;
@property (strong,nonatomic) NSArray *productImages;
@property (strong,nonatomic) PagedImageScrollView *pageScrollView;
@property (nonatomic) NSUInteger totalImageCount;
@property (strong,nonatomic) NSMutableArray *productImagesDataArray;
@property (strong,nonatomic) UIActivityIndicatorView *imageLoadingActivityIndicator;
@property (strong,nonatomic) UIActivityIndicatorView *dataLoadingActivityIndicator;
@property Boolean rotating;

@property (strong,nonatomic) UILabel *productNameLabel;

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
    self.pageScrollView = nil;
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductDetailCell" bundle:nil] forCellReuseIdentifier:@"Product Detail Cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductFieldCell" bundle:nil] forCellReuseIdentifier:@"Product Field Cell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Product Image Cell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self fetchProductDetail];
    [self didRotateFromInterfaceOrientation:self.interfaceOrientation];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.productField.count + 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if((indexPath.row == 0)){
        UILabel *productNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 185.0, self.view.frame.size.width, 10)];
        [productNameLabel setNumberOfLines:0];
        [productNameLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [productNameLabel setTag:1];
        productNameLabel.text = [self.productBasic valueForKeyPath:@"name"];
        [productNameLabel setTextAlignment:NSTextAlignmentCenter];
        [productNameLabel sizeToFit];
        if (([self.productImages count] > 0)) {
            
            return (190 + productNameLabel.frame.size.height + 5);
        }else{
            return ( 5 + productNameLabel.frame.size.height + 5);
        }
    }else if((indexPath.row == 1)){
        return 70;
    }else{
        CGFloat accumulateHeight = 0;
        accumulateHeight += 15;
        NSUInteger currentRow = indexPath.row - 2;
        NSDictionary *currentFieldPropertyList = [self.productField objectAtIndex:currentRow];
        UILabel *tFieldTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.view.frame.size.width - 40, 10)];
        tFieldTitle.text = [currentFieldPropertyList valueForKeyPath:@"customfieldname"];
        [tFieldTitle sizeToFit];
        if(tFieldTitle.frame.size.width >= self.view.frame.size.width - 40){
            accumulateHeight += tFieldTitle.frame.size.height;
        }else{
            accumulateHeight += 21;
        }
        UITextView *tFieldContent = [[UITextView alloc]initWithFrame:CGRectMake(20, accumulateHeight, self.view.frame.size.width, 1)];
        tFieldContent.text = [currentFieldPropertyList valueForKeyPath:@"fieldvalue"];
        CGSize sizeThatShouldFitTheContent = [tFieldContent sizeThatFits:tFieldContent.frame.size];
        accumulateHeight += sizeThatShouldFitTheContent.height;
        return accumulateHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if((indexPath.row == 0)){
        static NSString *CellIdentifier = @"Product Image Cell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath]; // forIndexPath:indexPath
        if (([self.productImages count] > 0)) {
            self.totalImageCount = [self.productImages count];
            if(!self.pageScrollView){
                self.pageScrollView = [[PagedImageScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
                [self.pageScrollView presetLoadingActivityIndicator:self.totalImageCount];
                /*
                self.pageScrollView.scrollView.hidden = true;
                
                self.imageLoadingActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                self.imageLoadingActivityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
                self.imageLoadingActivityIndicator.center = self.pageScrollView.center;
                self.imageLoadingActivityIndicator.hidesWhenStopped = false;
                [self.imageLoadingActivityIndicator startAnimating];
                [self.pageScrollView addSubview:self.imageLoadingActivityIndicator];
                */
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
                [self.productNameLabel removeFromSuperview];
                self.productNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 185.0, cell.frame.size.width, 10)];
                [self.productNameLabel setNumberOfLines:0];
                [self.productNameLabel setLineBreakMode:NSLineBreakByWordWrapping];
                [self.productNameLabel setTag:1];
                self.productNameLabel.text = [self.productBasic valueForKeyPath:@"name"];
                [self.productNameLabel setTextAlignment:NSTextAlignmentCenter];
                [self.productNameLabel sizeToFit];
                [self.productNameLabel setFrame:CGRectMake(0, 185.0, cell.frame.size.width, self.productNameLabel.frame.size.height)];
                [cell addSubview:self.productNameLabel];
                [cell addSubview:self.pageScrollView];
                [self.imageLoadingActivityIndicator startAnimating];
            }else{
                CGFloat currentpage = self.pageScrollView.pageControl.currentPage;
                if((self.rotating)){
                    self.pageScrollView.frame = CGRectMake(self.pageScrollView.frame.origin.x, self.pageScrollView.frame.origin.y, cell.frame.size.width, self.pageScrollView.frame.size.height);
                    self.pageScrollView.scrollView.frame = CGRectMake(self.pageScrollView.scrollView.frame.origin.x, self.pageScrollView.scrollView.frame.origin.y, cell.frame.size.width, self.pageScrollView.scrollView.frame.size.height);
                    self.pageScrollView.scrollView.contentSize = CGSizeMake(cell.frame.size.width * self.totalImageCount, self.pageScrollView.scrollView.frame.size.height);
                    NSUInteger count = 0;
                    for (UIView *v1 in self.pageScrollView.scrollView.subviews) {
                        if ([v1 isKindOfClass:[UIImageView class]]) {
                            v1.frame = CGRectMake(self.view.bounds.size.width * count, v1.frame.origin.y, cell.frame.size.width, v1.frame.size.height);
                            count++;
                        }
                    }
                    
                    CGFloat width = 10 * self.pageScrollView.pageControl.numberOfPages;
                    self.pageScrollView.pageControl.frame = CGRectMake((self.pageScrollView.scrollView.frame.size.width - width) / 2, self.pageScrollView.scrollView.frame.size.height - 10, width, 10);
                    [self.pageScrollView scrollToPreviousPage:currentpage];
                    self.productNameLabel.frame = CGRectMake(0, 185, cell.frame.size.width, self.productNameLabel.frame.size.height);
                    self.imageLoadingActivityIndicator.center = self.pageScrollView.center;
                    self.rotating = FALSE;
                }
            }
        }else{
            if(self.rotating){
                self.productNameLabel.frame = CGRectMake(0, 5, cell.frame.size.width, self.productNameLabel.frame.size.height);
                self.rotating = FALSE;
            }else{
                [self.productNameLabel removeFromSuperview];
                self.productNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5.0, cell.frame.size.width, 10)];
                [self.productNameLabel setNumberOfLines:0];
                [self.productNameLabel setLineBreakMode:NSLineBreakByWordWrapping];
                [self.productNameLabel setTag:1];
                self.productNameLabel.text = [self.productBasic valueForKeyPath:@"name"];
                [self.productNameLabel setTextAlignment:NSTextAlignmentCenter];
                [self.productNameLabel sizeToFit];
                [self.productNameLabel setFrame:CGRectMake(0, 5.0, cell.frame.size.width, self.productNameLabel.frame.size.height)];
                [cell addSubview:self.productNameLabel];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        [cell layoutIfNeeded];
        
        return cell;
    }else if((indexPath.row == 1)){
        static NSString *CellIdentifier = @"Product Detail Cell";
        ProductDetailCell *cell = (ProductDetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.quantityLabel.text = [NSString stringWithFormat:@"%@ left",[self.productStock valueForKeyPath:@"stock"]];
        cell.priceLabel.text = [NSString stringWithFormat:@"%@ %@",[self.productStock valueForKeyPath:@"currency"],[self.productStock valueForKeyPath:@"price"]];
        return cell;
    }else{
        CGFloat accumulateHeight = 0;
        accumulateHeight += 15;
        NSUInteger currentRow = indexPath.row - 2;
        NSDictionary *currentFieldPropertyList = [self.productField objectAtIndex:currentRow];
        static NSString *CellIdentifier = @"Product Field Cell";
        ProductFieldCell *cell = (ProductFieldCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        [cell.fieldTitle setFrame:CGRectMake(20, 10, self.view.frame.size.width - 40, 10)];
        cell.fieldTitle.text = [currentFieldPropertyList valueForKeyPath:@"customfieldname"];
        [cell.fieldTitle setLineBreakMode: NSLineBreakByWordWrapping];
        [cell.fieldTitle setTextAlignment:NSTextAlignmentLeft];
        cell.fieldTitle.textColor=[UIColor blackColor];
        cell.fieldTitle.tag=1;
        cell.fieldTitle.numberOfLines = 1;
        [cell.fieldTitle sizeToFit];
        if(cell.fieldTitle.frame.size.width >= self.view.frame.size.width - 40){
            accumulateHeight += cell.fieldTitle.frame.size.height;
        }else
            accumulateHeight += 21;
        //[cell.fieldTitle setFrame:CGRectMake(20, 10, self.view.frame.size.width - 40, cell.fieldTitle.frame.size.height)];
        NSLog([NSString stringWithFormat:@"%.1f %.1f %.1f",cell.fieldTitle.frame.size.height, cell.fieldTitle.frame.size.width,accumulateHeight]);
        [cell.fieldContent setFrame:CGRectMake(20, accumulateHeight - 50, self.view.frame.size.width, 1)];
        cell.fieldContent.text = [currentFieldPropertyList valueForKeyPath:@"fieldvalue"];
        CGSize sizeThatShouldFitTheContent = [cell.fieldContent sizeThatFits:cell.fieldContent.frame.size];
        [cell.fieldContent setFrame:CGRectMake(20, accumulateHeight, self.view.frame.size.width, sizeThatShouldFitTheContent.height)];
        return cell;
    }
}

- (void)updateImageSlider:(UIImage *)thisImage{
    if(!self.productImagesDataArray)
        self.productImagesDataArray = [[NSMutableArray alloc] init];
    if(thisImage == nil){return;}
    [self.productImagesDataArray addObject:thisImage];
    if([self.productImagesDataArray count] == self.totalImageCount){
        [self.pageScrollView setScrollViewContents:self.productImagesDataArray];
        [self.imageLoadingActivityIndicator stopAnimating];
        [self.imageLoadingActivityIndicator removeFromSuperview];
        self.pageScrollView.scrollView.hidden = false;
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(zoomInImages:)];
        [tapRecognizer setNumberOfTouchesRequired:1];
        [tapRecognizer setDelegate:self];
        for (UIView *iv in self.pageScrollView.scrollView.subviews) {
            if([iv isKindOfClass:[UIImageView class]]){
                iv.userInteractionEnabled = YES;
                [iv addGestureRecognizer:tapRecognizer];
            }
        }
        [self.pageScrollView addGestureRecognizer:tapRecognizer];
        [self.pageScrollView.scrollView addGestureRecognizer:tapRecognizer];
        [self.tableView reloadData];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"product detail to image view"]){
        if([segue.destinationViewController isKindOfClass:[imagePreviewViewController class]]){
            [self openImagePreviewView:segue.destinationViewController imagesDataArray:self.productImagesDataArray currentImages:self.pageScrollView.pageControl.currentPage];
        }
    }
}

- (void)openImagePreviewView:(imagePreviewViewController *)ipvc imagesDataArray:(NSArray *)imagesDataArray currentImages:(NSUInteger) currentImages{
    ipvc.pisv = [[PagedImageScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    ipvc.imagesDataArray = self.productImagesDataArray;
    ipvc.currentImages = self.pageScrollView.pageControl.currentPage;
}

#pragma mark - Click on images to zoom

- (void)zoomInImages:(id) sender{
    [self performSegueWithIdentifier:@"product detail to image view" sender:self];
}

@end
