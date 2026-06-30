package mem
build windows

import (
    "windows/lib/kernel32"
    "windows/lib/msvcrt"
)

class LibKernel32 : kernel32 {
    func GetProcessHeap() -> *void
    func HeapAlloc(hHeap: *void, flags: uint32, size: uint32) -> *void
    func HeapReAlloc(hHeap: *void, flags: uint32, ptr: *void, size: uint32) -> *void
    func HeapFree(hHeap: *void, flags: uint32, ptr: *void) -> int32
    func GetStdHandle(nStdHandle: int32) -> *void
    func WriteFile(
        hFile: *void,
        lpBuffer: *const char,
        nNumberOfBytesToWrite: uint32,
        lpNumberOfBytesWritten: *uint32,
        lpOverlapped: *void
    ) -> int32
}

// memcpy/memmove/memcmp/memset aren't exported by kernel32 — pull them
// from the CRT instead so the wrapper signatures stay identical.
class LibMsvcrt : msvcrt {
    func memcpy(dst: *void, src: *const void, n: uint32) -> *void
    func memmove(dst: *void, src: *const void, n: uint32) -> *void
    func memcmp(a: *const void, b: *const void, n: uint32) -> int32
    func memset(dst: *void, c: int32, n: uint32) -> *void
}

var k32  = LibKernel32()
var crt  = LibMsvcrt()
var heap = k32.GetProcessHeap()

func malloc(size: uint32) -> *void {
    return k32.HeapAlloc(heap, 0, size)
}

func realloc(ptr: *void, size: uint32) -> *void {
    if ptr == nil {
        return malloc(size)
    }
    return k32.HeapReAlloc(heap, 0, ptr, size)
}

func free(ptr: *void) {
    k32.HeapFree(heap, 0, ptr)
}

func memcpy(dst: *void, src: *const void, n: uint32) -> *void   { 
    return crt.memcpy(dst, src, n) 
}

func memmove(dst: *void, src: *const void, n: uint32) -> *void  { 
    return crt.memmove(dst, src, n) 
}

func memcmp(a: *const void, b: *const void, n: uint32) -> int32 { 
    return crt.memcmp(a, b, n) 
}

func memset(dst: *void, c: int32, n: uint32) -> *void { 
    return crt.memset(dst, c, n) 
}