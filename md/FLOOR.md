## floor

### **Name**

**floor**(3) - \[NUMERIC\] Function to return largest integral value
not greater than argument

### **Synopsis**
```fortran
    result = floor(a [,kind])
```
```fortran
     elemental integer(kind=kind) function floor( a ,kind )

      real(kind=KIND),intent(in) :: a
      integer,intent(in),optional :: kind
```
### **Characteristics**

where _KIND_ is any valid value for type _integer_.

### **Description**

**floor**(3) returns the greatest integer less than or equal to **a**.
That is, it picks the whole number at or to the left of the value on
the scale **-huge(int(a,kind=KIND))-1** to **huge(int(a),kind=KIND)**.

### **Options**

- **a**
  : The type shall be _real_.

- **kind**
  : (Optional) A scalar _integer_ constant initialization expression
  indicating the kind parameter of the result.

### **Result**

The return value is of type _integer(kind)_ if **kind** is present and of
default-kind _integer_ otherwise.

The result is undefined if it cannot be represented in the specified
integer type.

### **Examples**

Sample program:

```fortran
program demo_floor
implicit none
real :: x = 63.29
real :: y = -63.59
    print *, x, floor(x)
    print *, y, floor(y)
   ! elemental
   print *,floor([ &
   &  -2.7,  -2.5, -2.2, -2.0, -1.5, -1.0, -0.5, &
   &  0.0,   &
   &  +0.5,  +1.0, +1.5, +2.0, +2.2, +2.5, +2.7  ])

   ! note even a small deviation from the whole number changes the result
   print *,      [2.0,2.0-epsilon(0.0),2.0-2*epsilon(0.0)]
   print *,floor([2.0,2.0-epsilon(0.0),2.0-2*epsilon(0.0)])

   ! A=Nan, Infinity or  <huge(0_KIND)-1 < A > huge(0_KIND) is undefined
end program demo_floor
```

Results:

```text
      63.29000              63
     -63.59000             -64
             -3          -3          -3          -2          -2          -1
             -1           0           0           1           1           2
              2           2           2
      2.000000       2.000000       2.000000
              2           1           1
```

### **Standard**

Fortran 95

### **See Also**

[**ceiling**(3)](#ceiling),
[**nint**(3)](#nint)

[**aint**(3)](#aint),
[**anint**(3)](#anint),
[**int**(3)](#int),
[**selected_int_kind**(3)](#selected_int_kind)

 _fortran-lang intrinsic descriptions (license: MIT) \@urbanjost_
