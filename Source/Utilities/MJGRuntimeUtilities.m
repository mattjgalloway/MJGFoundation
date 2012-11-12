//
//  MJGRuntimeUtilities.c
//  MJGFoundation
//
//  Created by Matt Galloway on 12/11/2012.
//  Copyright (c) 2012 Matt Galloway. All rights reserved.
//

#import "MJGRuntimeUtilities.h"

void dumpClass(Class cls) {
    const char *className = class_getName(cls);
    
    NSLog(@"=== Class dump for %s ===", className);
    
    Class isa = object_getClass(cls);
    Class superClass = class_getSuperclass(cls);
    
    NSLog(@"  isa = %@", isa);
    NSLog(@"  superclass = %@", superClass);
    
    NSLog(@"Protocols:");
    unsigned int protocolCount = 0;
    Protocol *__unsafe_unretained* protocolList = class_copyProtocolList(cls, &protocolCount);
    for (unsigned int i = 0; i < protocolCount; i++) {
        Protocol *protocol = protocolList[i];
        const char *name = protocol_getName(protocol);
        NSLog(@"<%s>", name);
    }
    free(protocolList);
    
    NSLog(@"Instance variables:");
    unsigned int ivarCount = 0;
    Ivar *ivarList = class_copyIvarList(cls, &ivarCount);
    for (unsigned int i = 0; i < ivarCount; i++) {
        Ivar ivar = ivarList[i];
        const char *name = ivar_getName(ivar);
        ptrdiff_t offset = ivar_getOffset(ivar);
        const char *encoding = ivar_getTypeEncoding(ivar);
        NSLog(@"  %s [%i] %s", name, offset, encoding);
    }
    free(ivarList);
    
    NSLog(@"Instance methods:");
    unsigned int instanceMethodCount = 0;
    Method *instanceMethodList = class_copyMethodList(cls, &instanceMethodCount);
    for (unsigned int i = 0; i < instanceMethodCount; i++) {
        Method method = instanceMethodList[i];
        SEL name = method_getName(method);
        const char *encoding = method_getTypeEncoding(method);
        NSLog(@"  -[%s %@] %s", className, NSStringFromSelector(name), encoding);
    }
    free(instanceMethodList);
    
    NSLog(@"Class methods:");
    unsigned int classMethodCount = 0;
    Method *classMethodList = class_copyMethodList(isa, &classMethodCount);
    for (unsigned int i = 0; i < classMethodCount; i++) {
        Method method = classMethodList[i];
        SEL name = method_getName(method);
        const char *encoding = method_getTypeEncoding(method);
        NSLog(@"  +[%s %@] %s", className, NSStringFromSelector(name), encoding);
    }
    free(classMethodList);
}
