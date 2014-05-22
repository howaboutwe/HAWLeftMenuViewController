HAWLeftMenuViewController
=========================

A pod for a very basic implementation of the "slide left to reveal" menu. It is intentionally barebones to implement the bare minimum necessary for the UI without additional complexity.

## Installation

Install with [CocoaPods](http://cocoapods.org):

	pod 'HAWLeftMenuViewController'

## Usage

### Creating an HAWTiltedImageView

1. Import:

    `#import "HAWLeftMenuViewController.h"`

2. Create the view controller

    `HAWLeftMenuViewController *slideController = [[HAWLeftMenuViewController alloc] init];`
    
3. Specify the left and main controllers, specify the width while open

   `slideController.leftViewController = myMenuController;`
   
   `slideController.mainViewController = myMainController;`
   
   `slideController.leftViewOpenSize = 150;`
   
4. Replace the main controller as necessary (will close the menu if open)

   `slideController.mainViewController = anotherController;`
    
## Examples

There is a simple example included with the project. See LeftMenuViewExample

##Contribute

Send me pull requests !!

##Authors

Jerry Wong - [@potatolicious](http://twitter.com/potatolicious)
