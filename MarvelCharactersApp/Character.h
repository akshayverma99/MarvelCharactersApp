//
//  Character.h
//  MarvelCharactersApp
//
//  Created by Akshay Verma on 2019-02-26.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Character : NSObject

@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *url;
@property (strong,nonatomic) NSString *collectionViewImageUrl;
@property (strong,nonatomic) NSString *bigPosterUrl;


+(id)createNewCharacterWith: (NSString *)name withUrl:(NSString *)url;

@end
