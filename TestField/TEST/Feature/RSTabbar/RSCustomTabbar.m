//
//  RSCustomTabbar.m
//  TEST
//
//  Created by 111 on 2021/12/20.
//

#import "RSCustomTabbar.h"
#import "UIView + RSExtension.h"
#import "TabBarConst.h"

@interface RSCustomTabbar ()
@property (nonatomic,weak) UIButton *button;
@end

@implementation RSCustomTabbar

- (UIButton *)button {
    if (_button == nil) {
        UIButton * button = [[UIButton alloc] init];
        [button addTarget:self action:@selector(didBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:button];
        _button = button;
    }
    return _button;
}

- (void)didBtnAction:(UIButton*)btn {
    if (self.btnClickBlock) {
        self.btnClickBlock(btn);
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setTranslucent:NO];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat itemW = self.width/5.0;
    
    for (UIView *subviews in self.subviews)
    {
        //取到系统tabbar的Item方法
        if ([@"UITabBarButton" isEqualToString:NSStringFromClass(subviews.class)]){
//            subviews.left = index * itemW;
//            subviews.width = itemW;
//            if (index >= 2)
//            {
//                subviews.left +=itemW;
//            }
//            index++;
        }
    }
    self.button.frame = CGRectMake(0, 0, itemW, itemW);
    self.button.center = CGPointMake(self.width/2.0, (self.height - 15 - rs_safeBottomMargin)/2.0);
}

//判断点是否在响应范围
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.isHidden == NO) {
        UIBezierPath *circle  = [UIBezierPath bezierPathWithArcCenter:self.button.center radius:35 startAngle:0 endAngle:2* M_PI clockwise:YES];
        UIBezierPath *tabbar  = [UIBezierPath bezierPathWithRect:self.bounds];
        if ( [circle containsPoint:point] || [tabbar containsPoint:point]) {
            return YES;
        }
        return NO;
    }else {
        return [super pointInside:point withEvent:event];
    }
}

+ (void)setTabBarUI:(NSArray*)views tabBar:(UITabBar*)tabBar topLineColor:(UIColor*)lineColor backgroundColor:(UIColor*)backgroundColor{
    [views enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
            if ([obj viewWithTag:999] == nil) {
                UIView *top = [[UIView alloc] initWithFrame:CGRectMake(0, -20, tabBar.bounds.size.width, 20)];
                top.userInteractionEnabled = NO;
                top.backgroundColor = [UIColor clearColor];
                top.tag = 999;
                
                [obj addSubview:[[self class] addTopViewToParentView:top topLineColor:lineColor backgroundColor:backgroundColor]];
            }
            
        }
    }];
}



+ (UIView*)addTopViewToParentView:(UIView*)parent topLineColor:(UIColor*)lineColor backgroundColor:(UIColor*)backgroundColor {
    //
    UIBezierPath *path = [UIBezierPath bezierPath];
    //
    CGPoint p0 = CGPointMake(0.0, 20);
    CGPoint p1 = CGPointMake(parent.bounds.size.width/2.0 - 50, 20);
    CGPoint p = CGPointMake(parent.bounds.size.width/2.0, 10);
    CGPoint p2 = CGPointMake(parent.bounds.size.width/2.0 + 50, 20);
    CGPoint p3 = CGPointMake(parent.bounds.size.width, 20);
    //
    NSValue *v0 = [NSValue valueWithCGPoint:p0];
    NSValue *v1 = [NSValue valueWithCGPoint:p1];
    NSValue * v = [NSValue valueWithCGPoint:p];
    NSValue *v2 = [NSValue valueWithCGPoint:p2];
    NSValue *v3 = [NSValue valueWithCGPoint:p3];
    //
    NSArray *array = [NSArray arrayWithObjects:v0,  v1, v, v2, v3, nil];
    //
    [path moveToPoint:p0];
    //
    for (NSInteger i=0; i<array.count - 3; i++) {
        CGPoint t0 = [array[i+0] CGPointValue];
        CGPoint t1 = [array[i+1] CGPointValue];
        CGPoint t2 = [array[i+2] CGPointValue];
        CGPoint t3 = [array[i+3] CGPointValue];
        //
        for (int i=0; i<100; i++) {
            CGFloat t = i/100.0;
            CGPoint point = [[self class] getPoint:t p0:t0 p1:t1 p2:t2 p3:t3];
            [path addLineToPoint:point];
        }
    }
    //
    [path addLineToPoint:p3];
    //
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    shapeLayer.frame = CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    shapeLayer.lineWidth = 0.5;
    shapeLayer.lineCap = @"round";
    shapeLayer.strokeColor = [lineColor CGColor];
    shapeLayer.fillColor = [backgroundColor CGColor];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeStart = 0.0;
    shapeLayer.strokeEnd = 1.0;
    [parent.layer addSublayer:shapeLayer];
    parent.userInteractionEnabled = NO;
    return parent;
}

/**
 Catmull-Rom算法
 根据四个点计算中间点
 */
+ (CGPoint)getPoint:(CGFloat)t p0:(CGPoint)p0 p1:(CGPoint)p1 p2:(CGPoint)p2 p3:(CGPoint)p3 {
    CGFloat t2 = t*t;
    CGFloat t3 = t2*t;
    
    CGFloat f0 = -0.5*t3 + t2 - 0.5*t;
    CGFloat f1 = 1.5*t3 - 2.5*t2 + 1.0;
    CGFloat f2 = -1.5*t3 + 2.0*t2 + 0.5*t;
    CGFloat f3 = 0.5*t3 - 0.5*t2;
    
    CGFloat x = p0.x*f0 + p1.x*f1 + p2.x*f2 +p3.x*f3;
    CGFloat y = p0.y*f0 + p1.y*f1 + p2.y*f2 +p3.y*f3;
    
    return CGPointMake(x, y);
}

@end
