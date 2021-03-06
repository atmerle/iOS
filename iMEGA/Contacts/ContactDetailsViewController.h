
#import <UIKit/UIKit.h>

#import "MEGASdkManager.h"

typedef NS_ENUM (NSInteger, ContactDetailsMode) {
    ContactDetailsModeDefault = 0,
    ContactDetailsModeFromChat,
    ContactDetailsModeFromGroupChat
};

@interface ContactDetailsViewController : UIViewController

@property (nonatomic) ContactDetailsMode contactDetailsMode;

@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic) uint64_t userHandle;
@property (nonatomic) MEGAChatRoom *groupChatRoom; // Used to change contacts permissions or remove as participant in the group chat

@end
