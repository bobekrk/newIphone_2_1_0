//
//  FSAppStoreViewController.h
//  PeopleNewsReaderPhone
//
//  Created by Qin,Zhuoran on 12-12-18.
//
//

#import "FSBaseDataViewController.h"
#import <StoreKit/StoreKit.h>
#import "FSBaseSettingViewController.h"

@interface FSAppStoreViewController : FSBaseSettingViewController<SKStoreProductViewControllerDelegate>{
@private
//FSAppStoreContainerView * _fsAppStoreContainerView;
    
    BOOL _isprsend;
    SKStoreProductViewController *storeViewController;
} 

@property (nonatomic,assign) BOOL isprsend;

@property (nonatomic, copy) NSString *url;

@end
