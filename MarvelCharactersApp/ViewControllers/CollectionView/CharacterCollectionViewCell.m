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

// When the character is set, the cell gets the characters image
-(void)setCharacter:(Character *)character{
    _character = character;
    [self getImageForCell];
}

// Gets and assigns the image for the current character, if it cant, a placeholder image will be displayed
// also updates the name label
-(void)getImageForCell{
    if (self.character){
        NSURLSession *session = [NSURLSession sharedSession];
        NSURL *url = [NSURL URLWithString: self.character.collectionViewImageUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
        
        [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data){
                UIImage *image = [UIImage imageWithData:data];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.imageView.image = image;
                    });
            }else if(error){
                UIImage *notFoundImage = [UIImage imageNamed:@"portrait_uncanny"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.imageView.image = notFoundImage;
                });
            }
        }]resume];
    }
}

@end
