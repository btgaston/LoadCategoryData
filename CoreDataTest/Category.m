//
//  Category.m
//  CoreDataTest
//
//  Created by Jianwei Sun on 10/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Category.h"
#import "Item.h"
#import "QuestionType.h"


@implementation Category
@dynamic name;
@dynamic imagePath;
@dynamic QuestionType;
@dynamic Items;


- (void)addItemsObject:(Item *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"Items" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"Items"] addObject:value];
    [self didChangeValueForKey:@"Items" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeItemsObject:(Item *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"Items" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"Items"] removeObject:value];
    [self didChangeValueForKey:@"Items" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addItems:(NSSet *)value {    
    [self willChangeValueForKey:@"Items" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"Items"] unionSet:value];
    [self didChangeValueForKey:@"Items" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeItems:(NSSet *)value {
    [self willChangeValueForKey:@"Items" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"Items"] minusSet:value];
    [self didChangeValueForKey:@"Items" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
