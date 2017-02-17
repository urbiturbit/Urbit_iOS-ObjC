//
//  Utility.m
//  Millie
//
//  Created by Emmanuel Masangcay on 6/10/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "Utility.h"

@implementation Utility


#pragma mark - image

+(void)setRoundedView:(UIView*)roundedView toDiameter:(float)newsize
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newsize, newsize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newsize / 2.0;
    roundedView.center = saveCenter;

}


+ (UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize {

    CGAffineTransform scaleTransform;
    CGPoint origin;

    if (image.size.width > image.size.height) {
        CGFloat scaleRatio = newSize / image.size.height;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);

        origin = CGPointMake(-(image.size.width - image.size.height) / 2.0f, 0);
    } else {
        CGFloat scaleRatio = newSize / image.size.width;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);

        origin = CGPointMake(0, -(image.size.height - image.size.width) / 2.0f);
    }

    CGSize size = CGSizeMake(newSize, newSize);
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    } else {
        UIGraphicsBeginImageContext(size);
    }

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, scaleTransform);

    [image drawAtPoint:origin];

    image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    return image;
}

+(UIImage *) scaleImage:(UIImage*)image toSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark - Animator

+(void)animateView_downHide_showLeft_fade:(UIView *)showView hideView:(UIView *)hideView withViewAlphaAnimate:(UIView *)alphaAnimateView completion:(void (^)(BOOL))completionHandler
{
    [UIView animateWithDuration:0.4 animations:^{
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
        } completion:^(BOOL finished) {
            showView.transform = CGAffineTransformMakeTranslation(800, 0);
            hideView.transform = CGAffineTransformMakeTranslation(0, 100);

            [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{

                showView.transform = CGAffineTransformMakeTranslation(600, 0);
                showView.alpha = .15;
                hideView.transform = CGAffineTransformMakeTranslation(0, 210);
                hideView.alpha = .65f;

            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{

                    showView.transform = CGAffineTransformMakeTranslation(300, 0);
                    showView.alpha = .25;
                    hideView.alpha = .5f;
                    hideView.transform = CGAffineTransformMakeTranslation(0, 300);

                } completion:^(BOOL finished) {
                    [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{

                        showView.transform = CGAffineTransformMakeTranslation(210, 0);
                        showView.alpha = .35;
                        hideView.transform = CGAffineTransformMakeTranslation(0, 500);
                        hideView.alpha = .25f;

                    } completion:^(BOOL finished) {
                        [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{

                            showView.transform = CGAffineTransformMakeTranslation(0, 0);
                            showView.alpha = 1;
                            hideView.transform = CGAffineTransformMakeTranslation(0, 800);
                            hideView.alpha = 0;

                        } completion:^(BOOL finished) {
                            [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
                                alphaAnimateView.alpha = 1;
                            } completion:^(BOOL finished) {
                                completionHandler(YES);
                            }];}];}];}];}];}];}];
}

+(void)animateView_upShow_hideRight:(UIView *)showView hideView:(UIView *)hideView withViewAlphaAnimate:(UIView *)alphaAnimateView completion:(void (^)(BOOL))completionHandler
{
        [UIView animateWithDuration:0.4 animations:^{
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.4 animations:^{
            } completion:^(BOOL finished) {
                hideView.transform = CGAffineTransformMakeTranslation(0, 0);
                showView.transform = CGAffineTransformMakeTranslation(0, 800);
    
                [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
    
                    hideView.transform = CGAffineTransformMakeTranslation(210, 0);
                    hideView.alpha = .15;
                    showView.transform = CGAffineTransformMakeTranslation(0, 500);
                    showView.alpha = .65f;
    
                } completion:^(BOOL finished) {
                    [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
    
                        hideView.transform = CGAffineTransformMakeTranslation(300, 0);
                        hideView.alpha = .25;
                        showView.alpha = .5f;
                        showView.transform = CGAffineTransformMakeTranslation(0, 300);
    
                    } completion:^(BOOL finished) {
                        [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
    
                            hideView.transform = CGAffineTransformMakeTranslation(600, 0);
                            hideView.alpha = .35;
                            showView.transform = CGAffineTransformMakeTranslation(0, 210);
                            showView.alpha = .25f;
    
                        } completion:^(BOOL finished) {
                            [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
    
                                hideView.transform = CGAffineTransformMakeTranslation(800, 0);
                                hideView.alpha = 0;
                                showView.transform = CGAffineTransformMakeTranslation(0, 0);
                                showView.alpha = 1;

                            } completion:^(BOOL finished) {
                                [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
                                    alphaAnimateView.alpha = 0;
                                } completion:^(BOOL finished) {
    
                                }];}];}];}];}];}];}];
}



+(void)animateView_scaleshow_scaleHide:(UIView *)showView hideView:(UIView *)hideView accessoryView:(UIView *)accessoryView completion:(void (^)(BOOL))completionHandler
{
    [UIView animateWithDuration:0.1 animations:^{
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
        } completion:^(BOOL finished) {

            hideView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);

            [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{

            hideView.transform = CGAffineTransformScale(CGAffineTransformIdentity, .75, .75);

            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{

                hideView.transform = CGAffineTransformScale(CGAffineTransformIdentity, .5, .5);

                } completion:^(BOOL finished) {
                    [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{

                    hideView.transform = CGAffineTransformScale(CGAffineTransformIdentity, .25, .25);

                    } completion:^(BOOL finished) {
                        [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{

                            hideView.transform = CGAffineTransformScale(CGAffineTransformIdentity, .05, .05);

                        } completion:^(BOOL finished) {
                            [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{

                                hideView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0, 0);

                            } completion:^(BOOL finished) {
                                [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
                                    showView.alpha = 1;
                                    accessoryView.alpha = 1;
                                    showView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0, 0);
                                    accessoryView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0, 0);

                                } completion:^(BOOL finished) {
                                    [UIView animateKeyframesWithDuration:0.8/4 delay:0 options:0 animations:^{
                                        accessoryView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                                        showView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);

                                    } completion:^(BOOL finished) {
                                        completionHandler(YES);
                                    }];}];}];}];}];}];}];}];}];
}

+(void)animateViewFadeOut:(UIView *)fadeOutView completion:(void (^)(BOOL))completionHandler
{
    [UIView animateWithDuration:0.4f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
        fadeOutView.alpha = 0;
    } completion:^(BOOL finished) {
        completionHandler(YES);
    }];
}

#pragma mark - Location

+(NSDictionary*)parseAddress:(NSString*)addr
{
    NSError * err;
    NSDataDetector * addrParser = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeAddress
                                                                  error:&err];
    __block NSDictionary * addressParts;
    if( addrParser ){
        [addrParser enumerateMatchesInString:addr
                                     options:0
                                       range:(NSRange){0, [addr length]}
                                  usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                      addressParts = [result addressComponents];
                                  }];
    }

    NSLog(@"%@", addressParts);
    return addressParts;
}


+(NSMutableArray*)getLatLongfromAddress : (NSString *)addressText {

    NSString *stringAdress = [addressText stringByReplacingOccurrencesOfString:@" " withString:@"+"];

    NSString *esc_addr =  [stringAdress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];

    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];

    NSMutableDictionary *data = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding]options:NSJSONReadingMutableContainers error:nil];

    NSMutableArray *dataArray = (NSMutableArray *)[data valueForKey:@"results" ];

    if (dataArray.count == 0) {

        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Enter a valid address" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];

    }else{

        for (id firstTime in dataArray) {
            NSString *jsonStr1 = [firstTime valueForKey:@"geometry"];
            NSMutableArray *Location = [jsonStr1 valueForKey:@"location"];
            //            NSString *latitude = [Location  valueForKey:@"lat"];
            return Location;
            
        }
    }
    return nil;
    
}


@end
