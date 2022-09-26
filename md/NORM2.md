## norm2

### **Name**

**norm2**(3) - \[MATHEMATICS\] Euclidean vector norm

### **Synopsis**
```fortran
    result = norm2(array, dim)
```
```fortran
     real function norm2(array, dim)

     real,intent(in) :: array(..)
     integer,intent(in),optional :: dim
```
### **Description**

Calculates the Euclidean vector norm (L_2 norm) of **array** along
dimension **dim**.

### **Options**

- **array**
  : Shall be an array of type _real_.

- **dim**
  : shall be a scalar of type _integer_ with a value in the
  range from **1** to **rank(array)**.

### **Result**

The result is of the same type as **array**.

If **dim** is absent, a scalar with the square root of the sum of squares of
the elements of **array** is returned.

Otherwise, an array of rank **n-1**,
where **n** equals the rank of **array**, and a shape similar to that of **array**
with dimension DIM dropped is returned.

### **Examples**

Sample program:

```fortran
program demo_norm2
implicit none

real :: x(3,3) = reshape([ &
   1, 2, 3, &
   4, 5, 6, &
   7, 8, 9  &
],shape(x),order=[2,1])

write(*,*) 'x='
write(*,'(4x,3f4.0)')transpose(x)

write(*,*) 'norm2(x)=',norm2(x)

write(*,*) 'x**2='
write(*,'(4x,3f4.0)')transpose(x**2)
write(*,*)'sqrt(sum(x**2))=',sqrt(sum(x**2))

end program demo_norm2
```

Results:

```text
 x=
      1.  2.  3.
      4.  5.  6.
      7.  8.  9.
 norm2(x)=   16.88194
 x**2=
      1.  4.  9.
     16. 25. 36.
     49. 64. 81.
 sqrt(sum(x**2))=   16.88194
```

### **Standard**

Fortran 2008 and later

### **See Also**

[**product**(3)](#product),
[**sum**(3)](#sum),
[**hypot**(3)](#hypot)

 _fortran-lang intrinsic descriptions_
