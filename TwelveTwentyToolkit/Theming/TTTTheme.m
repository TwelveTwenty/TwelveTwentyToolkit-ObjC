#import <QuartzCore/QuartzCore.h>
#import <TwelveTwentyToolkit/NSObject+TTTBlocks.h>
#import <TwelveTwentyToolkit/UIView+TTTLayout.h>
#import "TTTTheme.h"

static TTTTheme <TTTTheme> *_currentTheme;

@implementation TTTTheme

+ (TTTTheme <TTTTheme> *)currentTheme
{
    NSAssert(_currentTheme != nil, @"Use `setCurrentTheme` before accessing `currentTheme`");
    return _currentTheme;
}

+ (void)setCurrentTheme:(TTTTheme <TTTTheme> *)theme
{
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{_currentTheme = theme;});
}

- (id)init
{
    self = [super init];

    if (self)
    {
        NSAssert([self conformsToProtocol:@protocol(TTTTheme)], @"Theme implementation must implement TTTTheme protocol");
        if (!_currentTheme)
        {
            [[self class] setCurrentTheme:(TTTTheme <TTTTheme> *) self];
        }
    }

    return self;
}

- (void)applyTextStyle:(TTTTextStyle)style toLabel:(UILabel *)label
{
    [self applyTextStyle:style toLabel:label forControlState:UIControlStateNormal];
}

- (void)applyTextStyle:(TTTTextStyle)style toLabel:(UILabel *)label forControlState:(UIControlState)controlState
{
    label.backgroundColor = [UIColor clearColor];
    label.opaque = NO;

    NSDictionary *attributes = [(id <TTTTheme>)self attributesForTextStyle:style forControlState:controlState];

    [attributes tttForKey:TTTAttributeFont performBlock:^(id value) {label.font = value;}];
    [attributes tttForKey:TTTAttributeTextColor performBlock:^(UIColor *value) {
        label.textColor = value;
        label.highlightedTextColor = value;
    }];

    [attributes tttForKey:TTTAttributeTextColorHighlighted performBlock:^(UIColor *value) {label.highlightedTextColor = value;}];
    [attributes tttForKey:TTTAttributeTextAlignment performBlock:^(id value) {label.textAlignment = (NSTextAlignment) [value integerValue];}];
    [attributes tttForKey:TTTAttributeLineBreakMode performBlock:^(NSNumber *value) {
        label.lineBreakMode = (NSLineBreakMode) [value integerValue];
    }];
    [attributes tttForKey:TTTAttributeNumberOfLines performBlock:^(NSNumber *value) {label.numberOfLines = [value integerValue];}];

    [attributes tttForKey:TTTAttributeLayerShadowRadius performBlock:^(NSNumber *value) {
        label.layer.shadowRadius = [value floatValue];
        label.clipsToBounds = NO;
    }];
    [attributes tttForKey:TTTAttributeLayerShadowColor performBlock:^(UIColor *value) {label.layer.shadowColor = [value CGColor];}];
    [attributes tttForKey:TTTAttributeLayerShadowOffset performBlock:^(NSValue *value) {label.layer.shadowOffset = [self UIOffsetValueToCGSize:value];}];
    [attributes tttForKey:TTTAttributeLayerShadowOpacity performBlock:^(NSNumber *value) {label.layer.shadowOpacity = [value floatValue];}];
}

- (void)applyTextStyle:(TTTTextStyle)style toTextField:(UITextField *)textField
{
    NSDictionary *attributes = [(id <TTTTheme>)self attributesForTextStyle:style forControlState:UIControlStateNormal];

    [attributes tttForKey:TTTAttributeFont  performBlock:^(UIFont *value) {textField.font = value;}];
    [attributes tttForKey:TTTAttributeTextColor  performBlock:^(UIColor *value) {textField.textColor = value;}];
    [attributes tttForKey:TTTAttributeTextAlignment performBlock:^(NSNumber *value) {textField.textAlignment = (NSTextAlignment) [value integerValue];}];
    [attributes tttForKey:TTTAttributeBackgroundImage performBlock:^(UIImage *value) {textField.background = value;}];
}

- (void)applyTextStyle:(TTTTextStyle)style toTextView:(UITextView *)textView
{
    NSDictionary *attributes = [(id <TTTTheme>)self attributesForTextStyle:style forControlState:UIControlStateNormal];

    [attributes tttForKey:TTTAttributeFont  performBlock:^(UIFont *value) {textView.font = value;}];
    [attributes tttForKey:TTTAttributeTextColor  performBlock:^(UIColor *value) {textView.textColor = value;}];
    [attributes tttForKey:TTTAttributeTextAlignment performBlock:^(NSNumber *value) {textView.textAlignment = (NSTextAlignment) [value integerValue];}];
    [attributes tttForKey:TTTAttributeBackgroundColor performBlock:^(UIColor *value) {textView.backgroundColor = value;}];
}

- (void)applyButtonStyle:(TTTButtonStyle)style toButton:(UIButton *)button
{
    NSArray *controlStates = @[@(UIControlStateNormal), @(UIControlStateHighlighted), @(UIControlStateSelected), @(UIControlStateDisabled)];

    for (NSNumber *controlStateNumber in controlStates)
    {
        NSInteger controlState = [controlStateNumber integerValue];
        NSDictionary *buttonAttributes = [(id <TTTTheme>)self attributesForButtonStyle:style withControlState:(UIControlState) controlState];

        [buttonAttributes tttForKey:TTTAttributeTextStyle performBlock:^(id value) {[self applyTextStyle:[value integerValue] toLabel:button.titleLabel forControlState:controlState];}];
        [buttonAttributes tttForKey:TTTAttributeImage performBlock:^(id value) {[button setImage:value forState:(UIControlState) controlState];}];
        [buttonAttributes tttForKey:TTTAttributeBackgroundImage performBlock:^(id value) {[button setBackgroundImage:value forState:(UIControlState) controlState];}];
        [buttonAttributes tttForKey:TTTAttributeTitleColor performBlock:^(id value) {[button setTitleColor:value forState:(UIControlState) controlState];}];

        if (controlState == UIControlStateNormal)
        {
            [buttonAttributes tttForKey:TTTAttributeShowsTouchWhenHighlighted performBlock:^(id value) {button.showsTouchWhenHighlighted = [value boolValue];}];
            [buttonAttributes tttForKey:TTTAttributeBackgroundColor performBlock:^(id value) {button.backgroundColor = value;}];
            [buttonAttributes tttForKey:TTTAttributeTitleEdgeInsets performBlock:^(id value) {[button setTitleEdgeInsets:[value UIEdgeInsetsValue]];}];
            [buttonAttributes tttForKey:TTTAttributeImageEdgeInsets performBlock:^(id value) {[button setImageEdgeInsets:[value UIEdgeInsetsValue]];}];
            [buttonAttributes tttForKey:TTTAttributeContentHorizontalAlignment performBlock:^(id value) {[button setContentHorizontalAlignment:[value integerValue]];}];
            [buttonAttributes tttForKey:TTTAttributeContentEdgeInsets performBlock:^(id value) {[button setContentEdgeInsets:[value UIEdgeInsetsValue]];}];

            [buttonAttributes tttForKey:TTTAttributeLayerShadowRadius performBlock:^(NSNumber *value) {button.layer.shadowRadius = [value floatValue];}];
            [buttonAttributes tttForKey:TTTAttributeLayerShadowColor performBlock:^(UIColor *value) {button.layer.shadowColor = [value CGColor];}];
            [buttonAttributes tttForKey:TTTAttributeLayerShadowOffset performBlock:^(NSValue *value) {button.layer.shadowOffset = [self UIOffsetValueToCGSize:value];}];
            [buttonAttributes tttForKey:TTTAttributeLayerShadowOpacity performBlock:^(NSNumber *value) {button.layer.shadowOpacity = [value floatValue];}];
        }
    }
}

- (CGSize)UIOffsetValueToCGSize:(NSValue *)offsetValue
{
    if (offsetValue == nil)
    {
        return CGSizeZero;
    }

    UIOffset offset = offsetValue ? [offsetValue UIOffsetValue] : UIOffsetZero;
    return CGSizeMake(offset.horizontal, offset.vertical);
}

@end

@implementation UILabel (TTTTheming)

+ (UILabel *)tttLabelWithText:(NSString *)text textStyle:(TTTTextStyle)textStyle
{
    UILabel *label = [[self alloc] init];
    label.text = text;
    [label tttApplyTextStyle:textStyle];
    [label tttResetIntrinsicContentFrame];
    return label;
}

+ (UILabel *)tttLabelWithTextStyle:(TTTTextStyle)textStyle
{
    UILabel *label = [[self alloc] init];
    [label tttApplyTextStyle:textStyle];
    [label tttResetIntrinsicContentFrame];
    return label;
}

- (void)tttApplyTextStyle:(TTTTextStyle)textStyle
{
    [[TTTTheme currentTheme] applyTextStyle:textStyle toLabel:self];
}

@end

@implementation UIColor (TTTTheming)

+ (UIColor *)tttColorForStyle:(TTTColorStyle)colorStyle
{
    return [[TTTTheme currentTheme] colorForStyle:colorStyle];
}

@end

@implementation UIButton (TTTTheming)

+ (UIButton *)tttButtonWithStyle:(TTTButtonStyle)buttonStyle
{
    return [self tttButtonWithTitle:@"" buttonStyle:buttonStyle];
}

+ (UIButton *)tttButtonWithTitle:(NSString *)title buttonStyle:(TTTButtonStyle)buttonStyle
{
    return [self tttButtonWithTitle:title buttonStyle:buttonStyle iconImage:nil];
}

+ (UIButton *)tttButtonWithTitle:(NSString *)title buttonStyle:(TTTButtonStyle)buttonStyle iconImage:(UIImage *)image
{
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    [button tttApplyButtonStyle:buttonStyle];
    [button tttResetIntrinsicContentFrame];
    return button;
}

- (void)tttApplyButtonStyle:(TTTButtonStyle)buttonStyle
{
    [[TTTTheme currentTheme] applyButtonStyle:buttonStyle toButton:self];
}

@end

@implementation UITextField (TTTTheming)

+ (id)tttTextFieldWithPlaceholder:(NSString *)placeholder textFieldStyle:(TTTTextStyle)textStyle
{
    UITextField *textField = [[self alloc] initWithFrame:CGRectWithSize(256, 35)];
    [textField setPlaceholder:placeholder];
    [textField tttApplyTextStyle:textStyle];
    return textField;
}

- (void)tttApplyTextStyle:(TTTTextStyle)textStyle
{
    [[TTTTheme currentTheme] applyTextStyle:textStyle toTextField:self];
}

@end

@implementation UITextView (TTTTheming)

+ (id)tttTextViewWithTextFieldStyle:(TTTTextStyle)textStyle
{
    UITextView *textField = [[self alloc] initWithFrame:CGRectWithSize(256, 35)];
    [textField tttApplyTextStyle:textStyle];
    return textField;
}

- (void)tttApplyTextStyle:(TTTTextStyle)textStyle
{
    [[TTTTheme currentTheme] applyTextStyle:textStyle toTextView:self];
}

@end