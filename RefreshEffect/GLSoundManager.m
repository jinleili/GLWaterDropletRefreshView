//
//  GLSoundManager.m
//  RefreshEffect
//
//  Created by grenlight on 14-1-1.
//  Copyright (c) 2014年 OWWWW. All rights reserved.
//

#import "GLSoundManager.h"
#import <AudioToolbox/AudioToolbox.h>

@interface GLSoundManager()
{
    SystemSoundID   refreshSound;  
}
@end

@implementation GLSoundManager

- (id)init
{
    self = [super init];
    if (self) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"pull_refresh" withExtension:@"aif"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url) , &refreshSound);

    }
    return self;
}

+ (GLSoundManager *)sharedInstance
{
    static GLSoundManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GLSoundManager alloc] init];
    });
    return instance;
}

- (void)playRefreshSound
{
    AudioServicesPlaySystemSound(refreshSound);
}

@end
