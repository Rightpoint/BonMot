//
//  UITextField+BonMotUtilities.m
//  BonMot
//
//  Created by Nora Trapp on 3/2/16.
//
//

#import "BonMot.h"
@import ObjectiveC.runtime;

@implementation UITextField (BonMotUtilities)

- (void)setBonChainable:(id<BONChainable>)chainable
{
    objc_setAssociatedObject(self, @selector(bonChainable), chainable, OBJC_ASSOCIATION_COPY_NONATOMIC);

    self.textAndApplyChainable = self.text;
}

- (BONChain *)bonChainable
{
    return objc_getAssociatedObject(self, @selector(bonChainable));
}

- (void)setTextAndApplyChainable:(NSString *)text
{
    if (self.bonChainable) {
        self.bonChainable.text.string = text;
        self.attributedText = self.bonChainable.text.attributedString;
    }
    else {
        self.text = text;
    }
}

@end
