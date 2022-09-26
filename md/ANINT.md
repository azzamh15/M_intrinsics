## anint

### **Name**

**anint**(3) - \[NUMERIC\] Nearest whole number

### **Synopsis**
```fortran
    result = anint(a [,kind])
```
```fortran
     elemental real(kind=KIND) function iaint(x,kind)

     real(kind=KIND),intent(in)   :: x
     integer,intent(in),optional :: kind
```
where the _kind_ of the result is the same as as **x** unless
**kind** is present.

### **Description**

**anint(a \[, kind\])** rounds its argument to the nearest whole number.

### **Options**

- **a**
  : the type of the argument shall be _real_.

- **kind**
  : (optional) an _integer_ initialization expression indicating the kind
  parameter of the result.

### **Result**

The return value is of type real with the kind type parameter of the
argument if the optional **kind** is absent; otherwise, the kind type
parameter will be given by **kind**. If **a** is greater than zero,
**anint(a)** returns **aint(a + 0.5)**. If **a** is less than or equal
to zero then it returns **aint(a - 0.5)**.

### **Examples**

Sample program:

```fortran
program demo_anint
use, intrinsic :: iso_fortran_env, only : real_kinds, &
& real32, real64, real128
implicit none
real(kind=real32) :: x4
real(kind=real64) :: x8

   x4 = 1.234E0_real32
   x8 = 4.321_real64
   print *, anint(x4), dnint(x8)
   x8 = anint(x4,kind=real64)
   print *, x8
   print *
   ! elemental
   print *,anint([ &
    & -2.7,  -2.5, -2.2, -2.0, -1.5, -1.0, -0.5, &
    &  0.0, &
    & +0.5,  +1.0, +1.5, +2.0, +2.2, +2.5, +2.7  ])

end program demo_anint
```
Results:

```text
    1.00000000       4.0000000000000000
    1.0000000000000000

   -3.00000000      -3.00000000      -2.00000000      -2.00000000
   -2.00000000      -1.00000000      -1.00000000       0.00000000
    1.00000000       1.00000000       2.00000000       2.00000000
    2.00000000       3.00000000       3.00000000
```
### **Standard**

FORTRAN 77 and later

### **See Also**

[**aint**(3)](#aint),
[**int**(3)](#int),
[**nint**(3)](#nint),
[**selected_int_kind**(3)](#selected_int_kind),
[**ceiling**(3)](#ceiling),
[**floor**(3)](#floor)

 _fortran-lang intrinsic descriptions_
