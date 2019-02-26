//
//  CharactersCollectionViewController.m
//  MarvelCharactersApp
//
//  Created by Akshay Verma on 2019-02-25.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

#import "CharactersCollectionViewController.h"
#import "UrlCreator.h"
#import "Character.h"
#import "CharacterCollectionViewCell.h"

@interface CharactersCollectionViewController ()

@property (strong,nonatomic) UrlCreator *urlCreator;
@property (strong,nonatomic) NSArray *characterNames;
@property (strong,nonatomic) NSArray *urlsForThumbnails;
@property NSInteger total;

@end

@implementation CharactersCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.total = 0;
    self.urlCreator = [[UrlCreator alloc] init];
    self.characters = [NSMutableArray array];
    // Do any additional setup after loading the view.
    [self getCharacters];
    
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.characters.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CharacterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    Character *currentCharacter = self.characters[indexPath.row];
    cell.character = currentCharacter;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%li", indexPath.row);
}

- (void)getCharacters{
    if (self.urlCreator){
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLRequest *request = [NSURLRequest requestWithURL:self.urlCreator.getCharacterUrl];
        
        [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data){
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                self.characterNames = [dict valueForKeyPath:@"data.results.name"];
                self.urlsForThumbnails = [dict valueForKeyPath:@"data.results.thumbnail.path"];
                self.total = [self.characterNames count];
                
                for (int x = 0; x < [self.characterNames count]; x++){
                    [self addCharacter: self.characterNames[x] withUrl:self.urlsForThumbnails[x]];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
                
            }
        }]resume];
    }
}

- (void)addCharacter:(NSString *)name withUrl:(NSString *)url{
    // If the image exists for a character, add them to the array that will be shown in the collectionview
    // Only adds characters to the character array if they have an image
    if (![url isEqualToString: [self.urlCreator getNoImageUrl]]){
        Character *newCharacter = [Character createNewCharacterWith:name withUrl:url];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURL *url = [NSURL URLWithString: newCharacter.collectionViewImageUrl];
        [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            self.total -= 1;
            
            // If they have a correct image url and an actual image from that url then they are added
            if (data){
                UIImage *image = [UIImage imageWithData:data];
                if (image){
                    [self.characters addObject:newCharacter];
                }
            }
            
            // The collection view is only reloaded when all the characters are returned so it only reloads once
            // instead of reloading while the user is scrolling
            if(self.total <= 0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                    NSLog(@"Total: %li", self.total);
                });
            }
        }]resume];
    }else{
        self.total -= 1;
    }
    
}


@end
















