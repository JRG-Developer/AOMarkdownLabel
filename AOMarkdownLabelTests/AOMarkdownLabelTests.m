//
//  AOMarkdownLabelTests.m
//  AOMarkdownLabel
//
//  Created by Joshua Greene on 6/29/14.
//  Copyright (c) 2014 App-Order, LLC. All rights reserved.
//

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

@end