//
//  LDGridView.m
//  宫格布局
//
//  Created by ld on 16/9/8.
//  Copyright © 2016年 ld. All rights reserved.
//

#import "LDGridView.h"

@implementation LDGridView

void layoutGird(NSInteger count,NSInteger col,CGFloat margin,CGFloat itemW,CGFloat itemH,UIView * desView,fetchItemBlock fetchItem)
{
    for (int i=0; i<count; i++) {
        int tmpRow = i/col;
        int tmpColum = i%col;
        CGRect itemFrame = CGRectMake(tmpColum * (itemW + margin), tmpRow * (itemH + margin), itemW, itemH);
        if (fetchItem) {
            UIView *sView = fetchItem(i);
            if (sView) {
                sView.frame = itemFrame;
                [desView addSubview:sView];
            }
        }
    }

}

#define HRCOMMONCONFIG(frame,itemMargin)\
NSInteger rowCount = (count-1)/col + 1;\
CGFloat itemW= (frame.size.width - (col - 1) * itemMargin)/col ;\
itemH = itemH > 0 ? itemH : itemW;\
CGFloat contentHeight = rowCount * (itemH + itemMargin) - itemMargin;

+(instancetype)configSubItemsIn:(UIView *)desView count:(NSInteger)count col:(NSInteger)col itemH:(CGFloat)itemH margin:(CGFloat)margin startY:(CGFloat)startY fetchItemAtIndex:(UIView * (^)(NSInteger index))fetchItemAtIndex
{
    HRCOMMONCONFIG(desView.frame, margin)
    
    LDGridView * gridView = [[LDGridView alloc]initWithFrame:CGRectMake(0, startY, desView.bounds.size.width,contentHeight)];
    gridView.itemMargin = margin;
    gridView.contentHeight = contentHeight;
    [desView addSubview:gridView];
    
    layoutGird(count, col, margin, itemW, itemH, gridView,fetchItemAtIndex);
    return gridView;
}

- (void)configItemsByItemCount:(NSInteger)count col:(NSInteger)col itemH:(CGFloat)itemH fetchItemAtIndex:(UIView * (^)(NSInteger index))fetchItemAtIndex
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    HRCOMMONCONFIG(self.frame, _itemMargin)
    self.contentHeight = contentHeight;
    
    layoutGird(count, col, _itemMargin, itemW, itemH, self,fetchItemAtIndex);
}

@end
