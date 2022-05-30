//
//  RSFloatContentBtn.m
//  TEST
//
//  Created by 111 on 2021/12/20.
//

#import "RSFloatContentBtn.h"
#import "NSDate+RSFormat.h"
#import "BaseConstants.h"
#import "UIWindow+Utils.h"
#import "ProjConstants.h"
#import "NSDictionary+plistData.h"

/// 系统默认build
#define MNFloatBtnSystemBuild [[[NSBundle mainBundle]infoDictionary]valueForKey:@"CFBundleVersion"]
/// 系统默认version
#define MNFloatBtnSystemVersion [[[NSBundle mainBundle]infoDictionary]valueForKey:@"CFBundleShortVersionString"]

#define floatBtnW 120 ///按钮宽度
#define floatBtnH 40 ///按钮高度
#define floatBtnCorner floatBtnH/2 ///按钮圆角

typedef NS_ENUM(NSInteger, RSBtnCornerType) {
    RSBtnCornerTypeAll = 0,   //全圆角
    RSBtnCornerTypeLeft,   //左边圆角
    RSBtnCornerTypeRight,  //右边圆角
};

@interface RSFloatContentBtn ()

@property (nonatomic, assign, getter=isBuildShowDate) BOOL buildShowDate; //是否显示当前日期
@property(nonatomic, copy) NSString *buildStr; //Build号
@property (nonatomic, copy) NSString *environmentStr; //当前展示的环境
@property (nonatomic, copy) NSDictionary *environmentMap; //环境数据集合
@property (nonatomic, assign) BOOL isStickToRight; //是否贴在右边

@end

@implementation RSFloatContentBtn {
    CGPoint _touchPoint; /// 拖动按钮的起始坐标点
    CGFloat _touchBtnX; /// 起始按钮的x,y值
    CGFloat _touchBtnY;
}

+ (instancetype)shared {
    static RSFloatContentBtn *btn;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        btn = [[RSFloatContentBtn alloc] initWithFrame:CGRectMake(0, 100, floatBtnW, floatBtnH)];
        [[NSNotificationCenter defaultCenter] addObserver:btn selector:@selector(orientationDidChangedNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    });
    return btn;
}

- (void)show {
    if ([UIWindow currentWindow]) {
        [[UIWindow currentWindow] addSubview:self];
    } else {
        //若主窗口未加载好，延时2秒再添加
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[UIWindow currentWindow] addSubview:self];
        });
    }
    
    //设置默认环境参数
    NSString *baseUrl = kAddress;
    [self setEnvironmentMap:[NSDictionary getDataFormPlist:@"ApplicationEnv.plist"] currentEnv:baseUrl];
}

- (void)dismiss {
    [self removeFromSuperview];
}

+ (instancetype)showWithType:(RSAssistiveTouchType)type {
    [RSFloatContentBtn shared].type = type;
    [[RSFloatContentBtn shared] show];
    return [RSFloatContentBtn shared];
}

- (void)showWithType:(RSAssistiveTouchType)type {
    self.type = type;
    [self show];
}

- (void)showInDebugModeWithType:(RSAssistiveTouchType)type {
//#ifdef DEBUG
    self.type = type;
    [self show];
//#else
//#endif
}

#pragma mark - lazy
- (NSString *)buildStr {
    if (!_buildStr) {
        _buildStr = [NSDate currentDate];
    }
    return _buildStr;
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
//        UIImage *image = [self p_loadResourceImage];
//        UIImage *image = [UIImage imageNamed:@"floatbtn_placeholder"];
        UIImage *image = [self imageWithColor:[UIColor systemTealColor]];
        
        //获取build的值
        [self p_getBuildStr];
        
        NSString *title = [NSString stringWithFormat:@"Ver:%@ %@\nBuild:%@",MNFloatBtnSystemVersion,self.environmentStr, self.buildStr];
        
        //UIbutton的换行显示
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        [self setTitle:title forState:UIControlStateNormal];
        [self setBackgroundImage:image forState:UIControlStateNormal];

    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    RSBtnCornerType cornerType = RSBtnCornerTypeAll;
    if (_type == RSAssistiveTypeNearLeft) {
        cornerType = RSBtnCornerTypeRight;
    } else if (_type == RSAssistiveTypeNearRight) {
        cornerType = RSBtnCornerTypeLeft;
    }
    [self setBtnCornerWithType:cornerType];
}

#pragma mark - set Method
- (void)setBuildShowDate:(BOOL)isBuildShowDate{
    _buildShowDate = isBuildShowDate;
    
    [self p_getBuildStr];
    
    [self p_updateBtnTitle];
}

/**
 切换环境
 */
- (void)changeEnvironment {

    NSArray *envKeys = self.environmentMap.allKeys;
    NSInteger currentIndex = 0;
    if ([envKeys containsObject:self.environmentStr]) {
        currentIndex = [envKeys indexOfObject:self.environmentStr];
    }
    NSInteger nextEnvIndex = (currentIndex + 1) % envKeys.count;
    self.environmentStr = envKeys[nextEnvIndex];
    [self p_updateBtnTitle];
    
    NSString *envBaseUrl = self.environmentMap[self.environmentStr];
    
    NSString *saveBaseUrlKey = @"RSBaseUrl";
    [[NSUserDefaults standardUserDefaults] setObject:envBaseUrl forKey:saveBaseUrlKey];
}

- (void)setEnvironmentMap:(NSDictionary *)environmentMap
               currentEnv:(NSString *)currentEnv{
    
    __block NSString *envStr = @"测试";
    
    [environmentMap enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        if ([currentEnv isEqualToString:obj]) {
            envStr = key;
            *stop = YES;
        }
    }];
    
    self.environmentStr = envStr;
    self.environmentMap = environmentMap;
    [self p_updateBtnTitle];
}


/// 获取build展示内容
- (void)p_getBuildStr {
    self.buildStr = self.isBuildShowDate ? [NSDate currentDate] : MNFloatBtnSystemBuild;
}

- (void)p_updateBtnTitle {
    
    NSString *title = [NSString stringWithFormat:@"Ver:%@ %@\nBuild:%@",MNFloatBtnSystemVersion,self.environmentStr, self.buildStr];
    
    //如果createBtn的时候直接改title，可能会出现title无法更新问题，所以加个0.01s的延迟函数
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setTitle:title forState:UIControlStateNormal];
    });
}

- (NSString *)environmentStr{
    if (!_environmentStr) {
        _environmentStr = @"测试";
    }
    return _environmentStr;
}


//#pragma mark - loadResourceImage
//- (UIImage *)p_loadResourceImage {
//
//    NSBundle *bundle = [NSBundle bundleForClass:[RSFloatingBtn class]];
//    NSURL *url = [bundle URLForResource:@"RSFloatingBtn" withExtension:@"bundle"];
//    NSBundle *imageBundle = [NSBundle bundleWithURL:url];
//    NSString *path = [imageBundle pathForResource:@"floatbtn_placeholder@3x" ofType:@"png"];
//    UIImage *image = [UIImage imageWithContentsOfFile:path];
//
//    return image;
//}

- (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


#pragma mark - Touch Respoder

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    //保存起始坐标，用于计算偏移
    UITouch *touch = [touches anyObject];
    _touchPoint = [touch locationInView:self];
    
    _touchBtnX = self.frame.origin.x;
    _touchBtnY = self.frame.origin.y;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentPosition = [touch locationInView:self];
    
    //偏移量(偏移量 = 当前坐标 - 起始坐标)
    CGFloat offsetX = currentPosition.x - _touchPoint.x;
    CGFloat offsetY = currentPosition.y - _touchPoint.y;
    
    //移动后的按钮中心坐标
    CGFloat centerX = self.center.x + offsetX;
    CGFloat centerY = self.center.y + offsetY;
    self.center = CGPointMake(centerX, centerY);
    
    //移动过程中显示4个圆角
    if (centerX > floatBtnW/2 && centerX < DeviceWidth-floatBtnW/2) {
        [self setBtnCornerWithType:RSBtnCornerTypeAll];
    }
    
    //父视图的宽高
    CGFloat btnX = self.frame.origin.x;
    CGFloat btnY = self.frame.origin.y;
    CGFloat btnW = self.frame.size.width;
    CGFloat btnH = self.frame.size.height;
    
    //x轴左右极限坐标
    if (btnX > DeviceWidth){
        //按钮右侧越界
        CGFloat centerX = DeviceWidth - btnW/2;
        self.center = CGPointMake(centerX, centerY);
    }else if (btnX < 0){
        //按钮左侧越界
        CGFloat centerX = btnW * 0.5;
        self.center = CGPointMake(centerX, centerY);
    }
    
    //默认都是有导航条的，有导航条的，父试图高度就要被导航条占据，固高度不够
    CGFloat defaultNaviHeight = 64;
    CGFloat judgeSuperViewHeight = DeviceHeight - defaultNaviHeight;
    
    //y轴上下极限坐标
    if (btnY <= 0){
        //按钮顶部越界
        centerY = btnH * 0.7;
        self.center = CGPointMake(centerX, centerY);
    }
    else if (btnY > judgeSuperViewHeight){
        //按钮底部越界
        CGFloat y = DeviceHeight - btnH * 0.5;
        self.center = CGPointMake(btnX, y);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGFloat btnY = self.frame.origin.y;
    CGFloat btnX = self.frame.origin.x;
    CGFloat minDistance = 2;
    
    //结束move的时候，计算移动的距离是>最低要求，如果没有，就调用按钮点击事件
    BOOL isOverX = fabs(btnX - _touchBtnX) > minDistance;
    BOOL isOverY = fabs(btnY - _touchBtnY) > minDistance;
    
    if (isOverX || isOverY) {
        //超过移动范围就不响应点击 - 只做移动操作
        NSLog(@"move - btn");
        [self touchesCancelled:touches withEvent:event];
    } else {
        [super touchesEnded:touches withEvent:event];
        
        if (self.btnClick) {
            self.btnClick(self);
        } else {
            //默认切换环境
            [self changeEnvironment];
        }
    }
    
    //设置贴边
    [self stickToBorder];
}


/**
 设置贴边
 */
- (void)stickToBorder {
    switch (_type) {
        case RSAssistiveTypeNone:{
            //自动识别贴边
            if (self.center.x >= DeviceWidth/2) {
                [self stickToRightBorder];
            } else {
                [self stickToLeftBorder];
            }
            break;
        }
        case RSAssistiveTypeNearLeft:{
            [self stickToLeftBorder];
            break;
        }
        case RSAssistiveTypeNearRight:{
            [self stickToRightBorder];
            break;
        }
    }
}


/**
 靠左吸边
 */
- (void)stickToLeftBorder {
    CGFloat duration = 0.5 * self.frame.origin.x/(DeviceWidth/2-floatBtnW/2);
    [UIView animateWithDuration:duration animations:^{
        self.frame = CGRectMake(0, self.frame.origin.y, floatBtnW, floatBtnH);
    } completion:^(BOOL finished) {
        self.isStickToRight = NO;
        [self setBtnCornerWithType:RSBtnCornerTypeRight];
    }];
}

/**
 靠右吸边
 */
- (void)stickToRightBorder {
    CGFloat duration = 0.5 * (DeviceWidth-self.frame.origin.x-floatBtnW)/(DeviceWidth/2-floatBtnW/2);
    [UIView animateWithDuration:duration animations:^{
        self.frame = CGRectMake(DeviceWidth - floatBtnW, self.frame.origin.y, floatBtnW, floatBtnH);
    } completion:^(BOOL finished) {
        self.isStickToRight = YES;
        [self setBtnCornerWithType:RSBtnCornerTypeLeft];
    }];
}


/**
 设置圆角
 */
- (void)setBtnCornerWithType:(RSBtnCornerType)type {
    CGFloat radius = floatBtnCorner; // 圆角大小
    
    UIRectCorner corners = UIRectCornerAllCorners;;
    if (type == RSBtnCornerTypeLeft) {
        corners = UIRectCornerTopLeft | UIRectCornerBottomLeft;
    } else if (type == RSBtnCornerTypeRight) {
        corners = UIRectCornerTopRight | UIRectCornerBottomRight;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
}

/**
 屏幕旋转
 */
- (void)orientationDidChangedNotification:(NSNotification *)notification {
    if (self.isStickToRight) {
        self.frame = CGRectMake(DeviceWidth - floatBtnW, DeviceHeight* self.frame.origin.y/DeviceWidth, floatBtnW, floatBtnH);
    } else {
        self.frame = CGRectMake(0, DeviceHeight* self.frame.origin.y/DeviceWidth, floatBtnW, floatBtnH);
    }
}

@end
