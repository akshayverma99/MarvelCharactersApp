//
//  PosterViewController.m
//  MarvelCharactersApp
//
//  Created by Akshay Verma on 2019-02-26.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

#import "PosterViewController.h"
#import <UIKit/UIKit.h>

@interface PosterViewController ()

@end

@implementation PosterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self updateImageView];
    [self setupGestures];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/// Updates the image view with a large version of the poster and the characters name
/// if this fails it presents a large placeHolder poster
-(void)updateImageView{
    
    NSURL *url = [NSURL URLWithString: self.character.bigPosterUrl];
    if (self.character){
        [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(data){
                UIImage *image = [UIImage imageWithData:data];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.posterImage.image = image;
                    self.nameLabel.text = self.character.name;
                });
                
                
            }else if (error){
                UIImage *notFoundImage = [UIImage imageNamed:@"portrait_uncanny"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.posterImage.image = notFoundImage;
                });
            }
        }]resume];
    }
}

/// Sets up a tap gesture and a swipe up gesture
-(void)setupGestures{
    UITapGestureRecognizer *dismiss = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToDismiss)];
    dismiss.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:dismiss];
    
    UISwipeGestureRecognizer *swipeUpToDismiss = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUpToDismiss)];
    swipeUpToDismiss.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUpToDismiss];
    
}

/// Transitions for the tap gesture
-(void)tapToDismiss{
    [UIView animateWithDuration:0.75 animations:^{
        self.view.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    
}

/// Transitions for the swipe gesture
-(void)swipeUpToDismiss{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, -1000);
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

@end












