## parity

### **Name**

**parity**(3) - \[TRANSFORMATIONAL\] Reduction with exclusive **OR**()

### **Syntax**
```fortran
    result = parity( mask [,dim] )
```
```fortran
     logical(kind=KIND) function parity(mask, dim)

     type(logical(kind=KIND)),intent(in)           :: mask(..)
     type(integer(kind=KINDD)),intent(in),optional :: dim
```
where KIND and LKIND are any supported kind for the type.

### **Description**

Calculates the parity (i.e. the reduction using .xor.) of __mask__ along
dimension __dim__.

### **Arguments**

  - __mask__
    : Shall be an array of type _logical_.

  - __dim__
    : (Optional) shall be a scalar of type _integer_ with a value in the
    range from __1 to n__, where __n__ equals the rank of __mask__.

### **Returns**

The result is of the same type as __mask__.

If __dim__ is absent, a scalar with the parity of all elements in __mask__
is returned: __.true.__ if an odd number of elements are __.true.__
and __.false.__ otherwise.

When __dim__ is specified the returned shape is similar to that of
__mask__ with dimension __dim__ dropped.

### **Examples**

Sample program:
```fortran
program demo_parity
implicit none
logical :: x(2) = [ .true., .false. ]
   print *, parity(x)
end program demo_parity
````
Results:
```text
    T
```
### **Standard**

Fortran 2008 and later

 _fortran-lang intrinsic descriptions_
