//
//  WaterDropletRefresh.m
//  RefreshEffect
//
//  Created by grenlight on 14-1-1.
//  Copyright (c) 2014年 OWWWW. All rights reserved.
//

#import "GLWaterDropletRefresh.h"
#import "GLSoundManager.h"

//正常可被下拉的距离，此距离之内，水滴无动画
#define  normalOffsetY 50


@implementation GLWaterDropletRefresh

- (id)initWithWidth:(float)w
{
    CGRect frame = CGRectMake(0, 0, w, 100);
    self = [super initWithFrame:frame];
    if (self) {
        isAnimating = isDropped = NO;
        spring = 0.06;
        friction = 0.9;
        vx = 0;
        
        self.circleColor = [UIColor whiteColor];
        self.lineColor = [UIColor grayColor];
        
        circleRadius = 8;
        bezierRadius = 11;
        
        maxRadiusOffsetY = 50;
        normalCenter = CGPointMake(w/2.0f, 70);
        currentRadiusOffsetY = 0;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)dropByOffsetY:(float)offsetY
{
    [self setCenter:CGPointMake(normalCenter.x, originalY + offsetY)];
}

- (void)setCenter:(CGPoint)center
{
    [super setCenter:center];
    if (self.superview == nil) {
        originalY = center.y;
        [self setNeedsDisplay];
    }
    //只有在没执行水滴下滴过程动画时，才计算随下拉形状变化的计算
    else if (!isAnimating && !isDropped) {
        if (center.y - originalY > normalOffsetY) {
            currentRadiusOffsetY = center.y - originalY - normalOffsetY;
            if (currentRadiusOffsetY < normalOffsetY)
                [self setNeedsDisplay];
            //下滴动画
            else {
                isAnimating = isDropped = YES;
                displayLink = [CADisplayLink displayLinkWithTarget:self
                                                          selector:@selector(enterFrame)];
                [displayLink setFrameInterval:1];
                [displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                                  forMode:NSRunLoopCommonModes];
                [[GLSoundManager sharedInstance] playRefreshSound];
            }
        }
    }
}

- (void)enterFrame
{
    float distance = normalCenter.y - currentCenterY;
    vx += distance * spring;
    vx *= friction;
    currentCenterY += vx;
    currentRadiusOffsetY = normalCenter.y - currentCenterY;
    [self setNeedsDisplay];

    if (abs(currentRadiusOffsetY) < 0.3) {
        currentCenterY = normalCenter.y;
        currentRadiusOffsetY = 0;
        [self setNeedsDisplay];

        [displayLink invalidate];
        displayLink = nil;
        
        isAnimating = NO;
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextAddPath(context, [UIBezierPath bezierPathWithRect:rect].CGPath);
    CGContextDrawPath(context, kCGPathFill);
    
    CGPoint leftP, rightP, topLeftP, topRightP, bottomLeftP, bottomRightP;
    if (isAnimating) {
        
    }
    else {
        currentCenterY = normalCenter.y - currentRadiusOffsetY;
    }
    float newRadius = circleRadius - (2.0f/normalOffsetY * currentRadiusOffsetY);

    leftP = CGPointMake(normalCenter.x-newRadius, currentCenterY);
    rightP = CGPointMake(normalCenter.x + newRadius, currentCenterY);
    
    topLeftP = CGPointMake(leftP.x, leftP.y-bezierRadius);
    topRightP = CGPointMake(rightP.x, rightP.y - bezierRadius);
    bottomLeftP = CGPointMake(leftP.x, leftP.y + bezierRadius + currentRadiusOffsetY/2.0f);
    bottomRightP = CGPointMake(rightP.x, rightP.y + bezierRadius + currentRadiusOffsetY/2.0f);
    
    //画竖线
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetLineWidth(context, 3-(2.5f/normalOffsetY * currentRadiusOffsetY));
    CGContextMoveToPoint(context, normalCenter.x, currentCenterY);
    CGContextAddLineToPoint(context, normalCenter.x, self.bounds.size.height);
    CGContextDrawPath(context, kCGPathStroke);
    
    //水滴
    CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);

    CGContextSetStrokeColorWithColor(context, self.circleColor.CGColor);
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path setLineWidth:2];
    [path moveToPoint:leftP];
    [path addCurveToPoint:rightP controlPoint1:topLeftP controlPoint2:topRightP];
    [path moveToPoint:leftP];
    [path addCurveToPoint:rightP controlPoint1:bottomLeftP controlPoint2:bottomRightP];
    [path fill];
    [path stroke];
}




@end
