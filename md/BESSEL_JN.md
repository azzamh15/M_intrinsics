## bessel_jn

### **Name**

**bessel_jn**(3) - \[MATHEMATICS\] Bessel function of the first kind

### **Synopsis**
```fortran
    result = bessel_jn(n, x)
```
```fortran
     elemental real(kind=KIND) function bessel_jn(n,x)

      integer(kind=KIND),intent(in) :: n(..)
      real(kind=KIND),intent(in) :: x(..)
```
  If **n** and **x** are arrays, their ranks and shapes
  shall conform.

  The return value has the same type and kind as **x**.
or
```fortran
    result = bessel_jn(n1, n2, x)
```
```fortran
     real(kind=KIND) function bessel_jn(n1, n2, ,x)

     integer(kind=KIND),intent(in) :: n1(..)
     integer(kind=KIND),intent(in) :: n2(..)
     real(kind=KIND),intent(in) :: x
```
  The return value has the same type and kind as **x**.

### **Description**

  **bessel_jn(n, x)** computes the Bessel function of the first kind of
  order **n** of **x**.

  **bessel_jn(n1, n2, x)** returns an array with the Bessel
  function\|Bessel functions of the first kind of the orders **n1**
  to **n2**.

### **Options**

- **n**
  : Shall be a scalar or an array of type _integer_.

- **n1**
  : Shall be a non-negative scalar of type _integer_.

- **n2**
  : Shall be a non-negative scalar of type _integer_.

- **x**
  : Shall be a scalar or an array of type _real_.
  For **bessel_jn(n1, n2, x)** it shall be scalar.

### **Result**

The return value is a scalar of type _real_. It has the same kind
as **x**.

### **Examples**

Sample program:

```fortran
program demo_bessel_jn
use, intrinsic :: iso_fortran_env, only : real_kinds, &
   & real32, real64, real128
implicit none
real(kind=real64) :: x = 1.0_real64
    x = bessel_jn(5,x)
    write(*,*)x
end program demo_bessel_jn
```

Results:

```text
      2.4975773021123450E-004
```

### **Standard**

Fortran 2008

### **See Also**

[**bessel_j0**(3)](#bessel_j0),
[**bessel_j1**(3)](#bessel_j1),
[**bessel_y0**(3)](#bessel_y0),
[**bessel_y1**(3)](#bessel_y1),
[**bessel_yn**(3)](#bessel_yn)

 _fortran-lang intrinsic descriptions_
