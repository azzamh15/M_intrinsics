## sign

### **Name**

**sign**(3) - \[NUMERIC\] Sign copying function

### **Synopsis**
```fortran
    result = sign(a, b)
```
```fortran
     elemental type(TYPE(kind=KIND))function sign(a, b)

     type(TYPE(kind=KIND)),intent(in) :: a, b
```
### **Characteristics**

where TYPE may be _real_ or _integer_ and KIND is any supported kind
for the type.

### **Description**

__sign__(a,b) return a value with the magnitude of __a__ but with the
sign of __b__.

For processors that distinguish between positive and negative zeros
__sign()__ may be used to distinguish between __real__ values 0.0 and
-0.0. SIGN (1.0, -0.0) will return  -1.0 when a negative zero is
distinguishable.

### **Options**

  - **a**
    : The value whos magnitude will be returned. Shall be of type
    _integer_ or _real_

  - **b**
    : The value whose sign will be returned. Shall be of the same type
    and kind as **a**

### **Result**

The kind of the return value is the magnitude of __a__ with the sign of
__b__. That is,

  - If __b \>= 0__ then the result is __abs(a)__
  - else if __b < 0__ it is -__abs(a)__.
  - if __b__ is _real_ and the processor distinguishes between __-0.0__
    and __0.0__ then the
    result is __-abs(a)__

### **Examples**

Sample program:
```fortran
program demo_sign
implicit none
   print *,  sign( -12,  1 )
   print *,  sign( -12,  0 )
   print *,  sign( -12, -1 )

   print *,  sign( -12.0, [1.0, 0.0, -1.0] )

   print *,  'can I distinguish 0 from -0? ', &
   &  sign( 1.0, -0.0 ) .ne. sign( 1.0, 0.0 )
end program demo_sign
````
Results:

```text
             12
             12
            -12
      12.00000       12.00000      -12.00000
    can I distinguish 0 from -0?  F
```
### **Standard**

FORTRAN 77 and later

 _fortran-lang intrinsic descriptions (license: MIT) \@urbanjost_
