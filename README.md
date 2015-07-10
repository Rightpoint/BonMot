# BonMot

[![CI Status](http://img.shields.io/travis/ZevEisenberg/BonMot.svg?style=flat)](https://travis-ci.org/Zev Eisenberg/BonMot)
[![Version](https://img.shields.io/cocoapods/v/BonMot.svg?style=flat)](http://cocoapods.org/pods/BonMot)
[![License](https://img.shields.io/cocoapods/l/BonMot.svg?style=flat)](http://cocoapods.org/pods/BonMot)
[![Platform](https://img.shields.io/cocoapods/p/BonMot.svg?style=flat)](http://cocoapods.org/pods/BonMot)

BonMot is an iOS attributed string generation library. It abstracts away the advanced iOS typography tools, freeing you to focus on making your text beautiful.

To run the example project, run `pod try BonMot`, or clone the repo and open `Example/BonMot.xcworkspace`.

### Warning:
BonMot should be considered extremely pre-release. I'm planning on [changing the names](https://github.com/ZevEisenberg/BonMot/issues/7) of several classes, so a future update will definitely break your code. Use accordingly.

## Installation with CocoaPods

BonMot is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "BonMot"
```

## Supported Text Features

BonMot uses attributed strings to give you control over the following typographical features:

- Font
- Text Color
- Tracking (in either UIKit Points or Adobe-friendly thousandths of an *em*)
- Line Height Multiple
- Baseline Offset
- Figure Case (uppercase vs. lowercase numbers)
- Figure Spacing (monospace vs. proportional numbers)
- Inline Images

Think something is missing? Please [file an issue](https://github.com/ZevEisenberg/BonMot/issues) (or add a +1 if one already exists).

## Usage

The basic object in BonMot is `BONTextConfiguration`. You create a text configuration object, set some properties to configure the font, and then ask for its `.attributedString` to get a string formatted according to your specification. Or ask for `.attributes` if you just need the attributes dictionary:

```objc
BONTextConfiguration *config = [BONTextConfiguration new];
NSString *quote = @"I used to love correcting people’s grammar until I realized what I loved more was having friends.\n—Mara Wilson";

config.font = [UIFont fontWithName:@"AmericanTypewriter" size:17.0f];
config.lineHeightMultiple = 1.8f;
config.string = quote;

NSAttributedString *string = config.attributedString;
NSDictionary *attributes = config.attributes;
```

## Chaining Syntax

`BONChainLink` is a wrapper around `BONTextConfiguration` that allows you to chain properties together for a more concise expression of a style. You can create a chain link with a normal initializer, but it's easier to just use the `RZCursive` macro:

```objc
NSString *quote = @"I used to love correcting people’s grammar until\
 I realized what I loved more was having friends.\n\
—Mara Wilson";

// line-wrapped for readability
NSAttributedString *attributedString =
RZCursive
.fontNameAndSize(@"AmericanTypewriter", 17.0f)
.lineHeightMultiple(1.8f)
.string(quote)
.attributedString;
```

You can also create a local variable or property to save a partially-configured chain link. All the chaining methods pass copies of the chain link, so you don't have to worry about later changes clobbering earlier properties:

```objc

// Base Chain Link
BONChainLink *birdChainLink =
RZCursive
.lineHeightMultiple(1.2f)
.font([UIFont systemFontOfSize:17.0f])
.string(@"bird");

// Two chain links with different colors
// that inherit their parents’ properties
BONChainLink *redBirds = birdChainLink.textColor([UIColor redColor]);
BONChainLink *blueBirds = birdChainLink.textColor([UIColor blueColor]);

// two different attributed strings with all attributes shared
// except for text color
NSAttributedString *redBirdString = redBirds.attributedString;
NSAttributedString *blueBirdSring = blueBirds.attributedString;
```

## Concatenation

You can concatenate an array of configurations:

```objc
BONTextConfiguration *oneFish = RZCursive.string(@"one fish").textConfiguration;
BONTextConfiguration *twoFish = RZCursive.string(@"two fish").textConfiguration;
BONTextConfiguration *redFish = RZCursive.string(@"red fish").textColor([UIColor redColor]).textConfiguration;
BONTextConfiguration *blueFish = RZCursive.string(@"blue fish").textColor([UIColor blueColor]).textConfiguration;
BONTextConfiguration *separator = RZCursive.string(@", ").textConfiguration;

NSAttributedString *string = [BONTextConfiguration joinAttributedStrings:@[ oneFish, twoFish, redFish, blueFish ] withSeparator:separator];
```

Outputs:

<img width=227 height=34 src="readme-images/fish-with-black-comma.png" />

You can also append text configurations to each other:

```objc
NSString *commaSpace = @", ";
BONChainLink *chainLink = RZCursive;
chainLink
.append(RZCursive.string(@"one fish"))
.appendWithSeparator(commaSpace, RZCursive.string(@"two fish"))
.appendWithSeparator(commaSpace, RZCursive.string(@"red fish").textColor([UIColor redColor]))
.appendWithSeparator(commaSpace, RZCursive.string(@"blue fish").textColor([UIColor blueColor]));

NSAttributedString *string = chainLink.attributedString;
```

Outputs:

<img width=227 height=34 src="readme-images/fish-with-red-comma.png" />

(Notice that the comma after `red fish` is red, but in the previous example, it was not colored. This is the behavior that made the most sense to me, but please open an issue or pull request if you think it should be different.)

## Image Attachments

BonMot uses NSTextAttachment to embed images in strings. Simply use the `.image` property of a chain link or text configuration:

```objc
BONChainLink *chainLink = RZCursive;
chainLink
.append(RZCursive.image(someUIImage).baselineOffset(-4.0f))
.appendWithSeparator(@" ", RZCursive.text(@"label with icon"));
NSAttributedString *string = chainLink.attributedString;
```

Outputs:

<img width=116 height=22 src="readme-images/label-with-icon.png" />

## Author

Zev Eisenberg, zev.eisenberg@raizlabs.com

## License

BonMot is available under the MIT license. See the LICENSE file for more info.
