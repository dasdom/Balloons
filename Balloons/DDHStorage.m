//  Created by Dominik Hauser on 12.11.24.
//  
//


#import "DDHStorage.h"
#import "NSFileManager+Extension.h"
#import <sqlite3.h>
#import "DDHBirthday.h"

@implementation DDHStorage

- (NSString *)databasePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *databaseURL = [fileManager databaseURL];
    return [databaseURL path];
}

- (void)createDatabaseIfNeeded {
    NSString *databasePath = [self databasePath];
    BOOL databaseFileExists = [[NSFileManager defaultManager] fileExistsAtPath:databasePath];
    if (NO == databaseFileExists) {
        const char *utf8Path = [databasePath UTF8String];

        sqlite3 *database;
        if (sqlite3_open(utf8Path, &database) == SQLITE_OK) {
            char *errorMessage;
            const char *sql_statement = "CREATE TABLE IF NOT EXISTS birthdays (id INTEGER PRIMARY KEY AUTOINCREMENT, uuid TEXT NOT NULL UNIQUE, givenName TEXT, nickname TEXT, familyName TEXT, date INT, yearUnknown INT)";

            if (sqlite3_exec(database, sql_statement, NULL, NULL, &errorMessage) != SQLITE_OK) {
                NSLog(@"Failed to create table: %s", sqlite3_errmsg(database));
            }

            sqlite3_close(database);
        }
    }
}

- (BOOL)insertBirthdays:(NSArray<DDHBirthday *> *)birthdays {
    for (DDHBirthday *birthday in birthdays) {
        BOOL success = [self insertBirthday:birthday];
        if (NO == success) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)insertBirthday:(DDHBirthday *)birthday {
    BOOL success = NO;
    const char *databasePath = [[self databasePath] UTF8String];
    sqlite3 *database;
    if (sqlite3_open(databasePath, &database) == SQLITE_OK) {
        const char *insert_statement = "INSERT OR IGNORE INTO birthdays (uuid, givenName, nickname, familyName, date, yearUnknown) VALUES (?,?,?,?,?,?)";
        sqlite3_stmt *statement;

        if (sqlite3_prepare_v2(database, insert_statement, -1, &statement, NULL) == SQLITE_OK) {
            NSPersonNameComponents *nameComponents = birthday.personNameComponents;
            sqlite3_bind_text(statement, 1, [[birthday.uuid UUIDString] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [nameComponents.givenName UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [nameComponents.nickname UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 4, [nameComponents.familyName UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(statement, 5, (int)[birthday.date timeIntervalSince1970]);
            sqlite3_bind_int(statement, 6, (int)(birthday.yearUnknown ? 1 : 0));

            if (sqlite3_step(statement) == SQLITE_DONE) {
                success = YES;
            } else {
                NSLog(@"Failed to add birthday: %s", sqlite3_errmsg(database));
            }

            sqlite3_finalize(statement);
        } else {
            NSLog(@"Failed to prepare database: %s", sqlite3_errmsg(database));
        }

        sqlite3_close(database);
    } else {
        NSLog(@"Failed to open database: %s", sqlite3_errmsg(database));
    }
    return success;
}

- (NSArray<DDHBirthday *> *)birthdays {
    const char *databasePath = [[self databasePath] UTF8String];
    sqlite3 *database;
    NSMutableArray<DDHBirthday *> *birthdays = [[NSMutableArray alloc] init];

    if (sqlite3_open(databasePath, &database) == SQLITE_OK) {
        const char *fetch_statement = "SELECT * FROM birthdays";
        sqlite3_stmt *statement;

        if (sqlite3_prepare_v2(database, fetch_statement, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *uuidString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];

                char *rawGivenName = (char *)sqlite3_column_text(statement, 2);
                NSString *givenName = (rawGivenName != NULL) ? [NSString stringWithUTF8String:rawGivenName] : @"";

                char *rawNickname = (char *)sqlite3_column_text(statement, 3);
                NSString *nickname = (rawNickname != NULL) ? [NSString stringWithUTF8String:rawNickname] : @"";

                char *rawFamilyName = (char *)sqlite3_column_text(statement, 4);
                NSString *familyName = (rawFamilyName != NULL) ? [NSString stringWithUTF8String:rawFamilyName] : @"";
                
                int timeInterval = sqlite3_column_int(statement, 5);
                int yearUnknown = sqlite3_column_int(statement, 6);

                NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:uuidString];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
                NSPersonNameComponents *nameComponents = [[NSPersonNameComponents alloc] init];
                nameComponents.givenName = givenName;
                nameComponents.nickname = nickname;
                nameComponents.familyName = familyName;
                DDHBirthday *birthday = [[DDHBirthday alloc] initWithUUID:uuid date:date personNameComponents:nameComponents yearUnknown:yearUnknown];

                [birthdays addObject:birthday];
            }
        }
    }
    return birthdays;
}

@end
