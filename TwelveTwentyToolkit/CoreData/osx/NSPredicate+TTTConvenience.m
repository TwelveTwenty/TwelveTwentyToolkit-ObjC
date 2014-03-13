#import "NSPredicate+TTTConvenience.h"

@interface MAStringFormatter : NSObject

+ (NSString *)format: (NSString *)format arguments: (NSArray *)arguments;

@end

@implementation NSPredicate (TTTConvenience)

+ (NSPredicate *)ttt_predicateWithComplexFormat:(NSString *)complexFormat innerArguments:(NSArray *)innerArguments outerArguments:(NSArray *)outerArguments
{
    NSString *simpleFormat = [MAStringFormatter format:complexFormat arguments:innerArguments];

	NSPredicate *predicate = [self predicateWithFormat:simpleFormat argumentArray:outerArguments];

	return predicate;
}

@end

@implementation MAStringFormatter {
    CFStringInlineBuffer _formatBuffer;
    NSUInteger _formatLength;
    NSUInteger _cursor;
    
    unichar *_outputBuffer;
    NSUInteger _outputBufferCursor;
    NSUInteger _outputBufferLength;
}

+ (NSString *)format: (NSString *)format arguments: (NSArray *)arguments
{
	MAStringFormatter *formatter = [[self alloc] init];
	NSString *result = [formatter format:format arguments:arguments];
	return result;
}

- (NSString *)format: (NSString *)format arguments: (NSArray *)arguments
{
	NSMutableArray *mArgs = [arguments mutableCopy];
    
    _formatLength = [format length];
    CFStringInitInlineBuffer((__bridge CFStringRef)format, &_formatBuffer, CFRangeMake(0, _formatLength));
    _cursor = 0;
    
    _outputBuffer = NULL;
    _outputBufferCursor = 0;
    _outputBufferLength = 0;
    
    int c;
    while((c = [self read]) >= 0)
    {
        if(c != '%')
        {
            [self write: c];
        }
        else
        {
            int next = [self read];
            
            if(next == '@')
            {
                id value = mArgs[0];
				[mArgs removeObjectAtIndex:0];
                NSString *description = [value description];
                NSUInteger length = [description length];
                
                while(length > _outputBufferLength - _outputBufferCursor)
                    [self doubleOutputBuffer];
                
                [description getCharacters: _outputBuffer + _outputBufferCursor range: NSMakeRange(0, length)];
                _outputBufferCursor += length;
            }
            else if(next == '%')
            {
                [self write: '%'];
            }
        }
    }
    
    NSString *output = [[NSString alloc] initWithCharactersNoCopy: _outputBuffer length: _outputBufferCursor freeWhenDone: YES];
    return output;
}

- (int)read
{
    if(_cursor < _formatLength)
        return CFStringGetCharacterFromInlineBuffer(&_formatBuffer, _cursor++);
    else
        return -1;
}

- (void)write: (unichar)c
{
    if(_outputBufferCursor >= _outputBufferLength)
        [self doubleOutputBuffer];
    
    _outputBuffer[_outputBufferCursor] = c;
    _outputBufferCursor++;
}

- (void)doubleOutputBuffer
{
    if(_outputBufferLength == 0)
        _outputBufferLength = 64;
    else
        _outputBufferLength *= 2;
    _outputBuffer = realloc(_outputBuffer, _outputBufferLength * sizeof(*_outputBuffer));
}

@end