//
//  WebViewViewController.m
//  ts
//
//  Created by JSL_ABC on 2017/11/14.
//  Copyright © 2017年 JSL_ABC. All rights reserved.
//


#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)

#import "WebViewViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>



@interface WebViewViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (weak, nonatomic) IBOutlet UIButton *OCtoJS;
@property (weak, nonatomic) IBOutlet UIButton *OCtoJSpargrams;
 @property (nonatomic,weak) JSContext * context;
@end

@implementation WebViewViewController
- (IBAction)octojsclick:(UIButton *)sender {
    if([sender isEqual:_OCtoJS]){
       [_webview stringByEvaluatingJavaScriptFromString:@"ocTojsNOpargrams()"];
    }
    
    if([sender isEqual:_OCtoJSpargrams]){
        NSString * name = @"pheromone";
        NSInteger num = 520;//准备传去给JS的参数
        [_webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"ocTojspargrams('%@','%ld');",name,num]];
    }
}

#pragma UIWebViewDelegate方法
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
     NSLog(@"开始加载网页");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
   NSLog(@"网页加载完毕");
    
    //获取js的运行环境
     _context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //html调用无参数OC
    _context[@"test1"] = ^(){
          [self menthod1];
    };
     //html调用OC(传参数过来)
   _context[@"test2"] = ^(){
       NSArray * args = [JSContext currentArguments];//传过来的参数
       NSString * name = args[0];
       NSString * str = args[1];
       [self menthod2:name and:str];
   };
 }

#pragma 供JS调用的方法
-(void)menthod1{
     NSLog(@"JS调用了无参数OC方法");
    [self alertCheckForiosSystem:@"JS调用了无参数OC方法"];
    
 }
-(void)menthod2:(NSString *)str1 and:(NSString *)str2{
    NSLog(@"%@%@",str1,str2);
    [self alertCheckForiosSystem:[NSString stringWithFormat:@"JS调用了参数OC方法(%@,%@)",str1,str2]];
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
    //取得欲读取档案的位置与文件名
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *filePath =[resourcePath stringByAppendingPathComponent:@"Emment.html"];
    
    if (_webview) {
        //encoding:NSUTF8StringEncoding error:nil 这一段一定要加，不然中文字会乱码
        NSString*htmlstring=[[NSString alloc] initWithContentsOfFile:filePath  encoding:NSUTF8StringEncoding error:nil];
        [_webview loadHTMLString:htmlstring baseURL:[NSURL fileURLWithPath:[ [NSBundle mainBundle] bundlePath]]];
        _webview.delegate =self;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(_OCtoJS){
        [_OCtoJS setClipsToBounds:YES];
        [_OCtoJS.layer setBorderWidth:3];
        [_OCtoJS.layer setCornerRadius:4.f];
        [_OCtoJS.layer setMasksToBounds:YES];
        [_OCtoJS.layer setBorderColor:[UIColor redColor].CGColor];
    }
    
    if(_OCtoJSpargrams){
        [_OCtoJSpargrams setClipsToBounds:YES];
        [_OCtoJSpargrams.layer setBorderWidth:3];
        [_OCtoJSpargrams.layer setCornerRadius:4.f];
        [_OCtoJSpargrams.layer setMasksToBounds:YES];
        [_OCtoJSpargrams.layer setBorderColor:[UIColor redColor].CGColor];
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
