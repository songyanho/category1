//
//  mainTabBarViewController.m
//  category1
//
//  Created by Songyan on 1/16/14.
//  Copyright (c) 2014 AppBox Technology. All rights reserved.
//

#import "mainTabBarViewController.h"

@interface mainTabBarViewController ()
@property (retain,nonatomic) UIColor *navigationTintColor;
@end

@implementation mainTabBarViewController

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

- (void)viewWillAppear:(BOOL)animated{
    /*
    self.navigationController.navigationBarHidden = FALSE;
    self.navigationItem.hidesBackButton = TRUE;
    self.navigationTintColor = [UIColor colorWithRed:250.0 green:228.0 blue:157.0 alpha:0.8];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    */
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //self.navigationController.navigationBarHidden = FALSE;
}

@end
