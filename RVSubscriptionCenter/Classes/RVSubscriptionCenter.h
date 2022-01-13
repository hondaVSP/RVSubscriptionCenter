//
//  RVSubscriptionCenter.h
//  RVSubscriptionCenter
//
//  Created by Zac on 2021/8/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 回调闭包

 @param resp 返回体
 */
typedef void (^RVDispatchCenterHandler)(id resp);


@interface RVSubscriptionCenter : NSObject

/**
 单例方法

 @return 单例
 */
+ (instancetype)sharedInstance;


/**
 注册事件

 @param subscriptionType 事件类型
 @return 注册结果
 */
- (BOOL)registerMessageWithIdentify:(NSInteger)subscriptionType;



/**
 订阅事件

 @param binder 绑定者
 @param subscriptionType 事件类型
 @param resultHandler 订阅结果回调
 @param handler 收到的回调
 
 - note: 当绑定者binder被回收，handler将不会被执行
 */
- (void)subscribeWithBinder:(NSObject *)binder
           subscriptionType:(NSInteger)subscriptionType
              resultHandler:(void (^)(NSError *error))resultHandler
                    handler:(RVDispatchCenterHandler)handler;


/**
 分发事件

 @param subscriptionType 事件类型
 @param object 事件参数
 */
- (void)dispatchMessage:(NSInteger)subscriptionType
                 object:(id)object;


/**
 取消订阅事件

 @param binder 绑定者
 @param subscriptionType 事件类型
 */
- (BOOL)unsubscribeWithBinder:(NSObject *)binder
             subscriptionType:(NSInteger)subscriptionType;


/**
 取消所有订阅事件

 @param binder 绑定者
 */
- (BOOL)unsubscribeWithBinder:(NSObject *)binder;

@end

NS_ASSUME_NONNULL_END
