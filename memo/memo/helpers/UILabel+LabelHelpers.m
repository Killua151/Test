//
//  UILabel+LabelHelpers.m
//  memo
//
//  Created by Ethan Nguyen on 10/14/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "UILabel+LabelHelpers.h"

@implementation UILabel (LabelHelpers)

- (void)adjustToFitHeight {
  [self adjustToFitHeightAndRelatedTo:nil withDistance:0];
}

- (void)adjustToFitHeightAndConstrainsToHeight:(CGFloat)maxHeight {
  [self adjustToFitHeightAndRelatedTo:nil withDistance:0];
  
  CGRect frame = self.frame;
  frame.size.height = MIN(frame.size.height, maxHeight);
  self.frame = frame;
}

- (void)adjustToFitHeightAndRelatedTo:(UILabel *)otherLabel withDistance:(CGFloat)distance {
  CGSize sizeThatFits = [self sizeThatFits:CGSizeMake(self.frame.size.width, MAXFLOAT)];
  CGRect frame = self.frame;
  
  if (otherLabel != nil)
    frame.origin.y = otherLabel.frame.origin.y + otherLabel.frame.size.height + distance;
  
  frame.size.height = sizeThatFits.height;
  self.frame = frame;
}

- (void)adjustToFitHeightAndConstrainsToHeight:(CGFloat)maxHeight
                                     relatedTo:(UILabel *)otherLabel
                                  withDistance:(CGFloat)distance {
  CGSize sizeThatFits = [self sizeThatFits:CGSizeMake(self.frame.size.width, MAXFLOAT)];
  CGRect frame = self.frame;
  
  if (otherLabel != nil)
    frame.origin.y = otherLabel.frame.origin.y + otherLabel.frame.size.height + distance;
  
  frame.size.height = MIN(sizeThatFits.height, maxHeight);
  self.frame = frame;
}

- (void)applyAttributedText:(NSString *)fullText onString:(NSString *)styledString withAttributes:(NSDictionary *)attributes {
  NSRange styledRange = [fullText rangeOfString:styledString];
  
  if (styledRange.location == NSNotFound) {
    self.text = fullText;
    return;
  }
  
  [self applyAttributedText:fullText inRange:styledRange withAttributes:attributes];
}

- (void)applyAttributedText:(NSString *)fullText inRange:(NSRange)styledRange withAttributes:(NSDictionary *)attributes {
  NSMutableAttributedString *attributedText =
  [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
  
  if (![[attributedText string] isEqualToString:fullText])
    attributedText = [[NSMutableAttributedString alloc] initWithString:fullText];
  
  [attributedText addAttributes:attributes range:styledRange];
  self.attributedText = attributedText;
}

- (CGRect)boundingRectForCharacterRange:(NSRange)range {
  NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:[self attributedText]];
  NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
  [textStorage addLayoutManager:layoutManager];
  NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:[self bounds].size];
  textContainer.lineFragmentPadding = 0;
  [layoutManager addTextContainer:textContainer];
  
  NSRange glyphRange;
  
  // Convert the range for glyphs.
  [layoutManager characterRangeForGlyphRange:range actualGlyphRange:&glyphRange];
  
  return [layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:textContainer];
}

- (CGRect)rectForLetterAtIndex:(NSUInteger)index {
//  NSAssert(self.lineBreakMode != NSLineBreakByClipping, @"UILabel.lineBreakMode cannot be UILineBreakModeClip to calculate the rect of a character. You might think that it's possible, seeing as UILineBreakModeWordWrap is supported, and they are almost the same. But the semantics are weird. Sorry.");
//  NSAssert(self.lineBreakMode != NSLineBreakByTruncatingHead, @"UILabel.lineBreakMode cannot be UILineBreakModeHeadTruncation to calculate the rect of a character. We can't have everything you know.");
//  NSAssert(self.lineBreakMode != NSLineBreakByTruncatingMiddle, @"UILabel.lineBreakMode cannot be UILineBreakModeMiddleTruncation to calculate the rect of a character. We can't have everything you know.");
//  NSAssert(self.lineBreakMode != NSLineBreakByTruncatingTail, @"UILabel.lineBreakMode cannot be UILineBreakModeTailTruncation to calculate the rect of a character. We can't have everything you know.");
  
  // Check if label is empty. Should add so it also checks for strings containing only spaces
  if ([self.text length] == 0)
    return self.bounds;
  
  // Algorithm goes like this:
  //    1. Determine which line the letter is on
  //    2. Get the x-position on the line by: width of string up to letter
  //    3. Apply UITextAlignment to the x-position
  //    4. Add y position based on height of letters * line number
  //    Et víolà!
  
  NSString *letter = [self.text substringWithRange:NSMakeRange(index, 1)];
  
  // Determine which line the letter is on and the string on that line
  CGSize letterSize = [letter sizeWithFont:self.font];
  
  int lineNo = 0;
  int linesDisplayed = 1;
  
  // Get the substring with the line on it
  NSUInteger lineStartsOn = 0;
  NSUInteger currentLineLength = 1;
  
  // Temporary variables
  NSUInteger currentLineStartsOn = 0;
  NSUInteger currentCurrentLineLength = 1;
  
  float currentWidth;
  
  // TODO: Add support for UILineBreakModeWordWrap, UILineBreakModeCharacterWrap to complete implementation
  // Get the line number of the current letter
  // Get the contents of that line
  // Get the total number of lines (which means that no matter what we loop through the entire thing)
  
  BOOL isDoneWithLine = NO;
  
  NSUInteger i = 0, len = [self.text length];
  
  // The loop is different depending on the lineBreakMode. If it is UILineBreakModeCharacterWrap it is easy
  // just check for every single character. For UILineBreakModeWordWrap it is a bit more tedious. We have
  // to think in terms of words. We have to find each word and check it. If it is longer than the frame width
  // then we know we have a new word, and that lines index starts on the words beginning index.
  // Spaces prove to be even morse troublesome. Several spaces in a row at the end of a line won't result in
  // any more width.
  for (; i < len; i++) {
    NSString *currentLine = [self.text substringWithRange:NSMakeRange(currentLineStartsOn, currentCurrentLineLength)];
    
    CGSize currentSize = [currentLine sizeWithFont:self.font
                                 constrainedToSize:CGSizeMake(self.frame.size.width, 1000)
                                     lineBreakMode:self.lineBreakMode];
    currentWidth = currentSize.width;
    
    if (currentSize.height > self.font.lineHeight) {
      // We have to go to a new line
      linesDisplayed++;
      
      //NSLog(@"new line on: %d", i);
      
      // If i <= index that means we are on the correct letter's line
      // store that
      if (i <= index) {
        lineStartsOn = i;
        lineNo++;
        currentLineLength = 1;
      } else
        isDoneWithLine = YES;
      
      currentLineStartsOn = i;
      currentCurrentLineLength = 1;
      i--;
    } else {
      // Okay with the same line
      currentCurrentLineLength++;
      
      if (!isDoneWithLine)
        currentLineLength++;
    }
  }
  
  // Make sure we didn't overstep the bounds
  while (lineStartsOn + currentLineLength > len)
    currentLineLength--;
  
  // Check if linesDisplayed is faulty, if for example lines have been clipped
  CGSize totalSize = [self.text sizeWithFont:self.font
                           constrainedToSize:CGSizeMake(self.frame.size.width, MAXFLOAT)
                               lineBreakMode:self.lineBreakMode];
  
  if (totalSize.height > self.frame.size.height) {
    // It has been clipped, calculate how many lines are actually shown
    
    linesDisplayed = 0;
    float lineHeight = 0;
    
    while (lineHeight < self.frame.size.height) {
      lineHeight += self.font.lineHeight;
      linesDisplayed++;
    }
    
    linesDisplayed--;
    
    // Number of lines is not automatic, keep it within that range
    if (self.numberOfLines > 0)
      linesDisplayed = linesDisplayed > self.numberOfLines ? self.numberOfLines : linesDisplayed;
  }
  
  // Length of the substring up and including this letter
  NSUInteger currentLineSubstrLength = index - lineStartsOn + 1;
  
  currentWidth = [[self.text substringWithRange:NSMakeRange(lineStartsOn, currentLineLength)] sizeWithFont:self.font].width;
  
  NSString *lineSubstr = [self.text substringWithRange:NSMakeRange(lineStartsOn, currentLineSubstrLength)];
  
  float x = [lineSubstr sizeWithFont:self.font].width - [letter sizeWithFont:self.font].width;
  float y = self.frame.size.height/2 - (linesDisplayed*self.font.lineHeight)/2 + self.font.lineHeight*lineNo;
  
  if (self.textAlignment == NSTextAlignmentCenter)
    x = x + (self.frame.size.width-currentWidth)/2;
  else if (self.textAlignment == NSTextAlignmentRight)
    x = self.frame.size.width-(currentWidth-x);
  
  return CGRectMake(x, y, letterSize.width, letterSize.height);
}

@end

@implementation TTTAttributedLabel (LabelHelpers)

- (void)applyWordDefinitions:(NSArray *)words withSpecialWords:(NSArray *)specialWords {
  self.linkAttributes = @{
                          NSUnderlineStyleAttributeName : @(NSUnderlineStyleThick | NSUnderlinePatternDot)
                          };
  self.activeLinkAttributes = @{
                                NSForegroundColorAttributeName : UIColorFromRGB(153, 153, 153),
                                NSUnderlineStyleAttributeName : @(NSUnderlineStyleThick | NSUnderlinePatternDot)
                                };
  
  NSMutableArray *allWords = [NSMutableArray arrayWithArray:words];
  [allWords addObjectsFromArray:specialWords];
  allWords = [allWords valueForKeyPath:@"@distinctUnionOfObjects.self"];
  
  for (NSString *word in allWords) {
    NSRange wordRange = [self.text rangeOfString:word options:NSCaseInsensitiveSearch];
    
    if (wordRange.location == NSNotFound)
      continue;
    
    [self addLinkToAddress:@{kParamWord : word, kParamWordRange : [NSValue valueWithRange:wordRange]}
                 withRange:wordRange];
    
    if ([specialWords containsObject:word])
      [self applyAttributedText:self.text
                        inRange:wordRange
                 withAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(255, 136, 0)}];
  }
}

@end
