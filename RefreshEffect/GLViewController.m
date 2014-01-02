//
//  GLViewController.m
//  RefreshEffect
//
//  Created by grenlight on 14-1-1.
//  Copyright (c) 2014年 OWWWW. All rights reserved.
//

#import "GLViewController.h"
#import "GLWaterDropletRefresh.h"

@interface GLViewController ()
{
    GLWaterDropletRefresh *refreshView;
}
@end

@implementation GLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView.delegate = self;
    
    refreshView = [[GLWaterDropletRefresh alloc] initWithWidth:320];
    [refreshView setCenter:CGPointMake(160, -50)];
    [self.view addSubview:refreshView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_tableView.contentOffset.y <= 0)
        [refreshView dropByOffsetY:-(_tableView.contentOffset.y)];
}
@end
