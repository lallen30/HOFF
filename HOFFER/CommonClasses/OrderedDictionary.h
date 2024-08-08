//
//  OrderedDictionary.h
//  OrderedDictionary
//

//

#import <Foundation/Foundation.h>
@import UIKit;

// FIXME:  This class is very suspicious.  It both inherits from NSMutableDictionary and also
//          contains an NSMutableDictionary.  It's also unclear why an OrderedDictionary is
//          necessary in the first place.  The constructors are not sound.

@interface OrderedDictionary : NSMutableDictionary
{
	NSMutableDictionary *dictionary;
	NSMutableArray *array;
}

- (void)insertObject:(id)anObject forKey:(id)aKey atIndex:(NSUInteger)anIndex;
- (id)keyAtIndex:(NSUInteger)anIndex;
- (NSEnumerator *)reverseKeyEnumerator;

@end
