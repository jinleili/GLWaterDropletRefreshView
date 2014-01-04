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
    refreshView.owner = _tableView;
    
    __unsafe_unretained GLViewController *weakSelf = self;
    [refreshView setRefreshBlock:^{
        [weakSelf performSelector:@selector(stopRefreshAnimation) withObject:Nil afterDelay:5];
    }];
    
    
}

- (void)stopRefreshAnimation
{
    [refreshView stopAnimating];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_tableView.contentOffset.y <= 0)
        [refreshView dropByOffsetY:-(_tableView.contentOffset.y)];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    if (_tableView.contentOffset.y <= 0)
//        [refreshView pullReleased];
}

@end
