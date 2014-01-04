//
//  WaterDropletView.h
//  RefreshEffect
//
//  Created by grenlight on 14-1-4.
//  Copyright (c) 2014年 OWWWW. All rights reserved.
//

#import <UIKit/UIKit.h>

#define    OWNER_CONTENTOFFSET_CHANGED  @"OWNER_ContentOffset_Changed"

typedef void(^GLNoneParamBlock) ();

//正常可被下拉的距离，此距离之内，水滴无动画
#define  normalOffsetY 50

@interface WaterDropletView : UIView
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
    BOOL            isDropped;
    BOOL            indicating;
    
    float           spring, friction, vx;
    
    float           startEngle;
    
}
@property (nonatomic, strong) UIColor *circleColor;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic,assign)__unsafe_unretained UIScrollView *owner;

@property (nonatomic, copy) GLNoneParamBlock refreshBlock;

- (id)initWithWidth:(float)w;

- (void)pullByOffsetY:(float)offsetY;
- (void)droppingAnimating;

- (void)stopAnimating;

@end
