//
//  ZWCustomPopView.m
//  ZWCustomPopView
//
//  Created by 郑亚伟 on 16/9/19.
//  Copyright © 2016年 郑亚伟. All rights reserved.
//

#import "ZWCustomPopView.h"

#pragma mark -ZWCustomPopContainerView内部新建类
//自己在这里再写一个ZWCustomPopContainerView类
@interface ZWCustomPopContainerView :UIView
@property (nonatomic, strong) CAShapeLayer *popLayer;
//三角形顶点的X坐标
@property (nonatomic, assign) CGFloat  apexOftriangelX;
@property (nonatomic, strong) UIColor *layerColor;
@end

@implementation ZWCustomPopContainerView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addObserver:self forKeyPath:@"frame" options:0 context:NULL];
    }
    return self;
}

- (CAShapeLayer *)popLayer
{
    if (nil == _popLayer) {
        _popLayer = [[CAShapeLayer alloc]init];
        //将这个_popLayer粘在这个view上，外部调用这个view的时候，始终会显示这个layer层
        [self.layer addSublayer:_popLayer];
    }
    return _popLayer;
}
//系统方法KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"frame"]) {
        CGRect newFrame = CGRectNull;
        if([object valueForKeyPath:keyPath] != [NSNull null]) {
            newFrame = [[object valueForKeyPath:keyPath] CGRectValue];
            [self setLayerFrame:newFrame];
        }
    }
}
//frame的值一改变，便回调用这二个方法
//只要有三角形顶点坐标，再加上自己的宽和高，便可确定位置，所以小三角的顶点坐标设置为属性
- (void)setLayerFrame:(CGRect)frame
{
    //这里设置了一个变量
    float apexOfTriangelX;
    
    if (_apexOftriangelX == 0) {
        apexOfTriangelX = frame.size.width - 60;
    }else
    {
        apexOfTriangelX = _apexOftriangelX;
    }
    //从三角形的顶点开始画线，刚好是7个点，即0-6
    if (apexOfTriangelX > frame.size.width - kPopOverLayerCornerRadius) {
        apexOfTriangelX = frame.size.width - kPopOverLayerCornerRadius - 0.5 * kTriangleWidth;
    }else if (apexOfTriangelX < kPopOverLayerCornerRadius) {
        apexOfTriangelX = kPopOverLayerCornerRadius + 0.5 * kTriangleWidth;
    }
    //这里是从三角形的顶点到三角形的坐标的点开始画线
    CGPoint point0 = CGPointMake(apexOfTriangelX, 0);
    CGPoint point1 = CGPointMake(apexOfTriangelX - 0.5 * kTriangleWidth, kTriangleHeight);
    CGPoint point2 = CGPointMake(kPopOverLayerCornerRadius, kTriangleHeight);
    CGPoint point2_center = CGPointMake(kPopOverLayerCornerRadius, kTriangleHeight + kPopOverLayerCornerRadius);
    CGPoint point3 = CGPointMake(0, frame.size.height - kPopOverLayerCornerRadius);
    CGPoint point3_center = CGPointMake(kPopOverLayerCornerRadius, frame.size.height - kPopOverLayerCornerRadius);
    CGPoint point4 = CGPointMake(frame.size.width - kPopOverLayerCornerRadius, frame.size.height);
    CGPoint point4_center = CGPointMake(frame.size.width - kPopOverLayerCornerRadius, frame.size.height - kPopOverLayerCornerRadius);
    CGPoint point5 = CGPointMake(frame.size.width, kTriangleHeight + kPopOverLayerCornerRadius);
    CGPoint point5_center = CGPointMake(frame.size.width - kPopOverLayerCornerRadius, kTriangleHeight + kPopOverLayerCornerRadius);
    CGPoint point6 = CGPointMake(apexOfTriangelX + 0.5 * kTriangleWidth, kTriangleHeight);

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point0];
    [path addLineToPoint:point1];
    [path addLineToPoint:point2];
    [path addArcWithCenter:point2_center radius:kPopOverLayerCornerRadius startAngle:3*M_PI_2 endAngle:M_PI clockwise:NO];
    
    [path addLineToPoint:point3];
    [path addArcWithCenter:point3_center radius:kPopOverLayerCornerRadius startAngle:M_PI endAngle:M_PI_2 clockwise:NO];
    
    [path addLineToPoint:point4];
    [path addArcWithCenter:point4_center radius:kPopOverLayerCornerRadius startAngle:M_PI_2 endAngle:0 clockwise:NO];
    
    [path addLineToPoint:point5];
    [path addArcWithCenter:point5_center radius:kPopOverLayerCornerRadius startAngle:0 endAngle:3*M_PI_2 clockwise:NO];
    
    [path addLineToPoint:point6];
    [path closePath];
    
    self.popLayer.path = path.CGPath;
    //如果设置_layerColor就显示_layerColor的颜色，否者默认为greenColor
    self.popLayer.fillColor = _layerColor? _layerColor.CGColor : [UIColor greenColor].CGColor;
}
- (void)setApexOftriangelX:(CGFloat)apexOftriangelX
{
    _apexOftriangelX = apexOftriangelX;
    [self setLayerFrame:self.frame];
    
}

- (void)setLayerColor:(UIColor *)layerColor
{
    _layerColor = layerColor;
    [self setLayerFrame:self.frame];
}
- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    //设置刚出来时的动画效果显示1.2倍，然后变回原来大小
    self.transform = CGAffineTransformMakeScale(1.2,1.2);
    self.alpha = 0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.transform = CGAffineTransformMakeScale(1.0,1.0);
    self.alpha = 1;
    [UIView commitAnimations];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"frame"];
}
@end




#pragma mark -ZWCustomPopView
@interface ZWCustomPopView ()<UITableViewDataSource,UITableViewDelegate>
//ZWCustomPopContainerView
@property (nonatomic, strong) ZWCustomPopContainerView *containerView;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *titleMenus;
@end

@implementation ZWCustomPopView
//
- (ZWCustomPopContainerView *)containerView
{
    if (nil == _containerView) {
        _containerView = [[ZWCustomPopContainerView alloc]init];
        [self addSubview:_containerView];
    }
    return _containerView;
}

- (UITableView *)table
{
    if (nil == _table) {
        _table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.tableFooterView = [UIView new];
        _table.layer.cornerRadius = kPopOverLayerCornerRadius;
        _table.clipsToBounds = YES;
    }
    return _table;
}

//如果调用这个方法就会使用tableView
- (instancetype)initWithBounds:(CGRect)bounds titleMenus:(NSArray *)titles maskAlpha:(CGFloat)alpha
{
    self = [super initWithFrame:bounds];
    if (self) {
        //注意这里  这里只是设置颜色的alpha 不是整个View的alpha，如果设置整个View的alpha，子视图的alpha也会改变
        //self.backgroundColor = [UIColor colorWithHue:100 saturation:10 brightness:200 alpha:0.2];
        //self.backgroundColor = [UIColor colorWithRed:240.f green:240.f blue:240.f alpha:1];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:alpha];
        self.titleMenus = titles;
        self.table.frame = CGRectMake(0, 0, CGRectGetWidth(bounds), CGRectGetHeight(bounds));
        self.table.delegate = self;
        self.table.dataSource = self;
        //这里把tableView设置为content，外部也可以自定义
        [self setContent:self.table];
        _table.scrollEnabled = NO;
        if ([_table respondsToSelector:@selector(setSeparatorInset:)]) {
            //让线头不留白
            [_table setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_table respondsToSelector:@selector(setLayoutMargins:)]) {
            [_table setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return self;
}

#pragma mark- set background color
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //注意这里  这里只是设置颜色的alpha 不是整个View的alpha，如果设置整个View的alpha，子视图的alpha也会改变
        //这个0.1用来控制蒙板效果的alpha
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        //self.backgroundColor = [UIColor colorWithRed:20.f green:100.f blue:100.f alpha:1];
    }
    return self;
}
+ (instancetype)popOverView
{
    return [[self alloc]init];
}

- (void)setContent:(UIView *)content
{
    _content = content;
    CGRect contentFrame = content.frame;
    contentFrame.origin.x = kRoundMargin;
    contentFrame.origin.y = kTriangleHeight + kRoundMargin;
    content.frame = contentFrame;
    
    CGRect  temp = self.containerView.frame;
    temp.size.width = CGRectGetMaxX(contentFrame) + kRoundMargin; // left and right space
    temp.size.height = CGRectGetMaxY(contentFrame) + kRoundMargin;
    self.containerView.frame = temp;
    [self.containerView addSubview:content];
}

- (void)setContentViewController:(UIViewController *)contentViewController{
    _contentViewController = contentViewController;
    [self setContent:_contentViewController.view];
}

- (void)setContainerBackgroudColor:(UIColor *)containerBackgroudColor{
    _containerBackgroudColor = containerBackgroudColor;
    self.containerView.layerColor = _containerBackgroudColor;
}

- (void)showFrom:(UIView *)from alignStyle:(CPAlignStyle)style
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    //窗口上粘贴这个类，并将这个类的frame和window的frame大小设置的一致
    [window addSubview:self];
    self.frame = window.bounds;
    CGRect newFrame = [from convertRect:from.bounds toView:window];
    CGRect containerViewFrame = self.containerView.frame;
    //使containerView的frame靠近，点击按钮的下方5个长度
    containerViewFrame.origin.y =  CGRectGetMaxY(newFrame) + 5;
    self.containerView.frame = containerViewFrame;
    switch (style) {
        case CPAlignStyleCenter:
        {
            CGPoint center = self.containerView.center;
            center.x = CGRectGetMidX(newFrame);
            self.containerView.center = center;
            
            self.containerView.apexOftriangelX = CGRectGetWidth(self.containerView.frame)/2;
        }
            break;
        case CPAlignStyleLeft:
        {
            CGRect frame = self.containerView.frame;
            frame.origin.x = CGRectGetMinX(newFrame);
            self.containerView.frame = frame;
            
            self.containerView.apexOftriangelX = CGRectGetWidth(from.frame)/2;
        }
            break;
        case CPAlignStyleRight:
        {
            CGRect frame = self.containerView.frame;
            frame.origin.x = CGRectGetMinX(newFrame) - (fabs(frame.size.width - newFrame.size.width));
            self.containerView.frame = frame;
            
            self.containerView.apexOftriangelX = CGRectGetWidth(self.containerView.frame) - CGRectGetWidth(from.frame)/2;
        }
            break;
        default:
            break;
    }
    if ([self.delegate respondsToSelector:@selector(popOverViewDidShow:)]) {
        [self.delegate popOverViewDidShow:self];
    }
}
- (void)dismiss
{
    // animations support
    [UIView animateWithDuration:0.2 animations:^{
        self.containerView.transform = CGAffineTransformMakeScale(0.9,0.9);
        self.containerView.alpha = 0;
    } completion:^(BOOL finished) {
        self.containerView.hidden = YES;
        //完成动画后要移除
        [self removeFromSuperview];
    }];
    //移除后的代理方法
    if ([self.delegate respondsToSelector:@selector(popOverViewDidDismiss:)]) {
        [self.delegate popOverViewDidDismiss:self];
    }
}
//点击隐藏
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}


#pragma mark- <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleMenus.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"GYPopOverCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor colorWithRed:68.0/255.0 green:77.0/255.0 blue:86.0/255.0 alpha:1.0];
        
        
    }
    cell.textLabel.text = self.titleMenus[indexPath.row];
        cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismiss];
    //代理方法
    if ([self.delegate respondsToSelector:@selector(popOverView:didClickMenuIndex:)]) {
        [self.delegate popOverView:self didClickMenuIndex:indexPath.row];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}




@end
