//
//  AOMarkdownLabel.m
//  AOMarkdownLabel
//
//  Created by Joshua Greene on 6/29/14.
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

#import "AOMarkdownLabel.h"
#import "AOMarkdownTextStorage.h"

@implementation AOMarkdownLabel

#pragma mark - Object Lifecycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self commonInit];
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self commonInit];
  }
  return self;
}

- (void)commonInit
{
  [self setUpTextKitStack];
}

#pragma mark - Text Kit Stack Setup

- (void)setUpTextKitStack
{
  [self setUpLayoutManager];
  [self setUpTextContainer];
  [self setUpTextStorage];
  
  [self assocateTextKitStackObjects];
}

- (void)setUpLayoutManager
{
  self.layoutManager = [[NSLayoutManager alloc] init];
}

- (void)setUpTextContainer
{
  self.textContainer = [[NSTextContainer alloc] init];
  self.textContainer.lineBreakMode = self.lineBreakMode;
  self.textContainer.maximumNumberOfLines = self.numberOfLines;
  self.textContainer.size = self.frame.size;
}

- (void)setUpTextStorage
{
  self.textStorage = [[AOMarkdownTextStorage alloc] init];
}

- (void)assocateTextKitStackObjects
{
  [self.layoutManager addTextContainer:self.textContainer];
  [self.textContainer setLayoutManager:self.layoutManager];
}

@end
