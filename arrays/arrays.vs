// runtime/arrays/arrays.vs
package arrays

import "builtins/mem"

// ── Control block ─────────────────────────────────────────────────────────────

class Array {
    data:     *void
    len:      uint32
    capacity: uint32
    elemSize: uint32
}

// ── Constructors ──────────────────────────────────────────────────────────────

func new(elemSize: uint32) -> Array {
    return Array(
        data:     nil,
        len:      0,
        capacity: 0,
        elemSize: elemSize,
    )
}

func newWithCapacity(elemSize: uint32, capacity: uint32) -> Array {
    let data = mem.malloc(elemSize * capacity)
    return Array(
        data:     data,
        len:      0,
        capacity: capacity,
        elemSize: elemSize,
    )
}

// ── Destructor ────────────────────────────────────────────────────────────────

func free(arr: Array) {
    if arr.data != nil {
        mem.free(arr.data)
    }
    arr.delete()
}

// ── Internal: grow capacity ───────────────────────────────────────────────────

func grow(arr: Array) {
    let initialCap: uint32 = 4
    var newCap: uint32 = initialCap
    if arr.capacity != 0 {
        newCap = arr.capacity * 2
    }
    arr.data     = mem.realloc(arr.data, newCap * arr.elemSize)
    arr.capacity = newCap
}

// ── Reserve ───────────────────────────────────────────────────────────────────

func reserve(arr: Array, capacity: uint32) {
    if capacity <= arr.capacity {
        return
    }
    arr.data     = mem.realloc(arr.data, capacity * arr.elemSize)
    arr.capacity = capacity
}

// ── Append ────────────────────────────────────────────────────────────────────

func push(arr: Array, elem: *const void) {
    if arr.len >= arr.capacity {
        grow(arr)
    }
    let dest = (arr.data as *uint8 + arr.len * arr.elemSize) as *void
    mem.memcpy(dest, elem, arr.elemSize)
    arr.len += 1
}

// ── Prepend ───────────────────────────────────────────────────────────────────

func unshift(arr: Array, elem: *const void) {
    if arr.len >= arr.capacity {
        grow(arr)
    }
    let dest = (arr.data as *uint8 + arr.elemSize) as *void
    mem.memmove(dest, arr.data, arr.len * arr.elemSize)
    mem.memcpy(arr.data, elem, arr.elemSize)
    arr.len += 1
}

// ── Pop (remove from end) ─────────────────────────────────────────────────────
// Copies the removed element into `out`. Returns false if the array is empty.

func pop(arr: Array, out: *void) -> bool {
    if arr.len == 0 {
        return false
    }
    arr.len -= 1
    let src = (arr.data as *uint8 + arr.len * arr.elemSize) as *const void
    mem.memcpy(out, src, arr.elemSize)
    return true
}

// ── Shift (remove from front) ─────────────────────────────────────────────────
// Copies the removed element into `out`. Returns false if the array is empty.

func shift(arr: Array, out: *void) -> bool {
    if arr.len == 0 {
        return false
    }
    mem.memcpy(out, arr.data as *const void, arr.elemSize)
    arr.len -= 1
    if arr.len > 0 {
        let src = (arr.data as *uint8 + arr.elemSize) as *const void
        mem.memmove(arr.data, src, arr.len * arr.elemSize)
    }
    return true
}

// ── Remove at index ───────────────────────────────────────────────────────────

func removeAt(arr: Array, index: uint32) {
    if index >= arr.len {
        return
    }
    let tail: uint32 = arr.len - index - 1
    if tail > 0 {
        let dst = (arr.data as *uint8 + index       * arr.elemSize) as *void
        let src = (arr.data as *uint8 + (index + 1) * arr.elemSize) as *const void
        mem.memmove(dst, src, tail * arr.elemSize)
    }
    arr.len -= 1
}