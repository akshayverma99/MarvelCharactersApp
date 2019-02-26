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

// Sets the url and sets the url to get a small version of the image
-(void) setUrl:(NSString *)url{
    _url = url;
    
    // Converts the string into one that can be used to get the picture
    // Creates https instead of http
    // also adds size of picture + .jpg to the end of the url so it can be called for the image directly
    NSMutableString *secureString = [NSMutableString stringWithString:url];
    [secureString insertString:@"s" atIndex:4];
    [secureString appendString:@"/portrait_medium.jpg"];
    _collectionViewImageUrl = secureString;
}


@end
