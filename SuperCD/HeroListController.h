//
//  HeroListController.h
//  SuperCD
//
//  Created by Corezina on 2/5/16.
//  Copyright © 2016 Corezina. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSelectedTabDefaultKey @"Selected Tab" //key for store/retrieve from user defaults
enum{
    kByName,
    kBySecretIdentity,
};

@interface HeroListController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addBtn;
@property (weak, nonatomic) IBOutlet UITableView *heroTableView;
@property (weak, nonatomic) IBOutlet UITabBar *heroTabBar;
- (IBAction)addHero:(id)sender;
@end
