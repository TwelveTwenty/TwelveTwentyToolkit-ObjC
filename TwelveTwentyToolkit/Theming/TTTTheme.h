#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define TTTAttributeBackgroundColor @"TTTAttributeBackgroundColor"
#define TTTAttributeBackgroundImage @"TTTAttributeBackgroundImage"
#define TTTAttributeContentEdgeInsets @"TTTAttributeContentEdgeInsets"
#define TTTAttributeContentHorizontalAlignment @"TTTAttributeContentHorizontalAlignment"
#define TTTAttributeFont NSFontAttributeName
#define TTTAttributeImage @"TTTAttributeImage"
#define TTTAttributeImageEdgeInsets @"TTTAttributeImageEdgeInsets"
#define TTTAttributeImageViewContentMode @"TTTAttributeImageViewContentMode"
#define TTTAttributeLayerShadowColor @"TTTAttributeLayerShadowColor"
#define TTTAttributeLayerShadowOffset @"TTTAttributeLayerShadowOffset"
#define TTTAttributeLayerShadowOpacity @"TTTAttributeLayerShadowOpacity"
#define TTTAttributeLayerShadowRadius @"TTTAttributeLayerShadowRadius"
#define TTTAttributeLineBreakMode @"TTTAttributeLineBreakMode"
#define TTTAttributeNumberOfLines @"TTTAttributeNumberOfLines"
#define TTTAttributeShowsTouchWhenHighlighted @"TTTAttributeShowsTouchWhenHighlighted"
#define TTTAttributeTextAlignment @"TTTAttributeTextAlignment"
#define TTTAttributeTextColor NSForegroundColorAttributeName
#define TTTAttributeTextColorHighlighted @"TTTAttributeTextColorHighlighted"
#define TTTAttributeTextStyle @"TTTAttributeTextStyle"
#define TTTAttributeTitleColor @"TTTAttributeTitleColor"
#define TTTAttributeTitleEdgeInsets @"TTTAttributeTitleEdgeInsets"

typedef NSInteger TTTTextStyle;
typedef NSInteger TTTButtonStyle;
typedef NSInteger TTTColorStyle;

@protocol TTTTheme <NSObject>

- (NSMutableDictionary *)attributesForTextStyle:(TTTTextStyle)style forControlState:(UIControlState)controlState;

- (NSMutableDictionary *)attributesForButtonStyle:(TTTButtonStyle)style withControlState:(UIControlState)controlState;

@optional

- (UIColor *)colorForStyle:(TTTColorStyle)colorStyle;

@end

/**
* Subclassing notes: when subclassing, also implement the <TTTTheme> protocol
*/

@interface TTTTheme : NSObject

+ (TTTTheme <TTTTheme> *)currentTheme;

+ (void)setCurrentTheme:(TTTTheme <TTTTheme> *)theme;

- (void)applyTextStyle:(TTTTextStyle)style toLabel:(UILabel *)label;

- (void)applyTextStyle:(TTTTextStyle)style toLabel:(UILabel *)label forControlState:(UIControlState)controlState;

- (void)applyTextAttributes:(NSDictionary *)attributes toLabel:(UILabel *)label forControlState:(UIControlState)controlState;

- (void)applyTextStyle:(TTTTextStyle)style toTextField:(UITextField *)textField;

- (void)applyTextStyle:(TTTTextStyle)style toTextView:(UITextView *)textView;

- (void)applyButtonStyle:(TTTButtonStyle)style toButton:(UIButton *)button;

- (CGSize)UIOffsetValueToCGSize:(NSValue *)offsetValue;

@end

@interface UIColor (TTTTheming)

+ (instancetype)ttt_colorForStyle:(TTTColorStyle)colorStyle;

@end

@interface UILabel (TTTTheming)

+ (instancetype)ttt_labelWithText:(NSString *)text textStyle:(TTTTextStyle)textStyle;

+ (instancetype)ttt_labelWithTextStyle:(TTTTextStyle)textStyle;

- (void)ttt_applyTextStyle:(TTTTextStyle)textStyle;

- (void)ttt_applyTextStyle:(TTTTextStyle)textStyle numberOfLines:(NSUInteger)numberOfLines lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end

@interface UIButton (TTTTheming)

+ (instancetype)ttt_buttonWithStyle:(TTTButtonStyle)buttonStyle;

+ (instancetype)ttt_buttonWithTitle:(NSString *)title buttonStyle:(TTTButtonStyle)buttonStyle;

+ (instancetype)ttt_buttonWithTitle:(NSString *)title buttonStyle:(TTTButtonStyle)buttonStyle iconImage:(UIImage *)image;

- (void)ttt_applyButtonStyle:(TTTButtonStyle)buttonStyle;

@end

@interface UITextField (TTTTheming)

+ (instancetype)ttt_textFieldWithPlaceholder:(NSString *)placeholder textFieldStyle:(TTTTextStyle)textStyle;

- (void)ttt_applyTextStyle:(TTTTextStyle)textStyle;

@end

@interface UITextView (TTTTheming)

+ (instancetype)ttt_textViewWithTextFieldStyle:(TTTTextStyle)textStyle;

- (void)ttt_applyTextStyle:(TTTTextStyle)textStyle;

@end