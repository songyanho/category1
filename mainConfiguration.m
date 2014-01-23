//
//  mainConfiguration.m
//  category1
//
//  Created by Songyan on 1/18/14.
//  Copyright (c) 2014 AppBox Technology. All rights reserved.
//

#import "mainConfiguration.h"

@implementation mainConfiguration

@synthesize memberauth = _memberauth;
@synthesize membercode = _membercode;
@synthesize memberloginid = _memberloginid;
@synthesize memberuserid = _memberuserid;

- (NSString *)memberuserid{
    return ([[NSUserDefaults standardUserDefaults] valueForKeyPath:@"userid"])?[[NSUserDefaults standardUserDefaults] valueForKeyPath:@"userid"]:nil;
}

- (void)setMemberuserid:(NSString *)memberuserid{
    [[NSUserDefaults standardUserDefaults] setObject:_memberuserid forKey:@"userid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)memberloginid{
    return ([[NSUserDefaults standardUserDefaults] valueForKeyPath:@"loginid"])?[[NSUserDefaults standardUserDefaults] valueForKeyPath:@"loginid"]:nil;
}

- (void)setMemberloginid:(NSString *)memberloginid{
    [[NSUserDefaults standardUserDefaults] setObject:_memberloginid forKey:@"loginid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)memberQueue{
    return [NSString stringWithFormat:@"loginid=%@&auth=%@&code=%@&",self.memberloginid,self.memberauth,self.membercode];
}

- (NSString *)memberauth{
    return ([[NSUserDefaults standardUserDefaults] valueForKeyPath:@"auth"])?[[NSUserDefaults standardUserDefaults] valueForKeyPath:@"auth"]:nil;
}

- (void)setMemberauth:(NSString *)memberauth{
    [[NSUserDefaults standardUserDefaults] setObject:_memberauth forKey:@"auth"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)membercode{
    return ([[NSUserDefaults standardUserDefaults] valueForKeyPath:@"code"])?[[NSUserDefaults standardUserDefaults] valueForKeyPath:@"code"]:nil;
}

- (void)setMembercode:(NSString *)membercode{
    [[NSUserDefaults standardUserDefaults] setObject:_membercode forKey:@"code"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
