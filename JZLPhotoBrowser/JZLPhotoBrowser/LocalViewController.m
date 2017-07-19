//
//  LocalViewController.m
//  JZLPhotoBrowser
//
//  Created by allenjzl on 2017/6/5.
//  Copyright © 2017年 allenjzl. All rights reserved.
//

#import "LocalViewController.h"
#import "LocalCollectionViewCell.h"
#import "JZLPhotoBrowser.h"

@interface LocalViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *frameArr;
@end


static NSString *const LocalCollectionViewCellReuseID = @"LocalCollectionViewCellReuseID";
@implementation LocalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];

}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LocalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LocalCollectionViewCellReuseID forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",(indexPath.item + 1)]];


    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *urlArr = [NSArray arrayWithObjects:
    @"http://cdn.duitang.com/uploads/item/201112/15/20111215182922_rawVz.thumb.700_0.jpg",
    @"http://pic1.win4000.com/mobile/5/52023317b2c3d.jpg",
    @"http://img4q.duitang.com/uploads/item/201406/11/20140611041502_SNiL5.thumb.700_0.jpeg",
    @"http://img1.gamedog.cn/2012/04/07/20-12040G54U0.jpg",
    @"http://img.kutoo8.com/upload/image/48980280/2013xinkuanmengdiao_320x480.jpg",
    @"http://ww1.sinaimg.cn/orj480/bd8686degw1f2o211mzevj20hs0vkdlg.jpg",
    @"http://i4.download.fd.pchome.net/t_320x520/g1/M00/10/00/ooYBAFVtCdKIToUrAAB7FiveNpMAACg_gIBVqwAAHsu136.jpg",
    @"http://img1.gamedog.cn/2012/03/20/20-120320103U7.jpg",
    @"http://p18.qhimg.com/bdr/__/d/_open360/sun1111/6.jpg", nil];


    [self.frameArr removeAllObjects];
    for (int i = 0; i < 9; i ++) {
        NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];
        LocalCollectionViewCell *cell = (LocalCollectionViewCell *)[collectionView cellForItemAtIndexPath:index];
        [self.frameArr addObject:cell.imageView];
    }
    
    [JZLPhotoBrowser showPhotoBrowserWithUrlArr:urlArr currentIndex:indexPath.row originalImageViewArr:self.frameArr];
    
}







- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowOut = [[UICollectionViewFlowLayout alloc] init];
        flowOut.itemSize = CGSizeMake(100, 100);
        flowOut.minimumLineSpacing = 10;
        flowOut.minimumInteritemSpacing = 10;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 20, self.view.bounds.size.width - 40, self.view.bounds.size.height) collectionViewLayout:flowOut];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[LocalCollectionViewCell class] forCellWithReuseIdentifier:LocalCollectionViewCellReuseID];
    }

    return _collectionView;
}

- (NSMutableArray *)frameArr {
    if (!_frameArr) {
        _frameArr = [NSMutableArray array];
    }
    
    return _frameArr;
}


@end
