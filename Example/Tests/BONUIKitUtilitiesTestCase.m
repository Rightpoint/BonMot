//
//  BONUIKitUtilitiesTestCase.m
//  BonMot
//
//  Created by Nora Trapp on 3/3/16.
//
//

#import "BONBaseTestCase.h"

NSMutableDictionary *BONDefaultAttributesForClassWithString(Class ViewClass, NSString *string)
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];

    id view = [[ViewClass alloc] init];
    if ([view respondsToSelector:@selector(setAttributedText:)] &&
        [view respondsToSelector:@selector(attributedText)]) {
        [view setAttributedText:[[NSAttributedString alloc] initWithString:string]];
        [[view attributedText] enumerateAttributesInRange:NSMakeRange(0, string.length) options:0 usingBlock:^(NSDictionary<NSString *, id> *_Nonnull attrs, NSRange range, BOOL *_Nonnull stop) {
            attributes[[NSValue valueWithRange:range]] = [attrs mutableCopy];
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

- (void)testNilWithLabel
{
    UILabel *label = UILabel.new;
    XCTAssertNoThrow(label.bonTextable = nil);
    XCTAssertNoThrow(label.bonString = nil);
    XCTAssertEqual(label.text.length, 0);
    XCTAssertEqual(label.attributedText.length, 0);
}

- (void)testLabelTextAfterTextable
{
    UILabel *label = UILabel.new;
    label.bonTextable = BONChain.new.font([UIFont systemFontOfSize:16]);
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

- (void)testLabelTextBeforeTextable
{
    UILabel *label = UILabel.new;
    label.bonString = @"Hello, world!";
    label.bonTextable = BONChain.new.font([UIFont systemFontOfSize:16]);

    XCTAssertNotNil(label.bonTextable);
    XCTAssertEqualObjects(label.attributedText.string, @"");
}

- (void)testLabelAttributedTextAfterTextable
{
    UILabel *label = UILabel.new;
    label.bonTextable = BONChain.new.font([UIFont systemFontOfSize:16]);
    label.attributedText = [[NSAttributedString alloc] initWithString:@"Hello, world!"];

    XCTAssertEqualObjects(label.attributedText.string, @"Hello, world!");

    NSDictionary *controlAttributes = BONDefaultAttributesForClassWithString([UILabel class], @"Hello, world!");

    BONAssertAttributedStringHasAttributes(label.attributedText, controlAttributes);
}

- (void)testLabelAttributedTextBeforeTextable
{
    UILabel *label = UILabel.new;
    label.attributedText = [[NSAttributedString alloc] initWithString:@"Hello, world!"];
    label.bonTextable = BONChain.new.font([UIFont systemFontOfSize:16]);

    XCTAssertNotNil(label.bonTextable);
    XCTAssertEqualObjects(label.attributedText.string, @"");
}

- (void)testLabelTextableWithStringClobbersExistingString
{
    UILabel *label = UILabel.new;
    label.text = @"this too shall pass";
    label.bonTextable = BONChain.new.font([UIFont systemFontOfSize:16]).string(@"Hello, world!");

    XCTAssertNotNil(label.bonTextable);
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

- (void)testNilWithTextView
{
    UITextView *textView = UITextView.new;
    XCTAssertNoThrow(textView.bonTextable = nil);
    XCTAssertNoThrow(textView.bonString = nil);
    XCTAssertEqual(textView.text.length, 0);
    XCTAssertEqual(textView.attributedText.length, 0);
}

- (void)testTextViewTextAfterTextable
{
    UITextView *textView = UITextView.new;
    textView.bonTextable = BONChain.new.font([UIFont systemFontOfSize:16]);
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

- (void)testTextViewTextBeforeTextable
{
    UITextView *textView = UITextView.new;
    textView.bonString = @"Hello, world!";
    textView.bonTextable = BONChain.new.font([UIFont systemFontOfSize:16]);

    XCTAssertNotNil(textView.bonTextable);
    XCTAssertEqualObjects(textView.attributedText.string, @"");
}

- (void)testTextViewAttributedTextAfterTextable
{
    UITextView *textView = UITextView.new;
    textView.bonTextable = BONChain.new.font([UIFont systemFontOfSize:16]);
    textView.attributedText = [[NSAttributedString alloc] initWithString:@"Hello, world!"];

    XCTAssertEqualObjects(textView.attributedText.string, @"Hello, world!");

    NSDictionary *controlAttributes = BONDefaultAttributesForClassWithString([UITextView class], @"Hello, world!");

    BONAssertAttributedStringHasAttributes(textView.attributedText, controlAttributes);
}

- (void)testTextViewAttributedTextBeforeTextable
{
    UITextView *textView = UITextView.new;
    textView.attributedText = [[NSAttributedString alloc] initWithString:@"Hello, world!"];
    textView.bonTextable = BONChain.new.font([UIFont systemFontOfSize:16]);

    XCTAssertNotNil(textView.bonTextable);
    XCTAssertEqualObjects(textView.attributedText.string, @"");
}

- (void)testTextViewTextableWithStringClobbersExistingString
{
    UITextView *textView = UITextView.new;
    textView.text = @"this too shall pass";
    textView.bonTextable = BONChain.new.font([UIFont systemFontOfSize:16]).string(@"Hello, world!");

    XCTAssertNotNil(textView.bonTextable);
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

- (void)testNilWithTextField
{
    UITextField *textField = UITextField.new;
    XCTAssertNoThrow(textField.bonTextable = nil);
    XCTAssertNoThrow(textField.bonString = nil);
    XCTAssertEqual(textField.text.length, 0);
    XCTAssertEqual(textField.attributedText.length, 0);
}

- (void)testTextFieldTextAfterTextable
{
    UITextField *textField = UITextField.new;
    textField.bonTextable = BONChain.new.font([UIFont systemFontOfSize:16]);
    textField.bonString = @"Hello, world!";

    XCTAssertEqualObjects(textField.attributedText.string, @"Hello, world!");

    NSDictionary *controlAttributes = BONDefaultAttributesForClassWithString([UITextField class], @"Hello, world!");
    [controlAttributes[BONValueFromRange(0, 13)] addEntriesFromDictionary:@{
        NSFontAttributeName : [UIFont systemFontOfSize:16],
    }];

    XCTAssertNotNil(controlAttributes[BONValueFromRange(0, 13)]);

    BONAssertAttributedStringHasAttributes(textField.attributedText, controlAttributes);
}

- (void)testTextFieldTextBeforeTextable
{
    UITextField *textField = UITextField.new;
    textField.bonString = @"Hello, world!";
    textField.bonTextable = BONChain.new.font([UIFont systemFontOfSize:16]);

    XCTAssertNotNil(textField.bonTextable);
    XCTAssertEqualObjects(textField.attributedText.string, @"");
}

- (void)testTextFieldAttributedTextAfterTextable
{
    UITextField *textField = UITextField.new;
    textField.bonTextable = BONChain.new.font([UIFont systemFontOfSize:16]);
    textField.attributedText = [[NSAttributedString alloc] initWithString:@"Hello, world!"];

    XCTAssertEqualObjects(textField.attributedText.string, @"Hello, world!");

    NSDictionary *controlAttributes = BONDefaultAttributesForClassWithString([UITextField class], @"Hello, world!");

    BONAssertAttributedStringHasAttributes(textField.attributedText, controlAttributes);
}

- (void)testTextFieldAttributedTextBeforeTextable
{
    UITextField *textField = UITextField.new;
    textField.attributedText = [[NSAttributedString alloc] initWithString:@"Hello, world!"];
    textField.bonTextable = BONChain.new.font([UIFont systemFontOfSize:16]);

    XCTAssertNotNil(textField.bonTextable);
    XCTAssertEqualObjects(textField.attributedText.string, @"");
}

- (void)testTextFieldTextableWithStringClobbersExistingString
{
    UITextField *textField = UITextField.new;
    textField.text = @"this too shall pass";
    textField.bonTextable = BONChain.new.font([UIFont systemFontOfSize:16]).string(@"Hello, world!");

    XCTAssertNotNil(textField.bonTextable);
    XCTAssertEqualObjects(textField.attributedText.string, @"Hello, world!");

    NSDictionary *controlAttributes = BONDefaultAttributesForClassWithString([UITextField class], @"Hello, world!");
    [controlAttributes[BONValueFromRange(0, 13)] addEntriesFromDictionary:@{
        NSFontAttributeName : [UIFont systemFontOfSize:16],
    }];

    XCTAssertNotNil(controlAttributes[BONValueFromRange(0, 13)]);

    BONAssertAttributedStringHasAttributes(textField.attributedText, controlAttributes);
}

@end
