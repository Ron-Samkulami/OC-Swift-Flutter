//
//  BlueToothTestVC.m
//  TEST
//
//  Created by mige on 2022/5/16.
//

#import "BlueToothTestVC.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface BlueToothTestVC ()<CBCentralManagerDelegate,CBPeripheralDelegate>

/// 蓝牙中心
@property (nonatomic, strong) CBCentralManager *blueCentralManger;
@end

@implementation BlueToothTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //点击按钮截屏
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50,100,300,30)];
    [button setTitle:@"开始扫描蓝牙设备" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(onStartscanBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)onStartscanBtnAction:(UIButton *)btn {
    [self startScanPeripheral];
}

/**
 开始扫描蓝牙外设
 */
- (void)startScanPeripheral {
    self.blueCentralManger = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    [self.blueCentralManger scanForPeripheralsWithServices:nil options:nil];
}

#pragma mark - CBCentralManagerDelegate
/**
 每创建一个CBCentralManager，就会回调一次次方法
 */
- (void)centralManagerDidUpdateState:(nonnull CBCentralManager *)central {
    if (central.state != CBManagerStatePoweredOn) {
        [self toast:@"蓝牙开启失败"];
        
    } else {
        [self toast:@"蓝牙开启成功，开始扫描外设"];
        [central scanForPeripheralsWithServices:nil options:nil];
    }
}


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    if (peripheral.name.length <= 0) {
        return;
    }
    if ([peripheral isKindOfClass:[CBPeripheral class]]) {
        [self toast:[NSString stringWithFormat:@"发现设备：%@，尝试连接",peripheral.name]];
        //停止扫描服务
        [self.blueCentralManger stopScan];
        [self.blueCentralManger connectPeripheral:peripheral options:nil];
    }
    
}

//连接成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}

//连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    [self toast:[NSString stringWithFormat:@"连接设备失败：%@",peripheral.name]];
}

//断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    [self toast:[NSString stringWithFormat:@"断开设备连接：%@",peripheral.name]];
}
@end
