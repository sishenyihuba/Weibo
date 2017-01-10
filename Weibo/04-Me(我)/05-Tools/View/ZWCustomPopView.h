//
//  ZWCustomPopView.h
//  ZWCustomPopView
//
//  Created by 郑亚伟 on 16/9/19.
//  Copyright © 2016年 郑亚伟. All rights reserved.
//
/*
 主要思路：
 1.创建一个view类，并在其上放置一个layer层。这个view类对外提供contentView和三角行顶点坐标，根据三角形的顶点坐标和这个view的宽高，就可以确定这个layer层的位置。
 2.创建另一个view类，获取当前window，将该view放在window上。然后将第一个view放置在这个view上。这个view类主要是充当蒙板作用，借助UIWindow可以实现坐标的转换，在特定按钮下弹出这个popView。
 */
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, CPAlignStyle) {
    CPAlignStyleCenter,
    CPAlignStyleLeft,
    CPAlignStyleRight,
};

// 小三角的高度
#define kTriangleHeight 8.0
// 小三角的宽度
#define kTriangleWidth 10.0
// 弹出视图背景的圆角半径
//如果是自定义视图contentView，这个contentView最好也要将其半径设置为这个数值，否则会出现边界线显示不完全的情况
#define kPopOverLayerCornerRadius 5.0
// 调整弹出视图背景四周的空隙
#define kRoundMargin 5.0

@class ZWCustomPopView;
@protocol ZWCustomPopViewDelegate <NSObject>

@optional
- (void)popOverViewDidShow:(ZWCustomPopView *)pView;
- (void)popOverViewDidDismiss:(ZWCustomPopView *)pView;
// for normal use
// 普通用法（点击菜单）的回调
- (void)popOverView:(ZWCustomPopView *)pView didClickMenuIndex:(NSInteger)index;
@end



@interface ZWCustomPopView : UIView
@property (nonatomic,   weak) id<ZWCustomPopViewDelegate> delegate;
// you can set custom view or custom viewController
@property (nonatomic, strong) UIView *content;
@property (nonatomic, strong) UIViewController *contentViewController;
@property (nonatomic, strong) UIColor *containerBackgroudColor;

//调用这个实现自定义
+ (instancetype)popOverView;
// 简单使用的话，直接传一组菜单，会以tableview的形式展示，可以自己修改tableview属性
- (instancetype)initWithBounds:(CGRect)bounds titleMenus:(NSArray *)titles maskAlpha:(CGFloat)alpha;
//设置popView弹出来的位置
- (void)showFrom:(UIView *)from alignStyle:(CPAlignStyle)style;
//隐藏popView
- (void)dismiss;

@end
