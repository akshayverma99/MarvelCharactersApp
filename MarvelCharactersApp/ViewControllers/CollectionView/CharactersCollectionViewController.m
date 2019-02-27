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
#import "PosterViewController.h"

@interface CharactersCollectionViewController ()

@property (strong,nonatomic) UrlCreator *urlCreator;
@property (strong,nonatomic) NSArray *characterNames;
@property (strong,nonatomic) NSArray *urlsForThumbnails;
@property NSInteger total;

// Holds the characters indexpath when pressed so it can be used outside of the function scope
@property NSInteger indexPath;

@end

@implementation CharactersCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];

    self.total = 0;
    self.urlCreator = [[UrlCreator alloc] init];
    
    // Need to assign to empty array because you cant append to nil
    self.characters = [NSMutableArray array];
    // Do any additional setup after loading the view.
    [self getCharacters];
    
}



#pragma mark - Navigation

// Passes the posterView the selected character
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"posterView"]){
        PosterViewController *newVC = [segue destinationViewController];
        newVC.character = self.characters[self.indexPath];
    }
    
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
    self.indexPath = indexPath.row;
    [self performSegueWithIdentifier:@"posterView" sender:nil];
}

#pragma mark - Networking

// Gets a list of the first 100 characters of the marvel api
// then gets rid of all the characters that don't have images
// reloads the collection view when its done
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
                
                
            }else if (error){
                [self presentNetworkErrorModalWithDescription:error.localizedDescription];
            }
        }]resume];
    }
}


// Adds a character to the array of characters
// Note: Characters are not added if they have no images assigned to their urls
- (void)addCharacter:(NSString *)name withUrl:(NSString *)url{
    // If the image exists for a character, add them to the array that will be shown in the collectionview
    // Only adds characters to the character array if they have an image
    if (![url isEqualToString: [self.urlCreator getNoImageUrl]]){
        Character *newCharacter = [Character createNewCharacterWith:name withUrl:url];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURL *url = [NSURL URLWithString: newCharacter.collectionViewImageUrl];
        [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            self.total -= 1;
            
            // If they have a correct image url and an actual image from that url, then they are added
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
                });
            }
        }]resume];
    }else{
        self.total -= 1;
    }
    
}

// Presents a model if there is a network error and provides a decription
-(void)presentNetworkErrorModalWithDescription:(NSString *)description{
    
    UIAlertController *alertModal = [UIAlertController alertControllerWithTitle:@"Network Error" message:description preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *retryButton = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getCharacters];
    }];
    
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler: nil];
    
    [alertModal addAction:cancelButton];
    [alertModal addAction:retryButton];
    
    [self presentViewController:alertModal animated:NO completion:nil];
}


@end
















