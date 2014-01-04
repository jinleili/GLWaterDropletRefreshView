//
//  WaterDropletView.m
//  RefreshEffect
//
//  Created by grenlight on 14-1-4.
//  Copyright (c) 2014年 OWWWW. All rights reserved.
//

#import "WaterDropletView.h"
#import "GLSoundManager.h"

@implementation WaterDropletView

@synthesize owner;

- (id)initWithWidth:(float)w
{
    CGRect frame = CGRectMake(0, 0, w, 100);
    self = [super initWithFrame:frame];
    if (self) {
        isDropped = NO;
        indicating = NO;
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
        originalY = CGRectGetMidY(frame);

    }
    return self;
}

- (void)pullByOffsetY:(float)offsetY
{
    //只有在没执行水滴下滴过程动画时，才计算随下拉形状变化的计算
    currentRadiusOffsetY = offsetY - normalOffsetY;
    if (offsetY > normalOffsetY && currentRadiusOffsetY <= normalOffsetY) {
        [self setNeedsDisplay];
    }

}

- (void)droppingAnimating
{
    isDropped = YES;
    currentCenterY = 30;
    vx = 0;
    displayLink = [CADisplayLink displayLinkWithTarget:self
                                              selector:@selector(enterFrame)];
    [displayLink setFrameInterval:1];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                      forMode:NSRunLoopCommonModes];
    [[GLSoundManager sharedInstance] playRefreshSound];
 
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
        
        [self showIndicatorView];
    }
}

- (void)showIndicatorView
{
    indicating = YES;
    if (self.refreshBlock)
        self.refreshBlock();
    
    startEngle = 3.14/2.0f;
    displayLink = [CADisplayLink displayLinkWithTarget:self
                                              selector:@selector(showIndicator)];
    [displayLink setFrameInterval:1];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                      forMode:NSRunLoopCommonModes];
}

- (void)showIndicator
{
    startEngle += 0.15;
    [self setNeedsDisplay];
}


- (void)stopAnimating
{
    if (owner) {
        isDropped = NO;
        indicating = NO;
        [self setNeedsDisplay];

        [displayLink invalidate];
        displayLink = nil;
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextAddPath(context, [UIBezierPath bezierPathWithRect:rect].CGPath);
    CGContextDrawPath(context, kCGPathFill);
    
    CGPoint leftP, rightP, topLeftP, topRightP, bottomLeftP, bottomRightP;
    if (isDropped) {
        
    }
    else {
        currentCenterY = normalCenter.y - currentRadiusOffsetY;
    }
    float newRadius = circleRadius - (2.0f/normalOffsetY * currentRadiusOffsetY);
    
    leftP = CGPointMake(normalCenter.x-newRadius, currentCenterY);
    rightP = CGPointMake(normalCenter.x + newRadius, currentCenterY);
    
    topLeftP = CGPointMake(leftP.x, leftP.y-bezierRadius);
    topRightP = CGPointMake(rightP.x, rightP.y - bezierRadius);
    bottomLeftP = CGPointMake(leftP.x, leftP.y + bezierRadius + currentRadiusOffsetY*0.7);
    bottomRightP = CGPointMake(rightP.x, rightP.y + bezierRadius + currentRadiusOffsetY*0.7);
    
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
    [path setLineWidth:2-(1.0f/normalOffsetY * currentRadiusOffsetY)];
    [path moveToPoint:leftP];
    [path addCurveToPoint:rightP controlPoint1:topLeftP controlPoint2:topRightP];
    [path moveToPoint:leftP];
    [path addCurveToPoint:rightP controlPoint1:bottomLeftP controlPoint2:bottomRightP];
    [path fill];
    [path stroke];
    
    if (indicating) {
        CGContextSetStrokeColorWithColor(context, [UIColor darkGrayColor].CGColor);
        UIBezierPath *indicatorPath = [UIBezierPath bezierPathWithArcCenter:normalCenter radius:circleRadius startAngle:startEngle endAngle:3.14+startEngle clockwise:YES];
        [indicatorPath setLineWidth:2.5];
        [indicatorPath stroke];

    }
}

@end
