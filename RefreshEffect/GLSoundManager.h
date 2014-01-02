//
//  GLSoundManager.h
//  RefreshEffect
//
//  Created by grenlight on 14-1-1.
//  Copyright (c) 2014年 OWWWW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLSoundManager : NSObject
{
}

+ (GLSoundManager *)sharedInstance;

- (void)playRefreshSound;

@end
