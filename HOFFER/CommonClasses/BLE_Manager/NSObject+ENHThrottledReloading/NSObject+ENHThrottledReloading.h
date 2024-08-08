

#import <UIKit/UIKit.h>

@protocol ENHThrottledReloading <NSObject>

-(void)reloadData;

@end

@interface NSObject (ENHThrottledReloading)

/**
 *  Schedules a throttled call to `reloadData` so that multiple calls may be aggregated.
 */
-(void)enh_throttledReloadData;

/**
 *  Cancels any pending throttled call to `reloadData`. 
 *  Typically called in `dealloc` implementation of the class that initiates the throttled calls.
 */
-(void)enh_cancelPendingReload;

/**
 *  Minimum number of nanoseconds between reloading data. Defaults to 0.3 seconds.
 */
@property (nonatomic, assign) uint64_t enh_minimumNanosecondsBetweenThrottledReloads;

@end

@interface UICollectionView (ENHThrottledReloading) <ENHThrottledReloading>

@end

@interface UITableView (ENHThrottledReloading) <ENHThrottledReloading>

@end
