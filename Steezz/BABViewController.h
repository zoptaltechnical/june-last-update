//
//  BABViewController.h
//  BABCropperView
//
//  Created by Bryn Bodayle on 04/17/2015.
//  Copyright (c) 2014 Bryn Bodayle. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark ImageCropViewController interface
@protocol ImageCropDelegate <NSObject>

- (void)ImageCropViewControllerDidDone:(UIImage *)selectedImage;

@end


@interface BABViewController : UIViewController
@property (strong, nonatomic)  UIImage *selectedImage;
@property (nonatomic, weak) id<ImageCropDelegate> delegate;

@end
