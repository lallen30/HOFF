//


#import "NSObject+ENHThrottledReloading.h"
#import <mach/mach_time.h>
#import <objc/runtime.h>

static NSString *kENHTimebaseInfoAssociatedObjectKey = @"com.enharmonichq.timebaseInfo";
static NSString *kENHLastReloadMachTimeAssociatedObjectKey = @"com.enharmonichq.lastReloadMachTime";
static NSString *kENHAwaitingReloadAssociatedObjectKey = @"com.enharmonichq.awaitingReload";
static NSString *kENHMinimumNanosecondsBetweenThrottledReloadsAssociatedObjectKey = @"com.enharmonichq.minimumNanosecondsBetweenThrottledReloads";

@interface NSObject ()

/**
 *  The last mach time when a throttled reload occured.
 */
@property (nonatomic, assign) uint64_t enh_lastReloadMachTime;

/**
 *  Bool indicating wheather a throttled reload is currently pending.
 */
@property (nonatomic, assign) BOOL enh_awaitingReload;

@end

@implementation NSObject (ENHThrottledReloading)

-(void)enh_throttledReloadData
{
    uint64_t now = mach_absolute_time ();
    uint64_t lastReloadMachTime = [self enh_lastReloadMachTime];
    uint64_t timeSinceLastUpdate = now - lastReloadMachTime;
    mach_timebase_info_data_t timebaseInfo = [self enh_timebaseInfo];
    uint64_t nanos = timeSinceLastUpdate * timebaseInfo.numer / timebaseInfo.denom;
    uint64_t minimumTimeDiffNanosecondsForUpdate = [self enh_minimumNanosecondsBetweenThrottledReloads];
    BOOL awaitingReload = [self enh_awaitingReload];
    
    if(nanos > minimumTimeDiffNanosecondsForUpdate || lastReloadMachTime == 0.0)
    {
        [self setEnh_lastReloadMachTime:now];
        [self setEnh_awaitingReload:NO];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:_cmd object:nil];
        if ([self respondsToSelector:@selector(reloadData)])
        {
            if(lastReloadMachTime != 0.0)
            {
                //NSLog(@"Final Response");
                [self performSelector:@selector(reloadData)];
            }
            else
            {
                //[self performSelector:@selector(reloadData)];
            }
        }
        else
        {
            NSAssert(NO, @"object does not respond to reloadData selector");
        }
    }
    else if (!awaitingReload)
    {
        NSTimeInterval delay = ((double)minimumTimeDiffNanosecondsForUpdate - nanos) / NSEC_PER_SEC;
        [self performSelector:_cmd withObject:nil afterDelay:delay];
        [self setEnh_awaitingReload:YES];
        //NSLog(@"awaiting reload is false now.");
    }
    else if (awaitingReload)
    {
        //NSLog(@"awaiting reload is true now.");
    }
}

-(void)enh_cancelPendingReload
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(enh_throttledReloadData) object:nil];
}

#pragma mark - Accessors

-(void)setEnh_minimumNanosecondsBetweenThrottledReloads:(uint64_t)enh_minimumNanosecondsBetweenThrottledReloads
{
    objc_setAssociatedObject(self, (__bridge const void *)kENHMinimumNanosecondsBetweenThrottledReloadsAssociatedObjectKey, @(enh_minimumNanosecondsBetweenThrottledReloads), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(uint64_t)enh_minimumNanosecondsBetweenThrottledReloads
{
    uint64_t minimumNanosecondsBetweenThrottledReloads = NSEC_PER_SEC * 1.0 ; // 0.3 seconds
    NSNumber *value = objc_getAssociatedObject(self, (__bridge const void *)kENHMinimumNanosecondsBetweenThrottledReloadsAssociatedObjectKey);
    if (value)
    {
        minimumNanosecondsBetweenThrottledReloads = [value unsignedLongLongValue];
    }
    
    return minimumNanosecondsBetweenThrottledReloads;
}

-(mach_timebase_info_data_t)enh_timebaseInfo
{
    mach_timebase_info_data_t timebaseInfo;
    
    NSValue *value = objc_getAssociatedObject(self, (__bridge const void *)kENHTimebaseInfoAssociatedObjectKey);
    if (!value)
    {
        if(mach_timebase_info(&timebaseInfo) != KERN_SUCCESS)
        {
            NSAssert(0, @"mach_timebase_info not successful");
        }
        value = [NSValue value:&timebaseInfo withObjCType:@encode(mach_timebase_info_data_t)];
        objc_setAssociatedObject(self, (__bridge const void *)kENHTimebaseInfoAssociatedObjectKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    else
    {
        [value getValue:&timebaseInfo];
    }
    
    return timebaseInfo;
}

-(void)setEnh_lastReloadMachTime:(uint64_t)enh_lastReloadMachTime
{
    objc_setAssociatedObject(self, (__bridge const void *)kENHLastReloadMachTimeAssociatedObjectKey, @(enh_lastReloadMachTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(uint64_t)enh_lastReloadMachTime
{
    NSNumber *value = objc_getAssociatedObject(self, (__bridge const void *)kENHLastReloadMachTimeAssociatedObjectKey);
    uint64_t lastReloadMachTime = [value unsignedLongLongValue];
    
    return lastReloadMachTime;
}

-(void)setEnh_awaitingReload:(BOOL)enh_awaitingReload
{
    objc_setAssociatedObject(self, (__bridge const void *)kENHAwaitingReloadAssociatedObjectKey, @(enh_awaitingReload), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)enh_awaitingReload
{
    NSNumber *value = objc_getAssociatedObject(self, (__bridge const void *)kENHAwaitingReloadAssociatedObjectKey);
    BOOL awaitingReload = [value boolValue];
    
    return awaitingReload;
}

@end
