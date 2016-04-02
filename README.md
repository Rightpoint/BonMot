<img width=443 src="readme-images/BonMot-logo.png" alt="BonMot Logo" />

[![CI Status](http://img.shields.io/travis/Raizlabs/BonMot.svg?style=flat)](https://travis-ci.org/Raizlabs/BonMot)
[![Version](https://img.shields.io/cocoapods/v/BonMot.svg?style=flat)](http://cocoapods.org/pods/BonMot)
[![License](https://img.shields.io/cocoapods/l/BonMot.svg?style=flat)](http://cocoapods.org/pods/BonMot)
[![Platform](https://img.shields.io/cocoapods/p/BonMot.svg?style=flat)](http://cocoapods.org/pods/BonMot)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

BonMot (pronounced *Bon Mo*, French for *good word*) is an iOS attributed string generation library. It abstracts away the advanced iOS typography tools, freeing you to focus on making your text beautiful.

To run the example project, run `pod try BonMot`, or clone the repo and open `Example/BonMot.xcworkspace`.

## Installation with CocoaPods

BonMot is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BonMot'
```

If you want to use the [UIKit Utilities](#uikit-utilities), add:

```ruby
pod 'BonMot/UIKit'
```

## Installation with Carthage

BonMot is also compatible with [Carthage](https://github.com/Carthage/Carthage). To install it, simply add the following line to your Cartfile:

```ogdl
github "Raizlabs/BonMot"
```

## Supported Text Features

BonMot uses attributed strings to give you control over the following typographical features:

- Font
- Text color
- Tracking (in either UIKit Points or Adobe-friendly thousandths of an *em*)
- First line head indent
- Head indent
- Tail indent
- Line height multiple
- Maximum line height
- Minimum line height
- Line spacing
- Line break mode
- Paragraph spacing before
- Paragraph spacing after
- Baseline offset
- Text alignment
- Underlining and strikethrough
- Figure case (uppercase vs. lowercase numbers)
- Figure spacing (monospace vs. proportional numbers)
- Inline Images with optional multi-line paragraph alignment

Think something is missing? Please [file an issue](https://github.com/Raizlabs/BonMot/issues) (or add a +1 if one already exists).

## Usage

In any Swift file where you want to use BonMot, simply `import BonMot`. In Objective-C, that’s `#import <BonMot/BonMot.h>` or `@import BonMot`.

The basic object in BonMot is `BONChain`, which allows you quickly construct attributed strings. You can create a chain with a normal `[[BONChain alloc] init]`, but it's easier to just use `[BONChain new]` or the even shorter and technically valid `BONChain.new`:

```objc
NSString *quote = @"I used to love correcting people’s grammar until\
 I realized what I loved more was having friends.\n\
—Mara Wilson";

// line-wrapped for readability
NSAttributedString *attributedString =
BONChain.new // [BONChain new] and [[BONChain alloc] init] also work
    .fontNameAndSize(@"AmericanTypewriter", 17.0)
    .lineHeightMultiple(1.8)
    .string(quote)
    .attributedString; // You can also query .attributes
                       // and get back a dictionary of attributes
```

You can also create a local variable or property to save a partially-configured chain. All the chaining methods pass copies of the chain, so you don't have to worry about later changes clobbering earlier properties:

```objc
// Base Chain
BONChain *birdChain =
BONChain.new
    .lineHeightMultiple(1.2)
    .font([UIFont systemFontOfSize:17.0])
    .string(@"bird");

// Two chains with different colors
// that inherit their parents’ properties
BONChain *redBirds = birdChain.textColor([UIColor redColor]);
BONChain *blueBirds = birdChain.textColor([UIColor blueColor]);

// two different attributed strings with all attributes shared
// except for text color
NSAttributedString *redBirdString = redBirds.attributedString;
NSAttributedString *blueBirdString = blueBirds.attributedString;
```

## Concatenation

You can concatenate an array of `BONChain`s:

```objc
BONChain *oneFish = BONChain.new.string(@"one fish");
BONChain *twoFish = BONChain.new.string(@"two fish");
BONChain *redFish = BONChain.new.string(@"red fish").textColor([UIColor redColor]);
BONChain *blueFish = BONChain.new.string(@"blue fish").textColor([UIColor blueColor]);
BONChain *separator = BONChain.new.string(@", ");

NSAttributedString *string = [BONChain joinChains:@[ oneFish, twoFish, redFish, blueFish ] withSeparator:separator];
```

Outputs:

<img width=227 src="readme-images/fish-with-black-comma.png" />

You can also append chains directly to each other:

```objc
NSString *commaSpace = @", ";
BONChain *chain = BONChain.new;
[chain appendChain:BONChain.new.string(@"one fish")];
[chain appendChain:BONChain.new.string(@"two fish") separator:commaSpace];
[chain appendChain:BONChain.new.string(@"red fish").textColor([UIColor redColor]) separator:commaSpace];
[chain appendChain:BONChain.new.string(@"blue fish").textColor([UIColor blueColor]) separator:commaSpace];

NSAttributedString *string = chain.attributedString;
```

Outputs:

<img width=227 src="readme-images/fish-with-red-comma.png" />

(Notice that the comma after `red fish` is red, but in the previous example, it was not colored. This is the behavior that made the most sense to me, but please open an issue or pull request if you think it should be different.)

## Image Attachments

BonMot uses `NSTextAttachment` to embed images in strings. Simply use the `.image` property of a chain:

```objc
BONChain *chain = BONChain.new;
[chain appendChain:BONChain.new.image(someUIImage).baselineOffset(-4.0)];
[chain appendChain:BONChain.new.string(@"label with icon") separator: @" "];
NSAttributedString *string = chain.attributedString;
```

Outputs:

<img width=116 height=22 src="readme-images/label-with-icon.png" />

If you need to wrap multiple lines of text after an image, use the `indentSpacer` property to align the whole paragraph after the image:

```objc
NSString *quote = @"This is some text that goes on and on and spans multiple lines, and it all ends up left-aligned";
BONChain *chain = BONChain.new;
[chain appendChain:BONChain.new.image(someUIImage).indentSpacer(10.0)];
[chain appendChain:BONChain.new.string(quote)];
NSAttributedString *attributedString = chain.attributedString;
```

Outputs:

<img width=285 src="readme-images/wrapped-label-with-icon.png" />

## Special Characters

You can easily access those hard-to-find special characters using the `BONSpecial` class. These include the No-Break Space, En and Em Spaces, various kinds of dashes, and more. If it’s hard to see in your source code or debug logs, it belongs in `BONSpecial`. If you want to add special characters to BonMot, add them to `BONSpecialGenerator.swift` (requires Xcode 7), run `swift BONSpecialGenerator.swift`, and submit a pull request! See `SpecialCharactersCell.m` in the sample project for some examples of how to use `BONSpecial`.

## UIKit Utilities

BonMot provides several utilities that enhance its interoperability with UIKit.

**Note:** to use these utilities, add `pod 'BonMot/UIKit'` to your Podfile.

### Text UI Elements

BonMot provides a `bonChain` property on `UILabel`, `UITextView`, and `UITextField` that allows assigning a `BONChain` object to apply styling to any strings assigned via the `bonString` property.

**Note:** to use these utilities, add `pod 'BonMot/UIKit'` to your Podfile.

```objc
UILabel *label = [[UILabel alloc] init];

BONChain *chain = BONChain.new.adobeTracking(300).fontNameAndSize(@"Avenir-Book", 18.0f);

label.bonChain = chain;
label.bonString = @"Some initial text.";
```

Outputs:

<img width=310 src="readme-images/initial-text.png" />

Some time later, you can update the text of the label with a plain string, without losing the original styling from the `bonChain`.

```objc
label.bonString = @"Some updated text.";
```

Outputs:

<img width=310 src="readme-images/updated-text.png" />

### Vertical Text Alignment

UIKit lets you align labels by top, bottom, or baseline. BonMot includes `BONTextAlignmentConstraint`, a layout constraint subclass that lets you align labels by cap height and x-height. For some fonts, this is essential to convey the designer’s intention:

<img width=320 src="readme-images/text-alignment.png" alt="Illustration of different methods of aligning text vertically" />

`BONTextAlignmentConstraint` works with any views that expose a `font` property. It uses Key-Value Observing to watch for changes to the `font` property, and adjust its internal measurements accordingly. This is ideal for use with Dynamic Type: if the user changes the font size of the app, `BONTextAlignmentConstraint` will update. You can also use it to align a label with a plain view, as illustrated by the red dotted line views in the example above.

**Warning:** `BONTextAlignmentConstraint` holds strong references to its `firstItem` and `secondItem` properties. Make sure that a view that is constrained by this constraint does not also hold a strong reference to said constraint, because it will cause a retain cycle.

You can use `BONTextAlignmentConstraint` programmatically or in Interface Builder. In code, use the convenience initializer:

```objc
[BONTextAlignmentConstraint constraintWithItem:someLabel
                                     attribute:BONConstraintAttributeCapHeight
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:someOtherLabel
                                     attribute:BONConstraintAttributeCapHeight].active = YES;
```

In Interface Builder, start by constraining two views to each other with a `top` constraint. Select the constraint, and in the Identity Inspector, change the class to `BONTextAlignmentConstraint`:

<img width=294 src="readme-images/text-alignment-identity-inspector.png" alt="setting the class in the Identity Inspector" />

Next, switch to the Attributes Inspector. `BONTextAlignmentConstraint` exposes two text fields through [IBInspectables](https://developer.apple.com/library/ios/recipes/xcode_help-IB_objects_media/Chapters/CreatingaLiveViewofaCustomObject.html). Type in the attributes you want to align. You will get a run-time error if you enter an invalid value.

<img width=294 src="readme-images/text-alignment-attributes-inspector.png" alt="setting the alignment attributes in the Attributes Inspector" />

The layout won’t change in Interface Builder (IBDesignable is not supported for constraint subclasses), but it will work when you run your code.

**Note:** some of the possible alignment values are not supported in all configurations. Check out [Issue #37](https://github.com/Raizlabs/BonMot/issues/37) for updates.

## Contributing

Issues and pull requests are welcome! Please format all code using [`clang-format`](http://clang.llvm.org/docs/ClangFormat.html) and the included `.clang-format` configuration file.


## Author

Zev Eisenberg: <mailto:zev.eisenberg@raizlabs.com>, [@ZevEisenberg](https://twitter.com/zeveisenberg)

Logo by Jon Lopkin: [@jonlopkin](https://twitter.com/jonlopkin)

## License

BonMot is available under the MIT license. See the LICENSE file for more info.
