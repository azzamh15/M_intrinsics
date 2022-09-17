## lgt

### **Name**

**lgt**(3) - \[CHARACTER:COMPARE\] Lexical greater than

### **Syntax**

```fortran
result = lgt(string_a, string_b)
```

### **Description**

  Determines whether one string is lexically greater than another string,
  where the two strings are interpreted as containing ASCII character
  codes. If the String **a** and String **b** are not the same length,
  the shorter is compared as if spaces were appended to it to form a
  value that has the same length as the longer.

  In general, the lexical comparison intrinsics **lge**, **lgt**, **lle**,
  and **llt** differ from the corresponding intrinsic operators _.ge.,
  .gt., .le., and .lt._, in that the latter use the processor's character
  ordering (which is not ASCII on some targets), whereas the former
  always use the ASCII ordering.

### **Arguments**

- **string_a**
  : Shall be of default _character_ type.

- **string_b**
  : Shall be of default _character_ type.

### **Returns**

  Returns _.true._ if string_a \> string_b, and _.false._ otherwise,
  based on the ASCII ordering.

### **Standard**

FORTRAN 77 and later

### **See Also**

[**lge**(3)](#lge),
[**lle**(3)](#lle),
[**llt**(3)](#llt)

  Functions that perform operations on character strings, return lengths
  of arguments, and search for certain arguments:

- **Elemental:**
  [**adjustl**(3)](#adjustl),
  [**adjustr**(3)](#adjustr),
  [**index**(3)](#index),

[**scan**(3)](#scan),
[**verify**(3)](#verify)

- **Nonelemental:**
  [**len_trim**(3)](#len_trim),
  [**len**(3)](#len),
  [**repeat**(3)](#repeat),
  [**trim**(3)](#trim)

 _fortran-lang intrinsic descriptions_
