//
//  HwBluetoothConfig.h
//  HwBluetooth
//
//  Created by SuJiang on 2018/4/12.
//  Copyright © 2021年 huawo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HwBluetoothConfig : NSObject

#pragma mark - 属性
/**
 * 扫描参数,centralManager:scanForPeripheralsWithServices:self.scanForPeripheralsWithServices options:self.scanForPeripheralsWithOptions
 * param An optional dictionary specifying options for the scan.
 *  @see                centralManager:scanForPeripheralsWithServices
 *  @seealso            CBCentralManagerScanOptionAllowDuplicatesKey :忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
 *    @seealso            CBCentralManagerScanOptionSolicitedServiceUUIDsKey
 */
@property (nonatomic, copy) NSDictionary *scanForPeripheralsWithOptions;

/**
 *  连接设备的参数
 *  method connectPeripheral:options:
 *  param              An optional dictionary specifying connection behavior options.
 *  @see                centralManager:didConnectPeripheral:
 *  @see                centralManager:didFailToConnectPeripheral:error:
 *  @seealso            CBConnectPeripheralOptionNotifyOnConnectionKey
 *  @seealso            CBConnectPeripheralOptionNotifyOnDisconnectionKey
 *  @seealso            CBConnectPeripheralOptionNotifyOnNotificationKey
 */
@property (nonatomic, copy) NSDictionary *connectPeripheralWithOptions;

/**
 * 扫描参数,centralManager:scanForPeripheralsWithServices:self.scanForPeripheralsWithServices options:self.scanForPeripheralsWithOptions
 * param serviceUUIDs A list of <code>CBUUID</code> objects representing the service(s) to scan for.
 *@see                centralManager:scanForPeripheralsWithServices
 */
@property (nonatomic, copy) NSArray *scanForPeripheralsWithServices;

// [peripheral discoverServices:self.discoverWithServices];
@property (nonatomic, copy) NSArray *discoverWithServices;

// [peripheral discoverCharacteristics:self.discoverWithCharacteristics forService:service];
@property (nonatomic, copy) NSArray *discoverWithCharacteristics;

@property(nonatomic, assign) BOOL autoConnect;

// 手动指定MTU
@property(nonatomic, assign) NSUInteger MTU;

+ (HwBluetoothConfig *) defaultConfig;

@end
