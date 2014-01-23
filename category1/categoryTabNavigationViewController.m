//
//  categoryTabNavigationViewController.m
//  category1
//
//  Created by Songyan on 1/19/14.
//  Copyright (c) 2014 AppBox Technology. All rights reserved.
//

#import "categoryTabNavigationViewController.h"

@interface categoryTabNavigationViewController ()

@end

@implementation categoryTabNavigationViewController

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
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
