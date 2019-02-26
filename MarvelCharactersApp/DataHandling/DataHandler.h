//
//  DataHandler.h
//  MarvelCharactersApp
//
//  Created by Akshay Verma on 2019-02-25.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataHandler : NSObject

- (NSArray *)getArrayOfCharacters;
- (void) updateCharacterArray:(NSArray *)characterArray;

@end
