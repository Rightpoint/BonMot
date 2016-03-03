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

- (void)setBonChainable:(id<BONChainable>)chainable
{
    objc_setAssociatedObject(self, @selector(bonChainable), chainable, OBJC_ASSOCIATION_COPY_NONATOMIC);

    if (chainable) {
        chainable.text.string = self.text;
        [self bon_setAttributedText:chainable.text.attributedString];

        if (chainable.text.font) {
            self.font = chainable.text.font;
        }

        if (chainable.text.textColor) {
            self.textColor = chainable.text.textColor;
        }
    }
}

- (BONChain *)bonChainable
{
    return objc_getAssociatedObject(self, @selector(bonChainable));
}

+ (void)load
{
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        Method originalSetTextMethod = class_getInstanceMethod(self, @selector(setText:));
        Method newSetTextMethod = class_getInstanceMethod(self, @selector(bon_setText:));
        method_exchangeImplementations(originalSetTextMethod, newSetTextMethod);

        Method originalSetAttributedTextMethod = class_getInstanceMethod(self, @selector(setAttributedText:));
        Method newSetAttributedTextMethod = class_getInstanceMethod(self, @selector(bon_setAttributedText:));
        method_exchangeImplementations(originalSetAttributedTextMethod, newSetAttributedTextMethod);
    });
}

- (void)bon_setText:(NSString *)text
{
    if (self.bonChainable) {
        self.bonChainable.text.string = text;
        [self bon_setAttributedText:self.bonChainable.text.attributedString];
    }
    else {
        [self bon_setText:text];
    }
}

- (void)bon_setAttributedText:(NSAttributedString *)attributedText
{
    if ([self.bonChainable.text.font isEqual:self.font]) {
        self.font = nil;
    }

    if ([self.bonChainable.text.textColor isEqual:self.textColor]) {
        self.textColor = nil;
    }

    self.bonChainable = nil;
    [self bon_setAttributedText:attributedText];
}

@end
