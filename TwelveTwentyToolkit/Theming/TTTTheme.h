#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define TTTAttributeBackgroundColor @"TTTAttributeBackgroundColor"
#define TTTAttributeBackgroundImage @"TTTAttributeBackgroundImage"
#define TTTAttributeContentEdgeInsets @"TTTAttributeContentEdgeInsets"
#define TTTAttributeContentHorizontalAlignment @"TTTAttributeContentHorizontalAlignment"
#define TTTAttributeFont NSFontAttributeName
#define TTTAttributeImage @"TTTAttributeImage"
#define TTTAttributeImageEdgeInsets @"TTTAttributeImageEdgeInsets"
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
#define TTTAttributeTextShadowColor UITextAttributeTextShadowColor
#define TTTAttributeTextShadowOffset UITextAttributeTextShadowOffset
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

- (void)applyTextStyle:(TTTTextStyle)style toTextField:(UITextField *)textField;

- (void)applyTextStyle:(TTTTextStyle)style toTextView:(UITextView *)textView;

- (void)applyButtonStyle:(TTTButtonStyle)style toButton:(UIButton *)button;

- (CGSize)UIOffsetValueToCGSize:(NSValue *)offsetValue;

@end

@interface UIColor (TTTTheming)

+ (UIColor *)tttColorForStyle:(TTTColorStyle)colorStyle;

@end

@interface UILabel (TTTTheming)

+ (UILabel *)tttLabelWithText:(NSString *)text textStyle:(TTTTextStyle)textStyle;

+ (UILabel *)tttLabelWithTextStyle:(TTTTextStyle)textStyle;

- (void)tttApplyTextStyle:(TTTTextStyle)textStyle;

@end

@interface UIButton (TTTTheming)

+ (id)tttButtonWithStyle:(TTTButtonStyle)buttonStyle;

+ (id)tttButtonWithTitle:(NSString *)title buttonStyle:(TTTButtonStyle)buttonStyle;

- (void)tttApplyButtonStyle:(TTTButtonStyle)buttonStyle;

@end

@interface UITextField (TTTTheming)

+ (id)tttTextFieldWithPlaceholder:(NSString *)placeholder textFieldStyle:(TTTTextStyle)textStyle;

- (void)tttApplyTextStyle:(TTTTextStyle)textStyle;

@end

@interface UITextView (TTTTheming)

+ (id)tttTextViewWithTextFieldStyle:(TTTTextStyle)textStyle;

- (void)tttApplyTextStyle:(TTTTextStyle)textStyle;

@end