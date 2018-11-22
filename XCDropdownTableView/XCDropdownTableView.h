//
//  XCDropdownTableView.h
//  测试下拉列表Demo
//
//  Created by 樊小聪 on 2017/4/1.
//  Copyright © 2017年 樊小聪. All rights reserved.
//


/*
 *  备注：自定义下拉列表视图；视图高度是自动计算的 🐾
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XCDropdownTableViewStyle)
{
    /// 默认样式 --- 只有文字
    XCDropdownTableViewStyleDefault = 0,
    
    /// 自定义样式
    XCDropdownTableViewStyleCustom
};


@interface XCDropdownTableView : UIView

typedef XCDropdownTableView *(^XCDropdownTableViewShow)(void);
typedef XCDropdownTableView *(^XCDropdownTableViewDismiss)(void);
typedef XCDropdownTableView *(^XCDropdownTableViewReloadData)(void);
typedef XCDropdownTableView *(^XCDropdownTableViewMaxShowRows)(NSInteger maxCount);
typedef XCDropdownTableView *(^XCDropdownTableViewRowHeight)(CGFloat rowHeight);
typedef void(^XCDropdownTableViewDidSelectRowHandle)(XCDropdownTableView *drop, UITableView *tableView, NSInteger index);

/*⏰ ----- XCDropdownTableViewStyleDefault ----- ⏰*/
typedef XCDropdownTableView *(^XCDropdownTableViewDataSource)(NSArray<NSString *> *dataSource);
typedef XCDropdownTableView *(^XCDropdownTableViewDefaultSelectedIndex)(NSInteger index);
typedef XCDropdownTableView *(^XCDropdownTableViewMaskBackgroundColor)(UIColor *color);
typedef XCDropdownTableView *(^XCDropdownTableViewNormalTextColor)(UIColor *color);
typedef XCDropdownTableView *(^XCDropdownTableViewSelectedTextColor)(UIColor *color);
typedef XCDropdownTableView *(^XCDropdownTableViewTextFontSize)(CGFloat fontSize);
typedef XCDropdownTableView *(^XCDropdownTableViewTextAlignment)(NSTextAlignment alignment);

/*⏰ ----- XCDropdownTableViewStyleCustom ----- ⏰*/
typedef XCDropdownTableView *(^XCDropdownTableViewRows)(NSInteger rows);
typedef UITableViewCell *(^XCDropdownTableViewCell)(UITableView *tableView, NSIndexPath *indexPath);




/**
 *  显示
 */
- (XCDropdownTableViewShow)show;

/**
 *  消失
 */
- (XCDropdownTableViewDismiss)dismiss;

/**
 *  刷新数据（会自动更新下拉框的高度）
 */
- (XCDropdownTableViewReloadData)reloadData;

/** 👀 最大显示的行数（默认为 5 行，超过 5 行后，则滚动显示） 👀 */
- (XCDropdownTableViewMaxShowRows)maxRows;

/** 👀 行高：默认 50 👀 */
- (XCDropdownTableViewRowHeight)rowHeight;

/** 👀 样式 👀 */
- (XCDropdownTableView *(^)(XCDropdownTableViewStyle style))style;

/** 👀 选中某一行的回调 👀 */
- (XCDropdownTableView *(^)(XCDropdownTableViewDidSelectRowHandle))didSelectRowHandle;

/** 👀 蒙板背景颜色 👀 */
- (XCDropdownTableViewMaskBackgroundColor)maskBackgroundColor;

#pragma mark - 👀 以下方法只在 style == XCDropdownTableViewStyleDefault 的样式下有效  👀 💤
/** 👀 数据源数组：如果是自定义的cell 👀 */
- (XCDropdownTableViewDataSource)dataSource;

/** 👀 默认选中某一行：默认为第 0 行 👀 */
- (XCDropdownTableViewDefaultSelectedIndex)defaultSelectedIndex;

/** 👀 每行文字的对齐方式：默认 NSTextAlignmentLeft 👀 */
- (XCDropdownTableViewTextAlignment)textAlignment;

/** 👀 文字的大小：默认 15 👀 */
- (XCDropdownTableViewTextFontSize)fontSize;

/** 👀 精通状态下文字的颜色：默认 blackColor 👀 */
- (XCDropdownTableViewNormalTextColor)normalTextColor;

/** 👀 选中状态下的文字的颜色：默认 orangeColor 👀 */
- (XCDropdownTableViewSelectedTextColor)selectedTextColor;

#pragma mark - 👀 以下方法只在 style == XCDropdownTableViewStyleCustom 的样式下有效  👀 💤
/** 👀 行数 👀 */
- (XCDropdownTableViewRows)rows;
/** 👀 自定义的cell 👀 */
- (XCDropdownTableView *(^)(XCDropdownTableViewCell cell))cell;

@end



