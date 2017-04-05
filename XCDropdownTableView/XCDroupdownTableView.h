//
//  XCDroupdownTableView.h
//  测试下拉列表Demo
//
//  Created by 樊小聪 on 2017/4/1.
//  Copyright © 2017年 樊小聪. All rights reserved.
//


/*
 *  备注：自定义下拉列表视图；视图高度是自动计算的 🐾
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XCDroupdownTableViewStyle)
{
    /// 默认样式 --- 只有文字
    XCDroupdownTableViewStyleDefault = 0,
    
    /// 自定义样式
    XCDroupdownTableViewStyleCustom
};


@interface XCDroupdownTableView : UIView

typedef XCDroupdownTableView *(^XCDroupdownTableViewShow)();
typedef XCDroupdownTableView *(^XCDroupdownTableViewMaxShowRows)(NSInteger maxCount);
typedef XCDroupdownTableView *(^XCDroupdownTableViewRowHeight)(CGFloat rowHeight);
typedef void(^XCDroupdownTableViewDidSelectRowHandle)(XCDroupdownTableView *drop, UITableView *tableView, NSInteger index);

/*⏰ ----- XCDroupdownTableViewStyleDefault ----- ⏰*/
typedef XCDroupdownTableView *(^XCDroupdownTableViewDataSource)(NSArray<NSString *> *dataSource);
typedef XCDroupdownTableView *(^XCDroupdownTableViewDefaultSelectedIndex)(NSInteger index);
typedef XCDroupdownTableView *(^XCDroupdownTableViewNormalTextColor)(UIColor *color);
typedef XCDroupdownTableView *(^XCDroupdownTableViewSelectedTextColor)(UIColor *color);
typedef XCDroupdownTableView *(^XCDroupdownTableViewTextFontSize)(CGFloat fontSize);
typedef XCDroupdownTableView *(^XCDroupdownTableViewTextAlignment)(NSTextAlignment alignment);

/*⏰ ----- XCDroupdownTableViewStyleCustom ----- ⏰*/
typedef XCDroupdownTableView *(^XCDroupdownTableViewRows)(NSInteger rows);
typedef UITableViewCell *(^XCDroupdownTableViewCell)(UITableView *tableView, NSIndexPath *indexPath);

/**
 *  显示
 */
- (XCDroupdownTableViewShow)show;

/** 👀 最大显示的行数（默认为 5 行，超过 5 行后，则滚动显示） 👀 */
- (XCDroupdownTableViewMaxShowRows)maxRows;

/** 👀 行高：默认 50 👀 */
- (XCDroupdownTableViewRowHeight)rowHeight;

/** 👀 样式 👀 */
- (XCDroupdownTableView *(^)(XCDroupdownTableViewStyle style))style;

/** 👀 选中某一行的回调 👀 */
- (XCDroupdownTableView *(^)(XCDroupdownTableViewDidSelectRowHandle))didSelectRowHandle;

#pragma mark - 👀 以下方法只在 style == XCDroupdownTableViewStyleDefault 的样式下有效  👀 💤
/** 👀 数据源数组：如果是自定义的cell 👀 */
- (XCDroupdownTableViewDataSource)dataSource;

/** 👀 默认选中某一行：默认为第 0 行 👀 */
- (XCDroupdownTableViewDefaultSelectedIndex)defaultSelectedIndex;

/** 👀 每行文字的对齐方式：默认 NSTextAlignmentLeft 👀 */
- (XCDroupdownTableViewTextAlignment)textAlignment;

/** 👀 文字的大小：默认 15 👀 */
- (XCDroupdownTableViewTextFontSize)fontSize;

/** 👀 精通状态下文字的颜色：默认 blackColor 👀 */
- (XCDroupdownTableViewNormalTextColor)normalTextColor;

/** 👀 选中状态下的文字的颜色：默认 orangeColor 👀 */
- (XCDroupdownTableViewSelectedTextColor)selectedTextColor;

#pragma mark - 👀 以下方法只在 style == XCDroupdownTableViewStyleCustom 的样式下有效  👀 💤
/** 👀 行数 👀 */
- (XCDroupdownTableViewRows)rows;
/** 👀 自定义的cell 👀 */
- (XCDroupdownTableView *(^)(XCDroupdownTableViewCell cell))cell;

@end



