//
//  loginViewController.m
//  crm-test1
//
//  Created by Songyan on 1/9/14.
//  Copyright (c) 2014 AppBox Technology. All rights reserved.
//

#import "loginViewController.h"

@interface loginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *loginEmailInput;
@property (weak, nonatomic) IBOutlet UITextField *loginPasswordInput;
@property (retain, nonatomic) NSURLConnection *connection;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UILabel *loginInvalidLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loginActivityIndicator;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *checkloginActivityIndicator;
@property (strong, nonatomic) IBOutlet UIView *loginView;
@property (strong, nonatomic) IBOutlet UIView *loginLoadingView;
@end

@implementation loginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated{
    self.loginPasswordInput.text = NULL;
    self.loginEmailInput.text = NULL;
    NSUInteger delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [super viewWillAppear:animated];
        self.navigationController.navigationBarHidden = true;
    });
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self checkLoginAvailable];
}

- (void)checkLoginAvailable{
    self.loginLoadingView.hidden = false;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([userDefault valueForKeyPath:@"loginid"]){
    if([[NSString stringWithString:[userDefault valueForKeyPath:@"loginid"]] integerValue] > 0){
        dispatch_queue_t LoginMT = dispatch_queue_create("checkLogin", NULL);
        dispatch_async(LoginMT, ^(void){
            NSString *post =[[NSString alloc]
                             initWithFormat:@"action=checklogin&loginid=%@&auth=%@&code=%@",
                             [userDefault stringForKey:@"loginid"],
                             [userDefault stringForKey:@"auth"],
                             [userDefault stringForKey:@"code"]];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://crmtest.appbox.com.my/login.php"]];
            [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
            [request setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
            [request setHTTPMethod:@"POST"];
            NSError *error = nil;
            NSURLResponse *response = nil;
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            if (error) {
                NSLog(@"Error:%@", error.localizedDescription);
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    self.loginLoadingView.hidden = TRUE;
                    self.loginView.hidden = FALSE;
                });
            }
            else {
                NSDictionary *loginRequestJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSString *loginlogged = [NSString stringWithFormat:@"%@",[loginRequestJSON valueForKeyPath:@"logged"]];
                if([loginlogged isEqualToString:@"1"]){
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        if([[NSString stringWithFormat:@"%@",[userDefault objectForKey:@"userid"]] isEqualToString:[NSString stringWithFormat:@"%@",[loginRequestJSON valueForKeyPath:@"userid"]]]){
                            self.loginLoadingView.hidden = TRUE;
                            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                            [self performSegueWithIdentifier:@"login to maintab" sender:self];
                        }else{
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loginid"];
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userid"];
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"auth"];
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"code"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            self.loginLoadingView.hidden = TRUE;
                            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                            self.loginView.hidden = FALSE;
                        }
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loginid"];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userid"];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"auth"];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"code"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        self.loginLoadingView.hidden = TRUE;
                        self.loginView.hidden = FALSE;
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    });
                }
            }
        });
    }}else{
        self.loginLoadingView.hidden = TRUE;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        self.loginView.hidden = FALSE;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loginEmailInput.delegate = self;
    self.loginPasswordInput.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == self.loginEmailInput) {
		[self.loginEmailInput resignFirstResponder];
		[self.loginPasswordInput becomeFirstResponder];
	}
	else if (textField == self.loginPasswordInput) {
		[self.loginPasswordInput resignFirstResponder];
		[self.loginButton sendActionsForControlEvents:UIControlEventTouchDown];
	}
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    [self.view addGestureRecognizer:tapRecognizer];
    
}

- (void)tapDetected:(UITapGestureRecognizer *)tapRecognizer
{
    [self.loginEmailInput resignFirstResponder];
    [self.loginPasswordInput resignFirstResponder];
    [self.view removeGestureRecognizer:tapRecognizer];
}

- (IBAction)loginButtonClick:(id)sender {
    if(self.loginEmailInput.text.length == 0){
        [self.loginEmailInput becomeFirstResponder];
    }
    else if(self.loginPasswordInput.text.length == 0){
        [self.loginEmailInput becomeFirstResponder];
    }
    else{
        [self.loginActivityIndicator startAnimating];
        dispatch_queue_t LoginMT = dispatch_queue_create("login", NULL);
        dispatch_async(LoginMT, ^(void){
            NSString *post =[[NSString alloc] initWithFormat:@"action=login&email=%@&password=%@",self.loginEmailInput.text,self.loginPasswordInput.text];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://crmtest.appbox.com.my/login.php"]];
            [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
            [request setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
            [request setHTTPMethod:@"POST"];
            NSError *error = nil;
            NSURLResponse *response = nil;
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    NSLog(@"Error:%@", error.localizedDescription);
                    [self.loginActivityIndicator stopAnimating];
                });
            }
            else {
                NSDictionary *loginRequestJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSString *loginlogged = [NSString stringWithFormat:@"%@",[loginRequestJSON valueForKeyPath:@"logged"]];
                if([loginlogged isEqualToString:@"1"]){
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[loginRequestJSON valueForKeyPath:@"userid"]] forKey:@"userid"];
                        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[loginRequestJSON valueForKeyPath:@"loginid"]] forKey:@"loginid"];
                        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[loginRequestJSON valueForKeyPath:@"auth"]] forKey:@"auth"];
                        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[loginRequestJSON valueForKeyPath:@"code"]] forKey:@"code"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [self performSegueWithIdentifier:@"login to maintab" sender:self];
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        self.loginInvalidLabel.hidden = FALSE;
                        CAKeyframeAnimation *scaleAnimation =
                        [CAKeyframeAnimation animationWithKeyPath:@"transform"];
                        scaleAnimation.delegate = self;
                        CATransform3D transform = CATransform3DMakeScale(1.5, 1.5, 1);
                        [scaleAnimation setValues:[NSArray arrayWithObjects:
                                                   [NSValue valueWithCATransform3D:CATransform3DIdentity],
                                                   [NSValue valueWithCATransform3D:transform],
                                                   [NSValue valueWithCATransform3D:CATransform3DIdentity],
                                                   nil]];
                        [scaleAnimation setDuration: 0.5];
                        [[self.loginInvalidLabel layer] addAnimation:scaleAnimation forKey:@"scaleText"];
                        [self.loginActivityIndicator stopAnimating];
                    });
                }
            }
        });
    }
}

@end
