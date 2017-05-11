//
//  ViewController.m
//  RXSocketDemo
//
//  Created by srx on 2017/5/11.
//  Copyright © 2017年 https://github.com/srxboys. All rights reserved.
//

#import "ViewController.h"

#import <sys/socket.h>
#import <netinet/in.h> //ip
#import <arpa/inet.h> //字符串转ip

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //百度百科什么的都可以查找到详细的步骤和说明
    //1 创建socket
    /* 参数说明：
     参数1:domain(协议域):AF_INET(ipv4)、AF_INET6、AF_LOCAL、AF_ROUTE...
     参数2:type(Socket类型):SOCK_STREAM(TCP)、SOCK_DGRAM(UDP)、SOCK_RAW...
     参数3:protocol(协议):IPPROTO_TCP、IPPROTO_UDP、IPPROTO_STCP...
     返回值:如果调用成功就返回新创建的套接字的描述符，如果失败就返回INVALID_SOCKET（Linux下失败返回-1）。
     注意:参数3位 0，标识自动选择
     */
    int clienSocket = socket(AF_INET, SOCK_STREAM, 0);
    
    //2.1 bind绑定
    /* 参数说明：
     socket：是一个套接字描述符。
     address：是一个sockaddr结构指针，该结构中包含了要结合的地址和端口号。
     address_len：确定address缓冲区的长度。
     返回值：如果函数执行成功，返回值为0，否则为SOCKET_ERROR。
     */
    struct sockaddr_in addrServer;
    //地址
    addrServer.sin_addr.s_addr = inet_addr("127.0.0.1");
    //端口
    addrServer.sin_port = htons(8099);
    addrServer.sin_family = AF_INET;
    
    //何时使用bind http://blog.csdn.net/suxinpingtao51/article/details/11809011
    //使用bind函数时，通过将my_addr.sin_port置为0，函数会自动为你选择一个未占用的端口来使用。
    //    int bindResult = bind(clienSocket, (const struct sockaddr *)&addrServer, sizeof(addrServer));
    //    if(bindResult != 0) {
    //        NSLog(@"绑定接口失败 %d", bindResult);
    //        return;
    //    }
    
    //2.2连接到服务端
    int connectResult = connect(clienSocket,(const struct sockaddr *)&addrServer,sizeof(addrServer));
    if(connectResult == 0) {
        NSLog(@"连接成功");
    }
    else {
        NSLog(@"连接失败了.... 失败状态码:%d", connectResult);
        return;
    }
    
    //3.发送数据
    /* 参数说明：
     socket：一个标识已连接套接口的描述字。
     const void *：可以发送任意类型的数据 的地址(指针)。
     size_t：内容长度。
     flags：调用方式标志位, 一般为0, 改变Flags，将会改变Sendto发送的形式
     返回值：如果成功，则返回发送的字节数，失败则返回SOCKET_ERROR。
     */
    NSString* message = @"好6哦。"; //汉字、符号为2个字节,,,数字、字母为1个字节
    ssize_t sendLength =  send(clienSocket, message.UTF8String, strlen(message.UTF8String), 0);
    NSLog(@"发送了%ld个字节数", sendLength);
    
    
    /* 参数说明：
     socket：一个标识已连接套接口的描述字。
     buf：用于接收数据的缓冲区。
     len：缓冲区长度。
     flags：指定调用方式。取值：MSG_PEEK 查看当前数据，数据将被复制到缓冲区中，但并不从输入队列中删除；MSG_OOB 处理带外数据。 0表示阻塞，等待服务器返回数据。
     返回值：若无错误发生，recv()返回读入的字节数。如果连接已中止，返回0。否则的话，返回SOCKET_ERROR错误，应用程序可通过WSAGetLastError()获取相应错误代码。
     */
    char buffer[1024];
    ssize_t secvLength = recv(clienSocket, buffer, sizeof(buffer), MSG_PEEK);
    NSLog(@"接收了%ld个字节数", secvLength);
    NSLog(@"结果为:%s" , buffer);
    NSString *str_From_buff = [NSString stringWithCString:(char*)buffer encoding:NSUTF8StringEncoding];
    NSLog(@"转译后的结果=%@", str_From_buff);
    
    //5 关闭socket
    int closeResult = close(clienSocket);
    NSLog(@"关闭socket=%d", closeResult);
}


/*
 终端 为服务器 (mac 终端: nc -help)
 nc -lk 8099
 
 
 shell命令说明(http://www.runoob.com/linux/linux-comm-nc.html)
 nc = netcat
 -l		Listen mode, for inbound connects使用监听模式，管控传入的资料
 -k  	Keep inbound sockets open for multiple connects为多个连接保持入站套接字打开
 */



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
