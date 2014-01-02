//
//  WaterDropletRefresh.h
//  RefreshEffect
//
//  Created by grenlight on 14-1-1.
//  Copyright (c) 2014年 OWWWW. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SystemSoundID;

@interface GLWaterDropletRefresh : UIView
{
    float originalY;
    
    float circleRadius, bezierRadius;
    //下半部分最大能被拉伸的的
    float maxRadiusOffsetY;
    //当前被拉伸的距离
    float currentRadiusOffsetY;
    //当前水滴中心点
    float currentCenterY;
    
    CGPoint normalCenter;
    
    CADisplayLink   *displayLink;
    BOOL            isAnimating, isDropped;
    float           spring, friction, vx;
    


}
@property (nonatomic, strong) UIColor *circleColor;
@property (nonatomic, strong) UIColor *lineColor;

- (id)initWithWidth:(float)w;

- (void)dropByOffsetY:(float)offsetY;

@end
