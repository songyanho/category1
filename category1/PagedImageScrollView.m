//
//  PagedImageScrollView.m
//  Test
//
//  Created by jianpx on 7/11/13.
//  Copyright (c) 2013 PS. All rights reserved.
//

#import "PagedImageScrollView.h"

@interface PagedImageScrollView() <UIScrollViewDelegate>
@property (nonatomic) BOOL pageControlIsChangingPage;
@end

@implementation PagedImageScrollView


#define PAGECONTROL_DOT_WIDTH 10
#define PAGECONTROL_HEIGHT 10

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self.scrollView removeFromSuperview];
    [self.pageControl removeFromSuperview];
    if (self) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
        self.pageControl = [[UIPageControl alloc] init];
        [self setDefaults];
        [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        
        self.scrollView.delegate = self;
    }
    return self;
}


- (void)setPageControlPos:(enum PageControlPosition)pageControlPos
{
    CGFloat width = PAGECONTROL_DOT_WIDTH * self.pageControl.numberOfPages;
    _pageControlPos = pageControlPos;
    if (pageControlPos == PageControlPositionRightCorner)
    {
        self.pageControl.frame = CGRectMake(self.scrollView.frame.size.width - width, self.scrollView.frame.size.height - PAGECONTROL_HEIGHT, width, PAGECONTROL_HEIGHT);
    }else if (pageControlPos == PageControlPositionCenterBottom)
    {
        self.pageControl.frame = CGRectMake((self.scrollView.frame.size.width - width) / 2, self.scrollView.frame.size.height - PAGECONTROL_HEIGHT, width, PAGECONTROL_HEIGHT);
    }else if (pageControlPos == PageControlPositionLeftCorner)
    {
        self.pageControl.frame = CGRectMake(0, self.scrollView.frame.size.height - PAGECONTROL_HEIGHT, width, PAGECONTROL_HEIGHT);
    }
    [self addSubview:self.pageControl];
}

- (void)setDefaults
{
    self.pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.hidesForSinglePage = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.pageControlPos = PageControlPositionCenterBottom;
}

- (void)presetLoadingActivityIndicator:(NSUInteger)imageCount{
    for (UIView *subview in [self.scrollView subviews]) {
        [subview removeFromSuperview];
    }
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * imageCount, self.scrollView.frame.size.height);
    for (int i = 0; i < imageCount; i++) {
        UIView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        imageView.backgroundColor = [UIColor whiteColor];
        UIActivityIndicatorView *imageLoadingActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        imageLoadingActivityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        imageLoadingActivityIndicator.center = imageView.center;
        imageLoadingActivityIndicator.hidesWhenStopped = false;
        [imageLoadingActivityIndicator startAnimating];
        [imageView addSubview:imageLoadingActivityIndicator];
        [imageView setFrame:CGRectMake(self.scrollView.frame.size.width * i, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        [self.scrollView addSubview:imageView];
    }
    self.pageControl.numberOfPages = imageCount;
    [self addSubview:self.scrollView];
    self.pageControlPos = self.pageControlPos;
}

- (void)setScrollViewContents: (NSArray *)images
{
    for (UIView *subview in [self.scrollView subviews]) {
        [subview removeFromSuperview];
    }
    if (images.count == 0) {
        self.pageControl.numberOfPages = 0;
        return;
    }
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * images.count, self.scrollView.frame.size.height);
    for (int i = 0; i < images.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width * i, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        imageView.backgroundColor = [UIColor whiteColor];
        [imageView setImage:images[i]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.scrollView addSubview:imageView];
    }
    self.pageControl.numberOfPages = images.count;
    [self addSubview:self.scrollView];
    self.pageControlPos = self.pageControlPos;
}

- (void)changePage:(UIPageControl *)sender
{
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    self.pageControlIsChangingPage = YES;
}

#pragma scrollviewdelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.pageControlIsChangingPage) {
        return;
    }
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (void)scrollToPreviousPage:(CGFloat)previouspage{
    CGRect frame = self.scrollView.frame;
    //self.pageControl.currentPage = previouspage;
    frame.origin.x = frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    self.pageControlIsChangingPage = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControlIsChangingPage = NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.pageControlIsChangingPage = NO;
}

@end
