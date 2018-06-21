//
//  LDGridView.h
//  宫格布局
//
//  Created by ld on 16/9/8.
//  Copyright © 2016年 ld. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIView *(^fetchItemBlock)(NSInteger index);

@interface LDGridView : UIView

/**
 在某个view上布局宫格，且宫格的宽度与父视图一致，高度由item个数决定

 @param desView          父视图
 @param count            item个数
 @param col              列数
 @param itemH            每个item的高度 值<=0 则item的宽高相等
 @param margin           item间距
 @param startY           宫格在父视图Y的位置
 @param fetchItemAtIndex 获取item UI的block

 @return 宫格
 */
+(instancetype)configSubItemsIn:(UIView *)desView count:(NSInteger)count col:(NSInteger)col itemH:(CGFloat)itemH margin:(CGFloat)margin startY:(CGFloat)startY fetchItemAtIndex:(fetchItemBlock) fetchItemAtIndex;

/**
 布局宫格
 @param count               总的item的个数
 @param col                 宫格有多少列
 @param itemH               每个item的高度 值<=0 则item的宽高相等
 @param fetchItemAtIndex    获取item
 */
- (void)configItemsByItemCount:(NSInteger)count col:(NSInteger)col itemH:(CGFloat)itemH fetchItemAtIndex:(fetchItemBlock)fetchItemAtIndex;

/**
 相邻item之间的距离，需在布局宫格方法之前设置
 */
@property (assign ,nonatomic) CGFloat itemMargin;
/**
 * 自身高度
 */
@property (assign ,nonatomic) CGFloat contentHeight;

@end
