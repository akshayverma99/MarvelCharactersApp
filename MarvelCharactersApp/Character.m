//
//  Character.m
//  MarvelCharactersApp
//
//  Created by Akshay Verma on 2019-02-26.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

#import "Character.h"

@implementation Character

+(id)createNewCharacterWith: (NSString *)name withUrl:(NSString *)url{
    
    Character *character = [[Character alloc] init];
    character.name = name;
    character.url = url;
    
    return character;    
}

// When the url is set, urls for the small and large versions of the poster are created
-(void) setUrl:(NSString *)url{
    _url = url;
    // Converts the string into one that can be used to get the picture
    // Creates https instead of http
    // also adds size of picture + .jpg to the end of the url so it can be called for the image directly
    NSMutableString *smallPosterString = [NSMutableString stringWithString:url];
    [smallPosterString insertString:@"s" atIndex:4];
    [smallPosterString appendString:@"/portrait_small.jpg"];
    _collectionViewImageUrl = smallPosterString;
    NSMutableString *bigPosterString = [NSMutableString stringWithString:url];
    [bigPosterString insertString:@"s" atIndex:4];
    [bigPosterString appendString:@"/portrait_uncanny.jpg"];
    _bigPosterUrl = bigPosterString;
}


@end
