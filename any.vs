// builtins/any.vs
//
// Any is a compiler-recognized stdlib enum — ordinary §30 enum syntax,
// no hidden vtable, no runtime type descriptor beyond its own discriminant.
// It is the target type for `...any` variadic-sugar auto-wrapping (§22.1).
//
// Unlike most enums, the compiler knows this exact type by name and shape:
// renaming or reordering variants here changes what `...any` desugars to
// everywhere in the language.

package builtins

enum Any {
    Int(int64),
    UInt(uint64),
    Float(float64),
    Bool(bool),
    Char(char),
    Str(string),
    Ptr(*const void),
}