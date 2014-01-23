//
//  productTableViewController.m
//  category1
//
//  Created by Songyan on 1/19/14.
//  Copyright (c) 2014 AppBox Technology. All rights reserved.
//

#import "productTableViewController.h"
#import "productDetailViewController.h"
#import "ProductDetailTableViewController.h"

@interface productTableViewController ()

@end

@implementation productTableViewController 

@synthesize productListArray = _productListArray;


- (void)setProductListArray:(NSArray *)productListArray{
    _productListArray = productListArray;
    [self.tableView reloadData];
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.productListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Product List";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *currenProduct = [self.productListArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [currenProduct valueForKeyPath:@"name"];
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[currenProduct valueForKeyPath:@"image"]]]];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"product list to detail"]){
        if([segue.destinationViewController isKindOfClass:[ProductDetailTableViewController class]]){
            NSDictionary *productPropertyList = self.productListArray[self.selectedIndexPath.row];
            [self prepareProductDetailViewController:segue.destinationViewController productID:[productPropertyList valueForKeyPath:@"productid"] productName:[productPropertyList valueForKeyPath:@"name"]];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"product list to detail" sender:self];
}

- (void)prepareProductDetailViewController:(ProductDetailTableViewController *)pdvc productID:(NSString *)productID productName:(NSString *)productName{
    pdvc.productName = productName;
    pdvc.productID = productID;
}

@end
