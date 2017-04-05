//
//  ViewController.m
//  XCDropdownTableViewExample
//
//  Created by 樊小聪 on 2017/4/5.
//  Copyright © 2017年 樊小聪. All rights reserved.
//

#import "ViewController.h"

#import "XCDroupdownTableView.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)didClickButton:(id)sender {
    
    XCDroupdownTableView *t = [[XCDroupdownTableView alloc] initWithFrame:CGRectMake(100, 100, 300, 100)];
    
    t.defaultSelectedIndex(11).dataSource(@[@"测试数据一", @"测试数据二", @"测试数据三", @"测试数据四", @"测试数据五", @"测试数据六"]).didSelectRowHandle(^(XCDroupdownTableView *view, UITableView *table, NSInteger row){
        
        NSLog(@"点击了第 %zi 行", row);
        
    }).show();
}

@end
