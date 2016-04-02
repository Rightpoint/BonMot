//
//  BONUIKitUtilitiesTestCase.m
//  BonMot
//
//  Created by Nora Trapp on 3/3/16.
//
//

#import "BONBaseTestCase.h"

BONGeneric(NSMutableDictionary, NSValue *, BONGeneric(NSMutableDictionary, NSString *, id) *) * BONDefaultAttributesForClassWithString(Class ViewClass, NSString *string)
{
    BONGeneric(NSMutableDictionary, NSValue *, BONGeneric(NSMutableDictionary, NSString *, id) *)*attributes = [NSMutableDictionary dictionary];

    id view = [[ViewClass alloc] init];
    if ([view respondsToSelector:@selector(setAttributedText:)] &&
        [view respondsToSelector:@selector(attributedText)]) {
        [view setAttributedText:[[NSAttributedString alloc] initWithString:string]];
        [[view attributedText] enumerateAttributesInRange:NSMakeRange(0, string.length) options:0 usingBlock:^(NSDictionary<NSString *, id> *_Nonnull attrs, NSRange range, BOOL *_Nonnull stop) {
            NSValue *value = [NSValue valueWithRange:range];
            attributes[value] = attrs.mutableCopy;
        }];
    }
    else {
        NSCAssert(NO, @"ViewClass must responsd to setAttributedText: and attributedText");
    }

    return attributes;
}

@import BonMot;

@interface BONUIKitUtilitiesTestCase : BONBaseTestCase

@end

@implementation BONUIKitUtilitiesTestCase

#pragma mark - UILabel

- (void)testLabelTextAfterChain
{
    UILabel *label = UILabel.new;
    label.bonChain = BONChain.new.font([UIFont systemFontOfSize:16]);
    label.bonString = @"Hello, world!";

    XCTAssertEqualObjects(label.attributedText.string, @"Hello, world!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 13) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
            NSFontAttributeName : [UIFont systemFontOfSize:16],
        },
    };

    BONAssertAttributedStringHasAttributes(label.attributedText, controlAttributes);
}

- (void)testLabelTextBeforeChain
{
    UILabel *label = UILabel.new;
    label.bonString = @"Hello, world!";
    label.bonChain = BONChain.new.font([UIFont systemFontOfSize:16]);

    XCTAssertEqualObjects(label.attributedText.string, @"Hello, world!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 13) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
            NSFontAttributeName : [UIFont systemFontOfSize:16],
        },
    };

    BONAssertAttributedStringHasAttributes(label.attributedText, controlAttributes);
}

- (void)testLabelAttributedTextAfterChain
{
    UILabel *label = UILabel.new;
    label.bonChain = BONChain.new.font([UIFont systemFontOfSize:16]);
    label.attributedText = [[NSAttributedString alloc] initWithString:@"Hello, world!"];

    XCTAssertEqualObjects(label.attributedText.string, @"Hello, world!");

    NSDictionary *controlAttributes = BONDefaultAttributesForClassWithString([UILabel class], @"Hello, world!");

    BONAssertAttributedStringHasAttributes(label.attributedText, controlAttributes);
}

- (void)testLabelAttributedTextBeforeChain
{
    UILabel *label = UILabel.new;
    label.attributedText = [[NSAttributedString alloc] initWithString:@"Hello, world!"];
    label.bonChain = BONChain.new.font([UIFont systemFontOfSize:16]);

    XCTAssertNotNil(label.bonChain);
    XCTAssertEqualObjects(label.attributedText.string, @"Hello, world!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 13) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
            NSFontAttributeName : [UIFont systemFontOfSize:16],
        },
    };

    BONAssertAttributedStringHasAttributes(label.attributedText, controlAttributes);
}

- (void)testLabelChainWithStringClobbersExistingString
{
    UILabel *label = UILabel.new;
    label.text = @"this too shall pass";
    label.bonChain = BONChain.new.font([UIFont systemFontOfSize:16]).string(@"Hello, world!");

    XCTAssertNotNil(label.bonChain);
    XCTAssertEqualObjects(label.attributedText.string, @"Hello, world!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 13) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
            NSFontAttributeName : [UIFont systemFontOfSize:16],
        },
    };

    BONAssertAttributedStringHasAttributes(label.attributedText, controlAttributes);
}

#pragma mark - UITextView

- (void)testTextViewTextAfterChain
{
    UITextView *textView = UITextView.new;
    textView.bonChain = BONChain.new.font([UIFont systemFontOfSize:16]);
    textView.bonString = @"Hello, world!";

    XCTAssertEqualObjects(textView.attributedText.string, @"Hello, world!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 13) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
            NSFontAttributeName : [UIFont systemFontOfSize:16],
        },
    };

    BONAssertAttributedStringHasAttributes(textView.attributedText, controlAttributes);
}

- (void)testTextViewTextBeforeChain
{
    UITextView *textView = UITextView.new;
    textView.bonString = @"Hello, world!";
    textView.bonChain = BONChain.new.font([UIFont systemFontOfSize:16]);

    XCTAssertEqualObjects(textView.attributedText.string, @"Hello, world!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 13) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
            NSFontAttributeName : [UIFont systemFontOfSize:16],
        },
    };

    BONAssertAttributedStringHasAttributes(textView.attributedText, controlAttributes);
}

- (void)testTextViewAttributedTextAfterChain
{
    UITextView *textView = UITextView.new;
    textView.bonChain = BONChain.new.font([UIFont systemFontOfSize:16]);
    textView.attributedText = [[NSAttributedString alloc] initWithString:@"Hello, world!"];

    XCTAssertEqualObjects(textView.attributedText.string, @"Hello, world!");

    NSDictionary *controlAttributes = BONDefaultAttributesForClassWithString([UITextView class], @"Hello, world!");

    BONAssertAttributedStringHasAttributes(textView.attributedText, controlAttributes);
}

- (void)testTextViewAttributedTextBeforeChain
{
    UITextView *textView = UITextView.new;
    textView.attributedText = [[NSAttributedString alloc] initWithString:@"Hello, world!"];
    textView.bonChain = BONChain.new.font([UIFont systemFontOfSize:16]);

    XCTAssertEqualObjects(textView.attributedText.string, @"Hello, world!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 13) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
            NSFontAttributeName : [UIFont systemFontOfSize:16],
        },
    };

    BONAssertAttributedStringHasAttributes(textView.attributedText, controlAttributes);
}

- (void)testTextViewChainWithStringClobbersExistingString
{
    UITextView *textView = UITextView.new;
    textView.text = @"this too shall pass";
    textView.bonChain = BONChain.new.font([UIFont systemFontOfSize:16]).string(@"Hello, world!");

    XCTAssertNotNil(textView.bonChain);
    XCTAssertEqualObjects(textView.attributedText.string, @"Hello, world!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 13) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
            NSFontAttributeName : [UIFont systemFontOfSize:16],
        },
    };

    BONAssertAttributedStringHasAttributes(textView.attributedText, controlAttributes);
}

#pragma mark - UITextField

- (void)testTextFieldTextAfterChain
{
    UITextField *textField = UITextField.new;
    textField.bonChain = BONChain.new.font([UIFont systemFontOfSize:16]);
    textField.bonString = @"Hello, world!";

    XCTAssertEqualObjects(textField.attributedText.string, @"Hello, world!");

    NSDictionary *controlAttributes = BONDefaultAttributesForClassWithString([UITextField class], @"Hello, world!");
    [controlAttributes[BONValueFromRange(0, 13)] addEntriesFromDictionary:@{
        NSFontAttributeName : [UIFont systemFontOfSize:16],
    }];

    XCTAssertNotNil(controlAttributes[BONValueFromRange(0, 13)]);

    BONAssertAttributedStringHasAttributes(textField.attributedText, controlAttributes);
}

- (void)testTextFieldTextBeforeChain
{
    UITextField *textField = UITextField.new;
    textField.bonString = @"Hello, world!";
    textField.bonChain = BONChain.new.font([UIFont systemFontOfSize:16]);

    XCTAssertEqualObjects(textField.attributedText.string, @"Hello, world!");

    NSDictionary *controlAttributes = BONDefaultAttributesForClassWithString([UITextField class], @"Hello, world!");
    [controlAttributes[BONValueFromRange(0, 13)] addEntriesFromDictionary:@{
        NSFontAttributeName : [UIFont systemFontOfSize:16],
    }];

    XCTAssertNotNil(controlAttributes[BONValueFromRange(0, 13)]);

    BONAssertAttributedStringHasAttributes(textField.attributedText, controlAttributes);
}

- (void)testTextFieldAttributedTextAfterChain
{
    UITextField *textField = UITextField.new;
    textField.bonChain = BONChain.new.font([UIFont systemFontOfSize:16]);
    textField.attributedText = [[NSAttributedString alloc] initWithString:@"Hello, world!"];

    XCTAssertEqualObjects(textField.attributedText.string, @"Hello, world!");

    NSDictionary *controlAttributes = BONDefaultAttributesForClassWithString([UITextField class], @"Hello, world!");

    BONAssertAttributedStringHasAttributes(textField.attributedText, controlAttributes);
}

- (void)testTextFieldAttributedTextBeforeChain
{
    UITextField *textField = UITextField.new;
    textField.attributedText = [[NSAttributedString alloc] initWithString:@"Hello, world!"];
    textField.bonChain = BONChain.new.font([UIFont systemFontOfSize:16]);

    XCTAssertNotNil(textField.bonChain);
    XCTAssertEqualObjects(textField.attributedText.string, @"Hello, world!");

    NSDictionary *controlAttributes = BONDefaultAttributesForClassWithString([UITextField class], @"Hello, world!");
    [controlAttributes[BONValueFromRange(0, 13)] addEntriesFromDictionary:@{
        NSFontAttributeName : [UIFont systemFontOfSize:16],
    }];

    XCTAssertNotNil(controlAttributes[BONValueFromRange(0, 13)]);

    BONAssertAttributedStringHasAttributes(textField.attributedText, controlAttributes);
}

- (void)testTextFieldChainWithStringClobbersExistingString
{
    UITextField *textField = UITextField.new;
    textField.text = @"this too shall pass";
    textField.bonChain = BONChain.new.font([UIFont systemFontOfSize:16]).string(@"Hello, world!");

    XCTAssertNotNil(textField.bonChain);
    XCTAssertEqualObjects(textField.attributedText.string, @"Hello, world!");

    NSDictionary *controlAttributes = BONDefaultAttributesForClassWithString([UITextField class], @"Hello, world!");
    [controlAttributes[BONValueFromRange(0, 13)] addEntriesFromDictionary:@{
        NSFontAttributeName : [UIFont systemFontOfSize:16],
    }];

    XCTAssertNotNil(controlAttributes[BONValueFromRange(0, 13)]);

    BONAssertAttributedStringHasAttributes(textField.attributedText, controlAttributes);
}

@end
