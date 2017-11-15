//
//  HYBJsObjCModel.h
//  ts
//
//  Created by JSL_ABC on 2017/11/15.
//  Copyright © 2017年 JSL_ABC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JavaScriptObjectiveCDelegate <JSExport>

// JS调用此方法来调用OC的share
- (void)share:(NSDictionary *)params ;

// JS调用此方法来调用OC的相机
- (void)callCamera ;

// 在JS中调用时，多个参数需要使用驼峰方式
// 这里是多个个参数的。
- (void)showAlert:(NSString *)title msg:(NSString *)msg;

// 通过JSON传过来
- (void)callWithDict:(NSDictionary *)params;

// JS调用Oc，然后在OC中通过调用JS方法来传值给JS。
- (void)jsCallObjcAndObjcCallJsWithDict:(NSDictionary *)params;

@end

@class HYBJsObjCModel;
@protocol HYBJsObjCModelDelegate
-(void)HYBJsObjCModel:(NSString  *)title withString:(NSString *)content;
@end

// 此模型用于注入JS的模型，这样就可以通过模型来调用方法。
@interface HYBJsObjCModel : NSObject<JavaScriptObjectiveCDelegate>
@property (nonatomic, strong) JSContext *jsContext;
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,assign)id<HYBJsObjCModelDelegate>delegate;
@end
