//
//  UrlCreator.m
//  MarvelCharactersApp
//
//  Created by Akshay Verma on 2019-02-25.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

#import "UrlCreator.h"

@implementation UrlCreator

- (NSURL *)getCharacterUrl{
    NSString *stringUrl = @"https://gateway.marvel.com:443/v1/public/characters?ts=1&limit=100&apikey=5b6494e1a28cf15dd246a56ad0cd7ce2&hash=8758706f9b2769dde9033e8949398d49";
    
    return [NSURL URLWithString:stringUrl];
}

- (NSString *)getNoImageUrl{
    NSString *stringUrl = @"http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available";
    return stringUrl;
}

@end
