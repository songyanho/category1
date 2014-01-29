//
//  imagePreviewViewController.m
//  category1
//
//  Created by Songyan on 1/26/14.
//  Copyright (c) 2014 AppBox Technology. All rights reserved.
//

#import "imagePreviewViewController.h"

@interface imagePreviewViewController ()
@property (strong, nonatomic) IBOutlet UIView *doneView;
@end

@implementation imagePreviewViewController

@synthesize imagesDataArray = _imagesDataArray;

- (void)setImagesDataArray:(NSArray *)imagesDataArray{
    [self.pisv setScrollViewContents:imagesDataArray];
    _imagesDataArray = imagesDataArray;
}

- (void)setCurrentImages:(NSUInteger)currentImages{
    [self.pisv scrollToPreviousPage:currentImages];
}


-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation)){
        self.pisv.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.pisv.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.pisv.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * [self.imagesDataArray count], self.pisv.scrollView.frame.size.height);
        CGFloat width = 10 * self.pisv.pageControl.numberOfPages;
        self.pisv.pageControl.frame = CGRectMake((self.pisv.scrollView.frame.size.width - width) / 2, self.pisv.scrollView.frame.size.height - 10, width, 10);
        NSUInteger count = 0;
        for (UIView *v1 in self.pisv.scrollView.subviews) {
            if ([v1 isKindOfClass:[UIImageView class]]) {
                v1.frame = CGRectMake(self.view.frame.size.width * count, 0, self.pisv.scrollView.frame.size.width, self.pisv.scrollView.frame.size.height - 10);
                count++;
            }
        }
    }else{
        CGFloat w = self.view.frame.size.width;
        CGFloat h = self.view.frame.size.height;
        self.pisv.frame = CGRectMake(self.pisv.frame.origin.x, self.pisv.frame.origin.y, h, h);
        self.pisv.scrollView.frame = CGRectMake(self.pisv.scrollView.frame.origin.x, self.pisv.scrollView.frame.origin.y, h, h);
        self.pisv.scrollView.contentSize = CGSizeMake(self.view.frame.size.height * [self.imagesDataArray count], h);
        CGFloat width = 10 * self.pisv.pageControl.numberOfPages;
        self.pisv.pageControl.frame = CGRectMake((h - width) / 2, w - 10, width, 10);
        NSUInteger count = 0;
        for (UIView *v1 in self.pisv.scrollView.subviews) {
            if ([v1 isKindOfClass:[UIImageView class]]) {
                v1.frame = CGRectMake(h * count, 0, h, w - 10);
                count++;
            }
        }
    }
    [self.pisv scrollToPreviousPage:self.pisv.pageControl.currentPage];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)doneButtonClick:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view addSubview:self.pisv];
    [self.view bringSubviewToFront:self.doneView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
