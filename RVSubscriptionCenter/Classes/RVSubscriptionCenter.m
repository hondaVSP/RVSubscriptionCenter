//
//  RVSubscriptionCenter.m
//  RVSubscriptionCenter
//
//  Created by Zac on 2021/8/17.
//

#import "RVSubscriptionCenter.h"

static RVSubscriptionCenter *_shareCenter = nil;

@interface RVSubscriptionCenter()

@property (nonatomic, strong) NSMutableArray *registerArray;

@property (nonatomic, strong) NSMutableArray *subscriptionArray;

@property (nonatomic, strong) NSMutableDictionary *subscriptionDictionary;

@end

@implementation RVSubscriptionCenter


#pragma mark - Public
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareCenter = [[RVSubscriptionCenter alloc]init];
    });
    return _shareCenter;
}

- (BOOL)registerMessageWithIdentify:(NSInteger)subscriptionType{
    [self.registerArray addObject:@(subscriptionType)];
    NSLog(@"注册了切换事件----%ld",(long)subscriptionType);
    return YES;
}

- (void)subscribeWithBinder:(NSObject *)binder
           subscriptionType:(NSInteger)subscriptionType
              resultHandler:(void (^)(NSError *error))resultHandler
                    handler:(RVDispatchCenterHandler)handler{

    @synchronized (self) {
        if (![self.registerArray containsObject:@(subscriptionType)]) {
            NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey: NSLocalizedStringFromTable(@"该事件尚未注册无法订阅.", @"订阅中心", nil)};
            NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:NSURLErrorBadURL userInfo:userInfo];
            resultHandler(error);
            return;
        }
        
        if (self.subscriptionArray.count > 0) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"address = %@ AND type = %ld",[NSString stringWithFormat:@"%p",binder],subscriptionType];
            NSMutableArray *newArray = [NSMutableArray arrayWithArray:[self.subscriptionArray filteredArrayUsingPredicate:predicate]];
            if (newArray.count > 0) {
                NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey: NSLocalizedStringFromTable(@"无法订阅已存在的事件.", @"订阅中心", nil)};
                NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:NSURLErrorBadURL userInfo:userInfo];
                resultHandler(error);
                return;
            }
        }

        NSMutableArray *actionArray = [[NSMutableArray alloc]init];
        [actionArray addObject:[handler copy]];

        NSPointerArray *pointerArray = [NSPointerArray weakObjectsPointerArray];
        [pointerArray addPointer:(__bridge void * _Nullable)(binder)];

        NSMutableDictionary *mDictionary = [[NSMutableDictionary alloc]init];
        [mDictionary setObject:actionArray forKey:@"actions"];
        [mDictionary setObject:pointerArray forKey:@"binders"];
        [mDictionary setObject:@(subscriptionType) forKey:@"type"];
        [mDictionary setObject:[NSString stringWithFormat:@"%p",[pointerArray pointerAtIndex:0]] forKey:@"address"];
        [self.subscriptionArray addObject:mDictionary];
        NSLog(@"订阅了事件%ld",(long)subscriptionType);
        resultHandler(nil);

    }

    
}

- (void)dispatchMessage:(NSInteger)subscriptionType
                 object:(id)object{
    
    @synchronized (self) {
        if (![self.registerArray containsObject:@(subscriptionType)]) {
            NSLog(@"该事件尚未注册无法发送消息----%ld",(long)subscriptionType);
            return;
        }
        else{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = %ld",subscriptionType];
            NSMutableArray *newArray = [NSMutableArray arrayWithArray:[self.subscriptionArray filteredArrayUsingPredicate:predicate]];
            if (newArray.count == 0) {
                NSLog(@"该事件无人订阅无法发送消息---%ld",(long)subscriptionType);
                return;
            }
            
            [newArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSPointerArray *pointerArray = [obj objectForKey:@"binders"];
                id binder = [pointerArray pointerAtIndex:0];
                if (binder != nil && binder != NULL) {
                    RVDispatchCenterHandler h = [obj[@"actions"] lastObject];
                    h(object);
                }
                else{
                    [newArray removeObject:obj];
                    [self.subscriptionArray removeObject:obj];
                }

            }];
        }
    }
}

- (BOOL)unsubscribeWithBinder:(NSObject *)binder
             subscriptionType:(NSInteger)subscriptionType{
    
    @synchronized (self) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"address = %@ AND type = %ld",[NSString stringWithFormat:@"%p",binder],subscriptionType];
        NSMutableArray *newArray = [NSMutableArray arrayWithArray:[self.subscriptionArray filteredArrayUsingPredicate:predicate]];
        if (newArray.count == 0) {
            NSLog(@"没有需要取消的事件");
            return NO;
        }
        
        [self.subscriptionArray removeObjectsInArray:newArray];
        return YES;
    }

}

- (BOOL)unsubscribeWithBinder:(NSObject *)binder{
    @synchronized (self) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"address = %@",[NSString stringWithFormat:@"%p",binder]];
        NSMutableArray *newArray = [NSMutableArray arrayWithArray:[self.subscriptionArray filteredArrayUsingPredicate:predicate]];
        if (newArray.count == 0) {
            NSLog(@"没有需要取消的事件");
            return NO;
        }
        
        [self.subscriptionArray removeObjectsInArray:newArray];
        return YES;
    }

}



#pragma mark - Getter
- (NSMutableDictionary *)subscriptionDictionary {
    if (!_subscriptionDictionary) {
        _subscriptionDictionary = [[NSMutableDictionary alloc]init];
    }
    return _subscriptionDictionary;
}

- (NSMutableArray *)registerArray {
    if (!_registerArray) {
        _registerArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _registerArray;
}

- (NSMutableArray *)subscriptionArray {
    if (!_subscriptionArray) {
        _subscriptionArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _subscriptionArray;
}

@end
