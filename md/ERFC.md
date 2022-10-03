## erfc

### **Name**

**erfc**(3) - \[MATHEMATICS\] Complementary error function

### **Synopsis**
```fortran
    result = erfc(x)
```
```fortran
     elemental real(kind=KIND) function erfc(x)

      real(kind=KIND),intent(in) :: x
```
### **Characteristics**

### **Description**

**erfc**(x) computes the complementary error function of **x**. Simply put
this is equivalent to **1 - erf(x)**, but **erfc** is provided because
of the extreme loss of relative accuracy if **erf(x)** is called for
large **x** and the result is subtracted from **1**.

**erfc(x)** is defined as

<!--
$$
\text{erfc}(x) = 1 - \text{erf}(x) = 1 - \frac{2}{\sqrt{\pi}} \int_0^x e^{-t^2} dt.
$$
-->

$$
\text{erfc}(x) = 1 - \text{erf}(x) = 1 - \frac{2}{\sqrt{\pi}} \int_x^{\infty} e^{-t^2} dt.
$$

### **Options**

- **x**
  : The type shall be _real_.

### **Result**

The return value is of type _real_ and of the same kind as **x**. It lies in
the range

> 0 \<= **erfc**(x) \<= 2.

### **Examples**

Sample program:

```fortran
program demo_erfc
use, intrinsic :: iso_fortran_env, only : &
 & real_kinds, real32, real64, real128
implicit none
real(kind=real64) :: x = 0.17_real64
    write(*,*)x, erfc(x)
end program demo_erfc
```

Results:

```text
     0.17000000000000001       0.81000753879819121
```

### **Standard**

Fortran 2008

### ***See also**

[**erf**(3)](#erf)
[**erf_scaled**(3)](#erf_scaled)

### **Resources**

- [Wikipedia:error function](https://en.wikipedia.org/wiki/Error_function)

 _fortran-lang intrinsic descriptions (license: MIT) \@urbanjost_
