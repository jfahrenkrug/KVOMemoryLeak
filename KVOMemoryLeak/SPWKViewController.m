//
//  SPWKViewController.m
//  KVOMemoryLeak
//
//  Created by Fahrenkrug, Johannes on 3/3/14.
//  Copyright (c) 2014 Springenwerk. All rights reserved.
//

#import "SPWKViewController.h"

@interface SPWKThing : NSObject
@property (strong, nonatomic) NSArray *things;
@end

@implementation SPWKThing {
    BOOL _isKVORegistered;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSLog(@"initing SPWKThing");
        [self registerKVO];
    }
    return self;
}

- (void)didChangeValueForKey:(NSString *)key {
    ////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////
    // If you comment out the call to super, you will have a memory leak!
    // Better yet, never override didChangeValueForKey:
    [super didChangeValueForKey:key];
    ////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////
    if ([key isEqualToString:@"things"]) {
        NSLog(@"didChangeValueForKey: things have changed!");
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"things"]) {
        NSLog(@"observeValueForKeyPath: things have changed!");
    }
}

#pragma mark - KVO
- (void)registerKVO
{
    if (!_isKVORegistered) {
        NSLog(@"Registering KVO, and things is %@", _things);
        [self addObserver:self forKeyPath:@"things" options:0 context:NULL];
        _isKVORegistered = YES;
    }
}

- (void)unregisterKVO
{
    if (_isKVORegistered) {
        NSLog(@"Unregistering KVO");
        [self removeObserver:self forKeyPath:@"things"];
        _isKVORegistered = NO;
    }
}

- (void)dealloc
{
    NSLog(@"SPWKThing dealloc");
    [self unregisterKVO];
}

@end

@implementation SPWKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self runDemo];
}

- (void)runDemo
{
    SPWKThing *thing = [[SPWKThing alloc] init];
    thing.things = @[@"one", @"two", @"three"];
    thing = nil;
}

@end
