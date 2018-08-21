//
//  JZLPhotoBrowser.m
//  JZLPhotoBrowser
//
//  Created by allenjzl on 2017/6/5.
//  Copyright © 2017年 allenjzl. All rights reserved.
//

//屏幕宽
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define JZLKeyWindow [UIApplication sharedApplication].keyWindow

#import "JZLPhotoBrowser.h"
#import "JZLPhoto.h"
#import "UIImageView+WebCache.h"
#import "JZLProgressView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import<CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/PHPhotoLibrary.h>
#import "JGProgressHUD.h"


@interface JZLPhotoBrowser ()<UIScrollViewDelegate>
/** 黑色背景 */
@property (nonatomic, strong) UIView *blackView;
/** 滑动的scrollview */
@property (nonatomic, strong) UIScrollView *bgScrollView;
@end


@implementation JZLPhotoBrowser
    



/**
 实例化图片浏览器并展示

 @param urlArr 大图url数组
 @param index 当前展示的下标
 @param originalImageViewArr 原始图片数组
 @return 返回图片浏览器
 */
+ (instancetype)showPhotoBrowserWithUrlArr:(NSArray *)urlArr currentIndex:(NSInteger)index originalImageViewArr:(NSArray *)originalImageViewArr {
    JZLPhotoBrowser *photoBrowser = [JZLPhotoBrowser photoBrowser];
    photoBrowser.urlArr = urlArr;
    photoBrowser.index = index;
    photoBrowser.originalImageViewArr = [originalImageViewArr mutableCopy];
    [photoBrowser setupUI];
    [photoBrowser show];
    return photoBrowser;
    
}


+ (instancetype)photoBrowser {
    return [[self alloc] init];
}


    
- (instancetype)initWithFrame:(CGRect)frame
    {
        self = [super initWithFrame:frame];
        if (self) {

            
        }
        return self;
    }
    
    /** 创建布局 */
- (void)setupUI {
    [self setupOriginalFrame];
    [self addSubview:self.blackView];
    [self addSubview:self.bgScrollView];
    
}
    
    
    
 /** 展示图片浏览器 */
- (void)show {
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [JZLKeyWindow addSubview:self];
    self.bgScrollView.contentSize = CGSizeMake(ScreenWidth * self.urlArr.count, 0);
    self.bgScrollView.contentOffset = CGPointMake(ScreenWidth * self.index, 0);
    [self creatSmallScrollView];
    [JZLKeyWindow addSubview:self.indexLbl];
    [JZLKeyWindow addSubview:self.saveBtn];
  
}

/** 设置原始图片的frame */
- (void)setupOriginalFrame {
    //先判断传入的是不是imageView格式,如果不对,直接清空,不再设置缩放动画
    for (int i = 0; i < self.originalImageViewArr.count; i++) {
        if (![self.originalImageViewArr[i] isKindOfClass:[UIImageView class]]) {
            [self.originalImageViewArr removeAllObjects];
            return;
        }
    }
    
    
    //如果没传入原始图片,则不进行
    if (self.originalImageViewArr.count == self.urlArr.count) {
        NSArray *arr = [self.originalImageViewArr copy];
        [self.originalImageViewArr removeAllObjects];
        for (UIImageView *imageView in arr) {
            CGRect sourceF = [JZLKeyWindow convertRect:imageView.frame fromView:imageView.superview];
            [self.originalImageViewArr addObject:NSStringFromCGRect(sourceF)];
        }
    }
    
}

    

    
    
    /** 创建子视图 */
- (void)creatSmallScrollView {
    _bgScrollView.contentSize = CGSizeMake(ScreenWidth * self.urlArr.count, ScreenHeight);
    for (int i = 0; i < self.urlArr.count; i++) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.frame = CGRectMake(ScreenWidth * i, 0, ScreenWidth, ScreenHeight);
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.delegate = self;
        scrollView.tag = i;
        scrollView.maximumZoomScale=3.0;
        scrollView.minimumZoomScale=1;
        JZLPhoto *photo = [self addtapWithTag:i];

        JZLProgressView *progressView = [[JZLProgressView alloc] init];
        progressView.bounds = CGRectMake(0, 0, 100, 100);
        progressView.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
//        progressView.progress = 0.5;
        
        
        [scrollView addSubview:photo];
        [scrollView addSubview:progressView];
        [self.smallScViewArray addObject:scrollView];
        
        [self.bgScrollView addSubview:scrollView];

        
        [photo sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:self.urlArr[i]] andPlaceholderImage:nil options:SDWebImageRetryFailed | SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {

            progressView.progress = (CGFloat)receivedSize/(CGFloat)expectedSize;
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            progressView.hidden = YES;
            if (image != nil) {
                //下载的图片
                if (cacheType == SDImageCacheTypeNone) {
                    [self setPhotoFrame:photo];
                }else {//缓存过的图片
                    //如果没有传入原始图片的frame,一样的没有放大动画
                    if (self.originalImageViewArr.count == 0) {
                        NSLog(@"========展示缩放动画需要传入原始图片的frame==========");
                    }else {
                         photo.frame = CGRectFromString(self.originalImageViewArr[i]);
                    }
                    [UIView animateWithDuration:0.3 animations:^{
                        [self setPhotoFrame:photo];
                    }];
                }
                
            }else {
                //下载失败,显示占位图
                photo.bounds = CGRectMake(0, 0, ScreenWidth, 240);
                photo.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
                photo.contentMode = UIViewContentModeScaleAspectFit;
                photo.image = [UIImage imageNamed:@"placeholder.jpg"];
                
                [progressView removeFromSuperview];
            }
        }];
        
    }
    
    
}
    
    
    
    /** 设置imageView的frame */
- (void)setPhotoFrame:(JZLPhoto *)photo {
    UIScrollView *smallScrollView = (UIScrollView *)photo.superview;
    self.blackView.alpha = 1.0;
    CGFloat ratio = (double)photo.image.size.height / (double)photo.image.size.width;
    CGFloat photoWidth = ScreenWidth;
    CGFloat photoHeight = ScreenWidth * ratio;
    
    if (photoHeight < ScreenHeight) {
    photo.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
    photo.bounds = CGRectMake(0, 0, photoWidth, photoHeight);
       
    }else {//长图的处理
        photo.frame = CGRectMake(0, 0, photoWidth, photoHeight);
        smallScrollView.contentSize = CGSizeMake(ScreenWidth, photoHeight);
    }
    
}
    
/** 给图片添加缩放手势 */
- (JZLPhoto *)addtapWithTag: (int)tag {
    JZLPhoto *photo = [[JZLPhoto alloc] init];
    photo.userInteractionEnabled = YES;
    UITapGestureRecognizer *photoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTap:)];
    UITapGestureRecognizer *zoomTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomTap:)];
    zoomTap.numberOfTapsRequired = 2;
    [photo addGestureRecognizer:photoTap];
    [photo addGestureRecognizer:zoomTap];
    //如果zonmTap识别出双击事件,那么photoTap不会被执行
    [photoTap requireGestureRecognizerToFail:zoomTap];
    //默认给一个位置,不然展开动画很难看
    photo.bounds = CGRectMake(0, 0, 100, 100);
    photo.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
    [self.photos addObject:photo];
    return photo;
}
    
    
    
    /** 点击事件 */
/** 图片点击事件 */
- (void)photoTap: (UIGestureRecognizer *)photoTap {
    NSInteger index = self.bgScrollView.contentOffset.x / ScreenWidth;
    JZLPhoto *photo = self.photos[index];
    UIScrollView *smScrollView =self.smallScViewArray[index];
    //    JZLPhoto *photo = (JZLPhoto *)photoTap.view;
    //    UIScrollView *scrollView = (UIScrollView *)photo.superview;
    smScrollView.zoomScale = 1.0;
    //1.1如果是长图片先将其移动到CGPointMake(0, 0)在缩放回去
    if (CGRectGetHeight(photo.frame)>ScreenHeight) {
        smScrollView.contentOffset = CGPointMake(0, 0);
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self.indexLbl removeFromSuperview];
        [self.saveBtn removeFromSuperview];
        //如果没传入原始的图片的frame,则不展示缩放动画
        if (self.originalImageViewArr.count == 0) {
            NSLog(@"========展示缩放动画需要传入原始图片的frame==========");
            self.blackView.alpha = 0;
            //设置一个缩放动画,防止缩放很丑,如果没有传原始图片的frame,并且不想要这个动画,直接把下面两句代码注释掉即可
            //            photo.bounds = CGRectMake(0, 0, 0, 0);
            //            photo.center = CGPointMake(ScreenWidth / 2, ScreenHeight /2);
            photo.alpha = 0;
        }else {
            photo.frame = CGRectFromString(self.originalImageViewArr[index]);
            self.blackView.alpha = 0;
        }
        
        
    }completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}

/** 图片放大缩小 */
- (void)zoomTap: (UIGestureRecognizer *)zoomTap {
    [UIView animateWithDuration:0.3 animations:^{
        
        UIScrollView *smallScrollView = (UIScrollView *)zoomTap.view.superview;

        if (smallScrollView.zoomScale > 1.0) {
            smallScrollView.zoomScale = 1.0;
        }else {
            smallScrollView.zoomScale = 3.0;
        }
        
        
    }];
}



#pragma mark UIScrollViewDelegate
    
    //告诉scrollview要缩放的是哪个子控件
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    if ([scrollView isEqual:(UIScrollView *)self.bgScrollView]) {
        return nil;
    }
    JZLPhoto *photo = self.photos[scrollView.tag];
    
    return photo;
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    if ([scrollView isEqual:(UIScrollView *)self.bgScrollView]) return;
    
    JZLPhoto *photo = (JZLPhoto *)self.photos[scrollView.tag];
    
    CGFloat photoY = (ScreenHeight - photo.frame.size.height)/2;
    CGRect photoF = photo.frame;
    
    if (photoY>0) {
        
        photoF.origin.y = photoY;
        
    }else{
        
        photoF.origin.y = 0;
        
    }
    
    photo.frame = photoF;
    
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"%.f",scrollView.contentOffset.x);
    if (scrollView.zoomScale == 1) {
        NSInteger index = scrollView.contentOffset.x / ScreenWidth;
        self.indexLbl.text = [NSString stringWithFormat:@"%ld / %ld",index + 1,self.urlArr.count];
        if (self.index!= index ) {
            self.index = index;
            for (UIView *view in scrollView.subviews) {
                if ([view isKindOfClass:[UIScrollView class]]) {
                    UIScrollView *scrollView = (UIScrollView *)view;
                    scrollView.zoomScale = 1.0;
                }
            }
        }
    }
}






#pragma mark - lazy

- (UIView *)blackView {
    if (!_blackView) {
        _blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _blackView.backgroundColor = [UIColor blackColor];
    }
    return _blackView;
}

- (UIScrollView *)bgScrollView {
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth , ScreenHeight)];
        _bgScrollView.delegate = self;
        _bgScrollView.pagingEnabled = YES;
        _bgScrollView.bounces = YES;
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.backgroundColor =  [UIColor clearColor];
        UITapGestureRecognizer *photoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTap:)];
        [_bgScrollView addGestureRecognizer:photoTap];
        
    }
    
    return _bgScrollView;
}


- (NSMutableArray *)photos {
    if (!_photos) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}


- (NSArray *)urlArr {
    if (!_urlArr) {
        _urlArr = [NSArray array];
    }
    return _urlArr;
}

- (UILabel *)indexLbl {
    if (!_indexLbl) {
        _indexLbl = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth - 100) / 2, 40, 100, 30)];
        _indexLbl.textColor = [UIColor whiteColor];
        _indexLbl.font = [UIFont systemFontOfSize:20];
        _indexLbl.textAlignment = NSTextAlignmentCenter;
        _indexLbl.text = [NSString stringWithFormat:@"%ld / %lu",(long)(self.index + 1) ,(unsigned long)self.urlArr.count];
    }
    return _indexLbl;
}


- (NSMutableArray *)originalImageViewArr {
    if (!_originalImageViewArr) {
        _originalImageViewArr = [NSMutableArray array];
    }
    return _originalImageViewArr;
}

- (NSMutableArray *)smallScViewArray {
    if (!_smallScViewArray) {
        _smallScViewArray = [NSMutableArray array];
    }
    return _smallScViewArray;
}

- (UIButton *)saveBtn {
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveBtn setFrame:CGRectMake(ScreenWidth - 80, ScreenHeight - 59, 80, 50)];
        [_saveBtn setTitle:@"保存" forState:0];
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:0];
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _saveBtn;
}


/** 保存图片 */
- (void) saveBtnClick {

    //保存图片
    JZLPhoto *photo = self.photos[self.index];
    UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}





/** 保存成功的回调 */
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
    HUD.textLabel.text = @"保存成功!";
    HUD.indicatorView = nil;
    [HUD showInView:JZLKeyWindow];
    [HUD dismissAfterDelay:2 animated:YES];

}





 
@end
