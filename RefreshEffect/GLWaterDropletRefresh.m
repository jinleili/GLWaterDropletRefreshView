//
//  WaterDropletRefresh.m
//  RefreshEffect
//
//  Created by grenlight on 14-1-1.
//  Copyright (c) 2014年 OWWWW. All rights reserved.
//

#import "GLWaterDropletRefresh.h"


@implementation GLWaterDropletRefresh

- (id)initWithWidth:(float)w
{
    CGRect frame = CGRectMake(0, 0, w, 100);
    self = [super initWithFrame:frame];
    if (self) {
        bg = [[UIView alloc] initWithFrame:frame];
        bg.backgroundColor = [UIColor blackColor];
        [bg setAlpha:0];
        [self addSubview:bg];
        
        dropletView = [[WaterDropletView alloc] initWithWidth:w];
        dropletView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:dropletView];
        self.backgroundColor = [UIColor clearColor];
        
        isDropped = NO;
        normalCenter = CGPointMake(w/2.0f, - 50);
        refreshingCenter = CGPointMake(normalCenter.x, normalCenter.y + CGRectGetHeight(self.frame));
    }
    return self;
}

- (void)setOwner:(UIScrollView *)owner
{
    _owner = owner;
    [dropletView setOwner:owner];
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    [dropletView setLineColor:lineColor];
}

- (void)setCircleColor:(UIColor *)circleColor
{
    [dropletView setCircleColor:circleColor];
}

- (void)setRefreshBlock:(GLNoneParamBlock)refreshBlock
{
    [dropletView setRefreshBlock:refreshBlock];
}

- (void)dropByOffsetY:(float)offsetY
{
    CGPoint center = CGPointMake(normalCenter.x, normalCenter.y + offsetY);
   
    //正在刷新，则视图固定不动
    if (isDropped) {
        [super setCenter:refreshingCenter];
    }
    else if (center.y >= 50) {
        isDropped = YES;
        [dropletView droppingAnimating];
        [UIView animateWithDuration:0.2 delay:0
                            options:UIViewAnimationOptionCurveEaseIn animations:^{
            [bg setAlpha:1];
        } completion:Nil];
    }
    else if (center.y < 50 && center.y >= normalCenter.y){
        [super setCenter:center];
        [dropletView pullByOffsetY:offsetY];
    }
}


- (void)stopAnimating
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self setCenter:normalCenter];
                     } completion:^(BOOL finished) {
                         if (finished) {
                             isDropped = NO;
                         }
                     }];
    [dropletView stopAnimating];
    
    [UIView animateWithDuration:1 delay:0
                        options:UIViewAnimationOptionCurveEaseIn animations:^{
                            [bg setAlpha:0];
                        } completion:Nil];
}


@end
