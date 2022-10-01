## sinh

### **Name**

**sinh**(3) - \[MATHEMATICS:TRIGONOMETRIC\] Hyperbolic sine function

### **Synopsis**
```fortran
    result = sinh(x)
```
```fortran
     elemental TYPE(kind=KIND) function sinh(x)

     TYPE(kind=KIND) :: x
```
### **Characteristics**

where **TYPE** may be _real_ or _complex_ and **KIND** may be any kind supported
by the associated type.

The returned value will be of the same type and kind as
the argument.

### **Description**

**sinh(x)** computes the hyperbolic sine of **x**.

The hyperbolic sine of x is defined mathematically as:

**sinh(x) = (exp(x) - exp(-x)) / 2.0**

If **x** is of type _complex_ its imaginary part is regarded as a value
in radians.

### **Options**

- **x**
  : The type shall be _real_ or _complex_.

### **Result**

The return value has same type and kind as **x**.

### **Examples**

Sample program:
```fortran
program demo_sinh
use, intrinsic :: iso_fortran_env, only : &
& real_kinds, real32, real64, real128
implicit none
real(kind=real64) :: x = - 1.0_real64
real(kind=real64) :: nan, inf
character(len=20) :: line

   print *, sinh(x)
   print *, (exp(x)-exp(-x))/2.0

   ! sinh(3) is elemental and can handle an array
   print *, sinh([x,2.0*x,x/3.0])

   ! a NaN input returns NaN
   line='NAN'
   read(line,*) nan
   print *, sinh(nan)

   ! a Inf input returns Inf
   line='Infinity'
   read(line,*) inf
   print *, sinh(inf)

   ! an overflow returns Inf
   x=huge(0.0d0)
   print *, sinh(x)

end program demo_sinh
```
Results:
```text
  -1.1752011936438014
  -1.1752011936438014
  -1.1752011936438014       -3.6268604078470190      -0.33954055725615012
                       NaN
                  Infinity
                  Infinity
```
### **Standard**

Fortran 95 , for a complex argument Fortran 2008

### **See Also**

[**asinh**(3)](#asinh)

### **Resources**

- [Wikipedia:hyperbolic functions](https://en.wikipedia.org/wiki/Hyperbolic_functions)

 _fortran-lang intrinsic descriptions_
