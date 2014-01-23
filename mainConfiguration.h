//
//  mainConfiguration.h
//  category1
//
//  Created by Songyan on 1/18/14.
//  Copyright (c) 2014 AppBox Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface mainConfiguration : NSObject

@property (strong,nonatomic) NSString *memberQueue;
@property (strong,nonatomic) NSString *memberauth;
@property (strong,nonatomic) NSString *membercode;
@property (strong,nonatomic) NSString *memberloginid;
@property (strong,nonatomic) NSString *memberuserid;

- (NSData *)performHttpPost:(NSString *)postData action:(NSString *)postUrl isMember:(NSUInteger) isMember;

@end
