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
    [self applyTextAttributes:attributes toLabel:label forControlState:controlState];
}

- (void)applyTextAttributes:(NSDictionary *)attributes toLabel:(UILabel *)label forControlState:(UIControlState)controlState
{
    [attributes ttt_forKey:TTTAttributeFont performBlock:^(id value) {label.font = value;}];
    [attributes ttt_forKey:TTTAttributeTextColor performBlock:^(UIColor *value) {
        label.textColor = value;
        label.highlightedTextColor = value;
    }];

    [attributes ttt_forKey:TTTAttributeTextColorHighlighted performBlock:^(UIColor *value) {label.highlightedTextColor = value;}];
    [attributes ttt_forKey:TTTAttributeTextAlignment performBlock:^(id value) {label.textAlignment = (NSTextAlignment) [value integerValue];}];
    [attributes ttt_forKey:TTTAttributeLineBreakMode performBlock:^(NSNumber *value) {
        label.lineBreakMode = (NSLineBreakMode) [value integerValue];
    }];
    [attributes ttt_forKey:TTTAttributeNumberOfLines performBlock:^(NSNumber *value) {label.numberOfLines = [value integerValue];}];

    [attributes ttt_forKey:TTTAttributeLayerShadowRadius performBlock:^(NSNumber *value) {
        label.layer.shadowRadius = [value floatValue];
        label.clipsToBounds = NO;
    }];
    [attributes ttt_forKey:TTTAttributeLayerShadowColor performBlock:^(UIColor *value) {label.layer.shadowColor = [value CGColor];}];
    [attributes ttt_forKey:TTTAttributeLayerShadowOffset performBlock:^(NSValue *value) {label.layer.shadowOffset = [self UIOffsetValueToCGSize:value];}];
    [attributes ttt_forKey:TTTAttributeLayerShadowOpacity performBlock:^(NSNumber *value) {label.layer.shadowOpacity = [value floatValue];}];
}

- (void)applyTextStyle:(TTTTextStyle)style toTextField:(UITextField *)textField
{
    NSDictionary *attributes = [(id <TTTTheme>)self attributesForTextStyle:style forControlState:UIControlStateNormal];

    [attributes ttt_forKey:TTTAttributeFont  performBlock:^(UIFont *value) {textField.font = value;}];
    [attributes ttt_forKey:TTTAttributeTextColor  performBlock:^(UIColor *value) {textField.textColor = value;}];
    [attributes ttt_forKey:TTTAttributeTextAlignment performBlock:^(NSNumber *value) {textField.textAlignment = (NSTextAlignment) [value integerValue];}];
    [attributes ttt_forKey:TTTAttributeBackgroundImage performBlock:^(UIImage *value) {textField.background = value;}];
}

- (void)applyTextStyle:(TTTTextStyle)style toTextView:(UITextView *)textView
{
    NSDictionary *attributes = [(id <TTTTheme>)self attributesForTextStyle:style forControlState:UIControlStateNormal];

    [attributes ttt_forKey:TTTAttributeFont  performBlock:^(UIFont *value) {textView.font = value;}];
    [attributes ttt_forKey:TTTAttributeTextColor  performBlock:^(UIColor *value) {textView.textColor = value;}];
    [attributes ttt_forKey:TTTAttributeTextAlignment performBlock:^(NSNumber *value) {textView.textAlignment = (NSTextAlignment) [value integerValue];}];
    [attributes ttt_forKey:TTTAttributeBackgroundColor performBlock:^(UIColor *value) {textView.backgroundColor = value;}];
}

- (void)applyButtonStyle:(TTTButtonStyle)style toButton:(UIButton *)button
{
    NSArray *controlStates = @[@(UIControlStateNormal), @(UIControlStateHighlighted), @(UIControlStateSelected), @(UIControlStateDisabled)];

    for (NSNumber *controlStateNumber in controlStates)
    {
        NSInteger controlState = [controlStateNumber integerValue];
        NSDictionary *buttonAttributes = [(id <TTTTheme>)self attributesForButtonStyle:style withControlState:(UIControlState) controlState];

        [buttonAttributes ttt_forKey:TTTAttributeTextStyle performBlock:^(id value) {[self applyTextStyle:[value integerValue] toLabel:button.titleLabel forControlState:controlState];}];
        [buttonAttributes ttt_forKey:TTTAttributeImage performBlock:^(id value) {[button setImage:value forState:(UIControlState) controlState];}];
        [buttonAttributes ttt_forKey:TTTAttributeBackgroundImage performBlock:^(id value) {[button setBackgroundImage:value forState:(UIControlState) controlState];}];
        [buttonAttributes ttt_forKey:TTTAttributeTitleColor performBlock:^(id value) {[button setTitleColor:value forState:(UIControlState) controlState];}];

        if (controlState == UIControlStateNormal)
        {
            [buttonAttributes ttt_forKey:TTTAttributeShowsTouchWhenHighlighted performBlock:^(id value) {button.showsTouchWhenHighlighted = [value boolValue];}];
            [buttonAttributes ttt_forKey:TTTAttributeBackgroundColor performBlock:^(id value) {button.backgroundColor = value;}];
            [buttonAttributes ttt_forKey:TTTAttributeTitleEdgeInsets performBlock:^(id value) {[button setTitleEdgeInsets:[value UIEdgeInsetsValue]];}];
            [buttonAttributes ttt_forKey:TTTAttributeImageEdgeInsets performBlock:^(id value) {[button setImageEdgeInsets:[value UIEdgeInsetsValue]];}];
            [buttonAttributes ttt_forKey:TTTAttributeImageViewContentMode performBlock:^(id value) {
                [button.imageView setContentMode:[value integerValue]];
            }];
            [buttonAttributes ttt_forKey:TTTAttributeContentHorizontalAlignment performBlock:^(id value) {[button setContentHorizontalAlignment:[value integerValue]];}];
            [buttonAttributes ttt_forKey:TTTAttributeContentEdgeInsets performBlock:^(id value) {[button setContentEdgeInsets:[value UIEdgeInsetsValue]];}];

            [buttonAttributes ttt_forKey:TTTAttributeLayerShadowRadius performBlock:^(NSNumber *value) {button.layer.shadowRadius = [value floatValue];}];
            [buttonAttributes ttt_forKey:TTTAttributeLayerShadowColor performBlock:^(UIColor *value) {button.layer.shadowColor = [value CGColor];}];
            [buttonAttributes ttt_forKey:TTTAttributeLayerShadowOffset performBlock:^(NSValue *value) {button.layer.shadowOffset = [self UIOffsetValueToCGSize:value];}];
            [buttonAttributes ttt_forKey:TTTAttributeLayerShadowOpacity performBlock:^(NSNumber *value) {button.layer.shadowOpacity = [value floatValue];}];
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

+ (UILabel *)ttt_labelWithText:(NSString *)text textStyle:(TTTTextStyle)textStyle
{
    UILabel *label = [[self alloc] init];
    label.text = text;
    [label ttt_applyTextStyle:textStyle];
    [label ttt_resetIntrinsicContentFrame];
    return label;
}

+ (UILabel *)ttt_labelWithTextStyle:(TTTTextStyle)textStyle
{
    UILabel *label = [[self alloc] init];
    [label ttt_applyTextStyle:textStyle];
    [label ttt_resetIntrinsicContentFrame];
    return label;
}

- (void)ttt_applyTextStyle:(TTTTextStyle)textStyle
{
    [[TTTTheme currentTheme] applyTextStyle:textStyle toLabel:self];
}

- (void)ttt_applyTextStyle:(TTTTextStyle)textStyle numberOfLines:(NSUInteger)numberOfLines lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    TTTTheme <TTTTheme> *theme = [TTTTheme currentTheme];
    NSMutableDictionary *attributes = [theme attributesForTextStyle:textStyle forControlState:UIControlStateNormal];
    attributes[TTTAttributeNumberOfLines] = @(numberOfLines);
    attributes[TTTAttributeNumberOfLines] = @(lineBreakMode);
    [theme applyTextAttributes:attributes toLabel:self forControlState:UIControlStateNormal];
}


@end

@implementation UIColor (TTTTheming)

+ (instancetype)ttt_colorForStyle:(TTTColorStyle)colorStyle
{
    return [[TTTTheme currentTheme] colorForStyle:colorStyle];
}

@end

@implementation UIButton (TTTTheming)

+ (instancetype)ttt_buttonWithStyle:(TTTButtonStyle)buttonStyle
{
    return [self ttt_buttonWithTitle:@"" buttonStyle:buttonStyle];
}

+ (instancetype)ttt_buttonWithTitle:(NSString *)title buttonStyle:(TTTButtonStyle)buttonStyle
{
    return [self ttt_buttonWithTitle:title buttonStyle:buttonStyle iconImage:nil];
}

+ (instancetype)ttt_buttonWithTitle:(NSString *)title buttonStyle:(TTTButtonStyle)buttonStyle iconImage:(UIImage *)image
{
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    [button ttt_applyButtonStyle:buttonStyle];
    [button ttt_resetIntrinsicContentFrame];
    return button;
}

- (void)ttt_applyButtonStyle:(TTTButtonStyle)buttonStyle
{
    [[TTTTheme currentTheme] applyButtonStyle:buttonStyle toButton:self];
}

@end

@implementation UITextField (TTTTheming)

+ (instancetype)ttt_textFieldWithPlaceholder:(NSString *)placeholder textFieldStyle:(TTTTextStyle)textStyle
{
    UITextField *textField = [[self alloc] initWithFrame:CGRectWithSize(256, 35)];
    [textField setPlaceholder:placeholder];
    [textField ttt_applyTextStyle:textStyle];
    return textField;
}

- (void)ttt_applyTextStyle:(TTTTextStyle)textStyle
{
    [[TTTTheme currentTheme] applyTextStyle:textStyle toTextField:self];
}

@end

@implementation UITextView (TTTTheming)

+ (instancetype)ttt_textViewWithTextFieldStyle:(TTTTextStyle)textStyle
{
    UITextView *textField = [[self alloc] initWithFrame:CGRectWithSize(256, 35)];
    [textField ttt_applyTextStyle:textStyle];
    return textField;
}

- (void)ttt_applyTextStyle:(TTTTextStyle)textStyle
{
    [[TTTTheme currentTheme] applyTextStyle:textStyle toTextView:self];
}

@end