//
//  ViewController.m
//  category1
//
//  Created by Songyan on 1/16/14.
//  Copyright (c) 2014 AppBox Technology. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) MPMoviePlayerController *moviePlayerController;

@end

@implementation ViewController
@synthesize moviePlayerController = _moviePlayerController;

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    [self.moviePlayerController.view setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.moviePlayerController.view removeFromSuperview];
    [self.view addSubview:self.moviePlayerController.view];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlaybackComplete:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.moviePlayerController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    NSString *filepath   =   [[NSBundle mainBundle] pathForResource:@"Untitled" ofType:@"mp4"];
    NSURL    *fileURL    =   [NSURL fileURLWithPath:filepath];
    self.moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];
    UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(UIInterfaceOrientationIsPortrait(currentOrientation)){
        [self.moviePlayerController.view setFrame:CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width)];
    }else{
        [self.moviePlayerController.view setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    }
    self.moviePlayerController.controlStyle = MPMovieControlStyleFullscreen;
    self.moviePlayerController.scalingMode = MPMovieScalingModeAspectFit;
    self.moviePlayerController.controlStyle =MPMovieControlStyleNone;
    [self.view addSubview:self.moviePlayerController.view];
    self.moviePlayerController.fullscreen = YES;
    [self.moviePlayerController prepareToPlay];
    [self.moviePlayerController play];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlaybackComplete:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.moviePlayerController];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillAppear:animated];
}

- (void)moviePlaybackComplete:(NSNotification *)notification
{
    MPMoviePlayerController *moviePlayerController = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayerController];
    [moviePlayerController.view removeFromSuperview];
    moviePlayerController = nil;
    self.moviePlayerController = nil;
    //mainTabBarViewController *tabBarController = [[mainTabBarViewController alloc]init];
    //[self.navigationController pushViewController:catTable animated:TRUE];
    [self performSegueWithIdentifier: @"trailer to login" sender: self];
}

@end
