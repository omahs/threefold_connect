// Objective-C API for talking to github.com/yggdrasil-network/yggdrasil-go/contrib/mobile Go package.
//   gobind -lang=objc github.com/yggdrasil-network/yggdrasil-go/contrib/mobile
//
// File is generated by gobind. Do not edit.

#ifndef __Mobile_H__
#define __Mobile_H__

@import Foundation;
#include "ref.h"
#include "Universe.objc.h"

#include "Config.objc.h"

@class MobileMobileLogger;
@class MobileYggdrasil;

@interface MobileMobileLogger : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) _Nonnull id _ref;

- (nonnull instancetype)initWithRef:(_Nonnull id)ref;
- (nonnull instancetype)init;
- (BOOL)write:(NSData* _Nullable)p0 n:(long* _Nullable)n error:(NSError* _Nullable* _Nullable)error;
@end

/**
 * Yggdrasil mobile package is meant to "plug the gap" for mobile support, as
Gomobile will not create headers for Swift/Obj-C etc if they have complex
(non-native) types. Therefore for iOS we will expose some nice simple
functions. Note that in the case of iOS we handle reading/writing to/from TUN
in Swift therefore we use the "dummy" TUN interface instead.
 */
@interface MobileYggdrasil : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) _Nonnull id _ref;

- (nonnull instancetype)initWithRef:(_Nonnull id)ref;
- (nonnull instancetype)init;
/**
 * GetAddressString gets the node's IPv6 address
 */
- (NSString* _Nonnull)getAddressString;
/**
 * GetCoordsString gets the node's coordinates
 */
- (NSString* _Nonnull)getCoordsString;
- (NSString* _Nonnull)getDHTJSON;
/**
 * GetMTU returns the configured node MTU. This must be called AFTER Start.
 */
- (long)getMTU;
- (NSString* _Nonnull)getPeersJSON;
/**
 * GetPublicKeyString gets the node's public key in hex form
 */
- (NSString* _Nonnull)getPublicKeyString;
/**
 * GetSubnetString gets the node's IPv6 subnet in CIDR notation
 */
- (NSString* _Nonnull)getSubnetString;
/**
 * Recv waits for and reads a packet coming from Yggdrasil. It
will be a fully formed IPv6 packet
 */
- (NSData* _Nullable)recv:(NSError* _Nullable* _Nullable)error;
/**
 * Send sends a packet to Yggdrasil. It should be a fully formed
IPv6 packet
 */
- (BOOL)send:(NSData* _Nullable)p0 error:(NSError* _Nullable* _Nullable)error;
/**
 * StartAutoconfigure starts a node with a randomly generated config
 */
- (BOOL)startAutoconfigure:(NSError* _Nullable* _Nullable)error;
/**
 * StartJSON starts a node with the given JSON config. You can get JSON config
(rather than HJSON) by using the GenerateConfigJSON() function
 */
- (BOOL)startJSON:(NSData* _Nullable)configjson error:(NSError* _Nullable* _Nullable)error;
/**
 * Stop the mobile Yggdrasil instance
 */
- (BOOL)stop:(NSError* _Nullable* _Nullable)error;
@end

/**
 * GenerateConfigJSON generates mobile-friendly configuration in JSON format
 */
FOUNDATION_EXPORT NSData* _Nullable MobileGenerateConfigJSON(void);

FOUNDATION_EXPORT NSString* _Nonnull MobileGetVersion(void);

#endif
