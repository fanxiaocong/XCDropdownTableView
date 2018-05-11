//
//  ViewController.m
//  XCDropdownTableViewExample
//
//  Created by 樊小聪 on 2017/4/5.
//  Copyright © 2017年 樊小聪. All rights reserved.
//

#import "ViewController.h"

#import "XCDroupdownTableView.h"
#import "XXXCell.h"


@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

/**
 *  显示默认的下拉菜单
 */
- (IBAction)didClickDefaultStyleButtonAction:(UIButton *)sender
{
    CGFloat x = CGRectGetMinX(sender.frame);
    CGFloat y = CGRectGetMaxY(sender.frame);
    CGFloat w = CGRectGetWidth(sender.frame);
    CGFloat h = CGRectGetHeight(sender.frame);
    
    XCDroupdownTableView *t = [[XCDroupdownTableView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    t.defaultSelectedIndex(3).maxRows(10).rowHeight(60).fontSize(12).textAlignment(NSTextAlignmentCenter).dataSource(@[@"测试数据一", @"测试数据二", @"测试数据三", @"测试数据四", @"测试数据五", @"测试数据六"]).didSelectRowHandle(^(XCDroupdownTableView *view, UITableView *table, NSInteger row){
        /// 点击某一行的回调
        NSLog(@"点击了第 %zi 行", row);
        
    }).show();
}

/**
 *  显示自定义样式
 */
- (IBAction)didClickCustomStyleButtonAction:(UIButton *)sender
{
    CGFloat x = CGRectGetMinX(sender.frame);
    CGFloat y = CGRectGetMaxY(sender.frame);
    CGFloat w = CGRectGetWidth(sender.frame);
    CGFloat h = CGRectGetHeight(sender.frame);
    
    XCDroupdownTableView *t = [[XCDroupdownTableView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    t.style(XCDroupdownTableViewStyleCustom).rows(10).rowHeight(80).maxRows(10).cell(^(UITableView *tableView, NSIndexPath *indexPath){
        
        /// 配置自定义的cell
        static NSString *cellIdentifier = @"XXXCell";
        XXXCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil] lastObject];
        }
        cell.numberTextLB.text = @(indexPath.row).description;
        return cell;
        
    }).didSelectRowHandle(^(XCDroupdownTableView *view, UITableView *table, NSInteger row){
        
        NSLog(@"点击了第 %zi 行", row);
        
    }).show();
}


@end
