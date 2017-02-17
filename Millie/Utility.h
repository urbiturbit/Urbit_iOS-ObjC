//
//  Utility.h
//  Millie
//
//  Created by Emmanuel Masangcay on 6/10/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utility : NSObject

// PICTURE RESIZING
+ (UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize;
+ (void)setRoundedView:(UIView*)roundedView toDiameter:(float)newsize;

+(UIImage *) scaleImage:(UIImage*)image toSize:(CGSize)newSize;


//ANIMATOR

+ (void)animateView_downHide_showLeft_fade:(UIView*)showView hideView:(UIView*)hideView withViewAlphaAnimate:(UIView*)alphaAnimateView completion:(void (^)(BOOL result))completionHandler;

+ (void)animateView_upShow_hideRight:(UIView*)showView hideView:(UIView*)hideView withViewAlphaAnimate:(UIView*)alphaAnimateView completion:(void (^)(BOOL result))completionHandler;

+ (void)animateView_scaleshow_scaleHide:(UIView*)showView hideView:(UIView*)hideView accessoryView:(UIView*)accessoryView completion:(void (^)(BOOL result))completionHandler;

+ (void)animateViewFadeOut:(UIView*)fadeOutView completion:(void (^)(BOOL result))completionHandler;

//LOCATION

+(NSDictionary*)parseAddress:(NSString*)addr;
+(NSMutableArray*)getLatLongfromAddress : (NSString *)addressText;

@end
