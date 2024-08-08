

#import <Foundation/Foundation.h>

@interface MBProgressHUD : NSObject

+ (MBProgressHUD*)showHUDAddedTo:(UIView *)view animated:(BOOL)animated;
+ (BOOL)hideAllHUDsForView:(UIView *)view animated:(BOOL)animated;
+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated;

@end
