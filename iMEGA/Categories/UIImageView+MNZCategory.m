
#import "UIImageView+MNZCategory.h"

#import "Helper.h"
#import "MEGASdkManager.h"
#import "UIImage+MNZCategory.h"
#import "UIImage+GKContact.h"
#import "MEGAGetThumbnailRequestDelegate.h"

@implementation UIImageView (MNZCategory)

- (void)mnz_setImageForUserHandle:(uint64_t)userHandle {
    [self mnz_setImageForUserHandle:userHandle name:@"?"];
}

- (void)mnz_setImageForUserHandle:(uint64_t)userHandle name:(NSString *)name {
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.layer.masksToBounds = YES;
    
    MEGAGetThumbnailRequestDelegate *getThumbnailRequestDelegate = [[MEGAGetThumbnailRequestDelegate alloc] initWithCompletion:^(MEGARequest *request) {
        self.image = [UIImage imageWithContentsOfFile:request.file];
    }];
    self.image = [UIImage mnz_imageForUserHandle:userHandle name:name size:self.frame.size delegate:getThumbnailRequestDelegate];
}

- (void)mnz_setImageAvatarOrColorForUserHandle:(uint64_t)userHandle {
    
    NSString *base64Handle = [MEGASdk base64HandleForUserHandle:userHandle];
    NSString *avatarFilePath = [[Helper pathForSharedSandboxCacheDirectory:@"thumbnailsV3"] stringByAppendingPathComponent:base64Handle];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:avatarFilePath]) {
        self.image = [UIImage imageWithContentsOfFile:avatarFilePath];
    } else {
        self.image = [UIImage imageWithColor:[UIColor colorFromHexString:[MEGASdk avatarColorForBase64UserHandle:base64Handle]] andBounds:self.bounds];
        MEGAGetThumbnailRequestDelegate *getThumbnailRequestDelegate = [[MEGAGetThumbnailRequestDelegate alloc] initWithCompletion:^(MEGARequest *request) {
            self.image = [UIImage imageWithContentsOfFile:request.file];
        }];
        [[MEGASdkManager sharedMEGASdk] getAvatarUserWithEmailOrHandle:base64Handle destinationFilePath:avatarFilePath delegate:getThumbnailRequestDelegate];
    }
}

- (void)mnz_setThumbnailByNode:(MEGANode *)node {
    if (node.hasThumbnail) {
        NSString *thumbnailFilePath = [Helper pathForNode:node inSharedSandboxCacheDirectory:@"thumbnailsV3"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:thumbnailFilePath]) {
            self.image = [UIImage imageWithContentsOfFile:thumbnailFilePath];
        } else {
            MEGAGetThumbnailRequestDelegate *getThumbnailRequestDelegate = [[MEGAGetThumbnailRequestDelegate alloc] initWithCompletion:^(MEGARequest *request) {
                self.image = [UIImage imageWithContentsOfFile:request.file];
            }];
            [self mnz_imageForNode:node];
            [[MEGASdkManager sharedMEGASdk] getThumbnailNode:node destinationFilePath:thumbnailFilePath delegate:getThumbnailRequestDelegate];
        }
    } else {
        [self mnz_imageForNode:node];
    }
}

- (void)mnz_setImageForExtension:(NSString *)extension {
    extension = extension.lowercaseString;
    UIImage *image;
    if ([extension isEqualToString:@"jpg"] || [extension isEqualToString:@"jpeg"]) {
        image = [Helper defaultPhotoImage];
    } else {
        NSDictionary *fileTypesDictionary = [Helper fileTypesDictionary];
        NSString *filetypeImage = [fileTypesDictionary valueForKey:extension];
        if (filetypeImage && filetypeImage.length > 0) {
            image = [UIImage imageNamed:filetypeImage];
        } else {
            image = [Helper genericImage];
        }
    }
    
    self.image = image;
}

- (void)mnz_imageForNode:(MEGANode *)node {
    switch (node.type) {
        case MEGANodeTypeFolder: {
            if ([node.name isEqualToString:MEGACameraUploadsNodeName]) {
                self.image = [Helper folderCameraUploadsImage];
            } else {
                if (node.isInShare) {
                    self.image = [Helper incomingFolderImage];
                } else if (node.isOutShare) {
                    self.image = [Helper outgoingFolderImage];
                } else {
                    self.image = [Helper folderImage];
                }
            }
            break;
        }
            
        case MEGANodeTypeFile:
            [self mnz_setImageForExtension:node.name.pathExtension];
            break;
            
        default:
            self.image = [Helper genericImage];
    }
}

@end
