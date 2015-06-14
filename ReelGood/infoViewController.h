//
//  infoViewController.h
//  ReelGood
//
//  Created by Paul Brenner on 1/10/15.
//  Copyright (c) 2015 reelGoodApps. All rights reserved.
//

#import <UIKit/UIKit.h>

NSString *title_of_movie;
NSString *releasedate_of_movie;
NSString *overview_of_movie;
NSString *ID_of_movie;
NSString *currentUser;
NSString *userRating;
NSString *userComments;

NSString *poster_of_movie;

NSMutableArray* movieIDsInSql;
NSMutableArray* friendInfoMovieTitle;
NSMutableArray* friendInfoMovieRating;
NSMutableArray* friendInfoFriend;
NSMutableArray* friendInfoComments;
NSMutableArray* friendInfoMovieID;

int IDcounter;
int friendMovieDataCounter;
bool foundMovieID;
bool pushRatingCalled;
bool alreadyRatedMovie;

@interface infoViewController : UIViewController <UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate>

@end
