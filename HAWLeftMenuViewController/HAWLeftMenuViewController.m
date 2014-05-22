//
//  HAWLeftMenuViewController.m
//  HowAboutWeCouples
//
//  Created by Jerry Wong on 5/21/14.
//  Copyright (c) 2014 HowAboutWe. All rights reserved.
//

#import "HAWLeftMenuViewController.h"

@interface HAWLeftMenuViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, assign) CGPoint panStartPosition;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, strong) UIView *centerView;
@end

@implementation HAWLeftMenuViewController

- (id)initWithMainViewController:(UIViewController *)mainController leftViewController:(UIViewController *)leftController
{
    self = [super init];
    if (self) {
        self.mainViewController = mainController;
        self.leftViewController = leftController;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.openResistance == 0.0)
        self.openResistance = 40.0;
    
    self.centerView = ({
        UIView *view = [[UIView alloc] init];
        view.autoresizesSubviews = YES;
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        view.clipsToBounds = YES;
        view.frame = self.view.bounds;
        [self.view addSubview:view];
        view;
    });
    
    self.panRecognizer = ({
        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
        [self.centerView addGestureRecognizer:recognizer];
        recognizer.delegate = self;
        recognizer;
    });
    
    self.tapRecognizer = ({
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapCenterView:)];
        [self.centerView addGestureRecognizer:recognizer];
        recognizer.delegate = self;
        recognizer;
    });
    
    [self openStateChanged:NO];
}

#pragma mark - Accessors

- (void)setBlockOpenClose:(BOOL)blockOpenClose
{
    _blockOpenClose = blockOpenClose;
    self.panRecognizer.enabled = !blockOpenClose;
}

- (void)setLeftViewController:(UIViewController *)leftViewController
{
    if (_leftViewController) {
        [_leftViewController removeFromParentViewController];
        [_leftViewController.view removeFromSuperview];
    }
    _leftViewController = leftViewController;
    [leftViewController willMoveToParentViewController:self];
    [self addChildViewController:leftViewController];
    [self.view insertSubview:leftViewController.view belowSubview:self.centerView];
    leftViewController.view.frame = CGRectMake(0, 0, self.leftViewOpenSize, self.view.bounds.size.height);
    [leftViewController didMoveToParentViewController:self];
}

- (void)setMainViewController:(UIViewController *)mainViewController
{
    BOOL isOpen = NO;
    if (_mainViewController) {
        isOpen = [self isLeftViewOpen];
        [_mainViewController removeFromParentViewController];
        [_mainViewController.view removeFromSuperview];
    }
    _mainViewController = mainViewController;
    [mainViewController willMoveToParentViewController:self];
    [self addChildViewController:mainViewController];
    [self.centerView addSubview:mainViewController.view];
    mainViewController.view.frame = self.view.bounds;
    [mainViewController didMoveToParentViewController:self];
    if (isOpen)
        [self setLeftViewOpen:YES animated:NO completion:nil];
}

#pragma mark - Actions

- (BOOL)isLeftViewOpen
{
    return CGRectGetMinX(self.centerView.frame) > 0.0;
}

- (void)toggleLeftViewAnimated:(BOOL)animated completion:(dispatch_block_t)completion
{
    if ([self isLeftViewOpen])
        [self setLeftViewOpen:NO animated:animated completion:completion];
    else
        [self setLeftViewOpen:YES animated:animated completion:completion];
}

- (void)setLeftViewOpen:(BOOL)open animated:(BOOL)animated completion:(dispatch_block_t)completion
{
    if (self.blockOpenClose) {
        if (completion)
            completion();
        return;
    }
    
    CGRect r = self.view.bounds;
    r.origin.x = open ? [self leftViewOpenSize] : 0.0;
    UIView *mainView = self.centerView;
    
    if (open)
        [self.leftViewController viewWillAppear:animated];
    else
        [self.leftViewController viewWillDisappear:animated];
    
    __weak HAWLeftMenuViewController *safeSelf = self;
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            mainView.frame = r;
        } completion:^(BOOL finished) {
            if (open)
                [safeSelf.leftViewController viewDidAppear:animated];
            else
                [safeSelf.leftViewController viewDidDisappear:animated];
            [self openStateChanged:open];
            if (completion)
                completion();
        }];
    } else {
        mainView.frame = r;
        if (open)
            [self.leftViewController viewDidAppear:animated];
        else
            [self.leftViewController viewDidDisappear:animated];
        [self openStateChanged:open];
        if (completion)
            completion();
    }
}

#pragma mark - Input Handling

- (void)didPan:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.panStartPosition = self.centerView.frame.origin;
    } else {
        CGFloat targetWidth = [self leftViewOpenSize];
        CGPoint p = [recognizer translationInView:self.view];
        CGPoint resultP = CGPointMake(self.panStartPosition.x + p.x, self.panStartPosition.y);
        if (self.panStartPosition.x == 0.0)
            resultP.x -= self.openResistance;
        resultP.x = MIN(targetWidth, resultP.x);
        resultP.x = MAX(0, resultP.x);
        self.centerView.frame = CGRectMake(resultP.x, resultP.y, self.centerView.bounds.size.width, self.centerView.bounds.size.height);
        if (recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateEnded) {
            CGFloat finalX = CGRectGetMinX(self.centerView.frame);
            if (finalX > 0.0 && finalX < targetWidth) {
                BOOL isOpen = NO;
                if (self.panStartPosition.x == 0.0)
                    isOpen = (finalX > targetWidth * 0.1);
                else
                    isOpen = !(finalX < targetWidth * 0.9);
                [self setLeftViewOpen:isOpen animated:YES completion:nil];
            } else {
                [self openStateChanged:[self isLeftViewOpen]];
            }
            self.panStartPosition = CGPointZero;
        }
    }
}

- (void)didTapCenterView:(UITapGestureRecognizer *)recognizer
{
    [self setLeftViewOpen:NO animated:YES completion:nil];
}

#pragma mark - Events

- (void)openStateChanged:(BOOL)isOpen
{
    self.tapRecognizer.enabled = isOpen;
    self.mainViewController.view.userInteractionEnabled = !isOpen;
}

#pragma mark - <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer == self.panRecognizer) {
        if ([self.panningGestureDelegate respondsToSelector:@selector(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)])
            return [self.panningGestureDelegate gestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
        return NO;
    } else {
        return NO;
    }
}

@end
