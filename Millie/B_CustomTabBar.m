//
//  B_CustomTabBar.m
//  Millie
//
//  Created by Emmanuel Masangcay on 6/16/15.
//  Copyright (c) 2015 CoderEXP. All rights reserved.
//

#import "B_CustomTabBar.h"
#import "UIColor+HEX.h"

@implementation B_CustomTabBar

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //Set Background Color
        self.backgroundColor = [UIColor colorwithHexString:@"D4ECDC" alpha:1];

        //Add btnCreateNewDeal
        btnCreateNewDeal = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnCreateNewDeal setImage:[UIImage imageNamed:@"deal"] forState:UIControlStateNormal];
        [btnCreateNewDeal setTintColor:[UIColor colorwithHexString:@"334d5c" alpha:1]];

        //set the frame

        float tabButtonHeight = 30;
        float tabButtonWidth = 30;

        float xPos1 = self.frame.origin.x +40;
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

        //Add btnSearch
        btnSearch = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnSearch setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
        [btnSearch setTintColor:[UIColor colorwithHexString:@"334d5c" alpha:1]];

        //set the frame

        float xPos2 = btnCreateNewDeal.frame.origin.x + btnCreateNewDeal.frame.size.width + 50;

        CGRect btnSearchFrame = CGRectMake(xPos2, yPos, tabButtonWidth, tabButtonHeight);

        btnSearch.frame = btnSearchFrame;

        btnSearch.translatesAutoresizingMaskIntoConstraints = NO;
        btnSearch.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        btnSearch.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;

        [btnSearch addTarget:self
                            action:@selector(clickSearch)
                  forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:btnSearch];

        //Add btnNews
        btnNews = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnNews setImage:[UIImage imageNamed:@"news"] forState:UIControlStateNormal];
        [btnNews setTintColor:[UIColor colorwithHexString:@"334d5c" alpha:1]];

        //set the frame

        float xPos3 = btnSearch.frame.origin.x + btnSearch.frame.size.width + 30;

        CGRect btnNewsFrame = CGRectMake(xPos3, yPos, tabButtonWidth, tabButtonHeight);

        btnNews.frame = btnNewsFrame;

        btnNews.translatesAutoresizingMaskIntoConstraints = NO;
        btnNews.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        btnNews.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;

        [btnNews addTarget:self
                     action:@selector(clickNews)
           forControlEvents:UIControlEventTouchUpInside];

        btnNews.alpha = 0;

        [self addSubview:btnNews];


        //Add btnActivity
        btnActivity = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnActivity setImage:[UIImage imageNamed:@"activity"] forState:UIControlStateNormal];
        [btnActivity setTintColor:[UIColor colorwithHexString:@"334d5c" alpha:1]];

        //set the frame

        float xPos4 = btnNews.frame.origin.x + btnNews.frame.size.width + 10;

        CGRect btnActivityFrame = CGRectMake(xPos4, yPos, tabButtonWidth, tabButtonHeight);

        btnActivity.frame = btnActivityFrame;

        btnActivity.translatesAutoresizingMaskIntoConstraints = NO;
        btnActivity.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        btnActivity.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;

        [btnActivity addTarget:self
                    action:@selector(clickActivity)
          forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btnActivity];

        //Add btnProfile
        btnProfile = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnProfile setImage:[UIImage imageNamed:@"profile"] forState:UIControlStateNormal];
        [btnProfile setTintColor:[UIColor colorwithHexString:@"334d5c" alpha:1]];

        //set the frame

        float xPos5 = self.frame.size.width - 70;

        CGRect btnProfileFrame = CGRectMake(xPos5, yPos, tabButtonWidth, tabButtonHeight);

        btnProfile.frame = btnProfileFrame;

        btnProfile.translatesAutoresizingMaskIntoConstraints = NO;
        btnProfile.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        btnProfile.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        
        [btnProfile addTarget:self
                        action:@selector(clickProfile)
              forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btnProfile];
        
    }
    
    return self;
}


-(void)clickCreateNewDeal
{
    NSLog(@"CreateNewDeal");
    [self.delegate onClickCreateNewDeal];
}

-(void)clickSearch
{
    NSLog(@"Search");
    [self.delegate onClickSearch];
}

-(void)clickNews
{
    NSLog(@"News");
    [self.delegate onClickNews];
}

-(void)clickActivity
{
    NSLog(@"Activity");
    [self.delegate onClickActivity];
}

-(void)clickProfile
{
    NSLog(@"Profile");
    [self.delegate onClickProfile];
}

@end
