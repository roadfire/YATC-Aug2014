//
//  RFSViewController.m
//  YATC
//
//  Created by Josh Brown on 8/27/14.
//  Copyright (c) 2014 Roadfire Software. All rights reserved.
//

#import "RFSViewController.h"
#import "RFSTwitterViewModel.h"

@interface RFSViewController ()

@property RFSTwitterViewModel *viewModel;

@end

@implementation RFSViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.viewModel = [[RFSTwitterViewModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.viewModel
     fetchTweetsWithSuccess:^
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             [self.tableView reloadData];
         });
     }
     failure:^
     {
         // TODO: show an error message
     }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.viewModel.numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.text = [self.viewModel usernameForRowAtIndexPath:indexPath];
    cell.detailTextLabel.text = [self.viewModel tweetForRowAtIndexPath:indexPath];
    [cell.detailTextLabel sizeToFit];
    
    [self.viewModel fetchImageForIndexPath:indexPath success:^(UIImage *image){
        dispatch_async(dispatch_get_main_queue(), ^{
            UITableViewCell *updateCell = [self.tableView cellForRowAtIndexPath:indexPath];
            if (updateCell)
            {
                updateCell.imageView.image = image;
            }
        });
    }];
    
    cell.imageView.image = [UIImage imageNamed:@"placeholder"];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
}

@end
