//
//  XCDropdownTableView.m
//  测试下拉列表Demo
//
//  Created by 樊小聪 on 2017/4/1.
//  Copyright © 2017年 樊小聪. All rights reserved.
//


/*
 *  备注：自定义下拉列表视图 🐾
 */

#import "XCDropdownTableView.h"

#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height

#define RGBA_COLOR(R,G,B,A)     [UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]

#define SEPERATOR_LINE_COLOR    RGBA_COLOR(226, 226, 226, 1)

#define MAX_ROWS_COUNT  5               // 内容最大显示的 行数， 超过之后，内容滚动显示
#define CELL_HEIGHT             50.f    // 每行 显示的高度
#define TEXT_FONT_SIZE          15.f    // 文字的大小
#define NORMAL_TEXT_COLOR       [UIColor blackColor]    // 普通状态下的文字颜色
#define SELECTED_TEXT_COLOR     [UIColor orangeColor]   // 选中状态下的文字颜色
#define DURATION                .3f
// 弱引用
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

/* 🐖 ***************************** 🐖 XCDropdownDefaultCell 🐖 *****************************  🐖 */

@interface XCDropdownDefaultCell : UITableViewCell
@property (weak, nonatomic, readonly) UILabel *contentLB;
@end

@implementation XCDropdownDefaultCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UILabel *contentLB = [[UILabel alloc] init];
        _contentLB = contentLB;
        [self.contentView addSubview:contentLB];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentLB.frame = UIEdgeInsetsInsetRect(self.contentView.bounds, UIEdgeInsetsMake(0, 15, 0, 15));
}
@end

/* 🐖 ***************************** 🐖 XCDropdownTableView 🐖 *****************************  🐖 */

@interface XCDropdownTableView ()<UITableViewDataSource, UITableViewDelegate>

/** 👀 蒙板 👀 */
@property (weak, nonatomic) UIButton *mask;
/** 👀 表格视图 👀 */
@property (weak, nonatomic) UITableView *tableView;

/** 👀 最大显示的数量 👀 */
@property (assign, nonatomic) NSInteger maxCount;
/** 👀 行高 👀 */
@property (assign, nonatomic) CGFloat rowH;
/** 👀 cell的样式 👀 */
@property (assign, nonatomic) XCDropdownTableViewStyle cellStyle;
/** 👀 选中某一行的回调 👀 */
@property (copy, nonatomic) XCDropdownTableViewDidSelectRowHandle selectedHandle;
/** 👀 点击蒙板的回调 👀 */
@property (copy, nonatomic) XCDropdownTableViewDidClickMaskHandle clickMaskHandle;


/// style == XCDropdownTableViewStyleDefault
/** 👀 数据源数组 👀 */
@property (strong, nonatomic) NSArray<NSString *> *dataArr;
/** 👀 选中的下标 👀 */
@property (assign, nonatomic) NSInteger selectedIndex;
/** 👀 文字的对齐方式 👀 */
@property (assign, nonatomic) NSTextAlignment alignment;
/** 👀 文字的大小 👀 */
@property (assign, nonatomic) CGFloat textFontSize;
/** 👀 普通状态下的文字颜色 👀 */
@property (weak, nonatomic) UIColor *normalColor;
/** 👀 选中状态下的文字颜色 👀 */
@property (weak, nonatomic) UIColor *selectedColor;



/// style == XCDropdownTableViewStyleCustom
/** 👀 cell的个数 👀 */
@property (assign, nonatomic) NSInteger cellCount;
/** 👀 自定义cell 👀 */
@property (copy, nonatomic) XCDropdownTableViewCell customCell;

@end


@implementation XCDropdownTableView

#pragma mark - 👀 Init Method 👀 💤

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        // 设置默认参数
        [self setupDefaults];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        // 设置默认参数
        [self setupDefaults];
    }
    
    return self;
}

// 设置默认参数
- (void)setupDefaults
{
    /// 配置默认数据
    [self configureData];
    
    /// 配置 UI
    [self configureUI];
}

/**
 *  配置默认数据
 */
- (void)configureData
{
    self.cellStyle      = XCDropdownTableViewStyleDefault;
    self.maxCount       = MAX_ROWS_COUNT;
    self.rowH           = CELL_HEIGHT;
    self.alignment      = NSTextAlignmentLeft;
    self.textFontSize   = TEXT_FONT_SIZE;
    self.normalColor    = NORMAL_TEXT_COLOR;
    self.selectedColor  = SELECTED_TEXT_COLOR;
}

/**
 *  配置 UI
 */
- (void)configureUI
{
    /**
     *  视图添加结构
     *
     *  keyWindow
     self
     tableView
     
     maskView
     */
    
    /*⏰ ----- 添加背景蒙板 ----- ⏰*/
    UIButton *maskView = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
    maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3f];
    [maskView addTarget:self action:@selector(clickMaskAction) forControlEvents:UIControlEventTouchUpInside];
    self.mask = maskView;
    [[UIApplication sharedApplication].keyWindow addSubview:maskView];
    
    /*⏰ ----- 添加内容视图 ----- ⏰*/
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView = tableView;
    tableView.delegate   = self;
    tableView.dataSource = self;
    tableView.rowHeight  = self.rowH;
    tableView.tableFooterView = [[UIView alloc] init];
    self.tableView = tableView;
    [self addSubview:tableView];
}

#pragma mark - 📕 👀 UITableViewDataSource 👀

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.cellStyle == XCDropdownTableViewStyleDefault)
    {
        return self.dataArr.count;
    }
    
    return self.cellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cellStyle == XCDropdownTableViewStyleCustom)
    {
        /// 是自定义的 cell
        if (self.customCell)
        {
            return self.customCell(tableView, indexPath);
        }
    }
    
    /// 非定义 cell
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        if (self.cellStyle == XCDropdownTableViewStyleCustom)
        {
            return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        else
        {
            /// 非自定义的cell
            cell = [[XCDropdownDefaultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    /// 配置数据
    if (self.dataArr.count > indexPath.row)
    {
        NSString *title = self.dataArr[indexPath.row];
        
        UILabel *contentLB = ((XCDropdownDefaultCell *)cell).contentLB;
        contentLB.text = title;
        contentLB.font = [UIFont systemFontOfSize:self.textFontSize];
        
        UIColor *titleColor = self.normalColor;
        
        /// 设置选中状态
        if (self.selectedIndex == indexPath.row)
        {
            titleColor = self.selectedColor;
        }
        
        contentLB.textColor     = titleColor;
        contentLB.textAlignment = self.alignment;
    }
    
    return cell;
}

#pragma mark - 💉 👀 UITableViewDelegate 👀

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismiss];
    
    if (self.selectedHandle)
    {
        self.selectedHandle(self, tableView, indexPath.row);
    }
}

// 设置分隔线的样式
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - 🎬 👀 Action Method 👀

/**
 *  点击蒙板的回调
 */
- (void)clickMaskAction
{
    if (self.clickMaskHandle) {
        self.clickMaskHandle(self);
    }
    
    [self dismiss];
}

#pragma mark - 🔒 👀 Privite Method 👀

/**
 *  获取内容的高度
 */
- (CGFloat)_fetchContentHeight
{
    /// cell 真实显示的数量
    NSInteger cellRealCount = self.dataArr.count;
    
    if (self.cellStyle == XCDropdownTableViewStyleCustom)
    {
        cellRealCount = self.cellCount;
    }
    
    return (MIN(cellRealCount, self.maxCount)) * self.rowH;
}

/**
 *  隐藏
 */
- (void)_dismiss
{
    WS(weakSelf);
    
    /*⏰ ----- 设置 tableView 的显示与隐藏 ----- ⏰*/
    __block CGRect rectTable = self.tableView.frame;
    
    [UIView animateWithDuration:DURATION animations:^{
        
        rectTable.size.height = 0;
        
        weakSelf.tableView.frame = rectTable;
        weakSelf.mask.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [weakSelf.mask removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}


#pragma mark - 🔓 👀 Public Method 👀

/**
 *  显示
 */
- (XCDropdownTableViewShow)show
{
    /// 添加至 窗口
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    /*⏰ ----- 重置 frame ----- ⏰*/
    CGRect rect = self.frame;
    rect.size.height = [self _fetchContentHeight];
    self.frame = rect;
    
    /*⏰ ----- 设置 tableView 的显示与隐藏 ----- ⏰*/
    CGFloat tableX = 0;
    CGFloat tableY = 0;
    CGFloat tableW = CGRectGetWidth(self.frame);
    CGFloat tableH = [self _fetchContentHeight];
    
    /// 检测当前 tableView 是否已经超过屏幕显示的范围
    if ((tableH + CGRectGetMinY(self.frame)) > SCREEN_HEIGHT) {
        tableH = SCREEN_HEIGHT - CGRectGetMinY(self.frame);
    }
    
    self.tableView.frame = CGRectMake(tableX, tableY, tableW, 0);
    self.mask.alpha = 0;
    
    WS(weakSelf);
    
    /// 设置阴影
    self.layer.shadowOpacity = 0.6f;
    self.layer.shadowOffset  = CGSizeMake(3, 3);
    self.layer.shadowRadius  = 3;
    
    [UIView animateWithDuration:DURATION animations:^{
        
        weakSelf.mask.alpha   = 1.f;
        weakSelf.tableView.frame = CGRectMake(tableX, tableY, tableW, tableH);
    }];
    
    /// 刷新 表格
    [self.tableView reloadData];
    
    return ^XCDropdownTableView *{
        
        return weakSelf;
    };
}

- (XCDropdownTableViewDismiss)dismiss
{
    [self _dismiss];
    
    WS(weakSelf);
    return ^XCDropdownTableView *{
        return weakSelf;
    };
}

- (XCDropdownTableViewReloadData)reloadData
{
    /*⏰ ----- 重置 frame ----- ⏰*/
    CGRect rect = self.frame;
    rect.size.height = [self _fetchContentHeight];
    self.frame = rect;
    
    /*⏰ ----- 设置 tableView 的显示与隐藏 ----- ⏰*/
    CGFloat tableX = 0;
    CGFloat tableY = 0;
    CGFloat tableW = CGRectGetWidth(self.frame);
    CGFloat tableH = [self _fetchContentHeight];
    
    /// 检测当前 tableView 是否已经超过屏幕显示的范围
    if ((tableH + CGRectGetMinY(self.frame)) > SCREEN_HEIGHT) {
        tableH = SCREEN_HEIGHT - CGRectGetMinY(self.frame);
    }
    
    WS(weakSelf);
    [UIView animateWithDuration:DURATION animations:^{
        weakSelf.tableView.frame = CGRectMake(tableX, tableY, tableW, tableH);
    }];
    
    /// 刷新 表格
    [self.tableView reloadData];
    
    return ^XCDropdownTableView *{
        
        return weakSelf;
    };
}

/** 👀 最大显示的行数（默认为 5 行，超过 5 行后，则滚动显示） 👀 */
- (XCDropdownTableViewMaxShowRows)maxRows
{
    WS(weakSelf);
    
    return ^XCDropdownTableView *(NSInteger maxCount){
        
        weakSelf.maxCount = maxCount;
        
        return weakSelf;
    };
}

/** 👀 行高：默认 50 👀 */
- (XCDropdownTableViewRowHeight)rowHeight
{
    WS(weakSelf);
    
    return ^XCDropdownTableView *(CGFloat rowHeight){
        
        weakSelf.rowH = rowHeight;
        weakSelf.tableView.rowHeight = rowHeight;
        
        return weakSelf;
    };
}

/** 👀 样式 👀 */
- (XCDropdownTableView *(^)(XCDropdownTableViewStyle style))style
{
    WS(weakSelf);
    
    return ^XCDropdownTableView *(XCDropdownTableViewStyle style){
        
        weakSelf.cellStyle = style;
        
        return weakSelf;
    };
}

/** 👀 蒙板背景颜色 👀 */
- (XCDropdownTableViewMaskBackgroundColor)maskBackgroundColor
{
    WS(weakSelf);
    
    return ^XCDropdownTableView *(UIColor *color){
        
        weakSelf.mask.backgroundColor = color;
        
        return weakSelf;
    };
}

#pragma mark 以下方法只在 style == XCDropdownTableViewStyleDefault 的样式下有效 👀 💤
/** 👀 数据源数组：如果是自定义的cell 👀 */
- (XCDropdownTableViewDataSource)dataSource
{
    WS(weakSelf);
    
    return ^XCDropdownTableView *(NSArray<NSString *> *dataSource){
        
        /// 设置 数据源
        weakSelf.dataArr = dataSource;
        
        return weakSelf;
    };
}

/** 👀 默认选中某一行 👀 */
- (XCDropdownTableViewDefaultSelectedIndex)defaultSelectedIndex
{
    WS(weakSelf);
    
    return ^XCDropdownTableView *(NSInteger index){
        
        weakSelf.selectedIndex = index;
        
        return weakSelf;
    };
}

/** 👀 每行文字的对齐方式：默认 NSTextAlignmentLeft 👀 */
- (XCDropdownTableViewTextAlignment)textAlignment
{
    WS(weakSelf);
    
    return ^XCDropdownTableView *(NSTextAlignment alignment){
        
        weakSelf.alignment = alignment;
        
        return weakSelf;
    };
}

/** 👀 文字的大小：默认 15 👀 */
- (XCDropdownTableViewTextFontSize)fontSize
{
    WS(weakSelf);
    
    return ^XCDropdownTableView *(CGFloat fontSize){
        
        weakSelf.textFontSize = fontSize;
        
        return weakSelf;
    };
}

/** 👀 精通状态下文字的颜色：默认 blackColor 👀 */
- (XCDropdownTableViewNormalTextColor)normalTextColor
{
    WS(weakSelf);
    
    return ^XCDropdownTableView *(UIColor *color){
        
        weakSelf.normalColor = color;
        
        return weakSelf;
    };
}

/** 👀 选中状态下的文字的颜色：默认 orangeColor 👀 */
- (XCDropdownTableViewSelectedTextColor)selectedTextColor
{
    WS(weakSelf);
    
    return ^XCDropdownTableView *(UIColor *color){
        
        weakSelf.selectedColor = color;
        
        return weakSelf;
    };
}

/** 👀 选中某一行的回调 👀 */
- (XCDropdownTableView *(^)(XCDropdownTableViewDidSelectRowHandle))didSelectRowHandle
{
    WS(weakSelf);
    
    return ^XCDropdownTableView *(XCDropdownTableViewDidSelectRowHandle handle){
        
        weakSelf.selectedHandle = handle;
        
        return weakSelf;
    };
}

- (XCDropdownTableView *(^)(XCDropdownTableViewDidClickMaskHandle))didClickMaskHandle
{
    WS(weakSelf);
    
    return ^XCDropdownTableView *(XCDropdownTableViewDidClickMaskHandle handle){
        
        weakSelf.clickMaskHandle = handle;
        
        return weakSelf;
    };
}

#pragma mark 以下方法只在 style == XCDropdownTableViewStyleCustom 的样式下有效  👀 💤
/** 👀 行数 👀 */
- (XCDropdownTableViewRows)rows
{
    WS(weakSelf);
    
    return ^XCDropdownTableView *(NSInteger rows){
        
        weakSelf.cellCount = rows;
        
        return weakSelf;
    };
}

/** 👀 自定义的cell 👀 */
- (XCDropdownTableView *(^)(XCDropdownTableViewCell))cell
{
    WS(weakSelf);
    
    return ^XCDropdownTableView *(XCDropdownTableViewCell cell){
        
        weakSelf.customCell = cell;
        
        return weakSelf;
    };
}

@end


