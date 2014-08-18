//
//  UnderlineLabel.m
//  PeggSite
//
//  Created by Jennifer Duffey on 7/9/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "UnderlineLabel.h"

@implementation UnderlineLabel

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        if(self.attributedText.length > 0)
        {
            NSMutableArray *underLinedStrings = [NSMutableArray array];
            
            // find underlined text ranges and add to array
            [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.string.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop)
            {
                if([attrs[NSUnderlineStyleAttributeName] intValue] == 1)
                {
                    [underLinedStrings addObject:NSStringFromRange(range)];
                }
                
                NSLog(@"attributes: %@, Range: %@", attrs, NSStringFromRange(range));
            }];
            
            // initialize new mutable string with correct font attributes
            NSMutableAttributedString *underlinedString = [[NSMutableAttributedString alloc] initWithString:self.attributedText.string attributes:@{NSFontAttributeName : [UIFont fontWithName:FONT_PROXIMA_BOLD size:FONT_SIZE_NOTES], NSForegroundColorAttributeName : self.textColor}];
            
            // add underline to ranges retrieved
            for(NSString *rangeString in underLinedStrings)
            {
                [underlinedString addAttributes:@{NSUnderlineStyleAttributeName : @(1)} range:NSRangeFromString(rangeString)];
            }
            
            // set our properly formatted attributed text
            [self setAttributedText:underlinedString];
        }
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
