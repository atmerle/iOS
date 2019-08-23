
#import "NSFileManager+MNZCategory.h"

@implementation NSFileManager (MNZCategory)

#pragma mark - Paths

- (NSString *)downloadsDirectory {
    NSString *downloadsDirectory = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"Downloads"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:downloadsDirectory]) {
        NSError *error = nil;
        if (![[NSFileManager defaultManager] createDirectoryAtPath:downloadsDirectory withIntermediateDirectories:YES attributes:nil error:&error]) {
            MEGALogError(@"Create directory at path failed with error: %@", error);
        }
    }
    
    return downloadsDirectory;
}

- (NSString *)uploadsDirectory {
    NSString *uploadsDirectory = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"Uploads"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:uploadsDirectory]) {
        NSError *error = nil;
        if (![[NSFileManager defaultManager] createDirectoryAtPath:uploadsDirectory withIntermediateDirectories:YES attributes:nil error:&error]) {
            MEGALogError(@"Create directory at path failed with error: %@", error);
        }
    }
    
    return uploadsDirectory;
}

#pragma mark - Manage files and folders

- (unsigned long long)mnz_sizeOfFolderAtPath:(NSString *)path {
    unsigned long long folderSize = 0;
    
    NSArray *directoryContents = [NSFileManager.defaultManager contentsOfDirectoryAtPath:path error:nil];
    for (NSString *item in directoryContents) {
        NSDictionary *attributesDictionary = [NSFileManager.defaultManager attributesOfItemAtPath:[path stringByAppendingPathComponent:item] error:nil];
        if ([attributesDictionary objectForKey:NSFileType] == NSFileTypeDirectory) {
            folderSize += [self mnz_sizeOfFolderAtPath:[path stringByAppendingPathComponent:item]];
        } else {
            folderSize += [[attributesDictionary objectForKey:NSFileSize] unsignedLongLongValue];
        }
    }
    
    return folderSize;
}

- (unsigned long long)mnz_groupSharedDirectorySize {
    //We avoid calculation the space of the whole shared directory 'group.mega.ios' because there is always a plist file there and that will cause that after tapping on 'Clear cache' the footer show that some space is being used.
    NSString *groupSharedDirectoryPath = [NSFileManager.defaultManager containerURLForSecurityApplicationGroupIdentifier:@"group.mega.ios"].path;
    unsigned long long logs = [NSFileManager.defaultManager mnz_sizeOfFolderAtPath:[groupSharedDirectoryPath stringByAppendingPathComponent:@"logs"]];
    unsigned long long fileProviderStorage = [NSFileManager.defaultManager mnz_sizeOfFolderAtPath:[groupSharedDirectoryPath stringByAppendingPathComponent:@"File Provider Storage"]];
    unsigned long long shareExtensionStorage = [NSFileManager.defaultManager mnz_sizeOfFolderAtPath:[groupSharedDirectoryPath stringByAppendingPathComponent:@"Share Extension Storage"]];
    
    return (logs + fileProviderStorage + shareExtensionStorage);
}

- (void)mnz_removeItemAtPath:(NSString *)path {
    if (path == nil) {
        MEGALogError(@"The path to remove the item is nil.");
        return;
    }
    
    NSError *error = nil;
    if ([NSFileManager.defaultManager removeItemAtPath:path error:&error]) {
        MEGALogInfo(@"Remove item at path succeed:\n- At path: %@", path);
    } else {
        if ([error.domain isEqualToString:NSCocoaErrorDomain]) {
            switch (error.code) {
                case NSFileNoSuchFileError:
                    MEGALogError(@"Remove item operation attempted on non-existent file:\n- At path: %@", path);
                    break;
                    
                default:
                    MEGALogError(@"Remove item failed:\n- At path: %@\n- With error: %@", path, error);
                    break;
            }
        }
    }
}

- (void)mnz_removeFolderContentsAtPath:(NSString *)folderPath {
    NSArray *directoryContentsArray = [NSFileManager.defaultManager contentsOfDirectoryAtPath:folderPath error:nil];
    for (NSString *itemName in directoryContentsArray) {
        [NSFileManager.defaultManager mnz_removeItemAtPath:[folderPath stringByAppendingPathComponent:itemName]];
    }
}

- (void)mnz_removeFolderContentsAtPath:(NSString *)folderPath forItemsContaining:(NSString *)itemsContaining {
    NSArray *directoryContentsArray = [NSFileManager.defaultManager contentsOfDirectoryAtPath:folderPath error:nil];
    for (NSString *itemName in directoryContentsArray) {
        if ([itemName.lowercaseString containsString:itemsContaining]) {
            [NSFileManager.defaultManager mnz_removeItemAtPath:[folderPath stringByAppendingPathComponent:itemName]];
        }
    }
}

- (void)mnz_removeFolderContentsRecursivelyAtPath:(NSString *)folderPath forItemsContaining:(NSString *)itemsContaining {
    NSArray *directoryContentsArray = [NSFileManager.defaultManager contentsOfDirectoryAtPath:folderPath error:nil];
    for (NSString *itemName in directoryContentsArray) {
        NSDictionary *attributesDictionary = [NSFileManager.defaultManager attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:itemName] error:nil];
        if ([attributesDictionary objectForKey:NSFileType] == NSFileTypeDirectory) {
            [NSFileManager.defaultManager mnz_removeFolderContentsRecursivelyAtPath:[folderPath stringByAppendingPathComponent:itemName] forItemsContaining:itemsContaining];
        } else {
            if ([itemName.lowercaseString containsString:itemsContaining]) {
                [NSFileManager.defaultManager mnz_removeItemAtPath:[folderPath stringByAppendingPathComponent:itemName]];
            }
        }
    }
}

- (void)mnz_removeFolderContentsRecursivelyAtPath:(NSString *)folderPath forItemsExtension:(NSString *)itemsExtension {
    NSArray *directoryContentsArray = [NSFileManager.defaultManager contentsOfDirectoryAtPath:folderPath error:nil];
    for (NSString *itemName in directoryContentsArray) {
        NSDictionary *attributesDictionary = [NSFileManager.defaultManager attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:itemName] error:nil];
        if ([attributesDictionary objectForKey:NSFileType] == NSFileTypeDirectory) {
            [NSFileManager.defaultManager mnz_removeFolderContentsRecursivelyAtPath:[folderPath stringByAppendingPathComponent:itemName] forItemsExtension:itemsExtension];
        } else {
            if ([itemName.pathExtension.lowercaseString isEqualToString:itemsExtension]) {
                [NSFileManager.defaultManager mnz_removeItemAtPath:[folderPath stringByAppendingPathComponent:itemName]];
            }
        }
    }
}

- (void)mnz_moveItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath {
    if (srcPath == nil || dstPath == nil) {
        MEGALogError(@"Source path (%@) or destination path (%@) nil.", srcPath, dstPath);
        return;
    }
    
    NSError *error = nil;
    if ([[NSFileManager defaultManager] moveItemAtPath:srcPath toPath:dstPath error:&error]) {
        MEGALogInfo(@"Move item succeed:\n- At path: %@\n- To path: %@", srcPath, dstPath);
    } else if (error) {
        MEGALogError(@"Move item failed:\n- At path: %@\n- To path: %@\n- With error: %@", srcPath, dstPath, error);
    }
}

#pragma mark - Properties

- (unsigned long long)mnz_fileSystemFreeSize {
    NSError *error;
    NSDictionary *attributesOfHomeDirectoryDictionary = [self attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (attributesOfHomeDirectoryDictionary) {
        NSNumber *fileSystemFreeSizeInBytes = [attributesOfHomeDirectoryDictionary objectForKey:NSFileSystemFreeSize];
        return fileSystemFreeSizeInBytes.unsignedLongLongValue;
    } else {
        MEGALogError(@"Obtaining attributes of home directory failed with error: %@", error);
    }
    
    return 0;
}

@end
