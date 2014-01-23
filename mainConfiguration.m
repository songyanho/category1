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
/*
- (NSData *)performHttpPost:(NSString *)postData action:(NSString *)postShortUrl isMember:(NSUInteger) isMember{
    __block NSData *responseFromHttp = nil;
    NSURL *postUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://crmtest.appbox.com.my/%@", postShortUrl]];
    dispatch_queue_t customMT = dispatch_queue_create("customMT", NULL);
    dispatch_async(customMT, ^(void){
        NSString *post;
        if(isMember == 1){
            post = [NSString stringWithFormat:@"%@%@",self.memberQueue,postData];
        }else{
            post = [NSString stringWithString:postData];
        }
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postUrl];
        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [request setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPMethod:@"POST"];
        NSError *error = nil;
        NSURLResponse *response = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (!error){
            responseFromHttp = [NSData dataWithData: data];
        }
    });
    return responseFromHttp;
}
*/
@end
