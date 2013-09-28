//
//  LygDeepTableViewCell.h
//  PeopleNewsReaderPhone
//
//  Created by lygn128 on 13-8-27.
//
//

#import <UIKit/UIKit.h>
#import "FSTableViewCell.h"
@interface LygDeepTableViewCell : FSTableViewCell
@property(nonatomic,retain)IBOutlet UILabel * kindsLabel;
@property(nonatomic,retain)IBOutlet UILabel * nameLabel;
@property(nonatomic,retain)IBOutlet UILabel * dateLabel;
@property(nonatomic,retain)IBOutlet UILabel * abstractLabel;
@property(nonatomic,retain)UIImageView      * timerImageView;
@end
