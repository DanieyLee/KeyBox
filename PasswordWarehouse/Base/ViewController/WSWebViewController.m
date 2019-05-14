//
//  WSWebViewController.m
//  yunFanPiaoWu
//
//  Created by NN on 2018/12/21.
//  Copyright © 2018 炜森. All rights reserved.
//

#import "WSWebViewController.h"

@interface WSWebViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView     *webView;
@end

@implementation WSWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    if (self.urlPath) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlPath]];
        [self.webView loadRequest:request];
    }
    self.webView.opaque = NO;
    self.webView.backgroundColor = [UIColor clearColor];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self showHudWithMessage:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideHudWithMessage:nil];
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideHudWithMessage:error.description];
}

#pragma mark - lazyload

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_webView];
        _webView.delegate = self;
    }
    return _webView;
}

@end
