
#import "MEGAConstants.h"

#pragma mark - global constants

NSString * const MEGAiOSAppUserAgent = @"MEGAiOS";
NSString * const MEGAiOSAppKey = @"EVtjzb7R";
NSString * const MEGAPasswordService = @"MEGA";
NSString * const MEGAPasswordName = @"sessionV3";

NSString * const MEGAGroupIdentifier = @"group.mega.ios";

#pragma mark - global notifications

NSString * const MEGALogoutNotification = @"nz.mega.logout";
NSString * const MEGANodesCurrentNotification = @"nz.mega.nodesCurrent";
NSString * const MEGAStorageOverQuotaNotification = @"nz.mega.storageOverQuota";
NSString * const MEGAStorageEventDidChangeNotification = @"nz.mega.event.storage";
NSString * const MEGAMediaInfoReadyNotification = @"nz.mega.mediaInfoReady";

#pragma mark - global notification keys

NSString * const MEGAStorageEventStateUserInfoKey = @"nz.mega.event.storage.stateKey";

#pragma mark - camera upload notifications

NSString * const MEGACameraUploadStatsChangedNotification = @"nz.mega.cameraUpload.statsChanged";
NSString * const MEGACameraUploadPhotoUploadLocalDiskFullNotification = @"nz.mega.cameraUpload.photo.localDiskFull";
NSString * const MEGACameraUploadVideoUploadLocalDiskFullNotification = @"nz.mega.cameraUpload.video.localDiskFull";
NSString * const MEGACameraUploadPhotoConcurrentCountChangedNotification = @"nz.mega.cameraUpload.photo.concurrentCountChanged";
NSString * const MEGACameraUploadVideoConcurrentCountChangedNotification = @"nz.mega.cameraUpload.video.concurrentCountChanged";
NSString * const MEGACameraUploadUploadingTasksCountChangedNotification = @"nz.mega.cameraUpload.uploadingTaskCountChanged";
NSString * const MEGACameraUploadTaskExpiredNotification = @"nz.mega.cameraUpload.uploadTaskExpired";
NSString * const MEGACameraUploadQueueUpNextAssetNotification = @"nz.mega.cameraUpload.queueUpNextAsset";
NSString * const MEGACameraUploadAllAssetsFinishedProcessingNotification = @"nz.mega.cameraUpload.allAssetsFinishedProcessing";

#pragma mark - camera upload notification keys

NSString * const MEGAPhotoConcurrentCountUserInfoKey = @"nz.mega.photoConcurrentCountKey";
NSString * const MEGAVideoConcurrentCountUserInfoKey = @"nz.mega.videoConcurrentCountKey";
NSString * const MEGAHasUploadingTasksReachedMaximumCountUserInfoKey = @"nz.mega.uploadingTasksReachedMaximumCountKey";
NSString * const MEGACurrentUploadingTasksCountUserInfoKey = @"nz.mega.currentUploadingTasksCountKey";
NSString * const MEGAAssetMediaTypeUserInfoKey = @"nz.mega.assetMediaTypeKey";

#pragma mark - camera upload constants

NSString * const MEGACameraUploadsNodeName = @"Camera Uploads";
const NSUInteger MEGACameraUploadLowDiskStorageSizeInBytes = 100 * 1024 * 1024;

#pragma mark - file extension constants

NSString * const MEGAJPGFileExtension = @"jpg";
NSString * const MEGAMP4FileExtension = @"mp4";
NSString * const MEGAQuickTimeFileExtension = @"mov";

#pragma mark - media formats

NSString * const JPGFormat = @"JPG";
NSString * const HEICFormat = @"HEIC";
NSString * const HEVCFormat = @"HEVC";
NSString * const H264Format = @"H.264";

#pragma mark - MEGA URLS

NSString * const MEGADisputeURL = @"https://mega.nz/dispute";

#pragma mark - Group Shared Directory

NSString * const MEGAShareExtensionStorageFolder = @"Share Extension Storage";
NSString * const MEGAFileExtensionStorageFolder = @"File Provider Storage";
NSString * const MEGAExtensionLogsFolder = @"logs";
NSString * const MEGAExtensionGroupSupportFolder = @"GroupSupport";
NSString * const MEGAExtensionCacheFolder = @"Library/Cache/";

#pragma mark - MEGA Activity Types

NSString * const MEGAUIActivityTypeGetLink = @"MEGAUIActivityTypeGetLink";
NSString * const MEGAUIActivityTypeOpenIn = @"MEGAUIActivityTypeOpenIn";
NSString * const MEGAUIActivityTypeRemoveLink = @"MEGAUIActivityTypeRemoveLink";
NSString * const MEGAUIActivityTypeRemoveSharing = @"MEGAUIActivityTypeRemoveSharing";
NSString * const MEGAUIActivityTypeShareFolder = @"MEGAUIActivityTypeShareFolder";
NSString * const MEGAUIActivityTypeSaveToCameraRoll = @"MEGAUIActivityTypeSaveToCameraRoll";
NSString * const MEGAUIActivityTypeSendToChat = @"MEGAUIActivityTypeSendToChat";

#pragma mark - MEGA Affiliate program

NSString * const MEGALastPublicHandleAccessed = @"kLastPublicHandleAccessed";
NSString * const MEGALastPublicTypeAccessed = @"kLastPublicTypeAccessed";
NSString * const MEGALastPublicTimestampAccessed = @"kLastPublicTimestampAccessed";
