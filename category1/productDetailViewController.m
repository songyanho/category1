//
//  productDetailViewController.m
//  category1
//
//  Created by Songyan on 1/19/14.
//  Copyright (c) 2014 AppBox Technology. All rights reserved.
//

#import "productDetailViewController.h"
#import "mainConfiguration.h"
#import "PagedImageScrollView.h"

@interface productDetailViewController ()
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIView *loadingProductDetail;
@property (strong,nonatomic) NSDictionary *productPropertyList;
@property (strong,nonatomic) UIScrollView *scrollView;
@end

@implementation productDetailViewController

#define SITE_URL @"http://crmtest.appbox.com.my/"

@synthesize productID = _productID;

- (void)setProductName:(NSString *)productName{
    self.title = productName;
    self.navigationItem.title = productName;
}

- (void)setProductID:(NSString *)productID{
    if(![_productID isEqualToString:productID]){
        [[self.mainView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        _productID = productID;
        [self fetchProductDetail];
    }
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    if((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)||(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)){
        [self.scrollView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.scrollView.bounds.size.height)];
    }else{
        [self.scrollView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    }
    UIScrollView *tmpView = self.scrollView;
    tmpView.contentMode = UIViewContentModeScaleAspectFill;
    [self.scrollView removeFromSuperview];
    [self.view addSubview:tmpView];
}

- (void)updateViewController{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.scrollView.contentSize = CGSizeMake(320, 900);
    self.scrollView.scrollEnabled = YES;
    self.scrollView.clipsToBounds = YES;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView.minimumZoomScale = 1;  // You will have to set some values for these
    self.scrollView.maximumZoomScale = 2.0;
    self.scrollView.zoomScale = 1;
    self.scrollView.contentMode = UIViewContentModeScaleAspectFill;
    
    PagedImageScrollView *pageScrollView = [[PagedImageScrollView alloc] initWithFrame:CGRectMake(0, 50, 320, 120)];
    [pageScrollView setScrollViewContents:@[[UIImage imageNamed:@"xyq.jpeg"], [UIImage imageNamed:@"x2.jpeg"], [UIImage imageNamed:@"xyq.jpeg"], [UIImage imageNamed:@"x2.jpeg"]]];
    [self.scrollView addSubview:pageScrollView];
    
    UIImageView *myImageView = [[UIImageView alloc] init];
    UIImage *picture = [UIImage imageNamed:@"The-Secret-Life-of-Walter-Mitty-1.png"];
    myImageView.image = picture;
    myImageView.frame = CGRectMake(0, 50, 320, 320);
    myImageView.contentMode = UIViewContentModeScaleToFill;
    [self.scrollView addSubview:myImageView];
    self.scrollView.contentMode = UIViewContentModeScaleAspectFill;
    [self.mainView addSubview:self.scrollView];
}

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
                self.productPropertyList = contentPropertyList;
                self.loadingProductDetail.hidden = TRUE;
                [self updateViewController];
            }
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.loadingProductDetail.hidden = FALSE;
}

@end
