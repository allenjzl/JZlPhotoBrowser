//
//  JZLPhotoBrowser.h
//  JZLPhotoBrowser
//
//  Created by allenjzl on 2017/6/5.
//  Copyright © 2017年 allenjzl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JZLPhotoBrowser : UIView
/** 存放JZLPhoto */
@property (nonatomic, strong) NSMutableArray *photos;
/** 存放图片url */
@property (nonatomic, strong) NSArray *urlArr;
/** 点击的下标 */
@property (nonatomic, assign) NSInteger index;
/** 索引显示 */
@property (nonatomic, strong) UILabel *indexLbl;
/** 保存按钮 */
@property (nonatomic, strong) UIButton *saveBtn;
/** 原始图片 */
@property (nonatomic, strong) NSMutableArray *originalImageViewArr;
/** 没涨图片的父视图(小的scrollview) */
@property (nonatomic, strong) NSMutableArray *smallScViewArray;


/**
 *  返回图片浏览器
 */
+ (instancetype)photoBrowser;


+ (instancetype)showPhotoBrowserWithUrlArr:(NSArray *)urlArr currentIndex:(NSInteger)index originalImageViewArr:(NSArray *)originalImageViewArr ;


/**
 展示图片浏览器
 */
- (void)show;
@end
