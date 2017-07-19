//
//  ViewController.m
//  JZLPhotoBrowser
//
//  Created by allenjzl on 2017/6/5.
//  Copyright © 2017年 allenjzl. All rights reserved.
//

#import "ViewController.h"
#import "LocalViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableview;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.view.backgroundColor =  [UIColor whiteColor];
    [self setupUI];
}


- (void)setupUI {
    [self.view addSubview:self.tableview];
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseID" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"图片浏览器";
    }else {
        cell.textLabel.text = @"图片选择器";
    }
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        LocalViewController *vc = [[LocalViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"嘿嘿,图片选择器还没完成,以后会加上的,谢谢!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ensureAc = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
  
        }];
        
        
        [alertVc addAction:ensureAc];
        
        [self presentViewController:alertVc animated:YES completion:^{
            
        }];
    }
    
    
    
}






#pragma mark - lazy
- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseID"];
        _tableview.rowHeight = 44;
        
        
    }
    return _tableview;
}


@end
