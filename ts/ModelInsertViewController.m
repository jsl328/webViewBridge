//
//  ModelInsertViewController.m
//  ts
//
//  Created by JSL_ABC on 2017/11/15.
//  Copyright © 2017年 JSL_ABC. All rights reserved.
//

#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)

#import "ModelInsertViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "HYBJsObjCModel.h"
@interface ModelInsertViewController ()<UIWebViewDelegate,HYBJsObjCModelDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *modelWebview;
@property (weak, nonatomic) IBOutlet UIButton *noParm;
@property (weak, nonatomic) IBOutlet UIButton *parms;
 @property (nonatomic,weak) JSContext * context;
@end

@implementation ModelInsertViewController
- (IBAction)modelOnclick:(UIButton *)sender {
    _parms.hidden=_noParm.hidden=YES;
    if([sender isEqual:_noParm]){
        [_modelWebview stringByEvaluatingJavaScriptFromString:@"ocTojsNOpargrams()"];
    }
    if([sender isEqual:_parms]){
        NSString * name = @"pheromone";
        NSInteger num = 520;//准备传去给JS的参数
        [_modelWebview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"ocTojspargrams('%@','%ld');",name,num]];
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
    
    // 通过模型调用方法，这种方式更好些。
    HYBJsObjCModel *model  = [[HYBJsObjCModel alloc] init];
    //html调用无参数OC ----模型
    model.jsContext = _context;
    model.delegate =self;
    model.webView = _modelWebview;
    
    _context[@"OCModel"] = model;
     //html调用OC(传参数过来)-----viewcontroller
//    _context[@"OCModel"] = self;
    // 增加异常的处理
    _context.exceptionHandler = ^(JSContext *context,
                                        JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
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
    //取得欲读取档案的位置与文件名
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *filePath =[resourcePath stringByAppendingPathComponent:@"EmmentModel.html"];
    
    if (_modelWebview) {
        //encoding:NSUTF8StringEncoding error:nil 这一段一定要加，不然中文字会乱码
        NSString*htmlstring=[[NSString alloc] initWithContentsOfFile:filePath  encoding:NSUTF8StringEncoding error:nil];
        [_modelWebview loadHTMLString:htmlstring baseURL:[NSURL fileURLWithPath:[ [NSBundle mainBundle] bundlePath]]];
        _modelWebview.delegate =self;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(_parms){
        [_parms setClipsToBounds:YES];
        [_parms.layer setBorderWidth:3];
        [_parms.layer setCornerRadius:4.f];
        [_parms.layer setMasksToBounds:YES];
        [_parms.layer setBorderColor:[UIColor redColor].CGColor];
    }
    
    if(_noParm){
        [_noParm setClipsToBounds:YES];
        [_noParm.layer setBorderWidth:3];
        [_noParm.layer setCornerRadius:4.f];
        [_noParm.layer setMasksToBounds:YES];
        [_noParm.layer setBorderColor:[UIColor redColor].CGColor];
    }
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
