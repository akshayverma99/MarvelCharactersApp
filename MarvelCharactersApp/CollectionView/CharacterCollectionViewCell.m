//
//  CharacterCollectionViewCell.m
//  MarvelCharactersApp
//
//  Created by Akshay Verma on 2019-02-25.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

#import "CharacterCollectionViewCell.h"

@interface CharacterCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation CharacterCollectionViewCell

-(void)setCharacter:(Character *)character{
    _character = character;
    [self getImageForCell];
}

-(void)getImageForCell{
    if (self.character){
        NSURLSession *session = [NSURLSession sharedSession];
        NSURL *url = [NSURL URLWithString: self.character.collectionViewImageUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:20];
        
        [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data){
                UIImage *image = [UIImage imageWithData:data];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.imageView setImage:image];
                });
            }
        }]resume];
    }
}

@end
