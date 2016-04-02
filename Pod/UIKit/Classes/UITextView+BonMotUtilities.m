//
//  UITextView+BonMotUtilities.m
//  BonMot
//
//  Created by Nora Trapp on 3/2/16.
//
//

#import "BonMot.h"
#import "BONChain_Private.h"

@import ObjectiveC.runtime;

@implementation UITextView (BonMotUtilities)

- (void)setBonChain:(BONChain *)chain
{
    objc_setAssociatedObject(self, @selector(bonChain), chain, OBJC_ASSOCIATION_COPY_NONATOMIC);

    // If the chain is empty, use the text view’s existing text
    if (chain.generatesEmptyString) {
        self.bonString = self.text;
    }
    else {
        self.attributedText = self.bonChain.attributedString;
    }
}

- (BONChain *)bonChain
{
    return objc_getAssociatedObject(self, @selector(bonChain));
}

- (void)setBonString:(NSString *)string
{
    if (self.bonChain) {
        self.bonChain.text.string = string;
        self.attributedText = self.bonChain.attributedString;
    }
    else {
        self.text = string;
    }
}

@end
