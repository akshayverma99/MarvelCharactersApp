//
//  PosterViewController.h
//  MarvelCharactersApp
//
//  Created by Akshay Verma on 2019-02-26.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Character.h"

@interface PosterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *posterImage;
@property (strong,nonatomic) Character *character;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
