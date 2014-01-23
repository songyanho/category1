//
//  categoryListTableViewController.m
//  category1
//
//  Created by Songyan on 1/16/14.
//  Copyright (c) 2014 AppBox Technology. All rights reserved.
//

#import "categoryListTableViewController.h"
#import "storyboardProductTableViewController.h"

@interface categoryListTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *categoryListTable;
@end

@implementation categoryListTableViewController
@synthesize categories = _categories;

-(void)setCategories:(NSArray *)categories{
    _categories = categories;
    [self.categoryListTable reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Category List";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *currentCategoryDictionary = self.categories[indexPath.row];
    cell.textLabel.text = [currentCategoryDictionary valueForKeyPath:@"categoryname"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"category to product table"]){
        if([segue.destinationViewController isKindOfClass:[storyboardProductTableViewController class]]){
            NSDictionary *selectedCategory = self.categories[self.selectedRow.row];
            [self passCategoryIdentifier:segue.destinationViewController categoryIdentifier:(NSString *)[selectedCategory valueForKey:@"categoryid"] categoryname:[selectedCategory valueForKey:@"categoryname"]];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedRow = indexPath;
    [self performSegueWithIdentifier:@"category to product table" sender:self];
}

- (void)passCategoryIdentifier:(storyboardProductTableViewController *)sptvc categoryIdentifier:(NSString *)categoryIdentifier categoryname:(NSString *)categoryname{
    sptvc.categoryName = categoryname;
    sptvc.categoryIdentifier = categoryIdentifier;
}

@end
