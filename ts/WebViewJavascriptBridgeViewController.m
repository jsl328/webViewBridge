//
//  WebViewJavascriptBridgeViewController.m
//  ts
//
//  Created by JSL_ABC on 2017/11/15.
//  Copyright © 2017年 JSL_ABC. All rights reserved.
//
#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)

#import "WebViewJavascriptBridgeViewController.h"
#import "WebViewJavascriptBridge.h"
@interface WebViewJavascriptBridgeViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *bridgeWebview;
@property WebViewJavascriptBridge* bridge;
@end

@implementation WebViewJavascriptBridgeViewController

#pragma UIWebViewDelegate方法
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"开始加载网页");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"网页加载完毕");
    
}
#pragma HYBJsObjCModelDelegate
-(void)HYBJsObjCModel:(NSString *)title withString:(NSString *)content
{
    [self alertCheckForiosSystem:[NSString stringWithFormat:@"(参数1%@,参数2%@)",title,content]];
}

-(void)alertCheckForiosSystem:(NSString *)str{
    if(iOS8Later){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:str message:@"这个是ios原生UIAlertController默认样式" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:nil];
        UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancelAction];
        [alertController addAction:deleteAction];
        [alertController addAction:archiveAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"标题" message:@"这个是ios原生的UIAlertView的默认样式" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
        [alertview show];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"网页加载出错");
}

-(void)viewWillAppear:(BOOL)animated
{
    // 开启日志, 便于调试
    [WebViewJavascriptBridge enableLogging];
    
    // 给webview建立JS与OjbC的沟通桥梁
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_bridgeWebview];
    // 设置代理(看需求是否需要实现)
    [_bridge setWebViewDelegate:self];
    
    //注册HandleName,js调oc方法，使用responseCallback将值再返回给js
    [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        responseCallback(@"Response from testObjcCallback");
    }];
    
    [_bridge callHandler:@"testJavascriptHandler" data:@{ @"foo":@"before ready" }];
    [self loadExamplePage:_bridgeWebview];
}

- (void)callHandler:(id)sender {
    id data = @{ @"greetingFromObjC": @"Hi there, JS!" };
    [_bridge callHandler:@"testJavascriptHandler" data:data responseCallback:^(id response) {
        NSLog(@"testJavascriptHandler responded: %@", response);
    }];
}

- (void)loadExamplePage:(UIWebView*)webView {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"Emment3" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
