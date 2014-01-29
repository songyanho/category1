//
//  imagePreviewViewController.h
//  category1
//
//  Created by Songyan on 1/26/14.
//  Copyright (c) 2014 AppBox Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagedImageScrollView.h"
@interface imagePreviewViewController : UIViewController
@property (strong,nonatomic) NSArray *imagesDataArray;
@property (nonatomic) NSUInteger currentImages;
@property (strong,nonatomic) PagedImageScrollView *pisv;
@end
