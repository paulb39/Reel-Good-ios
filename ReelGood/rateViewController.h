//
//  rateViewController.h
//  ReelGood
//
//  Created by Paul Brenner on 1/31/15.
//  Copyright (c) 2015 reelGoodApps. All rights reserved.
//

#import <UIKit/UIKit.h>
NSString* userRating;
NSString* userComments;
NSString* currentUser;
NSString* ID_of_movie;
NSString* title_of_movie;

NSMutableArray* movieIDsInSql;


bool alreadyRatedMovie;
bool foundMovieID;
int IDcounter;


@interface rateViewController : UIViewController <UIWebViewDelegate>

@end
