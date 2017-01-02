# XianDaDaProduct
鲜搭搭净菜公社WebAPP改

 
 ### web userPassword and userName save In NSUserDefaut
 

#### This method can write in AppDelegate or Notification when product will be in background

 ```Objective-C
- (void)applicationDidEnterBackground:(UIApplication *)application {

   NSHTTPCookie *cookie;
    NSHTTPCookieStorage *nCookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookiesURL = [nCookies cookiesForURL:[NSURL URLWithString:@"http://wx.hzjuym.com/xdd/mobile/index.php"]];  //这个是主页的url，不是登录页的url
    
    for (id c in cookiesURL)
    {
        if ([c isKindOfClass:[NSHTTPCookie class]])
        {
            cookie=(NSHTTPCookie *)c;
            NSLog(@"------%@", cookie.name);
            if ([cookie.name isEqualToString:@"PHPSESSID"]) {//我的cookies的名字是 "PHPSESSID"，你在上一行打个断点看看你的cookies的name是什么
                NSDate *expiresDate = [NSDate dateWithTimeIntervalSinceNow:3600*24*30*12];//当前点后，保存一年左右
                NSArray *cookies = [NSArray arrayWithObjects:cookie.name, cookie.value, expiresDate, cookie.domain, cookie.path, nil];
                
                if(cookies){
                    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
                    [cookieProperties setObject:[cookies objectAtIndex:0] forKey:NSHTTPCookieName];
                    [cookieProperties setObject:[cookies objectAtIndex:1] forKey:NSHTTPCookieValue];
                    [cookieProperties setObject:[cookies objectAtIndex:2] forKey:NSHTTPCookieExpires];
                    [cookieProperties setObject:[cookies objectAtIndex:3] forKey:NSHTTPCookieDomain];
                    [cookieProperties setObject:[cookies objectAtIndex:4] forKey:NSHTTPCookiePath];
                    
                    NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookieProperties];
                    [[NSHTTPCookieStorage sharedHTTPCookieStorage]  setCookie:cookieuser];
                }
                break;
            }
        }
    }
}
```
    
####  Wirte Cookies Mdethd
```Objective-C
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

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

```
