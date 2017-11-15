//
//  HYBJsObjCModel.m
//  ts
//
//  Created by JSL_ABC on 2017/11/15.
//  Copyright © 2017年 JSL_ABC. All rights reserved.
//

#import "HYBJsObjCModel.h"

#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)

@implementation HYBJsObjCModel

- (void)share:(NSDictionary *)params {
    NSLog(@"Js调用了OC的share方法，参数为：%@", params);
    [self.delegate HYBJsObjCModel:params[@"title"] withString:params[@"shareUrl"]];
}

- (void)callWithDict:(NSDictionary *)params {
    NSLog(@"Js调用了OC的方法，参数为：%@", params);
}

// JS调用了callCamera
- (void)callCamera {
    NSLog(@"JS调用了OC的方法，调起系统相册");
    
    [self.delegate HYBJsObjCModel:@"" withString:@""];
    
    // JS调用后OC后，可以传一个回调方法的参数，进行回调JS
    JSValue *jsFunc = self.jsContext[@"h5ToOCNOpargramsCallback"];
    //NSDictionary *dict =
    [jsFunc callWithArguments:@[@{@"age": @10, @"name": @"lili", @"height": @158}]];
    NSLog(@"___--%@",[jsFunc toString]);
    
    /*
     //不传参数--不返回
     function h5ToOCNOpargramsFunction(){
     OCModel.share({'title': '标题', 'desc': '内容', 'shareUrl': 'http://www.jianshu.com/p/f896d73c670a' });
     }
     
     //不传参数--返回
     function h5ToOCNOpargramsNocallbackFunction(){
     // alert('h5调用OC带参数');
     OCModel.callCamera();
     }
     
     //传参数的--不返回
     function h5ToOCpargramsFunction(object){
     //@{@"age": @10, @"name": @"lili", @"height": @158}
     // return(object.age+object.name+object.height);
     OCModel.share({'title': '标题', 'desc': '内容', 'shareUrl': 'http://www.jianshu.com/p/f896d73c670a' });
     }
     
     //传参数的--返回
     function h5ToOCpargramsCallbackFunction(object){
     OCModel.share({'title': '标题', 'desc': '内容', 'shareUrl': 'http://www.jianshu.com/p/f896d73c670a' });
     OCModel.callCamera();
     }
     
     //不传参数的js返回,传参数的js返回
     function h5ToOCNOpargramsCallback(object){
     alert(object.age+object.name+object.height);
     }
     */
}

- (void)jsCallObjcAndObjcCallJsWithDict:(NSDictionary *)params {
    NSLog(@"jsCallObjcAndObjcCallJsWithDict was called, params is %@", params);
    
    // 调用JS的方法
    JSValue *jsParamFunc = self.jsContext[@"jsParamFunc"];
    [jsParamFunc callWithArguments:@[@{@"age": @10, @"name": @"lili", @"height": @158}]];
    
    NSLog(@"___--%@",[jsParamFunc toString]);
}

// 指定参数的用法
// 在JS中调用时，函数名应该为showAlertMsg(arg1, arg2)
- (void)showAlert:(NSString *)title msg:(NSString *)msg {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate HYBJsObjCModel:title withString:msg];
//        UIAlertView *a = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [a show];
    });
}
@end
