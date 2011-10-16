//
//  Item.h
//  CoreDataTest
//
//  Created by Jianwei Sun on 10/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category;

@interface Item : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) Category * Category;

@end
