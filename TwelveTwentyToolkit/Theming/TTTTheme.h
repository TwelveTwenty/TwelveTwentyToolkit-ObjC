#import <Foundation/Foundation.h>

#define TTTAttributeBackgroundColor @"TTTAttributeBackgroundColor"
#define TTTAttributeBackgroundImage @"TTTAttributeBackgroundImage"
#define TTTAttributeContentEdgeInsets @"TTTAttributeContentEdgeInsets"
#define TTTAttributeContentHorizontalAlignment @"TTTAttributeContentHorizontalAlignment"
#define TTTAttributeFont UITextAttributeFont
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
#define TTTAttributeTextColorHighlighted @"TTTAttributeTextColorHighlighted"
#define TTTAttributeTextColor UITextAttributeTextColor
#define TTTAttributeTextShadowColor UITextAttributeTextShadowColor
#define TTTAttributeTextShadowOffset UITextAttributeTextShadowOffset
#define TTTAttributeTextStyle @"TTTAttributeTextStyle"
#define TTTAttributeTitleColor @"TTTAttributeTitleColor"
#define TTTAttributeTitleEdgeInsets @"TTTAttributeTitleEdgeInsets"

typedef NSInteger TTTTextStyle;
typedef NSInteger TTTButtonStyle;

@protocol TTTTheme <NSObject>

- (NSMutableDictionary *)attributesForTextStyle:(TTTTextStyle)style forControlState:(UIControlState)controlState;

- (NSDictionary *)attributesForButtonStyle:(TTTButtonStyle)style withControlState:(UIControlState)controlState;

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

@interface UILabel (TTTTheming)

+ (id)tttLabelWithText:(NSString *)text textStyle:(TTTTextStyle)textStyle;

+ (id)tttLabelWithTextStyle:(TTTTextStyle)textStyle;

- (void)tttApplyTextStyle:(TTTTextStyle)textStyle;

@end

@interface UIButton (TTTTheming)

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