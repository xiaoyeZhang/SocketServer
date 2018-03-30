//
//  ViewController.m
//  SockerServer
//
//  Created by 张晓烨 on 2018/3/30.
//  Copyright © 2018年 张晓烨. All rights reserved.
//

#import "ViewController.h"
#import <GCDAsyncSocket.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
#import "NSObject+GetIP.h"

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@interface ViewController ()<GCDAsyncSocketDelegate>
@property (weak, nonatomic) IBOutlet UITextField *portF;
@property (weak, nonatomic) IBOutlet UITextField *messageTF;
@property (weak, nonatomic) IBOutlet UITextView *showContentMessageTV;

//服务器socket（开放端口，监听客户端Socket的链接）
@property (strong,nonatomic) GCDAsyncSocket *serverSocket;
//保存客户端socket
@property (strong,nonatomic) GCDAsyncSocket *ClientSocket;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.serverSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    self.portF.text = @"8080";
    NSString *StringIP = [NSString deviceIPAdress]; //调用方法 获取ip地址 赋值给字符串 stringIP
        NSLog(@"ip地址：%@",StringIP);
    
    if (StringIP == nil) {
        NSString *StringIP = [NSString getIPAddresses];
        NSLog(@"ip地址：%@",StringIP);
    }
 
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket{
   
    // 保存客户端socket
    self.ClientSocket = newSocket;
    [self showMessageWithStr:@"链接成功"];
    
    [self showMessageWithStr: [NSString stringWithFormat:@"链接地址：%@",newSocket.connectedHost]];
    [self showMessageWithStr: [NSString stringWithFormat:@"端口：%d",newSocket.connectedPort]];
    
    [self.ClientSocket readDataWithTimeout:-1 tag:0];
}
//开始监听
- (IBAction)startReceive:(id)sender {
    
    NSError *error = nil;
    BOOL result = [self.serverSocket acceptOnPort:self.portF.text.integerValue error:&error];
    if (result && error == nil) {
        //开放成功
        [self showMessageWithStr:@"开放成功"];
    }
}

//收到消息
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    NSString *text = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    [self showMessageWithStr:text];
    
    //读取客户端的数据
    [self.ClientSocket readDataWithTimeout:-1 tag:0];
    
}
//发送消息
- (IBAction)sendMessage:(id)sender {
    
    if (self.ClientSocket == nil) return;
    
    NSData *data = [self.messageTF.text dataUsingEncoding:NSUTF8StringEncoding];
    
    [self.ClientSocket writeData:data withTimeout:-1 tag:0];
}

- (void)showMessageWithStr:(NSString *)str{
    
    self.showContentMessageTV.text = [self.showContentMessageTV.text stringByAppendingFormat:@"%@\n",str];
}
//接受消息
- (IBAction)ReceiveMessage:(id)sender {
    
    [self.ClientSocket readDataWithTimeout:11 tag:0];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
