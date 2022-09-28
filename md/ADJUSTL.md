## adjustl

### **Name**

**adjustl**(3) - \[CHARACTER:WHITESPACE\] Left-adjust a string

### **Synopsis**
```fortran
    result = adjustl(string)
```
```fortran
     elemental character(len=len(string)) function adjustl(string)

     character(len=*),intent(in) :: string
```
### **Description**

**adjustl(string)** will left-adjust a string by removing leading
spaces. Spaces are inserted at the end of the string as needed.

### **Options**

- **string**
  : the type shall be _character_.

### **Result**

The return value is of type _character_ and of the same kind as **string**
where leading spaces are removed and the same number of spaces are
inserted on the end of **string**.

### **Examples**

Sample program:

```fortran
program demo_adjustl
implicit none
character(len=20) :: str = '   sample string'
character(len=:),allocatable :: astr
    !
    ! basic use
    str = adjustl(str)
    write(*,'("[",a,"]")') str, trim(str)
    !
    ! an allocatable string stays the same length
    ! and is not trimmed.
    astr='    allocatable string   '
    write(*,'("[",a,"]")') adjustl(astr)
    !
end program demo_adjustl
```

Results:

```text
   [sample string       ]
   [sample string]
   [allocatable string       ]
```

### **Standard**

Fortran 95 and later

### **See Also**

[**adjustr**(3)](#adjustr)

 _fortran-lang intrinsic descriptions (license: MIT) \@urbanjost_
