package mem
build linux

import "linux/lib/c"

class LibC : c {
    func malloc(size: uint32) -> *void
    func realloc(ptr: *void, size: uint32) -> *void
    func free(ptr: *void)
    func memcpy(dst: *void, src: *const void, n: uint32) -> *void
    func memmove(dst: *void, src: *const void, n: uint32) -> *void
    func memcmp(a: *const void, b: *const void, n: uint32) -> int32
    func memset(dst: *void, c: int32, n: uint32) -> *void
    func write(fd: int32, buf: *const char, count: uint64) -> int64
}

var libc = LibC()

func malloc(size: uint32) -> *void  { 
    return libc.malloc(size) 
}

func realloc(ptr: *void, size: uint32) -> *void { 
    return libc.realloc(ptr, size) 
}

func free(ptr: *void) { 
    libc.free(ptr) 
}

func memcpy(dst: *void, src: *const void, n: uint32) -> *void { 
    return libc.memcpy(dst, src, n) 
}

func memmove(dst: *void, src: *const void, n: uint32) -> *void  { 
    return libc.memmove(dst, src, n) 
}

func memcmp(a: *const void, b: *const void, n: uint32) -> int32 { 
    return libc.memcmp(a, b, n) 
}

func memset(dst: *void, c: int32, n: uint32) -> *void { 
    return libc.memset(dst, c, n) 
}