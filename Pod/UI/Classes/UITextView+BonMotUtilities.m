//
//  UITextView+BonMotUtilities.m
//  BonMot
//
//  Created by Nora Trapp on 3/2/16.
//
//

#import "BonMot.h"
@import ObjectiveC.runtime;

@implementation UITextView (BonMotUtilities)

- (void)setBonTextable:(id<BONTextable>)textable
{
    objc_setAssociatedObject(self, @selector(bonTextable), textable, OBJC_ASSOCIATION_COPY_NONATOMIC);

    self.bonString = self.text;
}

- (BONChain *)bonTextable
{
    return objc_getAssociatedObject(self, @selector(bonTextable));
}

- (void)setBonString:(NSString *)string
{
    if (self.bonTextable) {
        self.bonTextable.text.string = string;
        self.attributedText = self.bonTextable.text.attributedString;
    }
    else {
        self.text = string;
    }
}

@end
