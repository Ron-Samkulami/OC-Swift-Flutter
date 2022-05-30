//
//  UIViewController+Monitor.m
//  TEST
//
//  Created by 111 on 2021/7/27.
//

#import "UIViewController+Monitor.h"
#import <objc/runtime.h>

#define d_screenW [UIScreen mainScreen].bounds.size.width
#define d_screenH [UIScreen mainScreen].bounds.size.height
#define d_toastLabelW 200
#define d_toastLabelH 40

@implementation UIViewController (Monitor)

#pragma mark - Hook
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSEL:@selector(viewDidLoad) withSEL:@selector(swizzled_viewDidLoad)];
    });
}

//作为NSObject分类的方法
+ (void)swizzleSEL:(SEL)originalSEL withSEL:(SEL)swizzledSEL {
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSEL);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSEL);
    BOOL didAddMethod = class_addMethod(class, originalSEL, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)swizzled_viewDidLoad {
    [self swizzled_viewDidLoad];
    NSLog(@"ViewDidLoad_%@",[self class]);
}


#pragma mark - Utils
- (void)categoryMethod {
    [self toast:@"通过runtime添加的类别方法"];
}

#pragma mark - toast
- (void)toast:(NSString *)message {
    // create the parent view
    UIView *wrapperView = [[UIView alloc] init];
    wrapperView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    wrapperView.layer.cornerRadius = 10;
    wrapperView.layer.shadowColor = [UIColor blackColor].CGColor;
    wrapperView.layer.shadowOpacity = 0.2;
    wrapperView.layer.shadowRadius = 6.0;
    wrapperView.layer.shadowOffset = CGSizeMake(4.0, 4.0);
    wrapperView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.45];
    
    UILabel *messageLabel = nil;
    if (message != nil) {
        messageLabel = [[UILabel alloc] init];
        messageLabel.numberOfLines = 0;
        messageLabel.font = [UIFont systemFontOfSize:16.0];
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.alpha = 1.0;
        messageLabel.text = message;
        
        // size the message label according to the length of the text
        CGSize maxSizeMessage = CGSizeMake((self.view.bounds.size.width * 0.8) , self.view.bounds.size.height * 0.8);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGSize expectedSizeMessage = [message sizeWithFont:messageLabel.font constrainedToSize:maxSizeMessage lineBreakMode:messageLabel.lineBreakMode];
#pragma clang diagnostic pop
        messageLabel.frame = CGRectMake(10.0, 10.0, expectedSizeMessage.width, expectedSizeMessage.height);
        CGFloat x = (d_screenW-expectedSizeMessage.width-20)/2;
        CGFloat y = (d_screenH-expectedSizeMessage.height-20)/2;
        wrapperView.frame = CGRectMake(x, y, expectedSizeMessage.width+20.0, expectedSizeMessage.height+20.0);
        [wrapperView addSubview:messageLabel];
    }
    
    [self.view addSubview:wrapperView];
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        wrapperView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:3.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            wrapperView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [wrapperView removeFromSuperview];
        }];
    }];
    
    
}
@end
