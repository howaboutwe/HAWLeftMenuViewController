//
//  HAWLeftMenuViewController.h
//  HowAboutWeCouples
//
//  Created by Jerry Wong on 5/21/14.
//  Copyright (c) 2014 HowAboutWe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HAWLeftMenuViewController : UIViewController
@property (nonatomic, assign) BOOL blockOpenClose;
@property (nonatomic, assign) BOOL allowPanning;
@property (nonatomic, assign) BOOL useShadow;
@property (nonatomic, assign) CGFloat leftViewOpenSize;
@property (nonatomic, assign) CGFloat openResistance;
@property (nonatomic, strong) IBOutlet UIViewController *leftViewController;
@property (nonatomic, strong) IBOutlet UIViewController *mainViewController;
@property (nonatomic, weak) id<UIGestureRecognizerDelegate> panningGestureDelegate;
- (id)initWithMainViewController:(UIViewController *)mainController leftViewController:(UIViewController *)leftController;
- (void)toggleLeftViewAnimated:(BOOL)animated completion:(dispatch_block_t)completion;
- (BOOL)isLeftViewOpen;
- (void)setLeftViewOpen:(BOOL)open animated:(BOOL)animated completion:(dispatch_block_t)completion;
@end
