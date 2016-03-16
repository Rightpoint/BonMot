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

- (void)setBonTextable:(id<BONTextable>)textable
{
    objc_setAssociatedObject(self, @selector(bonTextable), textable, OBJC_ASSOCIATION_COPY_NONATOMIC);

    // If the textable is empty, use the text field’s existing text
    if (textable.text.empty) {
        self.bonString = self.text;
    }
    else {
        self.attributedText = self.bonTextable.text.attributedString;
    }
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
