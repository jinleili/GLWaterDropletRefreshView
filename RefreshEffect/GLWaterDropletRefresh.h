//
//  WaterDropletRefresh.h
//  RefreshEffect
//
//  Created by grenlight on 14-1-1.
//  Copyright (c) 2014年 OWWWW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaterDropletView.h"


@interface GLWaterDropletRefresh : UIView
{
    WaterDropletView *dropletView;
    
//    水滴已经下落，则视图固定不动，完成刷新后自动收回，否则跟随滚动视图滚动
    BOOL            isDropped;
    
    CGPoint normalCenter, refreshingCenter;
    
    UIView  *bg;

}

@property (nonatomic, strong) UIColor *circleColor;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic,assign)__unsafe_unretained UIScrollView *owner;

@property (nonatomic, copy) GLNoneParamBlock refreshBlock;

- (id)initWithWidth:(float)w;

- (void)dropByOffsetY:(float)offsetY;

- (void)stopAnimating;


@end
