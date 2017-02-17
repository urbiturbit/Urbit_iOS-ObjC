//
//  M_CustomTabBar.m
//  Millie
//
//  Created by Emmanuel Masangcay on 6/16/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "M_CustomTabBar.h"
#import "UIColor+HEX.h"

@implementation M_CustomTabBar

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //Set Background Color
        self.backgroundColor = [UIColor colorwithHexString:@"D4ECDC" alpha:1];

        //Add btnCreateNewDeal
        btnCreateNewDeal = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnCreateNewDeal setImage:[UIImage imageNamed:@"newdeal"] forState:UIControlStateNormal];
        [btnCreateNewDeal setTintColor:[UIColor colorwithHexString:@"334d5c" alpha:1]];

        //set the frame

        float tabButtonHeight = 30;
        float tabButtonWidth = 30;

        float xPos1 = self.frame.origin.x +20;
        float yPos = self.frame.size.height /2 - tabButtonHeight/2;

        CGRect btnCreateNewDealFrame = CGRectMake(xPos1, yPos, tabButtonWidth, tabButtonHeight);

        btnCreateNewDeal.frame = btnCreateNewDealFrame;

        btnCreateNewDeal.translatesAutoresizingMaskIntoConstraints = NO;
        btnCreateNewDeal.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        btnCreateNewDeal.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;

        [btnCreateNewDeal addTarget:self
                        action:@selector(clickCreateNewDeal)
              forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:btnCreateNewDeal];

        //Add btnMerchantData
        btnMerchantData = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnMerchantData setImage:[UIImage imageNamed:@"data"] forState:UIControlStateNormal];
        [btnMerchantData setTintColor:[UIColor colorwithHexString:@"334d5c" alpha:1]];

        //set the frame

        float xPos2 = btnCreateNewDeal.frame.origin.x + btnCreateNewDeal.frame.size.width + 30;

        CGRect btnMerchantDataFrame = CGRectMake(xPos2, yPos, tabButtonWidth, tabButtonHeight);

        btnMerchantData.frame = btnMerchantDataFrame;

        btnMerchantData.translatesAutoresizingMaskIntoConstraints = NO;
        btnMerchantData.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        btnMerchantData.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;

        [btnMerchantData addTarget:self
                             action:@selector(clickMerchantData)
                   forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:btnMerchantData];

        //Add btnDeals
        btnDeals = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnDeals setImage:[UIImage imageNamed:@"deal"] forState:UIControlStateNormal];
        [btnDeals setTintColor:[UIColor colorwithHexString:@"334d5c" alpha:1]];

        //set the frame

        float xPos3 = btnMerchantData.frame.origin.x + btnMerchantData.frame.size.width + 30;

        CGRect btnDealsFrame = CGRectMake(xPos3, yPos, tabButtonWidth, tabButtonHeight);

        btnDeals.frame = btnDealsFrame;

        btnDeals.translatesAutoresizingMaskIntoConstraints = NO;
        btnDeals.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        btnDeals.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;

        [btnDeals addTarget:self
                            action:@selector(clickDeals)
                  forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:btnDeals];

        //Add btnMerchant
        btnMerchant = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnMerchant setImage:[UIImage imageNamed:@"merchant"] forState:UIControlStateNormal];
        [btnMerchant setTintColor:[UIColor colorwithHexString:@"334d5c" alpha:1]];

        //set the frame

        float xPos4 = self.frame.size.width - 50;

        CGRect btnMerchantFrame = CGRectMake(xPos4, yPos, tabButtonWidth, tabButtonHeight);

        btnMerchant.frame = btnMerchantFrame;

        btnMerchant.translatesAutoresizingMaskIntoConstraints = NO;
        btnMerchant.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        btnMerchant.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;

        [btnMerchant addTarget:self
                     action:@selector(clickMerchant)
           forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:btnMerchant];


    }

    return self;
}


-(void)clickCreateNewDeal
{
    NSLog(@"onClickCreateNewDeal");
    [self.delegate onClickCreateNewDeal];
}

-(void)clickMerchantData
{
    NSLog(@"onClickMerchantData");
    [self.delegate onClickMerchantData];
}

-(void)clickDeals
{
    NSLog(@"onClickDeals");
    [self.delegate onClickDeals];
}

-(void)clickMerchant
{
    NSLog(@"onClickMerchant");
    [self.delegate onClickMerchant];
}

@end
