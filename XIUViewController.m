
//
//  XIUViewController.m
//  WebAPP
//
//  Created by XIUDeveloper on 2016/12/24.
//  Copyright © 2016年 杨岫峰. All rights reserved.
//

#import "XIUViewController.h"
#import "MBProgressHUD.h"
@interface XIUViewController ()<UIWebViewDelegate>
{
   NSString * _urlStr;
}

@property (nonatomic, strong)UIWebView *XIUWebView;
@end

@implementation XIUViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self loadCookies];
    
    _urlStr = @"http://wx.hzjuym.com/xdd/mobile/index.php";
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"loading";
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });


    
    _XIUWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];
    
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) objectAtIndex:0];

    
    
     NSString * path = [cachesPath stringByAppendingString:[NSString stringWithFormat:@"/Caches/%lu.html",(unsigned long)[_urlStr hash]]];
      NSString *htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    _XIUWebView.delegate = self;
    if (!(htmlString ==nil || [htmlString isEqualToString:@""])) {

         [_XIUWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];
    }else {
        NSURL *url = [NSURL URLWithString:_urlStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_XIUWebView loadRequest:request];
        [self writeToCache];
    }
   
    _XIUWebView.scalesPageToFit = YES;
    _XIUWebView.scrollView.bounces=NO;

    [self.view addSubview:_XIUWebView];
    
    
    
    
    _XIUWebView.backgroundColor=[UIColor clearColor];
    for (UIView *aView in [_XIUWebView subviews])
    {
        
        if ([aView isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)aView setShowsVerticalScrollIndicator:NO]; //右侧的滚动条 （水平的类似）
            
            for (UIView *shadowView in aView.subviews)
            {
                
                if ([shadowView isKindOfClass:[UIImageView class]])
                {
                    shadowView.hidden = YES;  //上下滚动出边界时的黑色的图片 也就是拖拽后的上下阴影
                }
            } 
        } 
    }  

}



-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSArray *nCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSHTTPCookie *cookie;
    for (id c in nCookies)
    {
        if ([c isKindOfClass:[NSHTTPCookie class]])
        {
            cookie=(NSHTTPCookie *)c;
            if ([cookie.name isEqualToString:@"PHPSESSID"]) {
                NSNumber *sessionOnly = [NSNumber numberWithBool:cookie.sessionOnly];
                NSNumber *isSecure = [NSNumber numberWithBool:cookie.isSecure];
                NSArray *cookies = [NSArray arrayWithObjects:cookie.name, cookie.value, sessionOnly, cookie.domain, cookie.path, isSecure, nil];
                [[NSUserDefaults standardUserDefaults] setObject:cookies forKey:@"cookies"];
                break;
            }
        }
    }
}



/**
 * 网页缓存写入文件
 */
- (void)writeToCache
{
    NSString * htmlResponseStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:_urlStr]encoding:NSUTF8StringEncoding error:Nil];
    //创建文件管理器
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    //获取document路径
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,      NSUserDomainMask, YES) objectAtIndex:0];
    [fileManager createDirectoryAtPath:[cachesPath stringByAppendingString:@"/Caches"]withIntermediateDirectories:YES attributes:nil error:nil];
    //写入路径
    NSString * path = [cachesPath stringByAppendingString:[NSString stringWithFormat:@"/Caches/%lu.html",(unsigned long)[_urlStr hash]]];
    
    [htmlResponseStr writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}


- (void)loadCookies {
    //判断是否沙盒中是否有这个值
    if ([[[[NSUserDefaults standardUserDefaults]dictionaryRepresentation]allKeys]containsObject:@"cookie"]) {
        //获取cookies：程序起来之后，uiwebview加载url之前获取保存好的cookies，并设置cookies，
        NSArray *cookies =[[NSUserDefaults standardUserDefaults]  objectForKey:@"cookie"];
        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
        [cookieProperties setObject:[cookies objectAtIndex:0] forKey:NSHTTPCookieName];
        [cookieProperties setObject:[cookies objectAtIndex:1] forKey:NSHTTPCookieValue];
        [cookieProperties setObject:[cookies objectAtIndex:3] forKey:NSHTTPCookieDomain];
        [cookieProperties setObject:[cookies objectAtIndex:4] forKey:NSHTTPCookiePath];
        NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookieProperties];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage]  setCookie:cookieuser];
    }


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
