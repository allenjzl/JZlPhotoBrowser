//
//  JZLProgressView.m
//  JZLPhotoBrowser
//
//  Created by allenjzl on 2017/7/14.
//  Copyright © 2017年 allenjzl. All rights reserved.
//

#import "JZLProgressView.h"

@implementation JZLProgressView

- (instancetype)initWithFrame:(CGRect)frame {
        self = [super initWithFrame:frame];
        if (self) {
            self.backgroundColor = [UIColor clearColor];
        }
        return self;
}


- (void)drawRect:(CGRect)rect {
    //画外圆
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] set];
    
    CGContextSetLineWidth(context, 2);
    CGContextAddArc(context, rect.size.width / 2, rect.size.height / 2, 22, 0, M_PI * 2, 0);
//    CGContextDrawPath(context, kCGPathStroke);
    CGContextStrokePath(context);
    //画内园

    
    CGContextSetLineWidth(context, 20);
    CGContextAddArc(context, rect.size.width / 2, rect.size.height / 2, 10, -M_PI/2, -M_PI/2 + M_PI * 2 * self.progress , 0);
//    CGContextDrawPath(context, kCGPathFill);
 CGContextStrokePath(context);

//    //画扇形，也就画圆，只不过是设置角度的大小，形成一个扇形
////    aColor = [UIColor colorWithRed:0 green:1 blue:1 alpha:1];
//    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);//填充颜色
//    //以10为半径围绕圆心画指定角度扇形
//    CGContextMoveToPoint(context, rect.size.width / 2, rect.size.height / 2);
//    CGContextAddArc(context, rect.size.width / 2, rect.size.height / 2, 10, -M_PI/2, -M_PI/2 + M_PI * 2 * self.progress , 0);
//    CGContextClosePath(context);
//    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径
    
    
    
    
}

- (void)setProgress:(CGFloat)progress {
    if (_progress != progress) {
        _progress = progress;
    }
    [self setNeedsDisplay];
}
    
    
    
    
    
@end
