//
//  DataHandler.m
//  MarvelCharactersApp
//
//  Created by Akshay Verma on 2019-02-25.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

#import "DataHandler.h"

@interface DataHandler()

@property (strong, nonatomic) NSArray *arrayOfCharacters;

@end



@implementation DataHandler 


- (NSArray *)getArrayOfCharacters{
    return self.arrayOfCharacters;
}

- (void) updateCharacterArray:(NSArray *)characterArray{
    self.arrayOfCharacters = characterArray;
}

@end
