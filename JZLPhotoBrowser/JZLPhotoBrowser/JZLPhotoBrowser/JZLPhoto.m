//
//  JZLPhoto.m
//  JZLPhotoBrowser
//
//  Created by allenjzl on 2017/7/4.
//  Copyright © 2017年 allenjzl. All rights reserved.
//

#import "JZLPhoto.h"

@implementation JZLPhoto

- (instancetype)initWithFrame:(CGRect)frame
    {
        self = [super initWithFrame:frame];
        if (self) {
            
        }
        return self;
    }
    
    
    
- (NSMutableArray *)bigImageUrl {
    if (!_bigImageUrl) {
        _bigImageUrl = [NSMutableArray array];
    }
    return _bigImageUrl;
}

@end
