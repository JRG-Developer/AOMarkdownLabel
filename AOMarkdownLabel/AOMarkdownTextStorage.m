//
//  AOMarkdownTextStorage.m
//  AOMarkdownLabel
//
//  Created by Joshua Greene on 7/6/14.
//  Copyright (c) 2014 App-Order, LLC http://www.app-order.com
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  1. The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  2. Neither the name of the copyright holder nor the names of its contributors
//  may be used to endorse or promote products derived from this software without
//  specific prior written permission.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "AOMarkdownTextStorage.h"

@interface AOMarkdownTextStorage()
@property (strong, nonatomic) NSMutableAttributedString *backingStore;
@property (strong, nonatomic) NSMutableDictionary *attributePatterns;
@property (strong, nonatomic) NSMutableDictionary *rangeAttributePatterns;
@end

@implementation AOMarkdownTextStorage

#pragma mark - Object Lifecycle

- (instancetype)init
{
  if (self = [super init])
  {
    _backingStore = [[NSMutableAttributedString alloc] init];
    
    [self setDefaultAttributes];
    [self setUpAttributePatterns];
  }
  return self;
}

- (void)setDefaultAttributes
{
  _defaultAttributes = @{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]};
}

- (void)setUpAttributePatterns
{
  self.attributePatterns = [NSMutableDictionary dictionary];
  [self setUpBoldPattern];
  [self setUpItalicPattern];
  [self setUpStrikeThroughPattern];
}

#pragma mark - Bold

- (void)setUpBoldPattern
{
  NSString *regex = @"(\\*\\*\\w+(\\s\\w+)*\\*\\*)";
  NSDictionary *attributes = [self attributesForFontStyle:UIFontTextStyleBody withTrait:UIFontDescriptorTraitBold];
  self.attributePatterns[regex] = attributes;
}

#pragma mark - Italics

- (void)setUpItalicPattern
{
  NSString *regex = @"\\*\\w+(\\s\\w+)*\\*)";
  NSDictionary *attributes = [self attributesForFontStyle:UIFontTextStyleBody withTrait:UIFontDescriptorTraitItalic];
  self.attributePatterns[regex] = attributes;
}

#pragma mark - Strikethrough

- (void)setUpStrikeThroughPattern
{
  NSString *regex = @"(~~\\w+(\\s\\w+)*~~)";
  NSDictionary *attributes = @{NSStrikethroughStyleAttributeName : @1};
  self.attributePatterns[regex] = attributes;
}

#pragma mark - Underline


#pragma mark - URL

- (NSRegularExpression *)regexMatchingURLs
{
  return [NSRegularExpression
          regularExpressionWithPattern:@"((http|ftp|https):"@"\\/\\/[\\w\\-_]+(\\.[\\w\\-_]+)+"
                                       @"([\\w\\-\\.,@?^=%&amp;:/~\\+#]*[\\w\\-\\@?^=%&amp;/~\\+#])?)"
          options:NSRegularExpressionCaseInsensitive
          error:nil];
}

#pragma mark - attributesForFontStyle: withTrait:

- (NSDictionary*)attributesForFontStyle:(NSString*)style withTrait:(uint32_t)trait
{
  UIFontDescriptor *fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
  UIFontDescriptor *descriptorWithTrait = [fontDescriptor fontDescriptorWithSymbolicTraits:trait];
  UIFont* font =  [UIFont fontWithDescriptor: descriptorWithTrait size: 0.0];
  
  return @{NSFontAttributeName: font};
}

#pragma mark - Custom Accessors

- (void)setDefaultAttributes:(NSDictionary *)defaultAttributes
{
  if (_defaultAttributes == defaultAttributes) {
    return;
    
  } else if (defaultAttributes == nil) {
    [self setDefaultAttributes];
    return;
  }
  
  _defaultAttributes = defaultAttributes;
}

#pragma mark - NSTextStorage Optional Overrides

-(void)processEditing
{
  [self performReplacementsForCharacterChangeInRange:[self editedRange]];
  [super processEditing];
}

- (void)performReplacementsForCharacterChangeInRange:(NSRange)changedRange
{
  NSRange minRange = [[self.backingStore string] lineRangeForRange:NSMakeRange(changedRange.location, 0)];
  NSRange maxRange = [[self.backingStore string] lineRangeForRange:NSMakeRange(NSMaxRange(changedRange), 0)];
  
  NSRange extendedRange = NSUnionRange(changedRange, minRange);
  extendedRange = NSUnionRange(extendedRange, maxRange);
  
  [self applyStylesToRange:extendedRange];
}

- (void)applyStylesToRange:(NSRange)searchRange
{
  for (NSString *key in self.attributePatterns) {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:key options:0 error:nil];
    NSDictionary* attributes = self.attributePatterns[key];
    [self applyRegex:regex attributes:attributes toRange:searchRange];
  }
  
  [self highlightHyperlinksInRange:searchRange];
}

- (void)applyRegex:(NSRegularExpression *)regex
        attributes:(NSDictionary *)attributes
           toRange:(NSRange)searchRange
{
  [regex enumerateMatchesInString:[self.backingStore string]
                          options:0
                            range:searchRange
                       usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {

                         NSRange range = [match range];
                         [self addAttributes:attributes range:range];
                         [self restoreDefaultAttribures:range];
                       }];
}

- (void)restoreDefaultAttribures:(NSRange)range
{
  if (NSMaxRange(range) + 1 < self.length) {
    [self addAttributes:self.defaultAttributes range:NSMakeRange(NSMaxRange(range)+1, 1)];
  }
}

- (void)highlightHyperlinksInRange:(NSRange)searchRange {
  
  NSRegularExpression *regex = [self regexMatchingURLs];
  
  [regex enumerateMatchesInString:[self.backingStore string]
                          options:0
                            range:searchRange
                       usingBlock:^(NSTextCheckingResult *match,
                                    NSMatchingFlags flags,
                                    BOOL *stop){

                         NSRange range = [match rangeAtIndex:1];
                         
                         NSDictionary* attributes = @{ NSForegroundColorAttributeName : [UIColor blueColor],
                                                       NSUnderlineStyleAttributeName : @1,
                                                       NSLinkAttributeName: [self urlFromFromRange:range]};
                         [self addAttributes:attributes range:range];
                       }];
}

- (NSURL *)urlFromFromRange:(NSRange)range
{
  NSString *urlString = [[self.backingStore string] substringWithRange:range];
  return [NSURL URLWithString:urlString];
}

#pragma mark - NSTextStorage - Required Overrides

- (NSString *)string
{
  return [self.backingStore string];
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range
{
  return [self.backingStore attributesAtIndex:location effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
  [self beginEditing];
  
  [self.backingStore replaceCharactersInRange:range withString:str];
  
  NSInteger delta = str.length - range.length;
  [self edited:NSTextStorageEditedCharacters | NSTextStorageEditedAttributes range:range changeInLength:delta];
  
  [self endEditing];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range
{
  [self beginEditing];
  
  [self.backingStore setAttributes:attrs range:range];
  [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
  
  [self endEditing];
}

#pragma mark - Dynamic Type Text

-(void)refreshFont
{
  [self setUpAttributePatterns];
  
  NSDictionary *bodyFont = @{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody]};
  [self addAttributes:bodyFont range:NSMakeRange(0, self.length)];
  
  [self applyStylesToRange:NSMakeRange(0, self.length)];
}

@end
