# MLDynamicModal
Use this view to show a custom modal inside your app. Support iOS 9+.


# Example
![modal](https://user-images.githubusercontent.com/5194168/35331388-f098a916-00e5-11e8-9da3-d507020b1635.jpg)

## Installation

MLDynamicModal is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "MLDynamicModal"
```

# Usage
#### 1. Import MLDynamicModalViewController class
```objective-c
#import <MLDynamicModal/MLDynamicModalViewController.h>
```

#### 2. Create an intance
```objective-c
MLDynamicModalViewController *modal = [[MLDynamicModalViewController alloc] initWithView:[[UIView alloc] init]];
```
Use one of this alternative initializer to customize the view
##### ・More initializers
```objective-c
- (instancetype)initWithView:(UIView *)view headerView:(UIView *)headerView;
```
```objective-c
- (instancetype)initWithView:(UIView *)view title:(NSString *)title;
```
```objective-c
- (instancetype)initWithView:(UIView *)view attributedTitle:(NSAttributedString *)attributedTitle;
```

#### 3. Customize Modal
```objective-c
- (void)setShowCloseButton:(BOOL)show;
- (void)setModalCloseButtonColor:(UIColor *)color;
- (void)setShouldDismissOnTap:(BOOL)dismiss;
- (void)setShouldSwipeToDismiss:(BOOL)dismiss;
- (void)setModalBackgroundColor:(UIColor *)color;
- (void)setModalHeaderBackgroundColor:(UIColor *)color;
- (void)setShowVerticalIndicator:(BOOL)show;
- (void)setHorizontalMargin:(CGFloat)horizontalMargin;
```

#### 4. PresentModal
```objective-c
[self presentViewController:modal animated:YES completion:nil];
```

## Author
Julian Bruno, julian.bruno@mercadolibre.com

Vanesa Stricker, vanesa.stricker@mercadolibre.com

Damian Trimboli, damian.trimboli@mercadolibre.com

Jonatan Urquiza, jonatan.urquiza@mercadolibre.com
