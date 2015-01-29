

#import "PopUpControl.h"
#import <objc/runtime.h>
static const char kAssocKey_Window;
@interface CRSWindow : UIWindow

@end

@implementation CRSWindow

-(void)dealloc
{
    //NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

@end

@implementation PopUpControl

+(void)show:(UIViewController *)rootViewController
{
    UIWindow *window = [[CRSWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.alpha = 0.;
    window.transform = CGAffineTransformMakeScale(1.1, 1.1);
    window.rootViewController = rootViewController;
    window.backgroundColor = [UIColor colorWithWhite:0 alpha:.6];
    window.windowLevel = UIWindowLevelNormal + 5;
    
    [window makeKeyAndVisible];
    
    objc_setAssociatedObject([UIApplication sharedApplication], &kAssocKey_Window, window, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [UIView transitionWithView:window duration:.2 options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionCurveEaseInOut animations:^{
        window.alpha = 1.;
        window.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

+(void)doClose
{
    UIWindow *window = objc_getAssociatedObject([UIApplication sharedApplication], &kAssocKey_Window);
    
    [UIView transitionWithView:window
                      duration:.3
                       options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        UIView *view = window.rootViewController.view;
                        
                        for (UIView *v in view.subviews) {
                            v.transform = CGAffineTransformMakeScale(.8, .8);
                        }
                        
                        window.alpha = 0;
                    }
                    completion:^(BOOL finished) {
                        
                        [window.rootViewController.view removeFromSuperview];
                        window.rootViewController = nil;
                        
                        // 上乗せしたウィンドウを破棄
                        objc_setAssociatedObject([UIApplication sharedApplication], &kAssocKey_Window, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                        
                        // メインウィンドウをキーウィンドウにする
                        UIWindow *nextWindow = [[UIApplication sharedApplication].delegate window];
                        [nextWindow makeKeyAndVisible];
                    }];
}

@end
