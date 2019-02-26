//
//  CharactersCollectionViewController.m
//  MarvelCharactersApp
//
//  Created by Akshay Verma on 2019-02-25.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

#import "CharactersCollectionViewController.h"
#import "DataHandler.h"
#import "UrlCreator.h"
#import "Character.h"
#import "CharacterCollectionViewCell.h"

@interface CharactersCollectionViewController ()

@property (strong,nonatomic) DataHandler *dataStore;
@property (strong,nonatomic) UrlCreator *urlCreator;
@property (strong,nonatomic) NSArray *characterNames;
@property (strong,nonatomic) NSArray *urlsForThumbnails;
@property (strong,nonatomic) NSMutableArray *characters;

@end

@implementation CharactersCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataStore = [[DataHandler alloc] init];
    self.urlCreator = [[UrlCreator alloc] init];
    
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
    if (self.dataStore){
        return self.dataStore.getArrayOfCharacters.count;
    }else{
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CharacterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    Character *currentCharacter = self.characters[indexPath.row];
    cell.character = currentCharacter;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
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
                
                for (int x = 0; x < [self.characterNames count]; x++){
                    [self addCharacter:self.characterNames[x] withUrl:self.urlsForThumbnails[x]];
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
    if (![url isEqualToString: [self.urlCreator getNoImageUrl]]){
        Character *newCharacter = [Character createNewCharacterWith:name withUrl:url];
        [self.characters addObject:newCharacter];
    }
}




@end
















