

#import "MBProgressHUD.h"
#import "HOFFER-Swift.h"

@implementation MBProgressHUD


+ (AASquaresLoading*)showHUDAddedTo:(UIView *)view animated:(BOOL)animated{

        AASquaresLoading *loading  = [[AASquaresLoading alloc]initWithTarget:view size:120];
        loading.tag = 999845;
        loading.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        loading.color = [UIColor whiteColor];
        [loading startWithDelay:0];
        return loading;
        

    
}


+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated{

    [MBProgressHUD hideAllHUDsForView:view animated:animated];
    return true;
}


+ (BOOL)hideAllHUDsForView:(UIView *)view animated:(BOOL)animated{

    AASquaresLoading *loading = (AASquaresLoading*)[view viewWithTag:999845];
    [loading stopWithDelay:0];
    
//    for (AASquaresLoading *loading in view.subviews) {
//        
//        if ([loading isKindOfClass:[AASquaresLoading class]]) {
//            [loading stop:0];
//            break;
//        }
//        
//    }
//    
    return true;

}

@end
