//
//  AOMarkdownLabelTests.m
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

// Test Class
#import "AOMarkdownLabel.h"

// Collaborators

// Test Support
#import <XCTest/XCTest.h>

#define EXP_SHORTHAND YES
#import <Expecta/Expecta.h>

#import <OCMock/OCMock.h>

@interface AOMarkdownLabelTests : XCTestCase
@end

@implementation AOMarkdownLabelTests
{
  AOMarkdownLabel *sut;
  id partialMock;
}

#pragma mark - Test Lifecycle

- (void)setUp
{
  [super setUp];
  sut = [[AOMarkdownLabel alloc] init];
}

#pragma mark - Given

- (void)givenPartialMock
{
  partialMock = OCMPartialMock(sut);
}

#pragma mark - Object Lifecycle - Tests

- (void)test___initWithCoder___calls_commonInit
{
  // given
  sut = [AOMarkdownLabel alloc];
  [self givenPartialMock];
  
  // when
  sut = [sut initWithCoder:nil];
  
  // then
  [[partialMock verify] commonInit];
}

- (void)test___initWithFrame___calls_commonInit
{
  // given
  sut = [AOMarkdownLabel alloc];
  [self givenPartialMock];
  
  // when
  sut = [sut initWithFrame:CGRectZero];
  
  // then
  [[partialMock verify] commonInit];
}

#pragma mark - Common Init - Tests

- (void)test___commonInit___setsUpLayoutManager
{
  // given
  sut.layoutManager = nil;
  
  // when
  [sut commonInit];
  
  // then
  expect(sut.layoutManager).toNot.beNil();
}

- (void)test___commonInit___setsUpTextContainer
{
  // given
  sut.textContainer = nil;
  sut.lineBreakMode = NSLineBreakByTruncatingTail;
  sut.numberOfLines = 42;
  sut.frame = CGRectMake(0, 0, 320, 480);
  
  // when
  [sut commonInit];
  
  // then
  expect(sut.textContainer).toNot.beNil();
  expect(sut.textContainer.lineBreakMode).to.equal(sut.lineBreakMode);
  expect(sut.textContainer.maximumNumberOfLines).to.equal(sut.numberOfLines);
  expect(sut.textContainer.size).to.equal(sut.frame.size);
}

- (void)test___commonInit___setsUpTextStorage
{
  // given
  sut.textStorage = nil;
  
  // when
  [sut commonInit];
  
  // then
  expect(sut.textStorage).toNot.beNil();
}


@end