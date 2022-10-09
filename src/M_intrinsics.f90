!===================================================================================================================================
!()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()=
!===================================================================================================================================
module M_intrinsics
implicit none
private
public help_intrinsics
!interface help_intrinsics
!   module procedure help_intrinsics_all
!   module procedure help_intrinsics_one
!end interface help_intrinsics
contains
!===================================================================================================================================
!()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()=
!===================================================================================================================================
function help_intrinsics(name,prefix,topic,m_help) result (textblock)
character(len=*),intent(in)                       :: name
logical,intent(in),optional                       :: prefix
logical,intent(in),optional                       :: topic
logical,intent(in),optional                       :: m_help
character(len=256),allocatable                    :: textblock(:)
character(len=:),allocatable                      :: a, b, c
integer                                           :: i, p, pg
   select case(name)
   case('','manual','intrinsics','fortranmanual','fortran_manual')
      textblock=help_intrinsics_all(prefix,topic,m_help)
   case('fortran','toc')
      textblock=help_intrinsics_section()
      do i=1,size(textblock)
         p = index(textblock(i), '[')
         pg = index(textblock(i), ']')
         if(p.gt.0.and.pg.gt.p)then
          a=textblock(i)(:p-1)
          b=textblock(i)(p:pg)
          c=textblock(i)(pg+1:)
          textblock(i)=b//' '//a//c
         endif
      enddo
      call sort_name(textblock)
   case default
      textblock=help_intrinsics_one(name,prefix,topic,m_help)
   end select
end function help_intrinsics
!===================================================================================================================================
!()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()=
!===================================================================================================================================
function help_intrinsics_section() result (textblock)

!@(#) grab lines in NAME section and append them to generate an index of manpages

character(len=256),allocatable  :: textblock(:)
character(len=256),allocatable  :: add(:)
character(len=256),allocatable  :: label
character(len=10)               :: cnum
integer                         :: i
integer                         :: icount
logical                         :: is_label
logical                         :: grab
   allocate(textblock(0))
   icount=1
   do
      write(cnum,'(i0)') icount
      add=help_intrinsics_one(cnum) ! get a document by number
      if( size(add) .eq. 0 ) exit
      label=''
      grab=.false.
      is_label=.false.
      ! look for NAME then append everything together till a line starting in column 1 that is all uppercase letters
      ! and assume that is the beginning of the next section to extract the NAME section as one line
      do i=1,size(add)
         if(add(i).eq.'')cycle
            is_label=verify(trim(add(i)),'ABCDEFGHIJKLMNOPQRSTUVWXYZ _') == 0
         if(is_label.and.add(i).eq.'NAME')then
            grab=.true.
         elseif(is_label)then
            exit
         elseif(grab)then
            label=adjustl(trim(label))//' '//adjustl(trim(add(i)))
         endif
      enddo
      textblock=[character(len=256) :: textblock,label]
      icount=icount + 1
   enddo
end function help_intrinsics_section
!===================================================================================================================================
!()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()=
!===================================================================================================================================
function help_intrinsics_all(prefix,topic,m_help) result (textblock)
logical,intent(in),optional     :: prefix
logical,intent(in),optional     :: topic
logical,intent(in),optional     :: m_help
character(len=256),allocatable  :: textblock(:)
character(len=256),allocatable  :: header(:)
character(len=256),allocatable  :: add(:)
character(len=10)               :: cnum
integer                         :: icount
   allocate(textblock(0))
   icount=1
   do
      write(cnum,'(i0)') icount
      add=help_intrinsics_one(cnum,prefix,topic,m_help)
      if( size(add) .eq. 0 ) exit
      textblock=[character(len=256) :: textblock,add]
      icount=icount + 1
   enddo
   if(present(m_help))then
      if(m_help)then
         header=[ character(len=256) :: &
         '================================================================================',    &
         'SUMMARY',    &
         ' The primary Fortran topics are',    &
         ' abs                   achar                     acos',    &
         ' acosh                 adjustl                   adjustr',    &
         ' aimag                 aint                      all',    &
         ' allocated             anint                     any',    &
         ' asin                  asinh                     associated',    &
         ' atan                  atan2                     atanh',    &
         ' atomic_add            atomic_and                atomic_cas',    &
         ' atomic_define         atomic_fetch_add          atomic_fetch_and',    &
         ' atomic_fetch_or       atomic_fetch_xor          atomic_or',    &
         ' atomic_ref            atomic_xor                backspace',    &
         ' bessel_j0             bessel_j1                 bessel_jn',    &
         ' bessel_y0             bessel_y1                 bessel_yn',    &
         ' bge                   bgt                       bit_size',    &
         ' ble                   block                     blt',    &
         ' btest                 c_associated              ceiling',    &
         ' c_f_pointer           c_f_procpointer           c_funloc',    &
         ' char                  c_loc                     close',    &
         ' cmplx                 co_broadcast              co_lbound',    &
         ' co_max                co_min                    command_argument_count',    &
         ' compiler_options      compiler_version          conjg',    &
         ' continue              co_reduce                 cos',    &
         ' cosh                  co_sum                    co_ubound',    &
         ' count                 cpu_time                  cshift',    &
         ' c_sizeof              date_and_time             dble',    &
         ' digits                dim                       dot_product',    &
         ' dprod                 dshiftl                   dshiftr',    &
         ' eoshift               epsilon                   erf',    &
         ' erfc                  erfc_scaled               event_query',    &
         ' execute_command_line  exit                      exp',    &
         ' exponent              extends_type_of           findloc',    &
         ' float                 floor                     flush',    &
         ' fraction              gamma                     get_command',    &
         ' get_command_argument  get_environment_variable  huge',    &
         ' hypot                 iachar                    iall',    &
         ' iand                  iany                      ibclr',    &
         ' ibits                 ibset                     ichar',    &
         ' ieor                  image_index               include',    &
         ' index                 int                       ior',    &
         ' iparity               is_contiguous             ishft',    &
         ' ishftc                is_iostat_end             is_iostat_eor',    &
         ' kind                  lbound                    leadz',    &
         ' len                   len_trim                  lge',    &
         ' lgt                   lle                       llt',    &
         ' log                   log10                     log_gamma',    &
         ' logical               maskl                     maskr',    &
         ' matmul                max                       maxexponent',    &
         ' maxloc                maxval                    merge',    &
         ' merge_bits            min                       minexponent',    &
         ' minloc                minval                    mod',    &
         ' modulo                move_alloc                mvbits',    &
         ' nearest               new_line                  nint',    &
         ' norm2                 not                       null',    &
         ' num_images            pack                      parity',    &
         ' popcnt                poppar                    precision',    &
         ' present               product                   radix',    &
         ' random_number         random_seed               range',    &
         ' rank                  real                      repeat',    &
         ' reshape               return                    rewind',    &
         ' rrspacing             same_type_as              scale',    &
         ' scan                  selected_char_kind        selected_int_kind',    &
         ' selected_real_kind    set_exponent              shape',    &
         ' shifta                shiftl                    shiftr',    &
         ' sign                  sin                       sinh',    &
         ' size                  sngl                      spacing',    &
         ' spread                sqrt                      stop',    &
         ' storage_size          sum                       system_clock',    &
         ' tan                   tanh                      this_image',    &
         ' tiny                  trailz                    transfer',    &
         ' transpose             trim                      ubound',    &
         ' unpack                verify',    &
         '']
         textblock=[header,textblock]
      endif
   endif
end function help_intrinsics_all
!===================================================================================================================================
!()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()=
!===================================================================================================================================
function help_intrinsics_one(name,prefix,topic,m_help) result (textblock)
character(len=*),intent(in)      :: name
logical,intent(in),optional      :: prefix
logical,intent(in),optional      :: m_help
logical,intent(in),optional      :: topic
character(len=256),allocatable   :: textblock(:)
character(len=:),allocatable     :: shortname
integer                          :: i
select case(name)

case('1','abs')

textblock=[character(len=256) :: &
'', &
'abs(3fortran)                                                    abs(3fortran)', &
'', &
'NAME', &
'  ABS(3) - [NUMERIC] Absolute value', &
'', &
'SYNOPSIS', &
'  result = abs(a)', &
'', &
'           elemental TYPE(kind=KIND) function abs(a)', &
'', &
'            TYPE(kind=KIND),intent(in) :: a', &
'', &
'CHARACTERISTICS', &
'  o  A may be any real, integer, or complex value.', &
'', &
'  o  If A is complex the returned value will be a real with the same kind as', &
'     A.', &
'', &
'     Otherwise the returned type and kind is the same as for A.', &
'', &
'DESCRIPTION', &
'  ABS(3) computes the absolute value of numeric argument A.', &
'', &
'  In mathematics, the absolute value or modulus of a real number X, denoted', &
'  |X|, is the magnitude of X without regard to its sign.', &
'', &
'  The absolute value of a number may be thought of as its distance from zero.', &
'  So for a complex value the absolute value is a real number with magnitude', &
'  SQRT(X%RE**2,X%IM**2), as if the real component is the x value and the', &
'  imaginary value is the y value for the point <x,y>.', &
'', &
'OPTIONS', &
'  o  A : The value to compute the absolute value of.', &
'', &
'RESULT', &
'  If A is of type integer or real, the value of the result is the absolute', &
'  value |A| and of the same type and kind as the input argument.', &
'', &
'  If A is complex with value (X, Y), the result is a real equal to a', &
'  processor-dependent approximation to', &
'', &
'              sqrt(x**2 + y**2)', &
'', &
'  computed without undue overflow or underflow (that means the computation of', &
'  the result can overflow the allowed magnitude of the real value returned,', &
'  and that very small values can produce underflows if they are squared while', &
'  calculating the returned value, for example).', &
'', &
'  That is, if you think of non-complex values as being complex values on the', &
'  x-axis and complex values as being x-y points <x%re,x%im> the result of', &
'  ABS(3) is the (positive) magnitude of the distance of the value from the', &
'  origin.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_abs', &
'      implicit none', &
'      integer,parameter :: dp=kind(0.0d0)', &
'', &
'      integer           :: i = -1', &
'      real              :: x = -1.0', &
'      complex           :: z = (-3.0,-4.0)', &
'      doubleprecision   :: rr = -45.78_dp', &
'', &
'      character(len=*),parameter :: &', &
'         ! some formats', &
'         frmt  =  ''(1x,a15,1x," In: ",g0,            T51," Out: ",g0)'', &', &
'         frmtc = ''(1x,a15,1x," In: (",g0,",",g0,")",T51," Out: ",g0)'',  &', &
'         g     = ''(*(g0,1x))''', &
'', &
'        ! basic usage', &
'          ! any integer, real, or complex type', &
'          write(*, frmt)  ''integer         '',  i, abs(i)', &
'          write(*, frmt)  ''real            '',  x, abs(x)', &
'          write(*, frmt)  ''doubleprecision '', rr, abs(rr)', &
'          write(*, frmtc) ''complex         '',  z, abs(z)', &
'', &
'        ! You can take the absolute value of any value whose positive value', &
'        ! is representable with the same type and kind.', &
'          write(*, *) ''abs range test : '', abs(huge(0)), abs(-huge(0))', &
'          write(*, *) ''abs range test : '', abs(huge(0.0)), abs(-huge(0.0))', &
'          write(*, *) ''abs range test : '', abs(tiny(0.0)), abs(-tiny(0.0))', &
'          ! A dusty corner is that abs(-huge(0)-1) of an integer would be', &
'          ! a representable negative value on most machines but result in a', &
'          ! positive value out of range.', &
'', &
'        ! elemental', &
'          write(*, g) '' abs is elemental:'', abs([20,  0,  -1,  -3,  100])', &
'', &
'        ! COMPLEX input produces REAL output', &
'          write(*, g)'' complex input produces real output'', &', &
'          & abs(cmplx(30.0_dp,40.0_dp,kind=dp))', &
'          ! dusty corner: "kind=dp" is required or the value returned by', &
'          ! CMPLX() is a default real instead of double precision', &
'', &
'        ! the returned value for complex input can be thought of as the', &
'        ! distance from the origin <0,0>', &
'          write(*, g) '' distance of ('', z, '') from zero is'', abs( z )', &
'          write(*, g) '' so beware of overflow with complex values''', &
'          write(*, g) abs(cmplx( huge(0.0), huge(0.0) ))', &
'          write(*, g) '' because the biggest default real is'',huge(0.0)', &
'', &
'      end program demo_abs', &
'', &
'  Results:', &
'', &
'          integer          In: -1                     Out: 1', &
'          real             In: -1.000000              Out: 1.000000', &
'          doubleprecision  In: -45.78000000000000     Out: 45.78000000000000', &
'          complex          In: (-3.000000,-4.000000)  Out: 5.000000', &
'          abs range test :   2147483647  2147483647', &
'          abs range test :   3.4028235E+38  3.4028235E+38', &
'          abs range test :   1.1754944E-38  1.1754944E-38', &
'          abs is elemental: 20 0 1 3 100', &
'          complex input produces real output 50.00000000000000', &
'          distance of ( -3.000000 -4.000000 ) from zero is 5.000000', &
'          so beware of overflow with complex values', &
'          Inf', &
'          because the biggest default real is .3402823E+39', &
'', &
'STANDARD', &
'  FORTRAN 77', &
'', &
'SEE ALSO', &
'  SIGN(3)', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022                  abs(3fortran)', &
'']

shortname="abs"
call process()


case('2','achar')

textblock=[character(len=256) :: &
'', &
'achar(3fortran)                                                achar(3fortran)', &
'', &
'NAME', &
'  ACHAR(3) - [CHARACTER:CONVERSION] Returns a character in a specified', &
'  position in the ASCII collating sequence', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                achar(3fortran)', &
'']

shortname="achar"
call process()


case('3','acos')

textblock=[character(len=256) :: &
'', &
'acos(3fortran)                                                  acos(3fortran)', &
'', &
'NAME', &
'  ACOS(3) - [MATHEMATICS:TRIGONOMETRIC] Arccosine (inverse cosine) function', &
'', &
'SYNOPSIS', &
'  result = acos(x)', &
'', &
'           elemental TYPE(kind=KIND) function acos(x)', &
'', &
'            TYPE(kind=KIND),intent(in) :: x', &
'', &
'CHARACTERISTICS', &
'  o  TYPE may be real or complex', &
'', &
'  o  KIND may be any kind supported by the associated type.', &
'', &
'  o  The returned value will be of the same type and kind as the argument.', &
'', &
'DESCRIPTION', &
'  ACOS(3) computes the arccosine of X (inverse of COS(X)).', &
'', &
'OPTIONS', &
'  o  X : The value to compute the arctangent of. : If the type is real, the', &
'     value must satisfy |X| <= 1.', &
'', &
'RESULT', &
'  The return value is of the same type and kind as X. The real part of the', &
'  result is in radians and lies in the range 0 <= ACOS(X%RE) <= PI .', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_acos', &
'      use, intrinsic :: iso_fortran_env, only : real_kinds,real32,real64,real128', &
'      implicit none', &
'      character(len=*),parameter :: all=''(*(g0,1x))''', &
'      real(kind=real64) :: x , d2r', &
'', &
'         ! basics', &
'          x = 0.866_real64', &
'          print all,''acos('',x,'') is '', acos(x)', &
'', &
'         ! acos(-1) should be PI', &
'          print all,''for reference &', &
'          &PI ~= 3.14159265358979323846264338327950288419716939937510''', &
'          write(*,*) acos(-1.0_real64)', &
'          d2r=acos(-1.0_real64)/180.0_real64', &
'          print all,''90 degrees is '', d2r*90.0_real64, '' radians''', &
'         ! elemental', &
'          print all,''elemental'',acos([-1.0,-0.5,0.0,0.50,1.0])', &
'         ! complex', &
'          print *,''complex'',acos( (-1.0,  0.0) )', &
'          print *,''complex'',acos( (-1.0, -1.0) )', &
'          print *,''complex'',acos( ( 0.0, -0.0) )', &
'          print *,''complex'',acos( ( 1.0,  0.0) )', &
'', &
'      end program demo_acos', &
'', &
'  Results:', &
'', &
'       acos( 0.86599999999999999 ) is  0.52364958093182890', &
'       for reference PI ~= 3.14159265358979323846264338327950288419716939937510', &
'          3.1415926535897931', &
'       90 degrees is  1.5707963267948966  radians', &
'       elemental 3.14159274 2.09439516 1.57079637 1.04719758 0.00000000', &
'        complex            (3.14159274,-0.00000000)', &
'        complex             (2.23703575,1.06127501)', &
'        complex             (1.57079637,0.00000000)', &
'        complex            (0.00000000,-0.00000000)', &
'', &
'STANDARD', &
'  FORTRAN 77 ; for a complex argument - Fortran 2008', &
'', &
'SEE ALSO', &
'  Inverse function: COS(3)', &
'', &
'RESOURCES', &
'  o  wikipedia: inverse trigonometric functions', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022                 acos(3fortran)', &
'']

shortname="acos"
call process()


case('4','acosh')

textblock=[character(len=256) :: &
'', &
'acosh(3fortran)                                                acosh(3fortran)', &
'', &
'NAME', &
'  ACOSH(3) - [MATHEMATICS:TRIGONOMETRIC] Inverse hyperbolic cosine function', &
'', &
'SYNOPSIS', &
'  result = acosh(x)', &
'', &
'           elemental TYPE(kind=KIND) function acosh(x)', &
'', &
'            TYPE(kind=KIND),intent(in) :: x', &
'', &
'CHARACTERISTICS', &
'  o  TYPE may be real or complex', &
'', &
'  o  KIND may be any kind supported by the associated type.', &
'', &
'  o  The returned value will be of the same type and kind as the argument.', &
'', &
'DESCRIPTION', &
'  ACOSH(3) computes the inverse hyperbolic cosine of X in radians.', &
'', &
'OPTIONS', &
'  o  X : The value to compute the hyperbolic cosine of', &
'', &
'RESULT', &
'  The result has a value equal to a processor-dependent approximation to the', &
'  inverse hyperbolic cosine function of X.', &
'', &
'  If X is complex, the imaginary part of the result is in radians and lies', &
'  between', &
'', &
'    0 <= aimag(acosh(x)) <= PI', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_acosh', &
'      use,intrinsic :: iso_fortran_env, only : dp=>real64,sp=>real32', &
'      implicit none', &
'      real(kind=dp), dimension(3) :: x = [ 1.0d0, 2.0d0, 3.0d0 ]', &
'         write (*,*) acosh(x)', &
'      end program demo_acosh', &
'', &
'  Results:', &
'', &
'       0.000000000000000E+000   1.31695789692482        1.76274717403909', &
'', &
'STANDARD', &
'  Fortran 2008', &
'', &
'SEE ALSO', &
'  Inverse function: COSH(3)', &
'', &
'RESOURCES', &
'  o  Wikipedia:hyperbolic functions', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022                acosh(3fortran)', &
'']

shortname="acosh"
call process()


case('5','adjustl')

textblock=[character(len=256) :: &
'', &
'adjustl(3fortran)                                            adjustl(3fortran)', &
'', &
'NAME', &
'  ADJUSTL(3) - [CHARACTER:WHITESPACE] Left-justified a string', &
'', &
'SYNOPSIS', &
'  result = adjustl(string)', &
'', &
'         elemental character(len=len(string),kind=KIND) function adjustl(string)', &
'', &
'          character(len=*,kind=KIND),intent(in) :: string', &
'', &
'CHARACTERISTICS', &
'  o  STRING is a character variable of any supported kind', &
'', &
'  o  The return value is a character variable of the same kind and length as', &
'     STRING', &
'', &
'DESCRIPTION', &
'  ADJUSTL(3) will left-justify a string by removing leading spaces. Spaces are', &
'  inserted at the end of the string as needed.', &
'', &
'OPTIONS', &
'  o  STRING : the string to left-justify', &
'', &
'RESULT', &
'  A copy of STRING where leading spaces are removed and the same number of', &
'  spaces are inserted on the end of STRING.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_adjustl', &
'      implicit none', &
'      character(len=20) :: str = ''   sample string''', &
'      character(len=:),allocatable :: astr', &
'      integer :: length', &
'', &
'         ! basic use', &
'          write(*,''(a,"[",a,"]")'') ''original: '',str', &
'          str=adjustl(str)', &
'          write(*,''(a,"[",a,"]")'') ''adjusted: '',str', &
'', &
'          ! a fixed-length string can be printed', &
'          ! trimmed using trim(3f) or len_trim(3f)', &
'          write(*,''(a,"[",a,"]")'') ''trimmed:  '',trim(str)', &
'          length=len_trim(str)', &
'          write(*,''(a,"[",a,"]")'') ''substring:'',str(:length)', &
'', &
'          ! note an allocatable string stays the same length too', &
'          ! and is not trimmed by just an adjustl(3f) call.', &
'          astr=''    allocatable string   ''', &
'          write(*,''(a,"[",a,"]")'') ''original:'',astr', &
'          astr = adjustl(astr)', &
'          write(*,''(a,"[",a,"]")'') ''adjusted:'',astr', &
'          ! trim(3f) can be used to change the length', &
'          astr = trim(astr)', &
'          write(*,''(a,"[",a,"]")'') ''trimmed: '',astr', &
'', &
'      end program demo_adjustl', &
'', &
'  Results:', &
'', &
'         original: [   sample string    ]', &
'         adjusted: [sample string       ]', &
'         trimmed:  [sample string]', &
'         substring:[sample string]', &
'         original:[    allocatable string   ]', &
'         adjusted:[allocatable string       ]', &
'         trimmed: [allocatable string]', &
'', &
'STANDARD', &
'  Fortran 95', &
'', &
'SEE ALSO', &
'  ADJUSTR(3), TRIM(3)', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022              adjustl(3fortran)', &
'']

shortname="adjustl"
call process()


case('6','adjustr')

textblock=[character(len=256) :: &
'', &
'adjustr(3fortran)                                            adjustr(3fortran)', &
'', &
'NAME', &
'  ADJUSTR(3) - [CHARACTER:WHITESPACE] Right-justify a string', &
'', &
'SYNOPSIS', &
'  result = adjustr(string)', &
'', &
'         elemental character(len=len(string),kind=KIND) function adjustr(string)', &
'', &
'          character(len=*,kind=KIND),intent(in) :: string', &
'', &
'CHARACTERISTICS', &
'  o  STRING is a character variable', &
'', &
'  o  The return value is a character variable of the same kind and length as', &
'     STRING', &
'', &
'DESCRIPTION', &
'  ADJUSTR(3) right-justifies a string by removing trailing spaces. Spaces are', &
'  inserted at the start of the string as needed to retain the original length.', &
'', &
'OPTIONS', &
'  o  STRING : the string to right-justify', &
'', &
'RESULT', &
'  Trailing spaces are removed and the same number of spaces are inserted at', &
'  the start of STRING.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_adjustr', &
'      implicit none', &
'      character(len=20) :: str', &
'         ! print a short number line', &
'         write(*,''(a)'')repeat(''1234567890'',2)', &
'', &
'        ! basic usage', &
'         str = ''  sample string ''', &
'         write(*,''(a)'') str', &
'         str = adjustr(str)', &
'         write(*,''(a)'') str', &
'', &
'         !', &
'         ! elemental', &
'         !', &
'         write(*,''(a)'')repeat(''1234567890'',5)', &
'         write(*,''(a)'')adjustr([character(len=50) :: &', &
'         ''  first           '', &', &
'         ''     second       '', &', &
'         ''         third    '' ])', &
'         write(*,''(a)'')repeat(''1234567890'',5)', &
'', &
'      end program demo_adjustr', &
'', &
'  Results:', &
'', &
'         12345678901234567890', &
'           sample string', &
'                sample string', &
'         12345678901234567890123456789012345678901234567890', &
'                                                      first', &
'                                                     second', &
'                                                      third', &
'         12345678901234567890123456789012345678901234567890', &
'', &
'STANDARD', &
'  Fortran 95', &
'', &
'SEE ALSO', &
'  ADJUSTL(3), TRIM(3)', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022              adjustr(3fortran)', &
'']

shortname="adjustr"
call process()


case('7','aimag')

textblock=[character(len=256) :: &
'', &
'aimag(3fortran)                                                aimag(3fortran)', &
'', &
'NAME', &
'  AIMAG(3) - [TYPE:NUMERIC] Imaginary part of complex number', &
'', &
'SYNOPSIS', &
'  result = aimag(z)', &
'', &
'           elemental complex(kind=KIND) function aimag(z)', &
'', &
'            complex(kind=KIND),intent(in) :: z', &
'', &
'CHARACTERISTICS', &
'  o  The type of the argument Z shall be complex and any supported complex', &
'     kind', &
'', &
'  o  The return value is of type real with the kind type parameter of the', &
'     argument.', &
'', &
'DESCRIPTION', &
'  AIMAG(3) yields the imaginary part of the complex argument Z.', &
'', &
'  This is similar to the modern complex-part-designator %IM which also', &
'  designates the imaginary part of a value, accept a designator can appear on', &
'  the left-hand side of an assignment as well, as in VAL%IM=10.0.', &
'', &
'OPTIONS', &
'  o  Z : The complex value to extract the imaginary component of.', &
'', &
'RESULT', &
'  The return value is a real value with the magnitude and sign of the', &
'  imaginary component of the argument Z.', &
'', &
'  That is, If Z has the value (X,Y), the result has the value Y.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_aimag', &
'      use, intrinsic :: iso_fortran_env, only : real_kinds, &', &
'       & real32, real64, real128', &
'      implicit none', &
'      character(len=*),parameter :: g=''(*(1x,g0))''', &
'      complex              :: z4', &
'      complex(kind=real64) :: z8', &
'         ! basics', &
'          z4 = cmplx(1.e0, 2.e0)', &
'          print *, ''value='',z4', &
'          print g, ''imaginary part='',aimag(z4),''or'', z4%im', &
'', &
'          ! other kinds other than the default may be supported', &
'          z8 = cmplx(3.e0_real64, 4.e0_real64,kind=real64)', &
'          print *, ''value='',z8', &
'          print g, ''imaginary part='',aimag(z8),''or'', z8%im', &
'', &
'          ! an elemental function can be passed an array', &
'          print *', &
'          print *, [z4,z4/2.0,z4+z4,z4**3]', &
'          print *', &
'          print *, aimag([z4,z4/2.0,z4+z4,z4**3])', &
'', &
'      end program demo_aimag', &
'', &
'  Results:', &
'', &
'       value= (1.00000000,2.00000000)', &
'       imaginary part= 2.00000000 or 2.00000000', &
'       value= (3.0000000000000000,4.0000000000000000)', &
'       imaginary part= 4.0000000000000000 or 4.0000000000000000', &
'', &
'       (1.00000000,2.00000000) (0.500000000,1.00000000) (2.00000000,4.00000000)', &
'       (-11.0000000,-2.00000000)', &
'', &
'         2.00000000       1.00000000       4.00000000      -2.00000000', &
'', &
'STANDARD', &
'  FORTRAN 77', &
'', &
'SEE ALSO', &
'  o  CMPLX(3) - Complex conversion function', &
'', &
'  o  CONJG(3) - Complex conjugate function', &
'', &
'  o  REAL(3) - Convert to real type', &
'', &
'  Fortran has strong support for complex values, including many intrinsics', &
'  that take or produce complex values in addition to algebraic and logical', &
'  expressions:', &
'', &
'  ABS(3), ACOSH(3), ACOS(3), ASINH(3), ASIN(3), ATAN2(3), ATANH(3), ATAN(3),', &
'  COSH(3), COS(3), CO_SUM(3), DBLE(3), DOT_PRODUCT(3), EXP(3), INT(3),', &
'  IS_CONTIGUOUS(3), KIND(3), LOG(3), MATMUL(3), PRECISION(3), PRODUCT(3),', &
'  RANGE(3), RANK(3), SINH(3), SIN(3), SQRT(3), STORAGE_SIZE(3), SUM(3),', &
'  TANH(3), TAN(3), UNPACK(3),', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022                aimag(3fortran)', &
'']

shortname="aimag"
call process()


case('8','aint')

textblock=[character(len=256) :: &
'', &
'aint(3fortran)                                                  aint(3fortran)', &
'', &
'NAME', &
'  AINT(3) - [NUMERIC] Truncate toward zero to a whole number', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                 aint(3fortran)', &
'']

shortname="aint"
call process()


case('9','all')

textblock=[character(len=256) :: &
'', &
'all(3fortran)                                                    all(3fortran)', &
'', &
'NAME', &
'  ALL(3) - [ARRAY:REDUCTION] Determines if all the values are true', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                  all(3fortran)', &
'']

shortname="all"
call process()


case('10','allocated')

textblock=[character(len=256) :: &
'', &
'allocated(3fortran)                                        allocated(3fortran)', &
'', &
'NAME', &
'  ALLOCATED(3) - [ARRAY:INQUIRY] Status of an allocatable entity', &
'', &
'SYNOPSIS', &
'  result = allocated(entity)', &
'', &
'           logical function allocated(entity)', &
'', &
'            type(TYPE(kind=KIND)),allocatable :: entity(..)', &
'', &
'CHARACTERISTICS', &
'  where ENTITY may be any allocatable scalar or array object of any type.', &
'', &
'DESCRIPTION', &
'  ALLOCATED(3) checks the allocation status of both arrays and scalars.', &
'', &
'OPTIONS', &
'  o  ENTITY : the allocatable object to test.', &
'', &
'RESULT', &
'  If the argument is allocated then the result is .true.; otherwise, it', &
'  returns .false..', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_allocated', &
'      use,intrinsic :: iso_fortran_env, only : dp=>real64,sp=>real32', &
'      implicit none', &
'      real(kind=sp), allocatable :: x(:)', &
'      character(len=256) :: message', &
'      integer :: istat', &
'        ! basics', &
'         if( allocated(x)) then', &
'             write(*,*)''do things if allocated''', &
'         else', &
'             write(*,*)''do things if not allocated''', &
'         endif', &
'', &
'         ! if already allocated, deallocate', &
'         if ( allocated(x) ) deallocate(x,STAT=istat, ERRMSG=message )', &
'         if(istat.ne.0)then', &
'            write(*,*)trim(message)', &
'            stop', &
'         endif', &
'', &
'         ! only if not allocated, allocate', &
'         if ( .not. allocated(x) ) allocate(x(20))', &
'', &
'        ! allocation and intent(out)', &
'         call intentout(x)', &
'         write(*,*)''note it is deallocated!'',allocated(x)', &
'', &
'         contains', &
'', &
'         subroutine intentout(arr)', &
'         ! note that if arr has intent(out) and is allocatable,', &
'         ! arr is deallocated on entry', &
'         real(kind=sp),intent(out),allocatable :: arr(:)', &
'             write(*,*)''note it was allocated in calling program'',allocated(arr)', &
'         end subroutine intentout', &
'', &
'      end program demo_allocated', &
'', &
'  Results:', &
'', &
'          T           4', &
'          do things if allocated', &
'          note it was allocated in calling program F', &
'          note it is deallocated! F', &
'', &
'STANDARD', &
'  Fortran 95. allocatable scalar entities were added in Fortran 2003.', &
'', &
'SEE ALSO', &
'  MOVE_ALLOC(3)', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022            allocated(3fortran)', &
'']

shortname="allocated"
call process()


case('11','anint')

textblock=[character(len=256) :: &
'', &
'anint(3fortran)                                                anint(3fortran)', &
'', &
'NAME', &
'  ANINT(3) - [NUMERIC] Nearest whole number', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                anint(3fortran)', &
'']

shortname="anint"
call process()


case('12','any')

textblock=[character(len=256) :: &
'', &
'any(3fortran)                                                    any(3fortran)', &
'', &
'NAME', &
'  ANY(3) - [ARRAY:REDUCTION] Determines if any of the values in the logical', &
'  array are .true.', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                  any(3fortran)', &
'']

shortname="any"
call process()


case('13','asin')

textblock=[character(len=256) :: &
'', &
'asin(3fortran)                                                  asin(3fortran)', &
'', &
'NAME', &
'  ASIN(3) - [MATHEMATICS:TRIGONOMETRIC] Arcsine function', &
'', &
'SYNOPSIS', &
'  result = asin(x)', &
'', &
'           elemental TYPE(kind=KIND) function asin(x)', &
'', &
'            TYPE(kind=KIND) :: x', &
'', &
'CHARACTERISTICS', &
'  o  TYPE may be real or complex', &
'', &
'  o  KIND may be any kind supported by the associated type.', &
'', &
'  o  The returned value will be of the same type and kind as the argument.', &
'', &
'DESCRIPTION', &
'  ASIN(3) computes the arcsine of its argument X.', &
'', &
'  The arcsine is the inverse function of the sine function. It is commonly', &
'  used in trigonometry when trying to find the angle when the lengths of the', &
'  hypotenuse and the opposite side of a right triangle are known.', &
'', &
'OPTIONS', &
'  o  X : The value to compute the arcsine of : The type shall be either real', &
'     and a magnitude that is less than or equal to one; or be complex.', &
'', &
'RESULT', &
'  o  RESULT The result has a value equal to a processor-dependent', &
'     approximation to arcsin(x).', &
'', &
'     If X is real the result is real and it is expressed in radians and lies', &
'     in the range', &
'', &
'                 PI/2 <= ASIN (X) <= PI/2.', &
'', &
'     If the argument (and therefore the result) is imaginary The real part of', &
'     the result is in radians and lies in the range', &
'', &
'             -PI/2 <= real(asin(x)) <= PI/2', &
'', &
'EXAMPLES', &
'  The arcsine will allow you to find the measure of a right angle when you', &
'  know the ratio of the side opposite the angle to the hypotenuse.', &
'', &
'  So if you knew that a train track rose 1.25 vertical miles on a track that', &
'  was 50 miles long, you could determine the average angle of incline of the', &
'  track using the arcsine. Given', &
'', &
'       sin(theta) = 1.25 miles/50 miles (opposite/hypotenuse)', &
'', &
'  Sample program:', &
'', &
'      program demo_asin', &
'      use, intrinsic :: iso_fortran_env, only : dp=>real64', &
'      implicit none', &
'      ! value to convert degrees to radians', &
'      real(kind=dp),parameter :: D2R=acos(-1.0_dp)/180.0_dp', &
'      real(kind=dp)           :: angle, rise, run', &
'      character(len=*),parameter :: all=''(*(g0,1x))''', &
'        ! given sine(theta) = 1.25 miles/50 miles (opposite/hypotenuse)', &
'        ! then taking the arcsine of both sides of the equality yields', &
'        ! theta = arcsine(1.25 miles/50 miles) ie. arcsine(opposite/hypotenuse)', &
'        rise=1.250_dp', &
'        run=50.00_dp', &
'        angle = asin(rise/run)', &
'        print all, ''angle of incline(radians) = '', angle', &
'        angle = angle/D2R', &
'        print all, ''angle of incline(degrees) = '', angle', &
'', &
'        print all, ''percent grade='',rise/run*100.0_dp', &
'      end program demo_asin', &
'', &
'  Results:', &
'', &
'          angle of incline(radians) =    2.5002604899361139E-002', &
'          angle of incline(degrees) =    1.4325437375665075', &
'          percent grade=   2.5000000000000000', &
'', &
'  The percentage grade is the slope, written as a percent. To calculate the', &
'  slope you divide the rise by the run. In the example the rise is 1.25 mile', &
'  over a run of 50 miles so the slope is 1.25/50 = 0.025.  Written as a', &
'  percent this is 2.5 %.', &
'', &
'  For the US, two and 1/2 percent is generally thought of as the upper limit.', &
'  This means a rise of 2.5 feet when going 100 feet forward. In the US this', &
'  was the maximum grade on the first major US railroad, the Baltimore and', &
'  Ohio. Note curves increase the frictional drag on a train reducing the', &
'  allowable grade.', &
'', &
'STANDARD', &
'  FORTRAN 77 , for a complex argument Fortran 2008', &
'', &
'SEE ALSO', &
'  Inverse function: SIN(3)', &
'', &
'RESOURCES', &
'  o  wikipedia: inverse trigonometric functions', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022                 asin(3fortran)', &
'']

shortname="asin"
call process()


case('14','asinh')

textblock=[character(len=256) :: &
'', &
'asinh(3fortran)                                                asinh(3fortran)', &
'', &
'NAME', &
'  ASINH(3) - [MATHEMATICS:TRIGONOMETRIC] Inverse hyperbolic sine function', &
'', &
'SYNOPSIS', &
'  result = asinh(x)', &
'', &
'           elemental TYPE(kind=KIND) function asinh(x)', &
'', &
'            TYPE(kind=KIND) :: x', &
'', &
'CHARACTERISTICS', &
'  o  TYPE may be real or complex', &
'', &
'  o  KIND may be any kind supported by the associated type.', &
'', &
'  o  The returned value will be of the same type and kind as the argument.', &
'', &
'DESCRIPTION', &
'  ASINH(3) computes the inverse hyperbolic sine of X.', &
'', &
'OPTIONS', &
'  o  X : The value to compute the inverse hyperbolic sine of', &
'', &
'RESULT', &
'  The return value is of the same type and kind as X. If X is complex, the', &
'  imaginary part of the result is in radians and lies between -PI/2 <=', &
'  AIMAG(ASINH(X)) <= PI/2.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_asinh', &
'      use,intrinsic :: iso_fortran_env, only : dp=>real64,sp=>real32', &
'      implicit none', &
'      real(kind=dp), dimension(3) :: x = [ -1.0d0, 0.0d0, 1.0d0 ]', &
'', &
'          write (*,*) asinh(x)', &
'', &
'      end program demo_asinh', &
'', &
'  Results:', &
'', &
'        -0.88137358701954305  0.0000000000000000  0.88137358701954305', &
'', &
'STANDARD', &
'  Fortran 2008', &
'', &
'SEE ALSO', &
'  Inverse function: SINH(3)', &
'', &
'RESOURCES', &
'  o  Wikipedia:hyperbolic functions', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022                asinh(3fortran)', &
'']

shortname="asinh"
call process()


case('15','associated')

textblock=[character(len=256) :: &
'', &
'associated(3fortran)                                      associated(3fortran)', &
'', &
'NAME', &
'  ASSOCIATED(3) - [STATE] Status of a pointer or pointer/target pair', &
'', &
'SYNOPSIS', &
'                               October 09, 2022           associated(3fortran)', &
'']

shortname="associated"
call process()


case('16','atan2')

textblock=[character(len=256) :: &
'', &
'atan2(3fortran)                                                atan2(3fortran)', &
'', &
'NAME', &
'  ATAN2(3) - [MATHEMATICS:TRIGONOMETRIC] Arctangent (inverse tangent) function', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                atan2(3fortran)', &
'']

shortname="atan2"
call process()


case('17','atan')

textblock=[character(len=256) :: &
'', &
'atan(3fortran)                                                  atan(3fortran)', &
'', &
'NAME', &
'  ATAN(3) - [MATHEMATICS:TRIGONOMETRIC] Arctangent function', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                 atan(3fortran)', &
'']

shortname="atan"
call process()


case('18','atanh')

textblock=[character(len=256) :: &
'', &
'atanh(3fortran)                                                atanh(3fortran)', &
'', &
'NAME', &
'  ATANH(3) - [MATHEMATICS:TRIGONOMETRIC] Inverse hyperbolic tangent function', &
'', &
'SYNOPSIS', &
'  result = atanh(x)', &
'', &
'           elemental TYPE(kind=KIND) function atanh(x)', &
'', &
'            TYPE(kind=KIND),intent(in) :: x', &
'', &
'CHARACTERISTICS', &
'  o  TYPE may be real or complex', &
'', &
'  o  KIND may be any kind supported by the associated type.', &
'', &
'  o  The returned value will be of the same type and kind as the argument.', &
'', &
'DESCRIPTION', &
'  ATANH(3) computes the inverse hyperbolic tangent of X.', &
'', &
'OPTIONS', &
'  o  X : The type shall be real or complex.', &
'', &
'RESULT', &
'  The return value has same type and kind as X. If X is complex, the imaginary', &
'  part of the result is in radians and lies between', &
'', &
'           **-PI/2 <= aimag(atanh(x)) <= PI/2**', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_atanh', &
'      implicit none', &
'      real, dimension(3) :: x = [ -1.0, 0.0, 1.0 ]', &
'', &
'         write (*,*) atanh(x)', &
'', &
'      end program demo_atanh', &
'', &
'  Results:', &
'', &
'         -Infinity   0.00000000             Infinity', &
'', &
'STANDARD', &
'  Fortran 2008', &
'', &
'SEE ALSO', &
'  Inverse function: TANH(3)', &
'', &
'RESOURCES', &
'  o  Wikipedia:hyperbolic functions', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022                atanh(3fortran)', &
'']

shortname="atanh"
call process()


case('19','atomic_add')

textblock=[character(len=256) :: &
'', &
'atomic_add(3fortran)                                      atomic_add(3fortran)', &
'', &
'NAME', &
'  ATOMIC_ADD(3) - [ATOMIC] Atomic ADD operation', &
'', &
'SYNOPSIS', &
'                               October 09, 2022           atomic_add(3fortran)', &
'']

shortname="atomic_add"
call process()


case('20','atomic_and')

textblock=[character(len=256) :: &
'', &
'atomic_and(3fortran)                                      atomic_and(3fortran)', &
'', &
'NAME', &
'  ATOMIC_AND(3) - [ATOMIC:BIT MANIPULATION] Atomic bitwise AND operation', &
'', &
'SYNOPSIS', &
'                               October 09, 2022           atomic_and(3fortran)', &
'']

shortname="atomic_and"
call process()


case('21','atomic_cas')

textblock=[character(len=256) :: &
'', &
'atomic_cas(3fortran)                                      atomic_cas(3fortran)', &
'', &
'NAME', &
'  ATOMIC_CAS(3) - [ATOMIC] Atomic compare and swap', &
'', &
'SYNOPSIS', &
'                               October 09, 2022           atomic_cas(3fortran)', &
'']

shortname="atomic_cas"
call process()


case('22','atomic_define')

textblock=[character(len=256) :: &
'', &
'atomic_define(3fortran)                                atomic_define(3fortran)', &
'', &
'NAME', &
'  ATOMIC_DEFINE(3) - [ATOMIC] Setting a variable atomically', &
'', &
'SYNOPSIS', &
'                               October 09, 2022        atomic_define(3fortran)', &
'']

shortname="atomic_define"
call process()


case('23','atomic_fetch_add')

textblock=[character(len=256) :: &
'', &
'atomic_fetch_add(3fortran)                          atomic_fetch_add(3fortran)', &
'', &
'NAME', &
'  ATOMIC_FETCH_ADD(3) - [ATOMIC] Atomic ADD operation with prior fetch', &
'', &
'SYNOPSIS', &
'                               October 09, 2022     atomic_fetch_add(3fortran)', &
'']

shortname="atomic_fetch_add"
call process()


case('24','atomic_fetch_and')

textblock=[character(len=256) :: &
'', &
'atomic_fetch_and(3fortran)                          atomic_fetch_and(3fortran)', &
'', &
'NAME', &
'  ATOMIC_FETCH_AND(3) - [ATOMIC:BIT MANIPULATION] Atomic bitwise AND operation', &
'  with prior fetch', &
'', &
'SYNOPSIS', &
'                               October 09, 2022     atomic_fetch_and(3fortran)', &
'']

shortname="atomic_fetch_and"
call process()


case('25','atomic_fetch_or')

textblock=[character(len=256) :: &
'', &
'atomic_fetch_or(3fortran)                            atomic_fetch_or(3fortran)', &
'', &
'NAME', &
'  ATOMIC_FETCH_OR(3) - [ATOMIC:BIT MANIPULATION] Atomic bitwise OR operation', &
'  with prior fetch', &
'', &
'SYNOPSIS', &
'                               October 09, 2022      atomic_fetch_or(3fortran)', &
'']

shortname="atomic_fetch_or"
call process()


case('26','atomic_fetch_xor')

textblock=[character(len=256) :: &
'', &
'atomic_fetch_xor(3fortran)                          atomic_fetch_xor(3fortran)', &
'', &
'NAME', &
'  ATOMIC_FETCH_XOR(3) - [ATOMIC:BIT MANIPULATION] Atomic bitwise XOR operation', &
'  with prior fetch', &
'', &
'SYNOPSIS', &
'                               October 09, 2022     atomic_fetch_xor(3fortran)', &
'']

shortname="atomic_fetch_xor"
call process()


case('27','atomic_or')

textblock=[character(len=256) :: &
'', &
'atomic_or(3fortran)                                        atomic_or(3fortran)', &
'', &
'NAME', &
'  ATOMIC_OR(3) - [ATOMIC:BIT MANIPULATION] Atomic bitwise OR operation', &
'', &
'SYNOPSIS', &
'                               October 09, 2022            atomic_or(3fortran)', &
'']

shortname="atomic_or"
call process()


case('28','atomic_ref')

textblock=[character(len=256) :: &
'', &
'atomic_ref(3fortran)                                      atomic_ref(3fortran)', &
'', &
'NAME', &
'  ATOMIC_REF(3) - [ATOMIC] Obtaining the value of a variable atomically', &
'', &
'SYNOPSIS', &
'                               October 09, 2022           atomic_ref(3fortran)', &
'']

shortname="atomic_ref"
call process()


case('29','atomic_xor')

textblock=[character(len=256) :: &
'', &
'atomic_xor(3fortran)                                      atomic_xor(3fortran)', &
'', &
'NAME', &
'  ATOMIC_XOR(3) - [ATOMIC:BIT MANIPULATION] Atomic bitwise OR operation', &
'', &
'SYNOPSIS', &
'                               October 09, 2022           atomic_xor(3fortran)', &
'']

shortname="atomic_xor"
call process()


case('30','bessel_j0')

textblock=[character(len=256) :: &
'', &
'bessel_j0(3fortran)                                        bessel_j0(3fortran)', &
'', &
'NAME', &
'  BESSEL_J0(3) - [MATHEMATICS] Bessel function of the first kind of order 0', &
'', &
'SYNOPSIS', &
'  result = bessel_j0(x)', &
'', &
'           elemental real(kind=KIND) function bessel_j0(x)', &
'', &
'            real(kind=KIND),intent(in) :: x', &
'', &
'CHARACTERISTICS', &
'  o  KIND may be any KIND supported by the real type.', &
'', &
'  o  The result is the same type and kind as X.', &
'', &
'DESCRIPTION', &
'  BESSEL_J0(3) computes the Bessel function of the first kind of order 0 of X.', &
'', &
'OPTIONS', &
'  o  X : The value to operate on.', &
'', &
'RESULT', &
'  the Bessel function of the first kind of order 0 of X. The result lies in', &
'  the range -0.4027 <= BESSEL(0,X) <= 1.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_bessel_j0', &
'      use, intrinsic :: iso_fortran_env, only : real_kinds, &', &
'      & real32, real64, real128', &
'         implicit none', &
'         real(kind=real64) :: x = 0.0_real64', &
'         x = bessel_j0(x)', &
'         write(*,*)x', &
'      end program demo_bessel_j0', &
'', &
'  Results:', &
'', &
'            1.0000000000000000', &
'', &
'STANDARD', &
'  Fortran 2008', &
'', &
'SEE ALSO', &
'  BESSEL_J1(3), BESSEL_JN(3), BESSEL_Y0(3), BESSEL_Y1(3), BESSEL_YN(3)', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022            bessel_j0(3fortran)', &
'']

shortname="bessel_j0"
call process()


case('31','bessel_j1')

textblock=[character(len=256) :: &
'', &
'bessel_j1(3fortran)                                        bessel_j1(3fortran)', &
'', &
'NAME', &
'  BESSEL_J1(3) - [MATHEMATICS] Bessel function of the first kind of order 1', &
'', &
'SYNOPSIS', &
'  result = bessel_j1(x)', &
'', &
'           elemental real(kind=KIND) function bessel_j1(x)', &
'', &
'            real(kind=KIND),intent(in) :: x', &
'', &
'CHARACTERISTICS', &
'  o  KIND may be any supported real KIND.', &
'', &
'DESCRIPTION', &
'  BESSEL_J1(3) computes the Bessel function of the first kind of order 1 of X.', &
'', &
'OPTIONS', &
'  o  X : The type shall be real.', &
'', &
'RESULT', &
'  The return value is of type real and lies in the range -0.5818 <=', &
'  BESSEL(0,X) <= 0.5818 . It has the same kind as X.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_bessel_j1', &
'      use, intrinsic :: iso_fortran_env, only : real_kinds, &', &
'       & real32, real64, real128', &
'      implicit none', &
'      real(kind=real64) :: x = 1.0_real64', &
'         x = bessel_j1(x)', &
'         write(*,*)x', &
'      end program demo_bessel_j1', &
'', &
'  Results:', &
'', &
'           0.44005058574493350', &
'', &
'STANDARD', &
'  Fortran 2008', &
'', &
'SEE ALSO', &
'  BESSEL_J0(3), BESSEL_JN(3), BESSEL_Y0(3), BESSEL_Y1(3), BESSEL_YN(3)', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022            bessel_j1(3fortran)', &
'']

shortname="bessel_j1"
call process()


case('32','bessel_jn')

textblock=[character(len=256) :: &
'', &
'bessel_jn(3fortran)                                        bessel_jn(3fortran)', &
'', &
'NAME', &
'  BESSEL_JN(3) - [MATHEMATICS] Bessel function of the first kind', &
'', &
'SYNOPSIS', &
'                               October 09, 2022            bessel_jn(3fortran)', &
'']

shortname="bessel_jn"
call process()


case('33','bessel_y0')

textblock=[character(len=256) :: &
'', &
'bessel_y0(3fortran)                                        bessel_y0(3fortran)', &
'', &
'NAME', &
'  BESSEL_Y0(3) - [MATHEMATICS] Bessel function of the second kind of order 0', &
'', &
'SYNOPSIS', &
'  result = bessel_y0(x)', &
'', &
'           elemental real(kind=KIND) function bessel_y0(x)', &
'', &
'            real(kind=KIND),intent(in) :: x', &
'', &
'CHARACTERISTICS', &
'  o  KIND may be any supported real KIND.', &
'', &
'DESCRIPTION', &
'  BESSEL_Y0(3) computes the Bessel function of the second kind of order 0 of', &
'  X.', &
'', &
'OPTIONS', &
'  o  X : The type shall be real.', &
'', &
'RESULT', &
'  The return value is of type real. It has the same kind as X.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_bessel_y0', &
'      use, intrinsic :: iso_fortran_env, only : real_kinds, &', &
'      & real32, real64, real128', &
'      implicit none', &
'        real(kind=real64) :: x = 0.0_real64', &
'        x = bessel_y0(x)', &
'        write(*,*)x', &
'      end program demo_bessel_y0', &
'', &
'  Results:', &
'', &
'                          -Infinity', &
'', &
'STANDARD', &
'  Fortran 2008', &
'', &
'SEE ALSO', &
'  BESSEL_J0(3), BESSEL_J1(3), BESSEL_JN(3), BESSEL_Y1(3), BESSEL_YN(3)', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022            bessel_y0(3fortran)', &
'']

shortname="bessel_y0"
call process()


case('34','bessel_y1')

textblock=[character(len=256) :: &
'', &
'bessel_y1(3fortran)                                        bessel_y1(3fortran)', &
'', &
'NAME', &
'  BESSEL_Y1(3) - [MATHEMATICS] Bessel function of the second kind of order 1', &
'', &
'SYNOPSIS', &
'  result = bessel_y1(x)', &
'', &
'           elemental real(kind=KIND) function bessel_y1(x)', &
'', &
'            real(kind=KIND),intent(in) :: x', &
'', &
'CHARACTERISTICS', &
'  o  KIND may be any supported real KIND.', &
'', &
'DESCRIPTION', &
'  BESSEL_Y1(3) computes the Bessel function of the second kind of order 1 of', &
'  X.', &
'', &
'OPTIONS', &
'  o  X : The type shall be real.', &
'', &
'RESULT', &
'  The return value is real. It has the same kind as X.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_bessel_y1', &
'      use, intrinsic :: iso_fortran_env, only : real_kinds, &', &
'      & real32, real64, real128', &
'      implicit none', &
'        real(kind=real64) :: x = 1.0_real64', &
'        write(*,*)x, bessel_y1(x)', &
'      end program demo_bessel_y1', &
'', &
'STANDARD', &
'  Fortran 2008', &
'', &
'SEE ALSO', &
'  BESSEL_J0(3), BESSEL_J1(3), BESSEL_JN(3), BESSEL_Y0(3), BESSEL_YN(3)', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022            bessel_y1(3fortran)', &
'']

shortname="bessel_y1"
call process()


case('35','bessel_yn')

textblock=[character(len=256) :: &
'', &
'bessel_yn(3fortran)                                        bessel_yn(3fortran)', &
'', &
'NAME', &
'  BESSEL_YN(3) - [MATHEMATICS] Bessel function of the second kind', &
'', &
'SYNOPSIS', &
'                               October 09, 2022            bessel_yn(3fortran)', &
'']

shortname="bessel_yn"
call process()


case('36','bge')

textblock=[character(len=256) :: &
'', &
'bge(3fortran)                                                    bge(3fortran)', &
'', &
'NAME', &
'  BGE(3) - [BIT:COMPARE] Bitwise greater than or equal to', &
'', &
'SYNOPSIS', &
'  result = bge(i,j)', &
'', &
'            elemental logical function bge(i, j)', &
'', &
'             integer(kind=**),intent(in) :: i', &
'             integer(kind=**),intent(in) :: j', &
'', &
'CHARACTERISTICS', &
'  o  a kind designated as ** may be any supported kind value for the type', &
'', &
'  o  the integer kind of I and J may not necessarily be the same. In addition,', &
'     values may be a BOZ constant with a value valid for the integer kind', &
'     available with the most bits on the current platform.', &
'', &
'  o  The return value is of type logical and of the default kind.', &
'', &
'DESCRIPTION', &
'  BGE(3) Determines whether one integer is bitwise greater than or equal to', &
'  another.', &
'', &
'  The bit-level representation of a value is platform dependent. The endian-', &
'  ness of a system and whether the system uses a "two''s complement"', &
'  representation of signs can affect the results, for example.', &
'', &
'  A BOZ constant (Binary, Octal, Hexadecimal) does not have a kind or type of', &
'  its own, so be aware it is subject to truncation when transferred to an', &
'  integer type. The most bits the constant may contain is limited by the most', &
'  bits representable by any integer kind supported by the compilation.', &
'', &
'  Bit Sequence Comparison', &
'', &
'  When bit sequences of unequal length are compared, the shorter sequence is', &
'  padded with zero bits on the left to the same length as the longer sequence', &
'  (up to the largest number of bits any available integer kind supports).', &
'', &
'  Bit sequences are compared from left to right, one bit at a time, until', &
'  unequal bits are found or until all bits have been compared and found to be', &
'  equal.', &
'', &
'  The bits are always evaluated in this order, not necessarily from MSB to LSB', &
'  (most significant bit to least significant bit).', &
'', &
'  If unequal bits are found the sequence with zero in the unequal position is', &
'  considered to be less than the sequence with one in the unequal position.', &
'', &
'OPTIONS', &
'  o  I : The value to test if >= J based on the bit representation of the', &
'     values.', &
'', &
'  o  J : The value to test I against.', &
'', &
'RESULT', &
'  Returns .true. if I is bit-wise greater than J and .false. otherwise.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_bge', &
'      use,intrinsic :: iso_fortran_env, only : int8, int16, int32, int64', &
'      implicit none', &
'      integer            :: i', &
'      integer(kind=int8) :: byte', &
'      integer(kind=int8),allocatable :: arr1(:), arr2(:)', &
'', &
'        ! BASIC USAGE', &
'         write(*,*)''bge(-127,127)='',bge( -127, 127 )', &
'         ! on (very common) "two''s complement" machines that are', &
'         ! little-endian -127 will be greater than 127', &
'', &
'         ! BOZ constants', &
'         ! BOZ constants are subject to truncation, so make sure', &
'         ! your values are valid for the integer kind being compared to', &
'         write(*,*)''bge(b"0001",2)='',bge( b"1", 2)', &
'', &
'        ! ELEMENTAL', &
'         ! an array and scalar', &
'         write(*, *)''compare array of values [-128, -0, +0, 127] to 127''', &
'         write(*, *)bge(int([-128, -0, +0, 127], kind=int8), 127_int8)', &
'', &
'         ! two arrays', &
'         write(*, *)''compare two arrays''', &
'         arr1=int( [ -127, -0, +0,  127], kind=int8 )', &
'         arr2=int( [  127,  0,  0, -127], kind=int8 )', &
'         write(*,*)''arr1='',arr1', &
'         write(*,*)''arr2='',arr2', &
'         write(*, *)''bge(arr1,arr2)='',bge( arr1, arr2 )', &
'', &
'        ! SHOW TESTS AND BITS', &
'         ! actually looking at the bit patterns should clarify what affect', &
'         ! signs have ...', &
'         write(*,*)''Compare some one-byte values to 64.''', &
'         write(*,*)''Notice that the values are tested as bits not as integers''', &
'         write(*,*)''so the results are as if values are unsigned integers.''', &
'         do i=-128,127,32', &
'            byte=i', &
'            write(*,''(sp,i0.4,*(1x,1l,1x,b0.8))'')i,bge(byte,64_int8),byte', &
'         enddo', &
'', &
'        ! SIGNED ZERO', &
'         ! are +0 and -0 the same on your platform? When comparing at the', &
'         ! bit level this is important', &
'         write(*,''("plus zero=",b0)'')  +0', &
'         write(*,''("minus zero=",b0)'') -0', &
'', &
'      end program demo_bge', &
'', &
'  Results:', &
'', &
'  How an integer value is represented at the bit level can vary. These are', &
'  just the values expected on Today''s most common platforms ...', &
'', &
'          > bge(-127,127)= T', &
'          > bge(b"0001",2)= F', &
'          > compare array of values [-128, -0, +0, 127] to 127', &
'          > T F F T', &
'          > compare two arrays', &
'          > arr1= -127    0    0  127', &
'          > arr2=  127    0    0 -127', &
'          > bge(arr1,arr2)= T T T F', &
'          > Compare some one-byte values to 64.', &
'          > Notice that the values are tested as bits not as integers', &
'          > so the results are as if values are unsigned integers.', &
'          > -0128  T 10000000', &
'          > -0096  T 10100000', &
'          > -0064  T 11000000', &
'          > -0032  T 11100000', &
'          > +0000  F 00000000', &
'          > +0032  F 00100000', &
'          > +0064  T 01000000', &
'          > +0096  T 01100000', &
'          > plus zero=0', &
'          > minus zero=0', &
'', &
'STANDARD', &
'  Fortran 2008', &
'', &
'SEE ALSO', &
'  BGT(3), BLE(3), BLT(3)', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022                  bge(3fortran)', &
'']

shortname="bge"
call process()


case('37','bgt')

textblock=[character(len=256) :: &
'', &
'bgt(3fortran)                                                    bgt(3fortran)', &
'', &
'NAME', &
'  BGT(3) - [BIT:COMPARE] Bitwise greater than', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                  bgt(3fortran)', &
'']

shortname="bgt"
call process()


case('38','bit_size')

textblock=[character(len=256) :: &
'', &
'bit_size(3fortran)                                          bit_size(3fortran)', &
'', &
'NAME', &
'  BIT_SIZE(3) - [BIT:INQUIRY] Bit size inquiry function', &
'', &
'SYNOPSIS', &
'  result = bit_size(i)', &
'', &
'           integer(kind=KIND) function bit_size(i)', &
'', &
'            integer(kind=KIND),intent(in) :: i(..)', &
'', &
'CHARACTERISTICS', &
'  o  the value of KIND is any valid value for an integer kind parameter on the', &
'     processor.', &
'', &
'  o  the return value is of the same kind as the input value.', &
'', &
'DESCRIPTION', &
'  BIT_SIZE(3) returns the number of bits (integer precision plus sign bit)', &
'  represented by the type of the integer I.', &
'', &
'OPTIONS', &
'  o  I : An integer value of any kind whose size in bits is to be determined.', &
'     Because only the type of the argument is examined, the argument need not', &
'     be defined; I can be a scalar or an array, but a scalar representing just', &
'     a single element is always returned.', &
'', &
'RESULT', &
'  The number of bits used to represent a value of the type of I. The result is', &
'  a integer scalar of the same kind as I.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_bit_size', &
'      use,intrinsic :: iso_fortran_env, only : int8, int16, int32, int64', &
'      use,intrinsic :: iso_fortran_env, only : integer_kinds', &
'      implicit none', &
'      character(len=*),parameter   :: fmt=&', &
'      & ''(a,": bit size is ",i3," which is kind=",i3," on this platform")''', &
'', &
'          ! default integer bit size on this platform', &
'          write(*,fmt) "default", bit_size(0), kind(0)', &
'', &
'          write(*,fmt) "int8   ", bit_size(0_int8),   kind(0_int8)', &
'          write(*,fmt) "int16  ", bit_size(0_int16),  kind(0_int16)', &
'          write(*,fmt) "int32  ", bit_size(0_int32),  kind(0_int32)', &
'          write(*,fmt) "int64  ", bit_size(0_int64),  kind(0_int64)', &
'', &
'          write(*,''(a,*(i0:,", "))'') "The available kinds are ",integer_kinds', &
'', &
'      end program demo_bit_size', &
'', &
'  Typical Results:', &
'', &
'          default: bit size is  32 which is kind=  4 on this platform', &
'          int8   : bit size is   8 which is kind=  1 on this platform', &
'          int16  : bit size is  16 which is kind=  2 on this platform', &
'          int32  : bit size is  32 which is kind=  4 on this platform', &
'          int64  : bit size is  64 which is kind=  8 on this platform', &
'          The available kinds are 1, 2, 4, 8, 16', &
'', &
'STANDARD', &
'  Fortran 95', &
'', &
'SEE ALSO', &
'  ****(3)', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022             bit_size(3fortran)', &
'']

shortname="bit_size"
call process()


case('39','ble')

textblock=[character(len=256) :: &
'', &
'ble(3fortran)                                                    ble(3fortran)', &
'', &
'NAME', &
'  BLE(3) - [BIT:COMPARE] Bitwise less than or equal to', &
'', &
'SYNOPSIS', &
'  result = ble(i,j)', &
'', &
'           elemental logical function ble(i, j)', &
'', &
'            integer(kind=KIND),intent(in) :: i', &
'            integer(kind=KIND),intent(in) :: j', &
'', &
'CHARACTERISTICS', &
'  o  the kind of I and J may be of any supported integer kind, not necessarily', &
'     the same. An exception is that values may be a BOZ constant with a value', &
'     valid for the integer kind available with the most bits on the current', &
'     platform.', &
'', &
'  o  a logical scalar of default kind is returned.', &
'', &
'DESCRIPTION', &
'  BLE(3) determines whether an integer is bitwise less than or equal to', &
'  another.', &
'', &
'OPTIONS', &
'  o  I : the value to use for testing J', &
'', &
'  o  J : the value to be tested for being less than or equal to I', &
'', &
'RESULT', &
'  The return value is .true. if any bit in J is less than any bit in I', &
'  starting with the rightmost bit and continuing tests leftward.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_ble', &
'      use,intrinsic :: iso_fortran_env, only : int8, int16, int32, int64', &
'      implicit none', &
'      integer            :: i', &
'      integer(kind=int8) :: byte', &
'        ! Compare some one-byte values to 64.', &
'         ! Notice that the values are tested as bits not as integers', &
'         ! so sign bits in the integer are treated just like any other', &
'         do i=-128,127,32', &
'            byte=i', &
'            write(*,''(sp,i0.4,*(1x,1l,1x,b0.8))'')i,ble(byte,64_int8),byte', &
'            write(*,''(sp,i0.4,*(4x,b0.8))'')64_int8,64_int8', &
'         enddo', &
'', &
'         ! see the BGE() description for an extended description', &
'         ! of related information', &
'', &
'      end program demo_ble', &
'', &
'  Results:', &
'', &
'         -0128  F 10000000', &
'         +0064    01000000', &
'         -0096  F 10100000', &
'         +0064    01000000', &
'         -0064  F 11000000', &
'         +0064    01000000', &
'         -0032  F 11100000', &
'         +0064    01000000', &
'         +0000  T 00000000', &
'         +0064    01000000', &
'         +0032  T 00100000', &
'         +0064    01000000', &
'         +0064  T 01000000', &
'         +0064    01000000', &
'         +0096  F 01100000', &
'         +0064    01000000', &
'', &
'STANDARD', &
'  Fortran 2008', &
'', &
'SEE ALSO', &
'  BGE(3), BGT(3), BLT(3)', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022                  ble(3fortran)', &
'']

shortname="ble"
call process()


case('40','blt')

textblock=[character(len=256) :: &
'', &
'blt(3fortran)                                                    blt(3fortran)', &
'', &
'NAME', &
'  BLT(3) - [BIT:COMPARE] Bitwise less than', &
'', &
'SYNOPSIS', &
'  result = blt(i,j)', &
'', &
'           elemental logical function blt(i, j)', &
'', &
'            integer(kind=KIND),intent(in) :: i', &
'            integer(kind=KIND),intent(in) :: j', &
'', &
'CHARACTERISTICS', &
'  where the kind of I and J may be of any supported integer kind, not', &
'  necessarily the same. An exception is that values may be a BOZ constant with', &
'  a value valid for the integer kind available with the most bits on the', &
'  current platform.', &
'', &
'DESCRIPTION', &
'  BLT(3) determines whether an integer is bitwise less than another.', &
'', &
'OPTIONS', &
'  o  I : Shall be of integer type or a BOZ literal constant.', &
'', &
'  o  J : Shall be of integer type or a BOZ constant.', &
'', &
'RESULT', &
'  The return value is of type logical and of the default kind.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_blt', &
'      use,intrinsic :: iso_fortran_env, only : int8, int16, int32, int64', &
'      implicit none', &
'      integer            :: i', &
'      integer(kind=int8) :: byte', &
'        ! Compare some one-byte values to 64.', &
'         ! Notice that the values are tested as bits not as integers', &
'         ! so sign bits in the integer are treated just like any other', &
'         do i=-128,127,32', &
'            byte=i', &
'            write(*,''(sp,i0.4,*(1x,1l,1x,b0.8))'')i,blt(byte,64_int8),byte', &
'         enddo', &
'', &
'         ! see the BGE() description for an extended description', &
'         ! of related information', &
'', &
'      end program demo_blt', &
'', &
'  Results:', &
'', &
'         > -0128  F 10000000', &
'         > -0096  F 10100000', &
'         > -0064  F 11000000', &
'         > -0032  F 11100000', &
'         > +0000  T 00000000', &
'         > +0032  T 00100000', &
'         > +0064  F 01000000', &
'         > +0096  F 01100000', &
'', &
'STANDARD', &
'  Fortran 2008', &
'', &
'SEE ALSO', &
'  BGE(3), BGT(3), BLE(3)', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022                  blt(3fortran)', &
'']

shortname="blt"
call process()


case('41','btest')

textblock=[character(len=256) :: &
'', &
'btest(3fortran)                                                btest(3fortran)', &
'', &
'NAME', &
'  BTEST(3) - [BIT:INQUIRY] Tests a bit of an integer value.', &
'', &
'SYNOPSIS', &
'  result = btest(i,pos)', &
'', &
'           elemental integer(kind=KIND) function btest(i,pos)', &
'', &
'            integer,intent(in)  :: i', &
'            logical,intent(out) :: pos', &
'', &
'CHARACTERISTICS', &
'  where KIND is any integer kind supported by the programming environment.', &
'', &
'DESCRIPTION', &
'  BTEST(3) returns logical .true. if the bit at POS in I is set.', &
'', &
'OPTIONS', &
'  o  I : The type shall be integer.', &
'', &
'  o  POS : The bit position to query. it must be a valid position for the', &
'     value I; ie. 0 <= POS <= BIT_SIZE(I) .', &
'', &
'     A value of zero refers to the least significant bit.', &
'', &
'RESULT', &
'  The result is a logical that has the value .true. if bit position POS of I', &
'  has the value 1 and the value .false. if bit POS of I has the value 0.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_btest', &
'      implicit none', &
'      integer :: i, j, pos, a(2,2)', &
'      logical :: bool', &
'      character(len=*),parameter :: g=''(*(g0))''', &
'', &
'           i = 32768 + 1024 + 64', &
'          write(*,''(a,i0,"=>",b32.32,/)'')''Looking at the integer: '',i', &
'', &
'          ! looking one bit at a time from LOW BIT TO HIGH BIT', &
'          write(*,g)''from bit 0 to bit '',bit_size(i),''==>''', &
'          do pos=0,bit_size(i)-1', &
'              bool = btest(i, pos)', &
'              write(*,''(l1)'',advance=''no'')bool', &
'          enddo', &
'          write(*,*)', &
'', &
'          ! a binary format the hard way.', &
'          ! Note going from bit_size(i) to zero.', &
'          write(*,*)', &
'          write(*,g)''so for '',i,'' with a bit size of '',bit_size(i)', &
'          write(*,''(b32.32)'')i', &
'          write(*,g)merge(''^'',''_'',[(btest(i,j),j=bit_size(i)-1,0,-1)])', &
'          write(*,*)', &
'          write(*,g)''and for '',-i,'' with a bit size of '',bit_size(i)', &
'          write(*,''(b32.32)'')-i', &
'          write(*,g)merge(''^'',''_'',[(btest(-i,j),j=bit_size(i)-1,0,-1)])', &
'', &
'          ! elemental:', &
'          !', &
'          a(1,:)=[ 1, 2 ]', &
'          a(2,:)=[ 3, 4 ]', &
'          write(*,*)', &
'          write(*,''(a,/,*(i2,1x,i2,/))'')''given the array a ...'',a', &
'          ! the second bit of all the values in a', &
'          write(*,''(a,/,*(l2,1x,l2,/))'')''the value of btest (a, 2)'',btest(a,2)', &
'          ! bits 1,2,3,4 of the value 2', &
'          write(*,''(a,/,*(l2,1x,l2,/))'')''the value of btest (2, a)'',btest(2,a)', &
'      end program demo_btest', &
'', &
'  Results:', &
'', &
'      Looking at the integer: 33856=>11111111111111110111101111000000', &
'', &
'      00000000000000001000010001000000', &
'      11111111111111110111101111000000', &
'      1000010001000000', &
'      11111111111111110111101111000000', &
'      from bit 0 to bit 32==>', &
'', &
'   FFFFFFTFFFTFFFFTFFFFFFFFFFFFFFFF', &
'  so for 33856 with a bit size of 32 00000000000000001000010001000000', &
'  ________________^____^___^______', &
'', &
'  and for -33856 with a bit size of 32 11111111111111110111101111000000', &
'  ^^^^^^^^^^^^^^^^_^^^^_^^^^______', &
'', &
'  given the array a ...', &
'', &
'    1', &
'', &
'    2', &
'', &
'  the value of btest (a, 2)', &
'', &
'   F F', &
'   F T', &
'  the value of btest (2, a)', &
'', &
'   T F', &
'   F F', &
'STANDARD', &
'  Fortran 95', &
'', &
'SEE ALSO', &
'  IEOR(3), IBCLR(3), NOT(3), IBCLR(3), IBITS(3), IBSET(3), IAND(3), IOR(3),', &
'  IEOR(3), MVBITS(3)', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022                btest(3fortran)', &
'']

shortname="btest"
call process()


case('42','c_associated')

textblock=[character(len=256) :: &
'', &
'c_associated(3fortran)                                  c_associated(3fortran)', &
'', &
'NAME', &
'  C_ASSOCIATED(3) - [ISO_C_BINDING] Status of a C pointer', &
'', &
'SYNOPSIS', &
'                               October 09, 2022         c_associated(3fortran)', &
'']

shortname="c_associated"
call process()


case('43','ceiling')

textblock=[character(len=256) :: &
'', &
'ceiling(3fortran)                                            ceiling(3fortran)', &
'', &
'NAME', &
'  CEILING(3) - [NUMERIC] Integer ceiling function', &
'', &
'SYNOPSIS', &
'                               October 09, 2022              ceiling(3fortran)', &
'']

shortname="ceiling"
call process()


case('44','c_f_pointer')

textblock=[character(len=256) :: &
'', &
'c_f_pointer(3fortran)                                    c_f_pointer(3fortran)', &
'', &
'NAME', &
'  C_F_POINTER(3) - [ISO_C_BINDING] Convert C into Fortran pointer', &
'', &
'SYNOPSIS', &
'                               October 09, 2022          c_f_pointer(3fortran)', &
'']

shortname="c_f_pointer"
call process()


case('45','c_f_procpointer')

textblock=[character(len=256) :: &
'', &
'c_f_procpointer(3fortran)                            c_f_procpointer(3fortran)', &
'', &
'NAME', &
'  C_F_PROCPOINTER(3) - [ISO_C_BINDING] Convert C into Fortran procedure', &
'  pointer', &
'', &
'SYNOPSIS', &
'                               October 09, 2022      c_f_procpointer(3fortran)', &
'']

shortname="c_f_procpointer"
call process()


case('46','c_funloc')

textblock=[character(len=256) :: &
'', &
'c_funloc(3fortran)                                          c_funloc(3fortran)', &
'', &
'NAME', &
'  C_FUNLOC(3) - [ISO_C_BINDING] Obtain the C address of a procedure', &
'', &
'SYNOPSIS', &
'  result = c_funloc(x)', &
'', &
'CHARACTERISTICS', &
'DESCRIPTION', &
'  C_FUNLOC(3) determines the C address of the argument.', &
'', &
'OPTIONS', &
'  o  X : Interoperable function or pointer to such function.', &
'', &
'RESULT', &
'  The return value is of type c_funptr and contains the C address of the', &
'  argument.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      ! program demo_c_funloc and module', &
'      module x', &
'      use iso_c_binding', &
'      implicit none', &
'      contains', &
'      subroutine sub(a) bind(c)', &
'      real(c_float) :: a', &
'         a = sqrt(a)+5.0', &
'      end subroutine sub', &
'      end module x', &
'      !', &
'      program demo_c_funloc', &
'      use iso_c_binding', &
'      use x', &
'      implicit none', &
'      interface', &
'         subroutine my_routine(p) bind(c,name=''myC_func'')', &
'           import :: c_funptr', &
'           type(c_funptr), intent(in) :: p', &
'         end subroutine', &
'      end interface', &
'         call my_routine(c_funloc(sub))', &
'      !', &
'      end program demo_c_funloc', &
'', &
'STANDARD', &
'  Fortran 2003', &
'', &
'SEE ALSO', &
'  C_ASSOCIATED(3), C_LOC(3), C_F_POINTER(3),', &
'', &
'  C_F_PROCPOINTER(3), ISO_C_BINDING(3)', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022             c_funloc(3fortran)', &
'']

shortname="c_funloc"
call process()


case('47','char')

textblock=[character(len=256) :: &
'', &
'char(3fortran)                                                  char(3fortran)', &
'', &
'NAME', &
'  CHAR(3) - [CHARACTER] Generate a character from a code value', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                 char(3fortran)', &
'']

shortname="char"
call process()


case('48','c_loc')

textblock=[character(len=256) :: &
'', &
'c_loc(3fortran)                                                c_loc(3fortran)', &
'', &
'NAME', &
'  C_LOC(3) - [ISO_C_BINDING] Obtain the C address of an object', &
'', &
'SYNOPSIS', &
'  result = c_loc(x)', &
'', &
'CHARACTERISTICS', &
'DESCRIPTION', &
'  C_LOC(3) determines the C address of the argument.', &
'', &
'OPTIONS', &
'  o  X : Shall have either the pointer or target attribute. It shall not be a', &
'     coindexed object. It shall either be a variable with interoperable type', &
'     and kind type parameters, or be a scalar, nonpolymorphic variable with no', &
'     length type parameters.', &
'', &
'RESULT', &
'  The return value is of type c_ptr and contains the C address of the', &
'  argument.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'         subroutine association_test(a,b)', &
'         use iso_c_binding, only: c_associated, c_loc, c_ptr', &
'         implicit none', &
'         real, pointer :: a', &
'         type(c_ptr) :: b', &
'           if(c_associated(b, c_loc(a))) &', &
'              stop ''b and a do not point to same target''', &
'         end subroutine association_test', &
'', &
'STANDARD', &
'  Fortran 2003', &
'', &
'SEE ALSO', &
'  C_ASSOCIATED(3), C_FUNLOC(3), C_F_POINTER(3),', &
'', &
'  C_F_PROCPOINTER(3), ISO_C_BINDING(3)', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022                c_loc(3fortran)', &
'']

shortname="c_loc"
call process()


case('49','cmplx')

textblock=[character(len=256) :: &
'', &
'cmplx(3fortran)                                                cmplx(3fortran)', &
'', &
'NAME', &
'  CMPLX(3) - [TYPE:NUMERIC] Convert values to a complex type', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                cmplx(3fortran)', &
'']

shortname="cmplx"
call process()


case('50','co_broadcast')

textblock=[character(len=256) :: &
'', &
'co_broadcast(3fortran)                                  co_broadcast(3fortran)', &
'', &
'NAME', &
'  CO_BROADCAST(3) - [COLLECTIVE] Copy a value to all images the current set of', &
'  images', &
'', &
'SYNOPSIS', &
'                               October 09, 2022         co_broadcast(3fortran)', &
'']

shortname="co_broadcast"
call process()


case('51','co_lbound')

textblock=[character(len=256) :: &
'', &
'co_lbound(3fortran)                                        co_lbound(3fortran)', &
'', &
'NAME', &
'  CO_LBOUND(3) - [COLLECTIVE] Lower codimension bounds of an array', &
'', &
'SYNOPSIS', &
'                               October 09, 2022            co_lbound(3fortran)', &
'']

shortname="co_lbound"
call process()


case('52','co_max')

textblock=[character(len=256) :: &
'', &
'co_max(3fortran)                                              co_max(3fortran)', &
'', &
'NAME', &
'  CO_MAX(3) - [COLLECTIVE] Maximal value on the current set of images', &
'', &
'SYNOPSIS', &
'                               October 09, 2022               co_max(3fortran)', &
'']

shortname="co_max"
call process()


case('53','co_min')

textblock=[character(len=256) :: &
'', &
'co_min(3fortran)                                              co_min(3fortran)', &
'', &
'NAME', &
'  CO_MIN(3) - [COLLECTIVE] Minimal value on the current set of images', &
'', &
'SYNOPSIS', &
'                               October 09, 2022               co_min(3fortran)', &
'']

shortname="co_min"
call process()


case('54','command_argument_count')

textblock=[character(len=256) :: &
'', &
'command_argument_count(3fortran)              command_argument_count(3fortran)', &
'', &
'NAME', &
'  COMMAND_ARGUMENT_COUNT(3) - [SYSTEM:COMMAND LINE] Get number of command line', &
'  arguments', &
'', &
'SYNOPSIS', &
'  result = command_argument_count()', &
'', &
'           integer function command_argument_count()', &
'', &
'CHARACTERISTICS', &
'DESCRIPTION', &
'  COMMAND_ARGUMENT_COUNT(3) returns the number of arguments passed on the', &
'  command line when the containing program was invoked.', &
'', &
'OPTIONS', &
'  None', &
'', &
'RESULT', &
'  o  COUNT : The return value is of type default integer. It is the number of', &
'     arguments passed on the command line when the program was invoked.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_command_argument_count', &
'      implicit none', &
'      integer :: count', &
'         count = command_argument_count()', &
'         print *, count', &
'      end program demo_command_argument_count', &
'', &
'  Sample output:', &
'', &
'         # the command verb does not count', &
'         ./test_command_argument_count', &
'             0', &
'         # quoted strings may count as one argument', &
'         ./test_command_argument_count count arguments', &
'             2', &
'         ./test_command_argument_count ''count arguments''', &
'             1', &
'', &
'STANDARD', &
'  Fortran 2003', &
'', &
'SEE ALSO', &
'  GET_COMMAND(3), GET_COMMAND_ARGUMENT(3)', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 202command_argument_count(3fortran)', &
'']

shortname="command_argument_count"
call process()


case('55','compiler_options')

textblock=[character(len=256) :: &
'', &
'compiler_options(3fortran)                          compiler_options(3fortran)', &
'', &
'NAME', &
'  COMPILER_OPTIONS(3) - [COMPILER:INQUIRY] Options passed to the compiler', &
'', &
'SYNOPSIS', &
'  result = compiler_options()', &
'', &
'           character(len=:) function compiler_options()', &
'', &
'CHARACTERISTICS', &
'DESCRIPTION', &
'  COMPILER_OPTIONS(3) returns a string with the options used for compiling.', &
'', &
'OPTIONS', &
'  None.', &
'', &
'RESULT', &
'  The return value is a default-kind string with system-dependent length.  It', &
'  contains the compiler flags used to compile the file, which called the', &
'  compiler_options() intrinsic.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_compiler_version', &
'      use, intrinsic :: iso_fortran_env, only : compiler_version', &
'      use, intrinsic :: iso_fortran_env, only : compiler_options', &
'      implicit none', &
'         print ''(4a)'', &', &
'            ''This file was compiled by '', &', &
'            compiler_version(),           &', &
'            '' using the options '',        &', &
'            compiler_options()', &
'      end program demo_compiler_version', &
'', &
'  Results:', &
'', &
'         This file was compiled by GCC version 5.4.0 using the options', &
'         -I /usr/include/w32api -I /home/urbanjs/V600/lib/CYGWIN64_GFORTRAN', &
'         -mtune=generic -march=x86-64 -g -Wunused -Wuninitialized -Wall', &
'         -std=f2008 -fbounds-check -fbacktrace -finit-real=nan', &
'         -fno-range-check -frecord-marker=4', &
'         -J /home/urbanjs/V600/lib/CYGWIN64_GFORTRAN', &
'', &
'STANDARD', &
'  Fortran 2008', &
'', &
'SEE ALSO', &
'  COMPILER_VERSION(3), ISO_FORTRAN_ENV(7)', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022     compiler_options(3fortran)', &
'']

shortname="compiler_options"
call process()


case('56','compiler_version')

textblock=[character(len=256) :: &
'', &
'compiler_version(3fortran)                          compiler_version(3fortran)', &
'', &
'NAME', &
'  COMPILER_VERSION(3) - [COMPILER:INQUIRY] Compiler version string', &
'', &
'SYNOPSIS', &
'  result = compiler_version()', &
'', &
'           character(len=:) function compiler_version()', &
'', &
'CHARACTERISTICS', &
'DESCRIPTION', &
'  COMPILER_VERSION(3) returns a string containing the name and version of the', &
'  compiler.', &
'', &
'OPTIONS', &
'  None.', &
'', &
'RESULT', &
'  The return value is a default-kind string with system-dependent length.  It', &
'  contains the name of the compiler and its version number.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_compiler_version', &
'      use, intrinsic :: iso_fortran_env, only : compiler_version', &
'      use, intrinsic :: iso_fortran_env, only : compiler_options', &
'      implicit none', &
'         print ''(4a)'', &', &
'            ''This file was compiled by '', &', &
'            compiler_version(),           &', &
'            '' using the options '',        &', &
'            compiler_options()', &
'      end program demo_compiler_version', &
'', &
'  Results:', &
'', &
'         This file was compiled by GCC version 5.4.0 using the options', &
'         -I /usr/include/w32api -I /home/urbanjs/V600/lib/CYGWIN64_GFORTRAN', &
'         -mtune=generic -march=x86-64 -g -Wunused -Wuninitialized -Wall', &
'         -std=f2008 -fbounds-check -fbacktrace -finit-real=nan', &
'         -fno-range-check -frecord-marker=4', &
'         -J /home/urbanjs/V600/lib/CYGWIN64_GFORTRAN', &
'', &
'STANDARD', &
'  Fortran 2008', &
'', &
'SEE ALSO', &
'  COMPILER_OPTIONS(3), ISO_FORTRAN_ENV(7)', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022     compiler_version(3fortran)', &
'']

shortname="compiler_version"
call process()


case('57','conjg')

textblock=[character(len=256) :: &
'', &
'conjg(3fortran)                                                conjg(3fortran)', &
'', &
'NAME', &
'  CONJG(3) - [NUMERIC] Complex conjugate of a complex value', &
'', &
'SYNOPSIS', &
'  result = conjg(z)', &
'', &
'           elemental complex(kind=KIND) function conjg(z)', &
'', &
'            complex(kind=KIND),intent(in) :: z', &
'', &
'CHARACTERISTICS', &
'  o  KIND may be any supported value for the complex input value.', &
'', &
'  o  The returned value with be the same complex type as the input.', &
'', &
'DESCRIPTION', &
'  CONJG(3) returns the complex conjugate of the complex value Z.', &
'', &
'  In mathematics, the complex conjugate of a complex number is a value whose', &
'  real and imaginary part are equal parts are equal in magnitude to each other', &
'  but the Y value has opposite sign.', &
'', &
'  That is, If Z is the complex value (X, Y) then the result is (X, -Y).', &
'', &
'  For matrices of complex numbers, CONJG(ARRAY) represents the element-by-', &
'  element conjugation of ARRAY; not the conjugate transpose of the ARRAY .', &
'', &
'OPTIONS', &
'  o  Z : The complex value to create the conjugate of.', &
'', &
'RESULT', &
'  Returns a complex value equal to the input value except the sign of the', &
'  imaginary component is the opposite of the input value.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_conjg', &
'      use, intrinsic :: iso_fortran_env, only : real_kinds, &', &
'      & real32, real64, real128', &
'      implicit none', &
'      complex :: z = (2.0, 3.0)', &
'      complex(kind=real64) :: dz = (   &', &
'         &  1.2345678901234567_real64, -1.2345678901234567_real64)', &
'      complex :: arr(3,3)', &
'      integer :: i', &
'         ! basics', &
'          ! notice the sine of the imaginary component changes', &
'          print *, z, conjg(z)', &
'', &
'          ! any complex kind is supported. z is of default kind but', &
'          ! dz is kind=real64.', &
'          print *, dz', &
'          dz = conjg(dz)', &
'          print *, dz', &
'          print *', &
'', &
'          ! the function is elemental so it can take arrays', &
'          arr(1,:)=[(-1.0, 2.0),( 3.0, 4.0),( 5.0,-6.0)]', &
'          arr(2,:)=[( 7.0,-8.0),( 8.0, 9.0),( 9.0, 9.0)]', &
'          arr(3,:)=[( 1.0, 9.0),( 2.0, 0.0),(-3.0,-7.0)]', &
'', &
'          write(*,*)''original''', &
'          write(*,''(3("(",g8.2,",",g8.2,")",1x))'')(arr(i,:),i=1,3)', &
'          arr = conjg(arr)', &
'          write(*,*)''conjugate''', &
'          write(*,''(3("(",g8.2,",",g8.2,")",1x))'')(arr(i,:),i=1,3)', &
'', &
'      end program demo_conjg', &
'', &
'  Results:', &
'', &
'       (2.000000,3.000000) (2.000000,-3.000000)', &
'', &
'       (1.23456789012346,-1.23456789012346)', &
'       (1.23456789012346,1.23456789012346)', &
'', &
'       original', &
'', &
'    (-1.0', &
'      , 2.0    ) ( 3.0    , 4.0    ) ( 5.0    ,-6.0    )', &
'', &
'    ( 7.0', &
'      ,-8.0    ) ( 8.0    , 9.0    ) ( 9.0    , 9.0    )', &
'', &
'    ( 1.0', &
'      , 9.0    ) ( 2.0    , 0.0    ) (-3.0    ,-7.0    )', &
'', &
'         conjugate', &
'', &
'    (-1.0', &
'      ,-2.0    ) ( 3.0    ,-4.0    ) ( 5.0    , 6.0    )', &
'', &
'    ( 7.0', &
'      , 8.0    ) ( 8.0    ,-9.0    ) ( 9.0    ,-9.0    )', &
'', &
'    ( 1.0', &
'      ,-9.0    ) ( 2.0    , 0.0    ) (-3.0    , 7.0    )', &
'', &
'STANDARD', &
'  FORTRAN 77', &
'', &
'SEE ALSO', &
'  o  AIMAG(3) - Imaginary part of complex number', &
'', &
'  o  CMPLX(3) - Complex conversion function', &
'', &
'  o  REAL(3) - Convert to real type', &
'', &
'  Fortran has strong support for complex values, including many intrinsics', &
'  that take or produce complex values in addition to algebraic and logical', &
'  expressions:', &
'', &
'  ABS(3), ACOSH(3), ACOS(3), ASINH(3), ASIN(3), ATAN2(3), ATANH(3), ATAN(3),', &
'  COSH(3), COS(3), CO_SUM(3), DBLE(3), DOT_PRODUCT(3), EXP(3), INT(3),', &
'  IS_CONTIGUOUS(3), KIND(3), LOG(3), MATMUL(3), PRECISION(3), PRODUCT(3),', &
'  RANGE(3), RANK(3), SINH(3), SIN(3), SQRT(3), STORAGE_SIZE(3), SUM(3),', &
'  TANH(3), TAN(3), UNPACK(3),', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022                conjg(3fortran)', &
'']

shortname="conjg"
call process()


case('58','co_reduce')

textblock=[character(len=256) :: &
'', &
'co_reduce(3fortran)                                        co_reduce(3fortran)', &
'', &
'NAME', &
'  CO_REDUCE(3) - [COLLECTIVE] Reduction of values on the current set of images', &
'', &
'SYNOPSIS', &
'                               October 09, 2022            co_reduce(3fortran)', &
'']

shortname="co_reduce"
call process()


case('59','cos')

textblock=[character(len=256) :: &
'', &
'cos(3fortran)                                                    cos(3fortran)', &
'', &
'NAME', &
'  COS(3) - [MATHEMATICS:TRIGONOMETRIC] Cosine function', &
'', &
'SYNOPSIS', &
'  result = cos(x)', &
'', &
'           elemental TYPE(kind=KIND) function cos(x)', &
'', &
'            TYPE(kind=KIND),intent(in) :: x', &
'', &
'CHARACTERISTICS', &
'  o  where TYPE may be real or complex of any kind.', &
'', &
'  o  the returned value will be of the same type and kind as the argument.', &
'', &
'DESCRIPTION', &
'  COS(3) computes the cosine of an angle X given the size of the angle in', &
'  radians.', &
'', &
'  The cosine of a real value is the ratio of the adjacent side to the', &
'  hypotenuse of a right-angled triangle.', &
'', &
'OPTIONS', &
'  o  X : The angle in radians to compute the cosine of.', &
'', &
'RESULT', &
'  The return value is the tangent of X.', &
'', &
'  If X is of the type real, the return value lies in the range -1 <= COS(X) <=', &
'  1 .', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_cos', &
'      implicit none', &
'      doubleprecision,parameter :: PI=atan(1.0d0)*4.0d0', &
'         write(*,*)''COS(0.0)='',cos(0.0)', &
'         write(*,*)''COS(PI)='',cos(PI)', &
'         write(*,*)''COS(PI/2.0d0)='',cos(PI/2.0d0),'' EPSILON='',epsilon(PI)', &
'         write(*,*)''COS(2*PI)='',cos(2*PI)', &
'         write(*,*)''COS(-2*PI)='',cos(-2*PI)', &
'         write(*,*)''COS(-2000*PI)='',cos(-2000*PI)', &
'         write(*,*)''COS(3000*PI)='',cos(3000*PI)', &
'      end program demo_cos', &
'', &
'  Results:', &
'', &
'         COS(0.0)=        1.00000000', &
'         COS(PI)=        -1.0000000000000000', &
'         COS(PI/2.0d0)=   6.1232339957367660E-017', &
'         EPSILON=         2.2204460492503131E-016', &
'         COS(2*PI)=       1.0000000000000000', &
'         COS(-2*PI)=      1.0000000000000000', &
'         COS(-2000*PI)=   1.0000000000000000', &
'', &
'STANDARD', &
'  FORTRAN 77', &
'', &
'SEE ALSO', &
'  ACOS(3), SIN(3), TAN(3)', &
'', &
'RESOURCES', &
'  o  Wikipedia:sine and cosine', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022                  cos(3fortran)', &
'']

shortname="cos"
call process()


case('60','cosh')

textblock=[character(len=256) :: &
'', &
'cosh(3fortran)                                                  cosh(3fortran)', &
'', &
'NAME', &
'  COSH(3) - [MATHEMATICS:TRIGONOMETRIC] Hyperbolic cosine function', &
'', &
'SYNOPSIS', &
'  result = cosh(x)', &
'', &
'           elemental TYPE(kind=KIND) function cosh(x)', &
'', &
'            TYPE(kind=KIND),intent(in) :: x', &
'', &
'CHARACTERISTICS', &
'  o  TYPE may be real or complex of any kind.', &
'', &
'  o  The returned value will be of the same type and kind as the argument.', &
'', &
'DESCRIPTION', &
'  COSH(3) computes the hyperbolic cosine of X.', &
'', &
'OPTIONS', &
'  o  X : the value to compute the hyerbolic cosine of', &
'', &
'RESULT', &
'  If X is complex, the imaginary part of the result is in radians.', &
'', &
'  If X is real, the return value has a lower bound of one, COSH(X) >= 1.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_cosh', &
'      use, intrinsic :: iso_fortran_env, only : &', &
'       & real_kinds, real32, real64, real128', &
'      implicit none', &
'      real(kind=real64) :: x = 1.0_real64', &
'          x = cosh(x)', &
'      end program demo_cosh', &
'', &
'STANDARD', &
'  FORTRAN 77 , for a complex argument - Fortran 2008', &
'', &
'SEE ALSO', &
'  Inverse function: ACOSH(3)', &
'', &
'RESOURCES', &
'  o  Wikipedia:hyperbolic functions', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022                 cosh(3fortran)', &
'']

shortname="cosh"
call process()


case('61','co_sum')

textblock=[character(len=256) :: &
'', &
'co_sum(3fortran)                                              co_sum(3fortran)', &
'', &
'NAME', &
'  CO_SUM(3) - [COLLECTIVE] Sum of values on the current set of images', &
'', &
'SYNOPSIS', &
'                               October 09, 2022               co_sum(3fortran)', &
'']

shortname="co_sum"
call process()


case('62','co_ubound')

textblock=[character(len=256) :: &
'', &
'co_ubound(3fortran)                                        co_ubound(3fortran)', &
'', &
'NAME', &
'  CO_UBOUND(3) - [COLLECTIVE] Upper codimension bounds of an array', &
'', &
'SYNOPSIS', &
'                               October 09, 2022            co_ubound(3fortran)', &
'']

shortname="co_ubound"
call process()


case('63','count')

textblock=[character(len=256) :: &
'', &
'count(3fortran)                                                count(3fortran)', &
'', &
'NAME', &
'  COUNT(3) - [ARRAY:REDUCTION] Count true values in an array', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                count(3fortran)', &
'']

shortname="count"
call process()


case('64','cpu_time')

textblock=[character(len=256) :: &
'', &
'cpu_time(3fortran)                                          cpu_time(3fortran)', &
'', &
'NAME', &
'  CPU_TIME(3) - [SYSTEM:TIME] Return CPU processor time in seconds', &
'', &
'SYNOPSIS', &
'  call cpu_time(time)', &
'', &
'            subroutine cpu_time(time)', &
'', &
'             real,intent(out) :: time', &
'', &
'CHARACTERISTICS', &
'  o  TIME is of type real and any kind, with INTENT(OUT).', &
'', &
'DESCRIPTION', &
'  CPU_TIME(3) returns a real value representing the elapsed CPU time in', &
'  seconds. This is useful for testing segments of code to determine execution', &
'  time.', &
'', &
'  The exact definition of time is left imprecise because of the variability in', &
'  what different processors are able to provide.', &
'', &
'  If no time source is available, TIME is set to a negative value.', &
'', &
'  Note that TIME may contain a system dependent, arbitrary offset and may not', &
'  start with 0.0. For CPU_TIME(3) the absolute value is meaningless.  Only', &
'  differences between subsequent calls, as shown in the example below, should', &
'  be used.', &
'', &
'  A processor for which a single result is inadequate (for example, a parallel', &
'  processor) might choose to provide an additional version for which TIME is', &
'  an array.', &
'', &
'RESULT', &
'  o  TIME : The type shall be real with INTENT(OUT). It is assigned a', &
'     processor-dependent approximation to the processor time in seconds.  If', &
'     the processor cannot return a meaningful time, a processor-dependent', &
'     negative value is returned.', &
'', &
'     : The start time is left imprecise because the purpose is to time', &
'     sections of code, as in the example. This might or might not include', &
'     system overhead time.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_cpu_time', &
'      use, intrinsic :: iso_fortran_env, only : real_kinds,real32,real64,real128', &
'      implicit none', &
'      real :: start, finish', &
'      real(kind=real64) :: startd, finishd', &
'         !', &
'         call cpu_time(start)', &
'         call cpu_time(startd)', &
'         ! put code to time here', &
'         call cpu_time(finish)', &
'         call cpu_time(finishd)', &
'         !', &
'        ! writes processor time taken by the piece of code.', &
'', &
'        ! the accuracy of the clock and whether it includes system time', &
'        ! as well as user time is processor dependent. Accuracy up to', &
'        ! milliseconds is common but not guaranteed, and may be much', &
'        ! higher or lower', &
'         print ''("Processor Time = ",f6.3," seconds.")'',finish-start', &
'', &
'         ! see your specific compiler documentation for how to measure', &
'         ! parallel jobs and for the precision of the time returned', &
'         print ''("Processor Time = ",g0," seconds.")'',finish-start', &
'         print ''("Processor Time = ",g0," seconds.")'',finishd-startd', &
'      end program demo_cpu_time', &
'', &
'  Results:', &
'', &
'  The precision of the result, some aspects of what is returned, and what if', &
'  any options there are for parallel applications may very from system to', &
'  system. See compiler-specific for details.', &
'', &
'         Processor Time =  0.000 seconds.', &
'         Processor Time = .4000030E-05 seconds.', &
'         Processor Time = .2000000000000265E-05 seconds.', &
'', &
'STANDARD', &
'  Fortran 95', &
'', &
'SEE ALSO', &
'  SYSTEM_CLOCK(3), DATE_AND_TIME(3)', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022             cpu_time(3fortran)', &
'']

shortname="cpu_time"
call process()


case('65','cshift')

textblock=[character(len=256) :: &
'', &
'cshift(3fortran)                                              cshift(3fortran)', &
'', &
'NAME', &
'  CSHIFT(3) - [TRANSFORMATIONAL] Circular shift elements of an array', &
'', &
'SYNOPSIS', &
'                               October 09, 2022               cshift(3fortran)', &
'']

shortname="cshift"
call process()


case('66','c_sizeof')

textblock=[character(len=256) :: &
'', &
'c_sizeof(3fortran)                                          c_sizeof(3fortran)', &
'', &
'NAME', &
'  C_SIZEOF(3) - [ISO_C_BINDING] Size in bytes of an expression', &
'', &
'SYNOPSIS', &
'  result = c_sizeof(x)', &
'', &
'CHARACTERISTICS', &
'DESCRIPTION', &
'  C_SIZEOF(3) calculates the number of bytes of storage the expression X', &
'  occupies.', &
'', &
'OPTIONS', &
'  o  X : The argument shall be an interoperable data entity.', &
'', &
'RESULT', &
'  The return value is of type integer and of the system-dependent kind csize_t', &
'  (from the _iso_c_binding module). Its value is the number of bytes occupied', &
'  by the argument. If the argument has the pointer attribute, the number of', &
'  bytes of the storage area pointed to is returned. If the argument is of a', &
'  derived type with pointer or allocatable components, the return value does', &
'  not account for the sizes of the data pointed to by these components.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_c_sizeof', &
'      use iso_c_binding', &
'      implicit none', &
'      real(c_float) :: r, s(5)', &
'         print *, (c_sizeof(s)/c_sizeof(r) == 5)', &
'      end program demo_c_sizeof', &
'', &
'  Results:', &
'', &
'   T', &
'  The example will print .true. unless you are using a platform where default', &
'  real variables are unusually padded.', &
'', &
'STANDARD', &
'  Fortran 2008', &
'', &
'SEE ALSO', &
'  STORAGE_SIZE(3)', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022             c_sizeof(3fortran)', &
'']

shortname="c_sizeof"
call process()


case('67','date_and_time')

textblock=[character(len=256) :: &
'', &
'date_and_time(3fortran)                                date_and_time(3fortran)', &
'', &
'NAME', &
'  DATE_AND_TIME(3) - [SYSTEM:TIME] Gets current time', &
'', &
'SYNOPSIS', &
'                               October 09, 2022        date_and_time(3fortran)', &
'']

shortname="date_and_time"
call process()


case('68','dble')

textblock=[character(len=256) :: &
'', &
'dble(3fortran)                                                  dble(3fortran)', &
'', &
'NAME', &
'  DBLE(3) - [TYPE:NUMERIC] Double conversion function', &
'', &
'SYNOPSIS', &
'  result = dble(a)', &
'', &
'           elemental doubleprecision function dble(a)', &
'', &
'            doubleprecision :: dble', &
'            TYPE(kind=KIND),intent(in) :: a', &
'', &
'CHARACTERISTICS', &
'  where TYPE may be integer, real, or complex and KIND any kind supported by', &
'  the TYPE.', &
'', &
'DESCRIPTION', &
'  DBLE(3) Converts A to double precision real type.', &
'', &
'OPTIONS', &
'  o  A : The type shall be integer, real, or complex.', &
'', &
'RESULT', &
'  The return value is of type doubleprecision. For complex input, the returned', &
'  value has the magnitude and sign of the real component of the input value.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_dble', &
'      implicit none', &
'      real:: x = 2.18', &
'      integer :: i = 5', &
'      complex :: z = (2.3,1.14)', &
'         print *, dble(x), dble(i), dble(z)', &
'      end program demo_dble', &
'', &
'  Results:', &
'', &
'        2.1800000667572021  5.0000000000000000   2.2999999523162842', &
'', &
'STANDARD', &
'  FORTRAN 77', &
'', &
'SEE ALSO', &
'  FLOAT(3), REAL(3)', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022                 dble(3fortran)', &
'']

shortname="dble"
call process()


case('69','digits')

textblock=[character(len=256) :: &
'', &
'digits(3fortran)                                              digits(3fortran)', &
'', &
'NAME', &
'  DIGITS(3) - [NUMERIC MODEL] Significant digits function', &
'', &
'SYNOPSIS', &
'  result = digits(x)', &
'', &
'           integer function digits(x)', &
'', &
'            TYPE(kind=KIND),intent(in) :: x(..)', &
'', &
'CHARACTERISTICS', &
'  where TYPE may be integer or real and KIND is any kind supported by TYPE.', &
'', &
'  The return value is of type integer of default kind.', &
'', &
'DESCRIPTION', &
'  DIGITS(3) returns the number of significant digits of the internal model', &
'  representation of X. For example, on a system using a 32-bit floating point', &
'  representation, a default real number would likely return 24.', &
'', &
'OPTIONS', &
'  o  X : The type may be a scalar or array of type integer or real.', &
'', &
'RESULT', &
'  The return value is of type integer of default kind.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_digits', &
'      implicit none', &
'      integer :: i = 12345', &
'      real :: x = 3.143', &
'      doubleprecision :: y = 2.33d0', &
'         print *,''default integer:'', digits(i)', &
'         print *,''default real:   '', digits(x)', &
'         print *,''default doubleprecision:'', digits(y)', &
'      end program demo_digits', &
'', &
'  Typical Results:', &
'', &
'          default integer:                  31', &
'          default real:                     24', &
'          default doubleprecision:          53', &
'', &
'STANDARD', &
'  Fortran 95', &
'', &
'SEE ALSO', &
'  EPSILON(3), EXPONENT(3), FRACTION(3), HUGE(3), MAXEXPONENT(3),', &
'  MINEXPONENT(3), NEAREST(3), PRECISION(3), RADIX(3), RANGE(3), RRSPACING(3),', &
'  SCALE(3), SET_EXPONENT(3), SPACING(3), TINY(3)', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022               digits(3fortran)', &
'']

shortname="digits"
call process()


case('70','dim')

textblock=[character(len=256) :: &
'', &
'dim(3fortran)                                                    dim(3fortran)', &
'', &
'NAME', &
'  DIM(3) - [NUMERIC] Positive difference', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                  dim(3fortran)', &
'']

shortname="dim"
call process()


case('71','dot_product')

textblock=[character(len=256) :: &
'', &
'dot_product(3fortran)                                    dot_product(3fortran)', &
'', &
'NAME', &
'  DOT_PRODUCT(3) - [TRANSFORMATIONAL] Dot product function', &
'', &
'SYNOPSIS', &
'                               October 09, 2022          dot_product(3fortran)', &
'']

shortname="dot_product"
call process()


case('72','dprod')

textblock=[character(len=256) :: &
'', &
'dprod(3fortran)                                                dprod(3fortran)', &
'', &
'NAME', &
'  DPROD(3) - [NUMERIC] Double precision real product', &
'', &
'SYNOPSIS', &
'  result = dprod(x,y)', &
'', &
'           elemental function dprod(x,y)', &
'', &
'            real,intent(in) :: x', &
'            real,intent(in) :: y', &
'            doubleprecision :: dprod', &
'', &
'CHARACTERISTICS', &
'  X and Y must both be real values of default kind.', &
'', &
'  The return value is doubleprecision (ie. real(kind=kind(0.0d0))).', &
'', &
'  The setting of compiler options specifying the size of a default real can', &
'  affect this function.', &
'', &
'DESCRIPTION', &
'  DPROD(3) produces a doubleprecision product of default real values X and Y.', &
'', &
'  That is, it is expected to convert the arguments to double precision before', &
'  multiplying, which a simple expression X*Y would not be required to do. This', &
'  can be significant in specialized computations requiring high precision.', &
'', &
'  The result has a value equal to a processor-dependent approximation to the', &
'  product of X and Y. Note it is recommended in the standard that the', &
'  processor compute the product in double precision, rather than in single', &
'  precision then converted to double precision; but is only a recommendation.', &
'', &
'OPTIONS', &
'  o  X : the multiplier', &
'', &
'  o  Y : the multiplicand', &
'', &
'RESULT', &
'  The returned value of the product should have the same value as', &
'  DBLE(X)*DBLE(Y).', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_dprod', &
'      implicit none', &
'      integer,parameter :: dp=kind(0.0d0)', &
'      real :: x = 5.2', &
'      real :: y = 2.3', &
'      doubleprecision :: xx', &
'      real(kind=dp)   :: dd', &
'', &
'         print *,''algebraically 5.2 x 2.3 is exactly 11.96''', &
'         print *,''as floating point values results may differ slightly:''', &
'         ! basic usage', &
'         dd = dprod(x,y)', &
'         print *, ''compare dprod(xy)='',dd, &', &
'         & ''to x*y='',x*y, &', &
'         & ''to dble(x)*dble(y)='',dble(x)*dble(y)', &
'', &
'         print *,''test if an expected result is produced''', &
'         xx=-6.0d0', &
'         write(*,*)DPROD(-3.0, 2.0),xx', &
'         write(*,*)merge(''PASSED'',''FAILED'',DPROD(-3.0, 2.0) == xx)', &
'', &
'         print *,''elemental''', &
'         print *, dprod( [2.3,3.4,4.5], 10.0 )', &
'         print *, dprod( [2.3,3.4,4.5], [9.8,7.6,5.4] )', &
'', &
'      end program demo_dprod', &
'', &
'  Results: (this can vary between programming environments):', &
'', &
'          algebraically 5.2 x 2.3 is exactly 11.96', &
'          as floating point values results may differ slightly:', &
'          compare dprod(xy)=   11.959999313354501      to x*y=   11.9599991', &
'          to dble(x)*dble(y)=   11.959999313354501', &
'          test if an expected result is produced', &
'           -6.0000000000000000       -6.0000000000000000', &
'', &
'   PASSED', &
'  elemental', &
'', &
'    22.999999523162842', &
'      34.000000953674316        45.000000000000000', &
'', &
'    22.539999971389761', &
'      25.840000400543204        24.300000429153442', &
'', &
'STANDARD', &
'  FORTRAN 77', &
'', &
'SEE ALSO', &
'  ****(3)', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022                dprod(3fortran)', &
'']

shortname="dprod"
call process()


case('73','dshiftl')

textblock=[character(len=256) :: &
'', &
'dshiftl(3fortran)                                            dshiftl(3fortran)', &
'', &
'NAME', &
'  DSHIFTL(3) - [BIT:COPY] Combined left shift of the bits of two integers', &
'', &
'SYNOPSIS', &
'                               October 09, 2022              dshiftl(3fortran)', &
'']

shortname="dshiftl"
call process()


case('74','dshiftr')

textblock=[character(len=256) :: &
'', &
'dshiftr(3fortran)                                            dshiftr(3fortran)', &
'', &
'NAME', &
'  DSHIFTR(3) - [BIT:COPY] Combined right shift of the bits of two integers', &
'', &
'SYNOPSIS', &
'                               October 09, 2022              dshiftr(3fortran)', &
'']

shortname="dshiftr"
call process()


case('75','eoshift')

textblock=[character(len=256) :: &
'', &
'eoshift(3fortran)                                            eoshift(3fortran)', &
'', &
'NAME', &
'  EOSHIFT(3) - [TRANSFORMATIONAL] End-off shift elements of an array', &
'', &
'SYNOPSIS', &
'                               October 09, 2022              eoshift(3fortran)', &
'']

shortname="eoshift"
call process()


case('76','epsilon')

textblock=[character(len=256) :: &
'', &
'epsilon(3fortran)                                            epsilon(3fortran)', &
'', &
'NAME', &
'  EPSILON(3) - [NUMERIC MODEL] Epsilon function', &
'', &
'SYNOPSIS', &
'  result = epsilon(x)', &
'', &
'           real(kind=kind(x)) function epsilon(x)', &
'', &
'            real(kind=kind(x),intent(in)   :: x', &
'', &
'CHARACTERISTICS', &
'DESCRIPTION', &
'  EPSILON(3) returns the floating point relative accuracy. It is the nearly', &
'  negligible number relative to 1 such that 1+ LITTLE_NUMBER is not equal to', &
'  1; or more precisely', &
'', &
'         real( 1.0, kind(x)) + epsilon(x) /=  real( 1.0, kind(x))', &
'', &
'  It may be thought of as the distance from 1.0 to the next largest floating', &
'  point number.', &
'', &
'  One use of EPSILON(3) is to select a delta value for algorithms that search', &
'  until the calculation is within delta of an estimate.', &
'', &
'  If delta is too small the algorithm might never halt, as a computation', &
'  summing values smaller than the decimal resolution of the data type does not', &
'  change.', &
'', &
'OPTIONS', &
'  o  X : The type shall be real.', &
'', &
'RESULT', &
'  The return value is of the same type as the argument.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_epsilon', &
'      use,intrinsic :: iso_fortran_env, only : dp=>real64,sp=>real32', &
'      implicit none', &
'      real(kind=sp) :: x = 3.143', &
'      real(kind=dp) :: y = 2.33d0', &
'', &
'         ! so if x is of type real32, epsilon(x) has the value 2**-23', &
'         print *, epsilon(x)', &
'         ! note just the type and kind of x matter, not the value', &
'         print *, epsilon(huge(x))', &
'         print *, epsilon(tiny(x))', &
'', &
'         ! the value changes with the kind of the real value though', &
'         print *, epsilon(y)', &
'', &
'         ! adding and subtracting epsilon(x) changes x', &
'         write(*,*)x == x + epsilon(x)', &
'         write(*,*)x == x - epsilon(x)', &
'', &
'         ! these next two comparisons will be .true. !', &
'         write(*,*)x == x + epsilon(x) * 0.999999', &
'         write(*,*)x == x - epsilon(x) * 0.999999', &
'', &
'         ! you can calculate epsilon(1.0d0)', &
'         write(*,*)my_dp_eps()', &
'', &
'      contains', &
'', &
'         function my_dp_eps()', &
'         ! calculate the epsilon value of a machine the hard way', &
'         real(kind=dp) :: t', &
'         real(kind=dp) :: my_dp_eps', &
'', &
'            ! starting with a value of 1, keep dividing the value', &
'            ! by 2 until no change is detected. Note that with', &
'            ! infinite precision this would be an infinite loop,', &
'            ! but floating point values in Fortran have a defined', &
'            ! and limited precision.', &
'            my_dp_eps = 1.0d0', &
'            SET_ST: do', &
'               my_dp_eps = my_dp_eps/2.0d0', &
'               t = 1.0d0 + my_dp_eps', &
'               if (t <= 1.0d0) exit', &
'            enddo SET_ST', &
'            my_dp_eps = 2.0d0*my_dp_eps', &
'', &
'         end function my_dp_eps', &
'      end program demo_epsilon', &
'', &
'  Results:', &
'', &
'        1.1920929E-07', &
'        1.1920929E-07', &
'        1.1920929E-07', &
'        2.220446049250313E-016', &
'', &
'   F', &
'   F', &
'   T', &
'   T', &
'  2.220446049250313E-016', &
'', &
'STANDARD', &
'  Fortran 95', &
'', &
'SEE ALSO', &
'  DIGITS(3), EXPONENT(3), FRACTION(3), HUGE(3), MAXEXPONENT(3),', &
'  MINEXPONENT(3), NEAREST(3), PRECISION(3), RADIX(3), RANGE(3), RRSPACING(3),', &
'  SCALE(3), SET_EXPONENT(3), SPACING(3), TINY(3)', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022              epsilon(3fortran)', &
'']

shortname="epsilon"
call process()


case('77','erf')

textblock=[character(len=256) :: &
'', &
'erf(3fortran)                                                    erf(3fortran)', &
'', &
'NAME', &
'  ERF(3) - [MATHEMATICS] Error function', &
'', &
'SYNOPSIS', &
'  result = erf(x)', &
'', &
'           elemental real(kind=KIND) function erf(x)', &
'', &
'            real(kind=KIND),intent(in) :: x', &
'', &
'CHARACTERISTICS', &
'  o  The result is of the same type and kind as X.', &
'', &
'DESCRIPTION', &
'  ERF(3) computes the error function of X, defined as', &
'', &
'  $$ \text{erf}(x) = \frac{2}{\sqrt{\pi}} \int_0^x e^{-T^2} dt. $$', &
'', &
'OPTIONS', &
'  o  X : The type shall be real.', &
'', &
'RESULT', &
'  The return value is of type real, of the same kind as X and lies in the', &
'  range -1 <= ERF(x) <= 1 .', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_erf', &
'      use, intrinsic :: iso_fortran_env, only : real_kinds, &', &
'       & real32, real64, real128', &
'      implicit none', &
'      real(kind=real64) :: x = 0.17_real64', &
'          write(*,*)x, erf(x)', &
'      end program demo_erf', &
'', &
'  Results:', &
'', &
'           0.17000000000000001       0.18999246120180879', &
'', &
'STANDARD', &
'  Fortran 2008', &
'', &
'SEE ALSO', &
'  ERFC(3), ERF_SCALED(3)', &
'', &
'RESOURCES', &
'  o  Wikipedia:error function', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022                  erf(3fortran)', &
'']

shortname="erf"
call process()


case('78','erfc')

textblock=[character(len=256) :: &
'', &
'erfc(3fortran)                                                  erfc(3fortran)', &
'', &
'NAME', &
'  ERFC(3) - [MATHEMATICS] Complementary error function', &
'', &
'SYNOPSIS', &
'  result = erfc(x)', &
'', &
'           elemental real(kind=KIND) function erfc(x)', &
'', &
'            real(kind=KIND),intent(in) :: x', &
'', &
'CHARACTERISTICS', &
'DESCRIPTION', &
'  ERFC(3) computes the complementary error function of X. Simply put this is', &
'  equivalent to 1 - ERF(X), but ERFC is provided because of the extreme loss', &
'  of relative accuracy if ERF(X) is called for large X and the result is', &
'  subtracted from 1.', &
'', &
'  ERFC(X) is defined as', &
'', &
'  $$ \text{erfc}(x) = 1 - \text{erf}(x) = 1 - \frac{2}{\sqrt{\pi}}', &
'  \int_x^{\infty} e^{-t^2} dt. $$', &
'', &
'OPTIONS', &
'  o  X : The type shall be real.', &
'', &
'RESULT', &
'  The return value is of type real and of the same kind as X. It lies in the', &
'  range', &
'', &
'    0 <= ERFC(x) <= 2.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_erfc', &
'      use, intrinsic :: iso_fortran_env, only : &', &
'       & real_kinds, real32, real64, real128', &
'      implicit none', &
'      real(kind=real64) :: x = 0.17_real64', &
'          write(*,*)x, erfc(x)', &
'      end program demo_erfc', &
'', &
'  Results:', &
'', &
'           0.17000000000000001       0.81000753879819121', &
'', &
'STANDARD', &
'  Fortran 2008', &
'', &
'  *SEE ALSO', &
'', &
'  ERF(3) ERF_SCALED(3)', &
'', &
'RESOURCES', &
'  o  Wikipedia:error function', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022                 erfc(3fortran)', &
'']

shortname="erfc"
call process()


case('79','erfc_scaled')

textblock=[character(len=256) :: &
'', &
'erfc_scaled(3fortran)                                    erfc_scaled(3fortran)', &
'', &
'NAME', &
'  ERFC_SCALED(3) - [MATHEMATICS] Error function', &
'', &
'SYNOPSIS', &
'  result = erfc_scaled(x)', &
'', &
'           elemental real(kind=KIND) function erfc_scaled(x)', &
'', &
'            real(kind=KIND),intent(in) :: x', &
'', &
'CHARACTERISTICS', &
'DESCRIPTION', &
'  ERFC_SCALED(3) computes the exponentially-scaled complementary error', &
'  function of X:', &
'', &
'  $$ e^{x^2} \frac{2}{\sqrt{\pi}} \int_{x}^{\infty} e^{-t^2} dt. $$', &
'', &
'OPTIONS', &
'  o  X : The type shall be real.', &
'', &
'RESULT', &
'  The return value is of type real and of the same kind as X.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_erfc_scaled', &
'      implicit none', &
'      real(kind(0.0d0)) :: x = 0.17d0', &
'         x = erfc_scaled(x)', &
'         print *, x', &
'      end program demo_erfc_scaled', &
'', &
'  Results:', &
'', &
'           0.83375830214998126', &
'', &
'STANDARD', &
'  Fortran 2008', &
'', &
'SEE ALSO', &
'  ERF(3) ERFC(3)', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022          erfc_scaled(3fortran)', &
'']

shortname="erfc_scaled"
call process()


case('80','event_query')

textblock=[character(len=256) :: &
'', &
'event_query(3fortran)                                    event_query(3fortran)', &
'', &
'NAME', &
'  EVENT_QUERY(3) - [COLLECTIVE] Query whether a coarray event has occurred', &
'', &
'SYNOPSIS', &
'                               October 09, 2022          event_query(3fortran)', &
'']

shortname="event_query"
call process()


case('81','execute_command_line')

textblock=[character(len=256) :: &
'', &
'execute_command_line(3fortran)                  execute_command_line(3fortran)', &
'', &
'NAME', &
'  EXECUTE_COMMAND_LINE(3) - [SYSTEM:PROCESSES] Execute a shell command', &
'', &
'SYNOPSIS', &
'                               October 09, 2022 execute_command_line(3fortran)', &
'']

shortname="execute_command_line"
call process()


case('82','exp')

textblock=[character(len=256) :: &
'', &
'exp(3fortran)                                                    exp(3fortran)', &
'', &
'NAME', &
'  EXP(3) - [MATHEMATICS] Base-e exponential function', &
'', &
'SYNOPSIS', &
'  result = exp(x)', &
'', &
'           elemental TYPE(kind=KIND) function exp(x)', &
'', &
'            TYPE(kind=KIND),intent(in) :: x', &
'', &
'CHARACTERISTICS', &
'  o  X may be real or complex.', &
'', &
'  o  The return value has the same type and kind as X.', &
'', &
'DESCRIPTION', &
'  EXP(3) returns the value of e (the base of natural logarithms) raised to the', &
'  power of X.', &
'', &
'  "e" is also known as Euler''s constant.', &
'', &
'  If X is of type complex, its imaginary part is regarded as a value in', &
'  radians such that if (see Euler''s formula):', &
'', &
'          cx=(re,im)', &
'', &
'  then', &
'', &
'          exp(cx) = exp(re) * cmplx(cos(im),sin(im),kind=kind(cx))', &
'', &
'  Since EXP(3) is the inverse function of LOG(3) the maximum valid magnitude', &
'  of the real component of X is LOG(HUGE(X)).', &
'', &
'OPTIONS', &
'  o  X : The type shall be real or complex.', &
'', &
'RESULT', &
'  The value of the result is E**X where E is Euler''s constant.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_exp', &
'      implicit none', &
'      real :: x, re, im', &
'      complex :: cx', &
'', &
'         x = 1.0', &
'         write(*,*)"Euler''s constant is approximately",exp(x)', &
'', &
'         !! complex values', &
'         ! given', &
'         re=3.0', &
'         im=4.0', &
'         cx=cmplx(re,im)', &
'', &
'         ! complex results from complex arguments are Related to Euler''s formula', &
'         write(*,*)''given the complex value '',cx', &
'         write(*,*)''exp(x) is'',exp(cx)', &
'         write(*,*)''is the same as'',exp(re)*cmplx(cos(im),sin(im),kind=kind(cx))', &
'', &
'         ! exp(3) is the inverse function of log(3) so', &
'         ! the real component of the input must be less than or equal to', &
'         write(*,*)''maximum real component'',log(huge(0.0))', &
'         ! or for double precision', &
'         write(*,*)''maximum doubleprecision component'',log(huge(0.0d0))', &
'', &
'         ! but since the imaginary component is passed to the cos(3) and sin(3)', &
'         ! functions the imaginary component can be any real value', &
'', &
'      end program demo_exp', &
'', &
'  Results:', &
'', &
'       Euler''s constant is approximately   2.718282', &
'       given the complex value  (3.000000,4.000000)', &
'       exp(x) is (-13.12878,-15.20078)', &
'       is the same as (-13.12878,-15.20078)', &
'       maximum real component   88.72284', &
'       maximum doubleprecision component   709.782712893384', &
'', &
'STANDARD', &
'  FORTRAN 77', &
'', &
'SEE ALSO', &
'  o  LOG(3)', &
'', &
'RESOURCES', &
'  o  Wikipedia:Exponential function', &
'', &
'  o  Wikipedia:Euler''s formula', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022                  exp(3fortran)', &
'']

shortname="exp"
call process()


case('83','exponent')

textblock=[character(len=256) :: &
'', &
'exponent(3fortran)                                          exponent(3fortran)', &
'', &
'NAME', &
'  EXPONENT(3) - [MODEL_COMPONENTS] Exponent function', &
'', &
'SYNOPSIS', &
'  result = exponent(x)', &
'', &
'           elemental integer function exponent(x)', &
'', &
'            real(kind=KIND),intent(in) :: x', &
'', &
'CHARACTERISTICS', &
'DESCRIPTION', &
'  EXPONENT(3) returns the value of the exponent part of X. If X is zero the', &
'  value returned is zero.', &
'', &
'OPTIONS', &
'  o  X : The type shall be real.', &
'', &
'RESULT', &
'  The return value is of type default integer.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_exponent', &
'      implicit none', &
'      real :: x = 1.0', &
'      integer :: i', &
'         i = exponent(x)', &
'         print *, i', &
'         print *, exponent(0.0)', &
'      end program demo_exponent', &
'', &
'  Results:', &
'', &
'    1 0', &
'', &
'STANDARD', &
'  Fortran 95', &
'', &
'SEE ALSO', &
'  DIGITS(3), EPSILON(3), FRACTION(3), HUGE(3), MAXEXPONENT(3), MINEXPONENT(3),', &
'  NEAREST(3), PRECISION(3), RADIX(3), RANGE(3), RRSPACING(3), SCALE(3),', &
'  SET_EXPONENT(3), SPACING(3), TINY(3)', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022             exponent(3fortran)', &
'']

shortname="exponent"
call process()


case('84','extends_type_of')

textblock=[character(len=256) :: &
'', &
'extends_type_of(3fortran)                            extends_type_of(3fortran)', &
'', &
'NAME', &
'  EXTENDS_TYPE_OF(3) - [STATE] Determine if the dynamic type of A is an', &
'  extension of the dynamic type of MOLD.', &
'', &
'SYNOPSIS', &
'                               October 09, 2022      extends_type_of(3fortran)', &
'']

shortname="extends_type_of"
call process()


case('85','findloc')

textblock=[character(len=256) :: &
'', &
'findloc(3fortran)                                            findloc(3fortran)', &
'', &
'NAME', &
'  FINDLOC(3) - [ARRAY:LOCATION] Location of first element of ARRAY identified', &
'  by MASK along dimension DIM matching a target value', &
'', &
'SYNOPSIS', &
'                               October 09, 2022              findloc(3fortran)', &
'']

shortname="findloc"
call process()


case('86','floor')

textblock=[character(len=256) :: &
'', &
'floor(3fortran)                                                floor(3fortran)', &
'', &
'NAME', &
'  FLOOR(3) - [NUMERIC] Function to return largest integral value not greater', &
'  than argument', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                floor(3fortran)', &
'']

shortname="floor"
call process()


case('87','fraction')

textblock=[character(len=256) :: &
'', &
'fraction(3fortran)                                          fraction(3fortran)', &
'', &
'NAME', &
'  FRACTION(3) - [MODEL_COMPONENTS] Fractional part of the model representation', &
'', &
'SYNOPSIS', &
'  result = fraction(x)', &
'', &
'           elemental real(kind=KIND) function fraction(x)', &
'', &
'            real(kind=KIND),intent(in) :: fraction', &
'', &
'CHARACTERISTICS', &
'  The result has the same characteristics as the argument.', &
'', &
'DESCRIPTION', &
'  FRACTION(3) returns the fractional part of the model representation of X.', &
'', &
'OPTIONS', &
'  o  X : The value to interrogate', &
'', &
'RESULT', &
'  The fractional part of the model representation of X is returned; it is X *', &
'  RADIX(X)**(-EXPONENT(X)).', &
'', &
'  If X has the value zero, the result is zero.', &
'', &
'  If X is an IEEE NaN, the result is that NaN.', &
'', &
'  If X is an IEEE infinity, the result is an IEEE NaN.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_fraction', &
'      implicit none', &
'      real :: x', &
'         x = 178.1387e-4', &
'         print *, fraction(x), x * radix(x)**(-exponent(x))', &
'      end program demo_fraction', &
'', &
'  Results:', &
'', &
'           0.570043862      0.570043862', &
'', &
'STANDARD', &
'  Fortran 95', &
'', &
'SEE ALSO', &
'  DIGITS(3), EPSILON(3), EXPONENT(3), HUGE(3), MAXEXPONENT(3), MINEXPONENT(3),', &
'  NEAREST(3), PRECISION(3), RADIX(3), RANGE(3), RRSPACING(3), SCALE(3),', &
'  SET_EXPONENT(3), SPACING(3), TINY(3)', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022             fraction(3fortran)', &
'']

shortname="fraction"
call process()


case('88','gamma')

textblock=[character(len=256) :: &
'', &
'gamma(3fortran)                                                gamma(3fortran)', &
'', &
'NAME', &
'  GAMMA(3) - [MATHEMATICS] Gamma function, which yields factorials for', &
'  positive whole numbers', &
'', &
'SYNOPSIS', &
'  result = gamma(x)', &
'', &
'           elemental real(kind=KIND) function gamma( x)', &
'', &
'            type(real,kind=KIND),intent(in) :: x', &
'', &
'CHARACTERISTICS', &
'  o  GAMMA(3) returns a real value with the kind as X.', &
'', &
'DESCRIPTION', &
'  GAMMA(X) computes Gamma of X. For positive whole number values of N the', &
'  Gamma function can be used to calculate factorials, as (N-1)! ==', &
'  GAMMA(REAL(N)). That is', &
'', &
'      n! == gamma(real(n+1))', &
'', &
'  $$ \GAMMA(x) = \int_0**\infty t**{x-1}{\mathrm{e}}**{-T}\,{\mathrm{d}}t $$', &
'', &
'OPTIONS', &
'  o  X : Shall be of type real and neither zero nor a negative integer.', &
'', &
'RESULT', &
'  The return value is of type real of the same kind as x.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_gamma', &
'      use, intrinsic :: iso_fortran_env, only : wp=>real64', &
'      implicit none', &
'      real :: x, xa(4)', &
'      integer :: i', &
'', &
'         x = gamma(1.0)', &
'         write(*,*)''gamma(1.0)='',x', &
'', &
'         ! elemental', &
'         xa=gamma([1.0,2.0,3.0,4.0])', &
'         write(*,*)xa', &
'         write(*,*)', &
'', &
'         ! gamma(3) is related to the factorial function', &
'         do i=1,20', &
'            ! check value is not too big for default integer type', &
'            if(factorial(i).gt.huge(0))then', &
'               write(*,*)i,factorial(i)', &
'            else', &
'               write(*,*)i,factorial(i),int(factorial(i))', &
'            endif', &
'         enddo', &
'         ! more factorials', &
'         FAC: block', &
'         integer,parameter :: n(*)=[0,1,5,11,170]', &
'         integer :: j', &
'            do j=1,size(n)', &
'               write(*,''(*(g0,1x))'')''factorial of'', n(j),'' is '', &', &
'                & product([(real(i,kind=wp),i=1,n(j))]),  &', &
'                & gamma(real(n(j)+1,kind=wp))', &
'            enddo', &
'         endblock FAC', &
'', &
'         contains', &
'         function factorial(i) result(f)', &
'         integer,parameter :: dp=kind(0d0)', &
'         integer,intent(in) :: i', &
'         real :: f', &
'            if(i.le.0)then', &
'               write(*,''(*(g0))'')''<ERROR> gamma(3) function value '',i,'' <= 0''', &
'               stop      ''<STOP> bad value in gamma function''', &
'            endif', &
'            f=gamma(real(i+1))', &
'         end function factorial', &
'      end program demo_gamma', &
'', &
'  Results:', &
'', &
'          gamma(1.0)=   1.000000', &
'            1.000000       1.000000       2.000000       6.000000', &
'', &
'                    1   1.000000               1', &
'                    2   2.000000               2', &
'                    3   6.000000               6', &
'                    4   24.00000              24', &
'                    5   120.0000             120', &
'                    6   720.0000             720', &
'                    7   5040.000            5040', &
'                    8   40320.00           40320', &
'                    9   362880.0          362880', &
'                   10   3628800.         3628800', &
'                   11  3.9916800E+07    39916800', &
'                   12  4.7900160E+08   479001600', &
'                   13  6.2270208E+09', &
'                   14  8.7178289E+10', &
'                   15  1.3076744E+12', &
'                   16  2.0922791E+13', &
'                   17  3.5568741E+14', &
'                   18  6.4023735E+15', &
'                   19  1.2164510E+17', &
'                   20  2.4329020E+18', &
'', &
'    factorial of 0', &
'      is  1.000000000000000 1.000000000000000', &
'', &
'    factorial of 1', &
'      is  1.000000000000000 1.000000000000000', &
'', &
'    factorial of 5', &
'      is  120.0000000000000 120.0000000000000', &
'', &
'    factorial of 11', &
'      is  39916800.00000000 39916800.00000000', &
'', &
'    factorial of 170', &
'      is  .7257415615307994E+307 .7257415615307999E+307', &
'', &
'STANDARD', &
'  Fortran 2008', &
'', &
'SEE ALSO', &
'  Logarithm of the Gamma function: LOG_GAMMA(3)', &
'', &
'RESOURCES', &
'  Wikipedia: Gamma_function', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022                gamma(3fortran)', &
'']

shortname="gamma"
call process()


case('89','get_command')

textblock=[character(len=256) :: &
'', &
'get_command(3fortran)                                    get_command(3fortran)', &
'', &
'NAME', &
'  GET_COMMAND(3) - [SYSTEM:COMMAND LINE] Get the entire command line', &
'  invocation', &
'', &
'SYNOPSIS', &
'                               October 09, 2022          get_command(3fortran)', &
'']

shortname="get_command"
call process()


case('90','get_command_argument')

textblock=[character(len=256) :: &
'', &
'get_command_argument(3fortran)                  get_command_argument(3fortran)', &
'', &
'NAME', &
'  GET_COMMAND_ARGUMENT(3) - [SYSTEM:COMMAND LINE] Get command line arguments', &
'', &
'SYNOPSIS', &
'                               October 09, 2022 get_command_argument(3fortran)', &
'']

shortname="get_command_argument"
call process()


case('91','get_environment_variable')

textblock=[character(len=256) :: &
'', &
'get_environment_variable(3fortran)          get_environment_variable(3fortran)', &
'', &
'NAME', &
'  GET_ENVIRONMENT_VARIABLE(3) - [SYSTEM:ENVIRONMENT] Get value of an', &
'  environment variable', &
'', &
'SYNOPSIS', &
'                               October 09, 2get_environment_variable(3fortran)', &
'']

shortname="get_environment_variable"
call process()


case('92','huge')

textblock=[character(len=256) :: &
'', &
'huge(3fortran)                                                  huge(3fortran)', &
'', &
'NAME', &
'  HUGE(3) - [NUMERIC MODEL] Largest number of a type and kind', &
'', &
'SYNOPSIS', &
'  result = huge(x)', &
'', &
'           TYPE(kind=KIND) function huge(x)', &
'', &
'            TYPE(kind=KIND),intent(in) :: x', &
'', &
'CHARACTERISTICS', &
'  where TYPE may be real or integer and KIND is any supported associated kind.', &
'  It need not be defined, as only its characteristics are used.', &
'', &
'  The result will be of the same type and kind as the input to ensure the', &
'  returned value does not overflow. Any assignment of the result should take', &
'  this into consideration.', &
'', &
'DESCRIPTION', &
'  HUGE(3) returns the largest number that is not an infinity for the kind and', &
'  type of X.', &
'', &
'OPTIONS', &
'  o  X : XX is an arbitrary value which is used merely to determine what kind', &
'     and type of scalar is being queried.', &
'', &
'RESULT', &
'  The return value is of the same type and kind as x and is the largest value', &
'  supported by the specified model.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_huge', &
'      implicit none', &
'      character(len=*),parameter :: f=''(i2,1x,2(i11,1x),f14.0:,1x,l1,1x,a)''', &
'      integer :: i,j,k,biggest', &
'      real :: v, w', &
'         ! basic', &
'         print *, huge(0), huge(0.0), huge(0.0d0)', &
'         print *, tiny(0.0), tiny(0.0d0)', &
'', &
'         ! advanced', &
'         biggest=huge(0)', &
'         ! be careful of overflow when using integers in computation', &
'         do i=1,14', &
'            j=6**i   ! Danger, Danger', &
'            w=6**i   ! Danger, Danger', &
'            v=6.0**i', &
'            k=v      ! Danger, Danger', &
'            if(v.gt.biggest)then', &
'               write(*,f) i, j, k, v, v.eq.w, ''wrong j and k and w''', &
'            else', &
'               write(*,f) i, j, k, v, v.eq.w', &
'            endif', &
'         enddo', &
'      end program demo_huge', &
'', &
'  Results:', &
'', &
'        2147483647  3.4028235E+38  1.797693134862316E+308', &
'        1.1754944E-38  2.225073858507201E-308', &
'', &
'          1      6           6             6. T', &
'          2      36          36            36. T', &
'          3      216         216           216. T', &
'          4      1296        1296          1296. T', &
'          5      7776        7776          7776. T', &
'          6      46656       46656         46656. T', &
'          7      279936      279936        279936. T', &
'          8      1679616     1679616       1679616. T', &
'          9      10077696    10077696      10077696. T', &
'          10     60466176    60466176      60466176. T', &
'          11     362797056   362797056     362797056. T', &
'          12    -2118184960 -2147483648    2176782336. F wrong for j and k and w', &
'          13     175792128  -2147483648   13060694016. F wrong for j and k and w', &
'          14     1054752768 -2147483648   78364164096. F wrong for j and k and w', &
'', &
'STANDARD', &
'  Fortran 95', &
'', &
'SEE ALSO', &
'  DIGITS(3), EPSILON(3), EXPONENT(3), FRACTION(3), MAXEXPONENT(3),', &
'  MINEXPONENT(3), NEAREST(3), PRECISION(3), RADIX(3), RANGE(3), RRSPACING(3),', &
'  SCALE(3), SET_EXPONENT(3), SPACING(3), TINY(3)', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022                 huge(3fortran)', &
'']

shortname="huge"
call process()


case('93','hypot')

textblock=[character(len=256) :: &
'', &
'hypot(3fortran)                                                hypot(3fortran)', &
'', &
'NAME', &
'  HYPOT(3) - [MATHEMATICS] Returns the distance between the point and the', &
'  origin.', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                hypot(3fortran)', &
'']

shortname="hypot"
call process()


case('94','iachar')

textblock=[character(len=256) :: &
'', &
'iachar(3fortran)                                              iachar(3fortran)', &
'', &
'NAME', &
'  IACHAR(3) - [CHARACTER:CONVERSION] Return integer ASCII code of a character', &
'', &
'SYNOPSIS', &
'                               October 09, 2022               iachar(3fortran)', &
'']

shortname="iachar"
call process()


case('95','iall')

textblock=[character(len=256) :: &
'', &
'iall(3fortran)                                                  iall(3fortran)', &
'', &
'NAME', &
'  IALL(3) - [BIT:LOGICAL] Bitwise and of array elements', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                 iall(3fortran)', &
'']

shortname="iall"
call process()


case('96','iand')

textblock=[character(len=256) :: &
'', &
'iand(3fortran)                                                  iand(3fortran)', &
'', &
'NAME', &
'  IAND(3) - [BIT:LOGICAL] Bitwise logical AND', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                 iand(3fortran)', &
'']

shortname="iand"
call process()


case('97','iany')

textblock=[character(len=256) :: &
'', &
'iany(3fortran)                                                  iany(3fortran)', &
'', &
'NAME', &
'  IANY(3) - [BIT:LOGICAL] Bitwise OR of array elements', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                 iany(3fortran)', &
'']

shortname="iany"
call process()


case('98','ibclr')

textblock=[character(len=256) :: &
'', &
'ibclr(3fortran)                                                ibclr(3fortran)', &
'', &
'NAME', &
'  IBCLR(3) - [BIT:SET] Clear bit', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                ibclr(3fortran)', &
'']

shortname="ibclr"
call process()


case('99','ibits')

textblock=[character(len=256) :: &
'', &
'ibits(3fortran)                                                ibits(3fortran)', &
'', &
'NAME', &
'  IBITS(3) - [BIT:COPY] extraction of a subset of bits', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                ibits(3fortran)', &
'']

shortname="ibits"
call process()


case('100','ibset')

textblock=[character(len=256) :: &
'', &
'ibset(3fortran)                                                ibset(3fortran)', &
'', &
'NAME', &
'  IBSET(3) - [BIT:SET] Set a bit to one in an integer value', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                ibset(3fortran)', &
'']

shortname="ibset"
call process()


case('101','ichar')

textblock=[character(len=256) :: &
'', &
'ichar(3fortran)                                                ichar(3fortran)', &
'', &
'NAME', &
'  ICHAR(3) - [CHARACTER:CONVERSION] Character-to-integer conversion function', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                ichar(3fortran)', &
'']

shortname="ichar"
call process()


case('102','ieor')

textblock=[character(len=256) :: &
'', &
'ieor(3fortran)                                                  ieor(3fortran)', &
'', &
'NAME', &
'  IEOR(3) - [BIT:LOGICAL] Bitwise exclusive OR', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                 ieor(3fortran)', &
'']

shortname="ieor"
call process()


case('103','image_index')

textblock=[character(len=256) :: &
'', &
'image_index(3fortran)                                    image_index(3fortran)', &
'', &
'NAME', &
'  IMAGE_INDEX(3) - [COLLECTIVE] Cosubscript to image index conversion', &
'', &
'SYNOPSIS', &
'                               October 09, 2022          image_index(3fortran)', &
'']

shortname="image_index"
call process()


case('104','index')

textblock=[character(len=256) :: &
'', &
'index(3fortran)                                                index(3fortran)', &
'', &
'NAME', &
'  INDEX(3) - [CHARACTER:SEARCH] Position of a substring within a string', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                index(3fortran)', &
'']

shortname="index"
call process()


case('105','int')

textblock=[character(len=256) :: &
'', &
'int(3fortran)                                                    int(3fortran)', &
'', &
'NAME', &
'  INT(3) - [TYPE:NUMERIC] Convert to integer type by truncating towards zero', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                  int(3fortran)', &
'']

shortname="int"
call process()


case('106','ior')

textblock=[character(len=256) :: &
'', &
'ior(3fortran)                                                    ior(3fortran)', &
'', &
'NAME', &
'  IOR(3) - [BIT:LOGICAL] Bitwise logical inclusive OR', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                  ior(3fortran)', &
'']

shortname="ior"
call process()


case('107','iparity')

textblock=[character(len=256) :: &
'', &
'iparity(3fortran)                                            iparity(3fortran)', &
'', &
'NAME', &
'  IPARITY(3) - [BIT:LOGICAL] Bitwise exclusive or of array elements', &
'', &
'SYNOPSIS', &
'                               October 09, 2022              iparity(3fortran)', &
'']

shortname="iparity"
call process()


case('108','is_contiguous')

textblock=[character(len=256) :: &
'', &
'is_contiguous(3fortran)                                is_contiguous(3fortran)', &
'', &
'NAME', &
'  IS_CONTIGUOUS(3) - [ARRAY:INQUIRY] Test if object is contiguous', &
'', &
'SYNOPSIS', &
'  result = is_contiguous(a)', &
'', &
'           logical function is_contigious(a)', &
'', &
'            type(TYPE(kind=**)),intent(in) :: a', &
'', &
'CHARACTERISTICS', &
'  o  a kind designated as ** may be any supported kind value for the type', &
'', &
'  o  A may be of any type. It shall be an array. If it is a pointer it shall', &
'     be associated.', &
'', &
'  o  the result is a default logical scalar', &
'', &
'DESCRIPTION', &
'  IS_CONTIGIOUS(3) returns .true. if and only if an object is contiguous.', &
'', &
'  An object is contiguous if it is', &
'', &
'  o  (1) an object with the CONTIGUOUS attribute,', &
'', &
'  o  (2) a nonpointer whole array that is not assumed-shape,', &
'', &
'  o  (3) an assumed-shape array that is argument associated with an array that', &
'     is contiguous,', &
'', &
'  o  (4) an array allocated by an ALLOCATE statement,', &
'', &
'  o  (5) a pointer associated with a contiguous target, or', &
'', &
'  o  (6) a nonzero-sized array section provided that', &
'', &
'     o  (A) its base object is contiguous,', &
'', &
'     o  (B) it does not have a vector subscript,', &
'', &
'     o  (C) the elements of the section, in array element order, are a subset', &
'        of the base object elements that are consecutive in array element', &
'        order,', &
'', &
'     o  (D) if the array is of type character and a substring-range appears,', &
'        the substring-range specifies all of the characters of the parent-', &
'        string,', &
'', &
'     o  (E) only its final part-ref has nonzero rank, and', &
'', &
'     o  (F) it is not the real or imaginary part of an array of type complex.', &
'', &
'  An object is not contiguous if it is an array subobject, and', &
'', &
'  o  the object has two or more elements,', &
'', &
'  o  the elements of the object in array element order are not consecutive in', &
'     the elements of the base object,', &
'', &
'  o  the object is not of type character with length zero, and', &
'', &
'  o  the object is not of a derived type that has no ultimate components other', &
'     than zero-sized arrays and', &
'', &
'  o  characters with length zero.', &
'', &
'  It is processor-dependent whether any other object is contiguous.', &
'', &
'OPTIONS', &
'  o  A : An array of any type to be tested for being contigious. If it is a', &
'     pointer it shall be associated.', &
'', &
'RESULT', &
'  The result has the value .true. if A is contiguous, and .false.  otherwise.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_is_contiguous', &
'      implicit none', &
'      intrinsic is_contiguous', &
'      real, DIMENSION (1000, 1000), TARGET :: A', &
'      real, DIMENSION (:, :), POINTER       :: IN, OUT', &
'         IN => A              ! Associate IN with target A', &
'         OUT => A(1:1000:2,:) ! Associate OUT with subset of target A', &
'         !', &
'         write(*,*)''IN is '',IS_CONTIGUOUS(IN)', &
'         write(*,*)''OUT is '',IS_CONTIGUOUS(OUT)', &
'         !', &
'      end program demo_is_contiguous', &
'', &
'  Results:', &
'', &
'          IN is  T', &
'          OUT is  F', &
'', &
'STANDARD', &
'  Fortran 2008', &
'', &
'SEE ALSO', &
'  ****(3)', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022        is_contiguous(3fortran)', &
'']

shortname="is_contiguous"
call process()


case('109','ishft')

textblock=[character(len=256) :: &
'', &
'ishft(3fortran)                                                ishft(3fortran)', &
'', &
'NAME', &
'  ISHFT(3) - [BIT:SHIFT] Shift bits', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                ishft(3fortran)', &
'']

shortname="ishft"
call process()


case('110','ishftc')

textblock=[character(len=256) :: &
'', &
'ishftc(3fortran)                                              ishftc(3fortran)', &
'', &
'NAME', &
'  ISHFTC(3) - [BIT:SHIFT] Shift rightmost bits circularly, AKA. a logical', &
'  shift', &
'', &
'SYNOPSIS', &
'                               October 09, 2022               ishftc(3fortran)', &
'']

shortname="ishftc"
call process()


case('111','is_iostat_end')

textblock=[character(len=256) :: &
'', &
'is_iostat_end(3fortran)                                is_iostat_end(3fortran)', &
'', &
'NAME', &
'  IS_IOSTAT_END(3) - [STATE] Test for end-of-file value', &
'', &
'SYNOPSIS', &
'  result = is_iostat_end(iostat)', &
'', &
'           elemental logical function is_iostat_end(iostat)', &
'', &
'            integer,intent(in) :: iostat', &
'', &
'CHARACTERISTICS', &
'DESCRIPTION', &
'  IS_IOSTAT_END(3) tests whether a variable (assumed returned as a status from', &
'  an I/O statement) has the "end of file" I/O status value.', &
'', &
'  The function is equivalent to comparing the variable with the IOSTAT_END', &
'  parameter of the intrinsic module ISO_FORTRAN_ENV.', &
'', &
'OPTIONS', &
'  o  I : An integer status value to test if indicating end of file.', &
'', &
'RESULT', &
'  Returns a logical of the default kind, .true. if I has the value which', &
'  indicates an end of file condition for IOSTAT= specifiers, and is \.false.', &
'  otherwise.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_iostat', &
'      implicit none', &
'      real               :: value', &
'      integer            :: ios', &
'      character(len=256) :: message', &
'         write(*,*)''Begin entering numeric values, one per line''', &
'         do', &
'            read(*,*,iostat=ios,iomsg=message)value', &
'            if(ios.eq.0)then', &
'               write(*,*)''VALUE='',value', &
'            elseif( is_iostat_end(ios) ) then', &
'               stop ''end of file. Goodbye!''', &
'            else', &
'               write(*,*)''ERROR:'',ios,trim(message)', &
'            endif', &
'            !', &
'         enddo', &
'      end program demo_iostat', &
'', &
'STANDARD', &
'  Fortran 2003', &
'', &
'SEE ALSO', &
'  ****(3)', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022        is_iostat_end(3fortran)', &
'']

shortname="is_iostat_end"
call process()


case('112','is_iostat_eor')

textblock=[character(len=256) :: &
'', &
'is_iostat_eor(3fortran)                                is_iostat_eor(3fortran)', &
'', &
'NAME', &
'  IS_IOSTAT_EOR(3) - [STATE] Test for end-of-record value', &
'', &
'SYNOPSIS', &
'  result = is_iostat_eor(i)', &
'', &
'           elemental integer function is_iostat_eor(i)', &
'', &
'            integer(kind=KIND),intent(in) :: iostat', &
'', &
'CHARACTERISTICS', &
'DESCRIPTION', &
'  IS_IOSTAT_EOR(3) tests whether a variable has the value of the I/O status', &
'  "end of record". The function is equivalent to comparing the variable with', &
'  the IOSTAT_EOR parameter of the intrinsic module ISO_FORTRAN_ENV.', &
'', &
'OPTIONS', &
'  o  I : The value to test as indicating "end of record".', &
'', &
'RESULT', &
'  Returns a logical of the default kind, which is .true. if I has the value', &
'  which indicates an end of file condition for iostat= specifiers, and is', &
'  .false. otherwise.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_is_iostat_eor', &
'      use iso_fortran_env, only : iostat_eor', &
'      implicit none', &
'      integer :: inums(50), lun, ios', &
'', &
'        open(newunit=lun, file=''_test.dat'', form=''unformatted'')', &
'        write(lun, ''(a)'') ''10 20 30''', &
'        write(lun, ''(a)'') ''40 50 60 70''', &
'        write(lun, ''(a)'') ''80 90''', &
'        write(lun, ''(a)'') ''100''', &
'', &
'        do', &
'           read(lun, *, iostat=ios) inums', &
'           write(*,*)''iostat='',ios', &
'           if(is_iostat_eor(ios)) stop ''end of record''', &
'        enddo', &
'', &
'        close(lun,iostat=ios,status=''delete'')', &
'', &
'      end program demo_is_iostat_eor', &
'', &
'STANDARD', &
'  Fortran 2003', &
'', &
'SEE ALSO', &
'  ****(3)', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022        is_iostat_eor(3fortran)', &
'']

shortname="is_iostat_eor"
call process()


case('113','kind')

textblock=[character(len=256) :: &
'', &
'kind(3fortran)                                                  kind(3fortran)', &
'', &
'NAME', &
'  KIND(3) - [KIND:INQUIRY] Kind of an entity', &
'', &
'SYNOPSIS', &
'  result = kind(x)', &
'', &
'           integer function kind(x)', &
'', &
'            type(TYPE,kind=KIND),intent(in) :: x(..)', &
'', &
'CHARACTERISTICS', &
'  TYPE may logical, integer, real, complex or character.', &
'', &
'  X may be of any kind supported by the type, and may be scalar or an array.', &
'', &
'DESCRIPTION', &
'                               October 09, 2022                 kind(3fortran)', &
'']

shortname="kind"
call process()


case('114','lbound')

textblock=[character(len=256) :: &
'', &
'lbound(3fortran)                                              lbound(3fortran)', &
'', &
'NAME', &
'  LBOUND(3) - [ARRAY:INQUIRY] Lower dimension bounds of an array', &
'', &
'SYNOPSIS', &
'                               October 09, 2022               lbound(3fortran)', &
'']

shortname="lbound"
call process()


case('115','leadz')

textblock=[character(len=256) :: &
'', &
'leadz(3fortran)                                                leadz(3fortran)', &
'', &
'NAME', &
'  LEADZ(3) - [BIT:COUNT] Number of leading zero bits of an integer', &
'', &
'SYNOPSIS', &
'  result = leadz(i)', &
'', &
'           elemental integer function leadz(i)', &
'', &
'            integer(kind=KIND),intent(in) :: i', &
'', &
'CHARACTERISTICS', &
'DESCRIPTION', &
'  LEADZ(3) returns the number of leading zero bits of an integer.', &
'', &
'OPTIONS', &
'  o  I : integer to count the leading zero bits of.', &
'', &
'RESULT', &
'  The type of the return value is the same as a default integer. If all the', &
'  bits of I are zero, the result value is BIT_SIZE(I).', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_leadz', &
'      implicit none', &
'      integer :: value, i', &
'      character(len=80) :: f', &
'', &
'        ! make a format statement for writing a value as a bit string', &
'        write(f,''("(b",i0,".",i0,")")'')bit_size(value),bit_size(value)', &
'', &
'        ! show output for various integer values', &
'        value=0', &
'        do i=-150, 150, 50', &
'           value=i', &
'           write (*,''("LEADING ZERO BITS=",i3)'',advance=''no'') leadz(value)', &
'           write (*,''(" OF VALUE ")'',advance=''no'')', &
'           write(*,f,advance=''no'') value', &
'           write(*,''(*(1x,g0))'') "AKA",value', &
'        enddo', &
'        ! Notes:', &
'        ! for two''s-complements programming environments a negative non-zero', &
'        ! integer value will always start with a 1 and a positive value with 0', &
'        ! as the first bit is the sign bit. Such platforms are very common.', &
'      end program demo_leadz', &
'', &
'  Results:', &
'', &
'        LEADING ZERO BITS=  0 OF VALUE 11111111111111111111111101101010 AKA -150', &
'        LEADING ZERO BITS=  0 OF VALUE 11111111111111111111111110011100 AKA -100', &
'        LEADING ZERO BITS=  0 OF VALUE 11111111111111111111111111001110 AKA -50', &
'        LEADING ZERO BITS= 32 OF VALUE 00000000000000000000000000000000 AKA 0', &
'        LEADING ZERO BITS= 26 OF VALUE 00000000000000000000000000110010 AKA 50', &
'        LEADING ZERO BITS= 25 OF VALUE 00000000000000000000000001100100 AKA 100', &
'        LEADING ZERO BITS= 24 OF VALUE 00000000000000000000000010010110 AKA 150', &
'', &
'STANDARD', &
'  Fortran 2008', &
'', &
'SEE ALSO', &
'  BIT_SIZE(3), POPCNT(3), POPPAR(3), TRAILZ(3)', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022                leadz(3fortran)', &
'']

shortname="leadz"
call process()


case('116','len')

textblock=[character(len=256) :: &
'', &
'len(3fortran)                                                    len(3fortran)', &
'', &
'NAME', &
'  LEN(3) - [CHARACTER] Length of a character entity', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                  len(3fortran)', &
'']

shortname="len"
call process()


case('117','len_trim')

textblock=[character(len=256) :: &
'', &
'len_trim(3fortran)                                          len_trim(3fortran)', &
'', &
'NAME', &
'  LEN_TRIM(3) - [CHARACTER:WHITESPACE] Character length without trailing blank', &
'  characters', &
'', &
'SYNOPSIS', &
'                               October 09, 2022             len_trim(3fortran)', &
'']

shortname="len_trim"
call process()


case('118','lge')

textblock=[character(len=256) :: &
'', &
'lge(3fortran)                                                    lge(3fortran)', &
'', &
'NAME', &
'  LGE(3) - [CHARACTER:COMPARE] ASCII Lexical greater than or equal', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                  lge(3fortran)', &
'']

shortname="lge"
call process()


case('119','lgt')

textblock=[character(len=256) :: &
'', &
'lgt(3fortran)                                                    lgt(3fortran)', &
'', &
'NAME', &
'  LGT(3) - [CHARACTER:COMPARE] ASCII Lexical greater than', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                  lgt(3fortran)', &
'']

shortname="lgt"
call process()


case('120','lle')

textblock=[character(len=256) :: &
'', &
'lle(3fortran)                                                    lle(3fortran)', &
'', &
'NAME', &
'  LLE(3) - [CHARACTER:COMPARE] ASCII Lexical less than or equal', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                  lle(3fortran)', &
'']

shortname="lle"
call process()


case('121','llt')

textblock=[character(len=256) :: &
'', &
'llt(3fortran)                                                    llt(3fortran)', &
'', &
'NAME', &
'  LLT(3) - [CHARACTER:COMPARE] ASCII Lexical less than', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                  llt(3fortran)', &
'']

shortname="llt"
call process()


case('122','log10')

textblock=[character(len=256) :: &
'', &
'log10(3fortran)                                                log10(3fortran)', &
'', &
'NAME', &
'  LOG10(3) - [MATHEMATICS] Base 10 logarithm function', &
'', &
'SYNOPSIS', &
'  result = log10(x)', &
'', &
'           elemental real(kind=KIND) function log10(x)', &
'', &
'            real(kind=KIND),intent(in) :: x', &
'', &
'CHARACTERISTICS', &
'  o  X may be any kind of real value', &
'', &
'  o  the result is the same type and characteristics as X.', &
'', &
'DESCRIPTION', &
'  LOG10(3) computes the base 10 logarithm of X. This is generally called the', &
'  "common logarithm".', &
'', &
'OPTIONS', &
'  o  X : A real value > 0 to take the log of.', &
'', &
'RESULT', &
'  The logarithm to base 10 of X', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_log10', &
'      use, intrinsic :: iso_fortran_env, only : real_kinds, &', &
'       & real32, real64, real128', &
'      implicit none', &
'      real(kind=real64) :: x = 10.0_real64', &
'', &
'         x = log10(x)', &
'         write(*,''(*(g0))'')''log10('',x,'') is '',log10(x)', &
'', &
'         ! elemental', &
'         write(*, *)log10([1.0, 10.0, 100.0, 1000.0, 10000.0, &', &
'                           & 100000.0, 1000000.0, 10000000.0])', &
'', &
'      end program demo_log10', &
'', &
'  Results:', &
'', &
'         log10(1.0000000000000000) is 0.0000000000000000', &
'            0.00000000       1.00000000       2.00000000       3.00000000', &
'            4.00000000       5.00000000       6.00000000       7.00000000', &
'', &
'STANDARD', &
'  FORTRAN 77', &
'', &
'SEE ALSO', &
'  ****(3)', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022                log10(3fortran)', &
'']

shortname="log10"
call process()


case('123','log')

textblock=[character(len=256) :: &
'', &
'log(3fortran)                                                    log(3fortran)', &
'', &
'NAME', &
'  LOG(3) - [MATHEMATICS] Logarithm function', &
'', &
'SYNOPSIS', &
'  result = log(x)', &
'', &
'         elemental TYPE(kind=KIND) function log(x)', &
'', &
'          TYPE(kind=KIND),intent(in) :: x', &
'', &
'CHARACTERISTICS', &
'  o  X may be any kind of real or complex value', &
'', &
'  o  the result is the same type and characteristics as X.', &
'', &
'DESCRIPTION', &
'  LOG(3) computes the natural logarithm of X, i.e. the logarithm to the base', &
'  "e".', &
'', &
'OPTIONS', &
'  o  X : The value to take the log of', &
'', &
'RESULT', &
'  The natural logarithm of XX. If X is complex, the imaginary part OMEGA is in', &
'  the range', &
'', &
'          -PI < OMEGA <= PI', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_log', &
'      implicit none', &
'        real(kind(0.0d0)) :: x = 2.71828182845904518d0', &
'        complex :: z = (1.0, 2.0)', &
'        write(*,*)x, log(x)    ! will yield (approximately) 1', &
'        write(*,*)z, log(z)', &
'      end program demo_log', &
'', &
'  Results:', &
'', &
'            2.7182818284590451        1.0000000000000000', &
'  (1.00000000,2.00000000) (0.804718971,1.10714877)', &
'', &
'STANDARD', &
'  FORTRAN 77', &
'', &
'SEE ALSO', &
'  ****(3)', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022                  log(3fortran)', &
'']

shortname="log"
call process()


case('124','log_gamma')

textblock=[character(len=256) :: &
'', &
'log_gamma(3fortran)                                        log_gamma(3fortran)', &
'', &
'NAME', &
'  LOG_GAMMA(3) - [MATHEMATICS] Logarithm of the absolute value of the Gamma', &
'  function', &
'', &
'SYNOPSIS', &
'  result = log_gamma(x)', &
'', &
'           elemental real(kind=KIND) function log_gamma(x)', &
'', &
'            real(kind=KIND),intent(in) :: x', &
'', &
'CHARACTERISTICS', &
'  o  X may be any real type', &
'', &
'  o  the return value is of same type and kind as X.', &
'', &
'DESCRIPTION', &
'  LOG_GAMMA(3) computes the natural logarithm of the absolute value of the', &
'  Gamma function.', &
'', &
'OPTIONS', &
'  o  X : A non-negative (neither negative nor zero) value to render the result', &
'     for.', &
'', &
'RESULT', &
'  The result has a value equal to a processor-dependent approximation to the', &
'  natural logarithm of the absolute value of the gamma function of X.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_log_gamma', &
'      implicit none', &
'      real :: x = 1.0', &
'         write(*,*)x,log_gamma(x) ! returns 0.0', &
'         write(*,*)x,log_gamma(3.0) ! returns 0.693 (approximately)', &
'      end program demo_log_gamma', &
'', &
'  Results:', &
'', &
'            1.000000      0.0000000E+00', &
'            1.000000      0.6931472', &
'', &
'STANDARD', &
'  Fortran 2008', &
'', &
'SEE ALSO', &
'  Gamma function: GAMMA(3)', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022            log_gamma(3fortran)', &
'']

shortname="log_gamma"
call process()


case('125','logical')

textblock=[character(len=256) :: &
'', &
'logical(3fortran)                                            logical(3fortran)', &
'', &
'NAME', &
'  LOGICAL(3) - [TYPE:LOGICAL] Converts one kind of logical variable to another', &
'', &
'SYNOPSIS', &
'                               October 09, 2022              logical(3fortran)', &
'']

shortname="logical"
call process()


case('126','maskl')

textblock=[character(len=256) :: &
'', &
'maskl(3fortran)                                                maskl(3fortran)', &
'', &
'NAME', &
'  MASKL(3) - [BIT:SET] Generates a left justified mask', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                maskl(3fortran)', &
'']

shortname="maskl"
call process()


case('127','maskr')

textblock=[character(len=256) :: &
'', &
'maskr(3fortran)                                                maskr(3fortran)', &
'', &
'NAME', &
'  MASKR(3) - [BIT:SET] Generates a right-justified mask', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                maskr(3fortran)', &
'']

shortname="maskr"
call process()


case('128','matmul')

textblock=[character(len=256) :: &
'', &
'matmul(3fortran)                                              matmul(3fortran)', &
'', &
'NAME', &
'  MATMUL(3) - [TRANSFORMATIONAL] Numeric or logical matrix multiplication', &
'', &
'SYNOPSIS', &
'  result = matmul(matrix_a,matrix_b)', &
'', &
'           function matmul(matrix_a, matrix_b)', &
'', &
'            type(NUMERIC_OR_LOGICAL) :: matrix_a(..)', &
'            type(NUMERIC_OR_LOGICAL) :: matrix_b(..)', &
'            type(PROMOTED) :: matmul(..)', &
'', &
'CHARACTERISTICS', &
'  o  Arguments may be numeric (integer, real, or complex ) or logical and must', &
'     be one or two-dimensional arrays.', &
'', &
'  o  At least one argument must be rank two.', &
'', &
'  o  If one argument is logical, both must be logical.', &
'', &
'DESCRIPTION', &
'  MATMUL(3) performs a matrix multiplication on numeric or logical arguments.', &
'', &
'OPTIONS', &
'  o  MATRIX_A : A numeric or logical array with a rank of one or two.', &
'', &
'  o  MATRIX_B : A numeric or logical array with a rank of one or two. The last', &
'     dimension of MATRIX_A and the first dimension of MATRIX_B must be equal.', &
'', &
'     Note that MATRIX_A and MATRIX_B may be different numeric types.', &
'', &
'RESULT', &
'NUMERIC ARGUMENTS', &
'  If MATRIX_A and MATRIX_B are numeric the result is an array containing the', &
'  conventional matrix product of MATRIX_A and MATRIX_B.', &
'', &
'  First, for the numeric expression C=MATMUL(A,B)', &
'', &
'  o  Any vector A(N) is treated as a row vector A(1,N).', &
'', &
'  o  Any vector B(N) is treated as a column vector B(N,1).', &
'', &
'SHAPE AND RANK', &
'  The shape of the result can then be determined as the number of rows of the', &
'  first matrix and the number of columns of the second; but if any argument is', &
'  of rank one (a vector) the result is also rank one.  Conversely when both', &
'  arguments are of rank two, the result has a rank of two. That is ...', &
'', &
'  o  If MATRIX_A has shape [n,m] and MATRIX_B has shape [m,k], the result has', &
'     shape [n,k].', &
'', &
'  o  If MATRIX_A has shape [m] and MATRIX_B has shape [m,k], the result has', &
'     shape [k].', &
'', &
'  o  If MATRIX_A has shape [n,m] and MATRIX_B has shape [m], the result has', &
'     shape [n].', &
'', &
'VALUES', &
'  Then element C(I,J) of the product is obtained by multiplying term-by-term', &
'  the entries of the ith row of A and the jth column of B, and summing these', &
'  products. In other words, C(I,J) is the dot product of the ith row of A and', &
'  the jth column of B.', &
'', &
'CHARACTERISTICS', &
'  The returned array will be promoted to the same type and kind as would', &
'  result from multiplication between an element of each argument (like the', &
'  multiplication operator (*) had been used between the elements).', &
'', &
'LOGICAL ARGUMENTS', &
'VALUES', &
'  If MATRIX_A and MATRIX_B are of type logical, the array elements of the', &
'  result are instead:', &
'', &
'        Value_of_Element (i,j) = &', &
'        ANY( (row_i_of_MATRIX_A) .AND. (column_j_of_MATRIX_B) )', &
'', &
'CHARACTERISTICS', &
'  The returned array is of the type and kind that results if any element of', &
'  each argument had been operated on by the .AND. operator.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_matmul', &
'      implicit none', &
'      integer :: a(2,3), b(3,2), c(2), d(3), e(2,2), f(3), g(2), v1(4),v2(4)', &
'         a = reshape([1, 2, 3, 4, 5, 6], [2, 3])', &
'         b = reshape([10, 20, 30, 40, 50, 60], [3, 2])', &
'         c = [1, 2]', &
'         d = [1, 2, 3]', &
'         e = matmul(a, b)', &
'         f = matmul(c,a)', &
'         g = matmul(a,d)', &
'', &
'         call print_matrix_int(''A is '',a)', &
'         call print_matrix_int(''B is '',b)', &
'         call print_vector_int(''C is '',c)', &
'         call print_vector_int(''D is '',d)', &
'         call print_matrix_int(''E is matmul(A,B)'',e)', &
'         call print_vector_int(''F is matmul(C,A)'',f)', &
'         call print_vector_int(''G is matmul(A,D)'',g)', &
'', &
'         ! look at argument shapes when one is a vector', &
'         write(*,''(" > shape")'')', &
'         ! at least one argument must be of rank two', &
'         ! so for two vectors at least one must be reshaped', &
'         v1=[11,22,33,44]', &
'         v2=[10,20,30,40]', &
'', &
'         ! these return a vector C(1:1)', &
'         ! treat A(1:n) as A(1:1,1:n)', &
'         call print_vector_int(''Cd is a vector (not a scalar)'',&', &
'         & matmul(reshape(v1,[1,size(v1)]),v2))', &
'         ! or treat B(1:m) as B(1:m,1:1)', &
'         call print_vector_int(''cD is a vector too'',&', &
'         & matmul(v1,reshape(v2,[size(v2),1])))', &
'', &
'         ! or treat A(1:n) as A(1:1,1:n) and B(1:m) as B(1:m,1:1)', &
'         ! but note this returns a matrix C(1:1,1:1) not a vector!', &
'         call print_matrix_int(''CD is a matrix'',matmul(&', &
'         & reshape(v1,[1,size(v1)]), &', &
'         & reshape(v2,[size(v2),1])))', &
'', &
'      contains', &
'', &
'      ! CONVENIENCE ROUTINES TO PRINT IN ROW-COLUMN ORDER', &
'      subroutine print_vector_int(title,arr)', &
'      character(len=*),intent(in)  :: title', &
'      integer,intent(in)           :: arr(:)', &
'         call print_matrix_int(title,reshape(arr,[1,shape(arr)]))', &
'      end subroutine print_vector_int', &
'', &
'      subroutine print_matrix_int(title,arr)', &
'      !@(#) print small 2d integer arrays in row-column format', &
'      character(len=*),parameter :: all=''(" > ",*(g0,1x))'' ! a handy format', &
'      character(len=*),intent(in)  :: title', &
'      integer,intent(in)           :: arr(:,:)', &
'      integer                      :: i', &
'      character(len=:),allocatable :: biggest', &
'', &
'         print all', &
'         print all, trim(title)', &
'         biggest=''           ''  ! make buffer to write integer into', &
'         ! find how many characters to use for integers', &
'         write(biggest,''(i0)'')ceiling(log10(real(maxval(abs(arr)))))+2', &
'         ! use this format to write a row', &
'         biggest=''(" > [",*(i''//trim(biggest)//'':,","))''', &
'         ! print one row of array at a time', &
'         do i=1,size(arr,dim=1)', &
'            write(*,fmt=biggest,advance=''no'')arr(i,:)', &
'            write(*,''(" ]")'')', &
'         enddo', &
'', &
'      end subroutine print_matrix_int', &
'', &
'      end program demo_matmul', &
'', &
'  Results:', &
'', &
'          >', &
'          > A is', &
'          > [  1,  3,  5 ]', &
'          > [  2,  4,  6 ]', &
'          >', &
'          > B is', &
'          > [  10,  40 ]', &
'          > [  20,  50 ]', &
'          > [  30,  60 ]', &
'          >', &
'          > C is', &
'          > [  1,  2 ]', &
'          >', &
'          > D is', &
'          > [  1,  2,  3 ]', &
'          >', &
'          > E is matmul(A,B)', &
'          > [  220,  490 ]', &
'          > [  280,  640 ]', &
'          >', &
'          > F is matmul(C,A)', &
'          > [   5,  11,  17 ]', &
'          >', &
'          > G is matmul(A,D)', &
'          > [  22,  28 ]', &
'          > shape', &
'          >', &
'          > Cd is a vector (not a scalar)', &
'          > [  3300 ]', &
'          >', &
'          > cD is a vector too', &
'          > [  3300 ]', &
'          >', &
'          > CD is a matrix', &
'          > [  3300 ]', &
'', &
'STANDARD', &
'  Fortran 95', &
'', &
'SEE ALSO', &
'  PRODUCT(3), TRANSPOSE(3)', &
'', &
'RESOURCES', &
'  o  Matrix multiplication : Wikipedia', &
'', &
'  o  The Winograd variant of Strassen''s matrix-matrix multiply algorithm may', &
'     be of interest for optimizing multiplication of very large matrices. See', &
'', &
'          "GEMMW: A portable level 3 BLAS Winograd variant of Strassen''s', &
'          matrix-matrix multiply algorithm",', &
'', &
'          Douglas, C. C., Heroux, M., Slishman, G., and Smith, R. M.,', &
'          Journal of Computational Physics,', &
'          Vol. 110, No. 1, January 1994, pages 1-10.', &
'', &
'  The numerical instabilities of Strassen''s method for matrix multiplication', &
'  requires special processing.', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022               matmul(3fortran)', &
'']

shortname="matmul"
call process()


case('129','max')

textblock=[character(len=256) :: &
'', &
'max(3fortran)                                                    max(3fortran)', &
'', &
'NAME', &
'  MAX(3) - [NUMERIC] Maximum value of an argument list', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                  max(3fortran)', &
'']

shortname="max"
call process()


case('130','maxexponent')

textblock=[character(len=256) :: &
'', &
'maxexponent(3fortran)                                    maxexponent(3fortran)', &
'', &
'NAME', &
'  MAXEXPONENT(3) - [NUMERIC MODEL] Maximum exponent of a real kind', &
'', &
'SYNOPSIS', &
'  result = maxexponent(x)', &
'', &
'           elemental integer function maxexponent(x)', &
'', &
'            real(kind=KIND),intent(in)   :: x', &
'', &
'CHARACTERISTICS', &
'  where KIND is any real kind.', &
'', &
'DESCRIPTION', &
'  MAXEXPONENT(3) returns the maximum exponent in the model of the type of X.', &
'', &
'OPTIONS', &
'  o  X : Shall be of type real.', &
'', &
'RESULT', &
'  The return value is of type integer and of the default integer kind.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_maxexponent', &
'      use,intrinsic :: iso_fortran_env, only : dp=>real64,sp=>real32', &
'      implicit none', &
'      real(kind=sp) :: x', &
'      real(kind=dp) :: y', &
'', &
'         print *, minexponent(x), maxexponent(x)', &
'         print *, minexponent(y), maxexponent(y)', &
'      end program demo_maxexponent', &
'', &
'  Results:', &
'', &
'                 -125         128', &
'', &
'    -1021', &
'      1024', &
'', &
'STANDARD', &
'  Fortran 95', &
'', &
'SEE ALSO', &
'  DIGITS(3), EPSILON(3), EXPONENT(3), FRACTION(3), HUGE(3), MINEXPONENT(3),', &
'  NEAREST(3), PRECISION(3), RADIX(3), RANGE(3), RRSPACING(3), SCALE(3),', &
'  SET_EXPONENT(3), SPACING(3), TINY(3)', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022          maxexponent(3fortran)', &
'']

shortname="maxexponent"
call process()


case('131','maxloc')

textblock=[character(len=256) :: &
'', &
'maxloc(3fortran)                                              maxloc(3fortran)', &
'', &
'NAME', &
'  MAXLOC(3) - [ARRAY:LOCATION] Location of the maximum value within an array', &
'', &
'SYNOPSIS', &
'                               October 09, 2022               maxloc(3fortran)', &
'']

shortname="maxloc"
call process()


case('132','maxval')

textblock=[character(len=256) :: &
'', &
'maxval(3fortran)                                              maxval(3fortran)', &
'', &
'NAME', &
'  MAXVAL(3) - [ARRAY:REDUCTION] Determines the maximum value in an array or', &
'  row', &
'', &
'SYNOPSIS', &
'                               October 09, 2022               maxval(3fortran)', &
'']

shortname="maxval"
call process()


case('133','merge')

textblock=[character(len=256) :: &
'', &
'merge(3fortran)                                                merge(3fortran)', &
'', &
'NAME', &
'  MERGE(3) - [ARRAY:CONSTRUCTION] Merge variables', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                merge(3fortran)', &
'']

shortname="merge"
call process()


case('134','merge_bits')

textblock=[character(len=256) :: &
'', &
'merge_bits(3fortran)                                      merge_bits(3fortran)', &
'', &
'NAME', &
'  MERGE_BITS(3) - [BIT:COPY] Merge bits using a mask', &
'', &
'SYNOPSIS', &
'                               October 09, 2022           merge_bits(3fortran)', &
'']

shortname="merge_bits"
call process()


case('135','min')

textblock=[character(len=256) :: &
'', &
'min(3fortran)                                                    min(3fortran)', &
'', &
'NAME', &
'  MIN(3) - [NUMERIC] Minimum value of an argument list', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                  min(3fortran)', &
'']

shortname="min"
call process()


case('136','minexponent')

textblock=[character(len=256) :: &
'', &
'minexponent(3fortran)                                    minexponent(3fortran)', &
'', &
'NAME', &
'  MINEXPONENT(3) - [NUMERIC MODEL] Minimum exponent of a real kind', &
'', &
'SYNOPSIS', &
'  result = minexponent(x)', &
'', &
'           elemental integer function minexponent(x)', &
'', &
'            real(kind=KIND),intent(in)   :: x', &
'', &
'CHARACTERISTICS', &
'  where KIND is any real kind.', &
'', &
'DESCRIPTION', &
'  MINEXPONENT(3) returns the minimum exponent in the model of the type of X.', &
'', &
'OPTIONS', &
'  o  X : Shall be of type real.', &
'', &
'RESULT', &
'  The return value is of type integer and of the default integer kind.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_minexponent', &
'      use, intrinsic :: iso_fortran_env, only : &', &
'       &real_kinds, real32, real64, real128', &
'      implicit none', &
'      real(kind=real32) :: x', &
'      real(kind=real64) :: y', &
'          print *, minexponent(x), maxexponent(x)', &
'          print *, minexponent(y), maxexponent(y)', &
'      end program demo_minexponent', &
'', &
'  Expected Results:', &
'', &
'              -125         128', &
'', &
'    -1021', &
'      1024', &
'', &
'STANDARD', &
'  Fortran 95', &
'', &
'SEE ALSO', &
'  DIGITS(3), EPSILON(3), EXPONENT(3), FRACTION(3), HUGE(3), MAXEXPONENT(3),', &
'  NEAREST(3), PRECISION(3), RADIX(3), RANGE(3), RRSPACING(3), SCALE(3),', &
'  SET_EXPONENT(3), SPACING(3), TINY(3)', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022          minexponent(3fortran)', &
'']

shortname="minexponent"
call process()


case('137','minloc')

textblock=[character(len=256) :: &
'', &
'minloc(3fortran)                                              minloc(3fortran)', &
'', &
'NAME', &
'  MINLOC(3) - [ARRAY:LOCATION] Location of the minimum value within an array', &
'', &
'SYNOPSIS', &
'                               October 09, 2022               minloc(3fortran)', &
'']

shortname="minloc"
call process()


case('138','minval')

textblock=[character(len=256) :: &
'', &
'minval(3fortran)                                              minval(3fortran)', &
'', &
'NAME', &
'  MINVAL(3) - [ARRAY:REDUCTION] Minimum value of an array', &
'', &
'SYNOPSIS', &
'                               October 09, 2022               minval(3fortran)', &
'']

shortname="minval"
call process()


case('139','mod')

textblock=[character(len=256) :: &
'', &
'mod(3fortran)                                                    mod(3fortran)', &
'', &
'NAME', &
'  MOD(3) - [NUMERIC] Remainder function', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                  mod(3fortran)', &
'']

shortname="mod"
call process()


case('140','modulo')

textblock=[character(len=256) :: &
'', &
'modulo(3fortran)                                              modulo(3fortran)', &
'', &
'NAME', &
'  MODULO(3) - [NUMERIC] Modulo function', &
'', &
'SYNOPSIS', &
'                               October 09, 2022               modulo(3fortran)', &
'']

shortname="modulo"
call process()


case('141','move_alloc')

textblock=[character(len=256) :: &
'', &
'move_alloc(3fortran)                                      move_alloc(3fortran)', &
'', &
'NAME', &
'  MOVE_ALLOC(3) - [MEMORY] Move allocation from one object to another', &
'', &
'SYNOPSIS', &
'                               October 09, 2022           move_alloc(3fortran)', &
'']

shortname="move_alloc"
call process()


case('142','mvbits')

textblock=[character(len=256) :: &
'', &
'mvbits(3fortran)                                              mvbits(3fortran)', &
'', &
'NAME', &
'  MVBITS(3) - [BIT:COPY] Reproduce bit patterns found in one integer in', &
'  another', &
'', &
'SYNOPSIS', &
'                               October 09, 2022               mvbits(3fortran)', &
'']

shortname="mvbits"
call process()


case('143','nearest')

textblock=[character(len=256) :: &
'', &
'nearest(3fortran)                                            nearest(3fortran)', &
'', &
'NAME', &
'  NEAREST(3) - [MODEL_COMPONENTS] Nearest representable number', &
'', &
'SYNOPSIS', &
'                               October 09, 2022              nearest(3fortran)', &
'']

shortname="nearest"
call process()


case('144','new_line')

textblock=[character(len=256) :: &
'', &
'new_line(3fortran)                                          new_line(3fortran)', &
'', &
'NAME', &
'  NEW_LINE(3) - [CHARACTER:INQUIRY] Newline character', &
'', &
'SYNOPSIS', &
'  result = new_line(c)', &
'', &
'           character(len=1,kind=KIND) function new_line(c)', &
'', &
'            character(len=1,kind=KIND),intent(in) :: c(..)', &
'', &
'CHARACTERISTICS', &
'  o  C shall be of type character. It may be a scalar or an array.', &
'', &
'  o  the result is a character scalar of length one with the same kind type', &
'     parameter as C.', &
'', &
'DESCRIPTION', &
'  NEW_LINE(3) returns the newline character.', &
'', &
'  Normally, newlines are generated with regular formatted I/O statements like', &
'  WRITE() and PRINT() when each statement completes:', &
'', &
'         print *, ''x=11''', &
'         print *', &
'         print *, ''y=22''', &
'         end', &
'', &
'  produces: x=11', &
'', &
'      y=22', &
'', &
'      Alternatively, a "/" descriptor in a format is used to generate a', &
'      newline on the output. For example:', &
'      ```fortran', &
'         write(*,''(a,1x,i0,/,a)'') ''x ='',11,''is the answer''', &
'         end', &
'', &
'  produces:', &
'', &
'         x = 11', &
'         is the answer', &
'', &
'  Also, for formatted sequential output if more data is listed on the output', &
'  statement than can be represented by the format statement a newline is', &
'  generated and then the format is reused until the output list is exhausted.', &
'', &
'         write(*,''(a,"=",i0)'') ''x'', 10, ''y'', 20', &
'         end', &
'', &
'  produces', &
'', &
'         x=10', &
'         y=20', &
'', &
'  But there are occasions, particularly when non-advancing I/O or stream I/O', &
'  is being generated (which does not generate a newline at the end of each', &
'  WRITE statement, as normally occurs) where it is preferable to place a', &
'  newline explicitly in the output at specified points.', &
'', &
'  To do so you must make sure you are generating the correct newline', &
'  character, which the techniques above do automatically.', &
'', &
'  The newline character varies between some platforms, and can even depend on', &
'  the encoding (ie. which character set is being used) of the output file. In', &
'  these cases selecting the correct character to output can be determined by', &
'  the NEW_LINE(3) procedure.', &
'', &
'OPTIONS', &
'  o  C : an arbitrary character whose kind is used to decide on the output', &
'     character that represents a newline.', &
'', &
'RESULT', &
'  Case (i) : If A is default character and the character in position 10 of the', &
'  ASCII collating sequence is representable in the default character set, then', &
'  the result is ACHAR(10).', &
'', &
'  This is the typical case, and just requires using "new_line(''a'')".', &
'', &
'  Case (ii) : If A is an ASCII character or an ISO 10646 character, then the', &
'  result is CHAR(10, KIND (A)).', &
'', &
'  Case (iii) : Otherwise, the result is a processor-dependent character that', &
'  represents a newline in output to files connected for formatted stream', &
'  output if there is such a character.', &
'', &
'  Case (iv) : If not of the previous cases apply, the result is the blank', &
'  character.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_new_line', &
'      implicit none', &
'      character,parameter :: nl=new_line(''a'')', &
'      character(len=:),allocatable :: string', &
'      real :: r', &
'      integer :: i, count', &
'', &
'        ! basics', &
'         ! print a string with a newline embedded in it', &
'         string=''This is record 1.''//nl//''This is record 2.''', &
'         write(*,''(a)'') string', &
'', &
'         ! print a newline character string', &
'         write(*,''(*(a))'',advance=''no'') &', &
'            nl,''This is record 1.'',nl,''This is record 2.'',nl', &
'', &
'         ! output a number of words of random length as a paragraph', &
'         ! by inserting a new_line before line exceeds 70 characters', &
'', &
'        ! simplistic paragraph print using non-advancing I/O', &
'         count=0', &
'         do i=1,100', &
'', &
'            ! make some fake word of random length', &
'            call random_number(r)', &
'            string=repeat(''x'',int(r*10)+1)', &
'', &
'            count=count+len(string)+1', &
'            if(count.gt.70)then', &
'               write(*,''(a)'',advance=''no'')nl', &
'               count=len(string)+1', &
'            endif', &
'            write(*,''(1x,a)'',advance=''no'')string', &
'         enddo', &
'         write(*,''(a)'',advance=''no'')nl', &
'', &
'      end program demo_new_line', &
'', &
'  Results:', &
'', &
'         This is record 1.', &
'         This is record 2.', &
'', &
'         This is record 1.', &
'         This is record 2.', &
'          x x xxxx xxxxxxx xxxxxxxxxx xxxxxxxxx xxxx xxxxxxxxxx xxxxxxxx', &
'          xxxxxxxxx xxxx xxxxxxxxx x xxxxxxxxx xxxxxxxx xxxxxxxx xxxx x', &
'          xxxxxxxxxx x x x xxxxxx xxxxxxxxxx x xxxxxxxxxx x xxxxxxx xxxxxxxxx', &
'          xx xxxxxxxxxx xxxxxxxx x xx xxxxxxxxxx xxxxxxxx xxx xxxxxxx xxxxxx', &
'          xxxxx xxxxxxxxx x xxxxxxxxxx xxxxxx xxxxxxxx xxxxx xxxxxxxx xxxxxxxx', &
'          xxxxx xxx xxxxxxxx xxxxxxx xxxxxxxx xxx xxxx xxx xxxxxxxx xxxxxx', &
'          xxxxxxx xxxxxxx xxxxx xxxxx xx xxxxxx xx xxxxxxxxxx xxxxxx x xxxx', &
'          xxxxxx xxxxxxx x xxx xxxxx xxxxxxxxx xxx xxxxxxx x xxxxxx xxxxxxxxx', &
'          xxxx xxxxxxxxx xxxxxxxx xxxxxxxx xxx xxxxxxx xxxxxxx xxxxxxxxxx', &
'          xxxxxxxxxx xxxxxx xxxxx xxxx xxxxxxx xx xxxxxxxxxx xxxxxx xxxxxx', &
'          xxxxxx xxxx xxxxx', &
'', &
'STANDARD', &
'  Fortran 2003', &
'', &
'SEE ALSO', &
'  ACHAR(3), CHAR(3), IACHAR(3), ICHAR(3), SELECTED_CHAR_KIND(3)', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022             new_line(3fortran)', &
'']

shortname="new_line"
call process()


case('145','nint')

textblock=[character(len=256) :: &
'', &
'nint(3fortran)                                                  nint(3fortran)', &
'', &
'NAME', &
'  NINT(3) - [TYPE:NUMERIC] Nearest whole number', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                 nint(3fortran)', &
'']

shortname="nint"
call process()


case('146','norm2')

textblock=[character(len=256) :: &
'', &
'norm2(3fortran)                                                norm2(3fortran)', &
'', &
'NAME', &
'  NORM2(3) - [MATHEMATICS] Euclidean vector norm', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                norm2(3fortran)', &
'']

shortname="norm2"
call process()


case('147','not')

textblock=[character(len=256) :: &
'', &
'not(3fortran)                                                    not(3fortran)', &
'', &
'NAME', &
'  NOT(3) - [BIT:LOGICAL] Logical negation', &
'', &
'SYNOPSIS', &
'  result = not(i)', &
'', &
'  elemental integer(kind=KIND) function not(i)', &
'', &
'           integer(kind=KIND), intent(in) :: i', &
'', &
'CHARACTERISTICS', &
'  The return type is of the same kind as the argument.', &
'', &
'DESCRIPTION', &
'  NOT(3) returns the bitwise Boolean inverse of I.', &
'', &
'OPTIONS', &
'  o  I : The type shall be integer.', &
'', &
'RESULT', &
'  The return type is integer, of the same kind as the argument.', &
'', &
'EXAMPLES', &
'  Sample program', &
'', &
'      program demo_not', &
'      implicit none', &
'      integer :: i', &
'', &
'         i=13741', &
'         write(*,''(b32.32,1x,i0)'')i,i', &
'         write(*,''(b32.32,1x,i0)'')not(i),not(i)', &
'', &
'      end program demo_not', &
'', &
'  Results:', &
'', &
'         00000000000000000011010110101101 13741', &
'         11111111111111111100101001010010 -13742', &
'', &
'STANDARD', &
'  Fortran 95', &
'', &
'SEE ALSO', &
'  IAND(3), IOR(3), IEOR(3), IBITS(3), IBSET(3),', &
'', &
'  IBCLR(3)', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022                  not(3fortran)', &
'']

shortname="not"
call process()


case('148','null')

textblock=[character(len=256) :: &
'', &
'null(3fortran)                                                  null(3fortran)', &
'', &
'NAME', &
'  NULL(3) - [TRANSFORMATIONAL] Function that returns a disassociated pointer', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                 null(3fortran)', &
'']

shortname="null"
call process()


case('149','num_images')

textblock=[character(len=256) :: &
'', &
'num_images(3fortran)                                      num_images(3fortran)', &
'', &
'NAME', &
'  NUM_IMAGES(3) - [COLLECTIVE] Number of images', &
'', &
'SYNOPSIS', &
'  result = num_images()', &
'', &
'           integer function num_images ()', &
'', &
'  or', &
'', &
'          result = num_images(team)', &
'', &
'           integer function num_images (team)', &
'', &
'            type(TEAM_TYPE),intent(in) :: team', &
'', &
'  or', &
'', &
'          result = num_images(team_number)', &
'', &
'           integer function num_images (team_number)', &
'', &
'            integer(kind=KIND),intent(in) :: team_number', &
'', &
'CHARACTERISTICS', &
'DESCRIPTION', &
'  NUM_IMAGES(3) Returns the number of images.', &
'', &
'OPTIONS', &
'  o  TEAM : shall be a scalar of type TEAM_TYPE from the intrinsic module', &
'     ISO_FORTRAN_ENV, with a value that identifies the current or an ancestor', &
'     team.', &
'', &
'  o  TEAM_NUMBER : shall be an integer scalar. It shall identify the initial', &
'     team or a team whose parent is the same as that of the current team.', &
'', &
'RESULT', &
'  The number of images in the specified team, or in the current team if no', &
'  team is specified.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_num_images', &
'      implicit none', &
'      integer :: value[*]', &
'      integer :: i', &
'', &
'         value = this_image()', &
'         sync all', &
'         if (this_image() == 1) then', &
'           do i = 1, num_images()', &
'             write(*,''(2(a,i0))'') ''value['', i, ''] is '', value[i]', &
'           end do', &
'         endif', &
'', &
'      end program demo_num_images', &
'', &
'STANDARD', &
'  Fortran 2008 . With DISTANCE or FAILED argument, TS 18508', &
'', &
'SEE ALSO', &
'  THIS_IMAGE(3), IMAGE_INDEX(3)', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022           num_images(3fortran)', &
'']

shortname="num_images"
call process()


case('150','out_of_range')

textblock=[character(len=256) :: &
'', &
'out_of_range(3fortran)                                  out_of_range(3fortran)', &
'', &
'NAME', &
'  OUT_OF_RANGE(3) - [TYPE:NUMERIC] Whether a value cannot be converted safely.', &
'', &
'SYNOPSIS', &
'                               October 09, 2022         out_of_range(3fortran)', &
'']

shortname="out_of_range"
call process()


case('151','pack')

textblock=[character(len=256) :: &
'', &
'pack(3fortran)                                                  pack(3fortran)', &
'', &
'NAME', &
'  PACK(3) - [ARRAY:CONSTRUCTION] Pack an array into an array of rank one', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                 pack(3fortran)', &
'']

shortname="pack"
call process()


case('152','parity')

textblock=[character(len=256) :: &
'', &
'parity(3fortran)                                              parity(3fortran)', &
'', &
'NAME', &
'  PARITY(3) - [TRANSFORMATIONAL] Reduction with exclusive OR()', &
'', &
'SYNOPSIS', &
'                               October 09, 2022               parity(3fortran)', &
'']

shortname="parity"
call process()


case('153','popcnt')

textblock=[character(len=256) :: &
'', &
'popcnt(3fortran)                                              popcnt(3fortran)', &
'', &
'NAME', &
'  POPCNT(3) - [BIT:COUNT] Number of bits set', &
'', &
'SYNOPSIS', &
'  result = popcnt(i)', &
'', &
'           elemental integer function popcnt(i)', &
'', &
'            integer(kind=KIND), intent(in) :: i', &
'', &
'CHARACTERISTICS', &
'  o  I may be an integer of any kind.', &
'', &
'  o  The return value is an integer of the default integer kind.', &
'', &
'DESCRIPTION', &
'  POPCNT(3) returns the number of bits set to one in the binary representation', &
'  of an integer.', &
'', &
'OPTIONS', &
'  o  I : value to count set bits in', &
'', &
'RESULT', &
'  The number of bits set to one in I.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_popcnt', &
'      use, intrinsic :: iso_fortran_env, only : integer_kinds, &', &
'         & int8, int16, int32, int64', &
'      implicit none', &
'      character(len=*),parameter :: pretty=''(b64,1x,i0)''', &
'        ! basic usage', &
'         print pretty, 127,     popcnt(127)', &
'         print pretty, int(b"01010"), popcnt(int(b"01010"))', &
'', &
'        ! any kind of an integer can be used', &
'         print pretty, huge(0_int8),  popcnt(huge(0_int8))', &
'         print pretty, huge(0_int16), popcnt(huge(0_int16))', &
'         print pretty, huge(0_int32), popcnt(huge(0_int32))', &
'         print pretty, huge(0_int64), popcnt(huge(0_int64))', &
'      end program demo_popcnt', &
'', &
'  Results:', &
'', &
'  Note that on most machines the first bit is the sign bit, and a zero is used', &
'  for positive values; but that this is system-dependent. These are typical', &
'  values, where the huge(3f) function has set all but the first bit to 1.', &
'', &
'       >                                                         1111111 7', &
'       >                                                            1010 2', &
'       >                                                         1111111 7', &
'       >                                                 111111111111111 15', &
'       >                                 1111111111111111111111111111111 31', &
'       > 111111111111111111111111111111111111111111111111111111111111111 63', &
'', &
'STANDARD', &
'  Fortran 2008', &
'', &
'SEE ALSO', &
'  There are many procedures that operator or query values at the bit level:', &
'', &
'  POPPAR(3), LEADZ(3), TRAILZ(3) ATOMIC_AND(3), ATOMIC_FETCH_AND(3),', &
'  ATOMIC_FETCH_OR(3), ATOMIC_FETCH_XOR(3), ATOMIC_OR(3), ATOMIC_XOR(3),', &
'  BGE(3), BGE(3), BGT(3), BIT_SIZE(3), BLE(3), BLT(3), BTEST(3), DSHIFTL(3),', &
'  DSHIFTR(3), IALL(3), IAND(3), IANY(3), IBCLR(3), IBITS(3), IBSET(3),', &
'  IEOR(3), IOR(3), IPARITY(3), ISHFTC(3), ISHFT(3), MASKL(3), MASKR(3),', &
'  MERGE_BITS(3), MVBITS(3), MVBITS(3), NOT(3), SHIFTA(3), SHIFTL(3),', &
'  SHIFTR(3), STORAGE_SIZE(3)', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022               popcnt(3fortran)', &
'']

shortname="popcnt"
call process()


case('154','poppar')

textblock=[character(len=256) :: &
'', &
'poppar(3fortran)                                              poppar(3fortran)', &
'', &
'NAME', &
'  POPPAR(3) - [BIT:COUNT] Parity of the number of bits set', &
'', &
'SYNOPSIS', &
'  result = poppar(i)', &
'', &
'           elemental integer function poppar(i)', &
'', &
'            integer(kind=KIND), intent(in) :: i', &
'', &
'CHARACTERISTICS', &
'  o  I is an integer of any kind', &
'', &
'  o  the return value is a default kind integer', &
'', &
'DESCRIPTION', &
'  POPPAR(3) returns the parity of an integer''s binary representation (i.e.,', &
'  the parity of the number of bits set).', &
'', &
'OPTIONS', &
'  o  I : The value to query the bits of', &
'', &
'RESULT', &
'  The return value is equal to 0 if I has an even number of bits set and 1 if', &
'  an odd number of bits are set.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_poppar', &
'      use, intrinsic :: iso_fortran_env, only : integer_kinds, &', &
'         & int8, int16, int32, int64', &
'      implicit none', &
'      character(len=*),parameter :: pretty=''(b64,1x,i0)''', &
'         ! basic usage', &
'         print pretty, 127,     poppar(127)', &
'         print pretty, 128,     poppar(128)', &
'         print pretty, int(b"01010"), poppar(int(b"01010"))', &
'', &
'         ! any kind of an integer can be used', &
'         print pretty, huge(0_int8),  poppar(huge(0_int8))', &
'         print pretty, huge(0_int16), poppar(huge(0_int16))', &
'         print pretty, huge(0_int32), poppar(huge(0_int32))', &
'         print pretty, huge(0_int64), poppar(huge(0_int64))', &
'      end program demo_poppar', &
'', &
'  Results:', &
'', &
'       >                                                          1111111 1', &
'       >                                                         10000000 1', &
'       >                                                             1010 0', &
'       >                                  1111111111111111111111111111111 1', &
'       >                                                          1111111 1', &
'       >                                                  111111111111111 1', &
'       >                                  1111111111111111111111111111111 1', &
'       >  111111111111111111111111111111111111111111111111111111111111111 1', &
'', &
'STANDARD', &
'  Fortran 2008', &
'', &
'SEE ALSO', &
'  There are many procedures that operator or query values at the bit level:', &
'', &
'  POPCNT(3), LEADZ(3), TRAILZ(3) ATOMIC_AND(3), ATOMIC_FETCH_AND(3),', &
'  ATOMIC_FETCH_OR(3), ATOMIC_FETCH_XOR(3), ATOMIC_OR(3), ATOMIC_XOR(3),', &
'  BGE(3), BGE(3), BGT(3), BIT_SIZE(3), BLE(3), BLT(3), BTEST(3), DSHIFTL(3),', &
'  DSHIFTR(3), IALL(3), IAND(3), IANY(3), IBCLR(3), IBITS(3), IBSET(3),', &
'  IEOR(3), IOR(3), IPARITY(3), ISHFTC(3), ISHFT(3), MASKL(3), MASKR(3),', &
'  MERGE_BITS(3), MVBITS(3), MVBITS(3), NOT(3), SHIFTA(3), SHIFTL(3),', &
'  SHIFTR(3), STORAGE_SIZE(3)', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022               poppar(3fortran)', &
'']

shortname="poppar"
call process()


case('155','precision')

textblock=[character(len=256) :: &
'', &
'precision(3fortran)                                        precision(3fortran)', &
'', &
'NAME', &
'  PRECISION(3) - [NUMERIC MODEL] Decimal precision of a real kind', &
'', &
'SYNOPSIS', &
'  result = precision(x)', &
'', &
'           integer function precision(x)', &
'', &
'            TYPE(kind=KIND),intent(in) :: x', &
'', &
'CHARACTERISTICS', &
'  where TYPE may be real or complex', &
'', &
'  The return value is of type integer and of the default integer kind.', &
'', &
'DESCRIPTION', &
'  PRECISION(3) returns the decimal precision in the model of the type of X.', &
'', &
'OPTIONS', &
'  o  X : Shall be of type real or complex.', &
'', &
'RESULT', &
'  The precision of values of the type and kind of X', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_precision', &
'      use,intrinsic :: iso_fortran_env, only : dp=>real64,sp=>real32', &
'      implicit none', &
'      real(kind=sp)    :: x(2)', &
'      complex(kind=dp) :: y', &
'', &
'         print *, precision(x), range(x)', &
'         print *, precision(y), range(y)', &
'      end program demo_precision', &
'', &
'  Results:', &
'', &
'    6 37', &
'', &
'  15', &
'    307', &
'', &
'STANDARD', &
'  Fortran 95', &
'', &
'SEE ALSO', &
'  DIGITS(3), EPSILON(3), EXPONENT(3), FRACTION(3), HUGE(3), MAXEXPONENT(3),', &
'  MINEXPONENT(3), NEAREST(3), RADIX(3), RANGE(3), RRSPACING(3), SCALE(3),', &
'  SET_EXPONENT(3), SPACING(3), TINY(3)', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022            precision(3fortran)', &
'']

shortname="precision"
call process()


case('156','present')

textblock=[character(len=256) :: &
'', &
'present(3fortran)                                            present(3fortran)', &
'', &
'NAME', &
'  PRESENT(3) - [STATE] Determine whether an optional dummy argument is', &
'  specified', &
'', &
'SYNOPSIS', &
'  result = present(a)', &
'', &
'           logical function present (a)', &
'', &
'            type(TYPE(kind=KIND)) :: a(..)', &
'', &
'CHARACTERISTICS', &
'  o  A May be of any type and may be a pointer, scalar or array value, or a', &
'     dummy procedure.', &
'', &
'DESCRIPTION', &
'  PRESENT(3) can be used in a procedure to determine if an optional dummy', &
'  argument was present on the current call to the procedure.', &
'', &
'  When an argument is not present when the current procedure is invoked, you', &
'  may only pass it as an optional argument to another procedure or pass it as', &
'  an argument to PRESENT.', &
'', &
'OPTIONS', &
'  o  A : the name of an optional dummy argument accessible within the current', &
'     subroutine or function.', &
'', &
'RESULT', &
'  Returns .true. if the optional argument A is present (was passed on the call', &
'  to the procedure) , or .false. otherwise.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_present', &
'      implicit none', &
'      integer :: answer', &
'         ! argument to func() is not present', &
'         answer=func()', &
'         write(*,*) answer', &
'         ! argument to func() is present', &
'         answer=func(1492)', &
'         write(*,*) answer', &
'      contains', &
'', &
'      integer function func(x)', &
'      ! the optional characteristic on this definition allows this variable', &
'      ! to not be specified on a call; and also allows it to subsequently', &
'      ! be passed to PRESENT(3f):', &
'      integer, intent(in), optional :: x', &
'      integer :: x_local', &
'', &
'        ! basic', &
'         if(present(x))then', &
'           ! if present, you can use x like any other variable.', &
'           x_local=x', &
'         else', &
'           ! if not, you cannot define or reference x except to', &
'           ! pass it as an optional parameter to another procedure', &
'           ! or in a call to present(3f)', &
'           x_local=0', &
'         endif', &
'', &
'         func=x_local**2', &
'', &
'        ! passing the argument on to other procedures', &
'         ! so something like this is a bad idea because x is used', &
'         ! as the first argument to merge(3f) when it might not be', &
'         ! present', &
'         ! xlocal=merge(x,0,present(x)) ! NO!!', &
'', &
'         ! We can pass it to another procedure if and only if the', &
'         ! other procedure declares the argument as optional as well.', &
'         call tattle(''optional argument x'',x)', &
'      end function', &
'', &
'      subroutine tattle(label,arg)', &
'      character(len=*),intent(in) :: label', &
'      integer,intent(in),optional :: arg', &
'         if(present(arg))then', &
'            write(*,*)label,'' is present''', &
'         else', &
'            write(*,*)label,'' is not present''', &
'         endif', &
'      end subroutine tattle', &
'', &
'      end program demo_present', &
'', &
'  Results:', &
'', &
'          optional argument x is not present', &
'                    0', &
'          optional argument x is present', &
'              2226064', &
'', &
'STANDARD', &
'  Fortran 95', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022              present(3fortran)', &
'']

shortname="present"
call process()


case('157','product')

textblock=[character(len=256) :: &
'', &
'product(3fortran)                                            product(3fortran)', &
'', &
'NAME', &
'  PRODUCT(3) - [ARRAY:REDUCTION] Product of array elements', &
'', &
'SYNOPSIS', &
'                               October 09, 2022              product(3fortran)', &
'']

shortname="product"
call process()


case('158','radix')

textblock=[character(len=256) :: &
'', &
'radix(3fortran)                                                radix(3fortran)', &
'', &
'NAME', &
'  RADIX(3) - [NUMERIC MODEL] Base of a model number', &
'', &
'SYNOPSIS', &
'  result = radix(x)', &
'', &
'          integer function radix(x)', &
'', &
'           TYPE(kind=**),intent(in) :: x(..)', &
'', &
'CHARACTERISTICS', &
'  o  TYPE may be real or integer', &
'', &
'  o  X may be scalar or an array', &
'', &
'DESCRIPTION', &
'  RADIX(3) returns the base of the internal model representing the numeric', &
'  entity X.', &
'', &
'  In a positional numeral system, the radix or base is the number of unique', &
'  digits, including the digit zero, used to represent numbers.', &
'', &
'  This function helps to represent the internal computing model generically,', &
'  but will be 2 (representing a binary machine) for any common platform for', &
'  all the numeric types.', &
'', &
'OPTIONS', &
'  o  X : used to identify the type of number to query.', &
'', &
'RESULT', &
'  The returned value indicates what base is internally used to represent the', &
'  type of numeric value X represents.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_radix', &
'      implicit none', &
'         print *, "The radix for the default integer kind is", radix(0)', &
'         print *, "The radix for the default real kind is", radix(0.0)', &
'         print *, "The radix for the doubleprecision real kind is", radix(0.0d0)', &
'      end program demo_radix', &
'', &
'  Results:', &
'', &
'          The radix for the default integer kind is           2', &
'          The radix for the default real kind is           2', &
'          The radix for the doubleprecision real kind is          2', &
'', &
'STANDARD', &
'  Fortran 95', &
'', &
'SEE ALSO', &
'  DIGITS(3), EPSILON(3), EXPONENT(3), FRACTION(3), HUGE(3), MAXEXPONENT(3),', &
'  MINEXPONENT(3), NEAREST(3), PRECISION(3), RANGE(3), RRSPACING(3), SCALE(3),', &
'  SET_EXPONENT(3), SPACING(3), TINY(3)', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022                radix(3fortran)', &
'']

shortname="radix"
call process()


case('159','random_number')

textblock=[character(len=256) :: &
'', &
'random_number(3fortran)                                random_number(3fortran)', &
'', &
'NAME', &
'  RANDOM_NUMBER(3) - [MATHEMATICS:RANDOM] Pseudo-random number', &
'', &
'SYNOPSIS', &
'  call random_number(harvest)', &
'', &
'           subroutine random_number(harvest)', &
'', &
'            real,intent(out) :: harvest(..)', &
'', &
'CHARACTERISTICS', &
'  o  HARVEST and the result are default real variables', &
'', &
'  REAL X, Y (10, 10) ! Initialize X with a pseudorandom number CALL', &
'  RANDOM_NUMBER (HARVEST = X) CALL RANDOM_NUMBER (Y) ! X and Y contain', &
'  uniformly distributed random numbers', &
'', &
'DESCRIPTION', &
'  RANDOM_NUMBER(3) returns a single pseudorandom number or an array of', &
'  pseudorandom numbers from the uniform distribution over the range 0 <= x <', &
'  1.', &
'', &
'OPTIONS', &
'  o  HARVEST : Shall be a scalar or an array of type real.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_random_number', &
'      use, intrinsic :: iso_fortran_env, only : dp=>real64', &
'      implicit none', &
'      integer, allocatable :: seed(:)', &
'      integer              :: n', &
'      integer              :: first,last', &
'      integer              :: i', &
'      integer              :: rand_int', &
'      integer,allocatable  :: count(:)', &
'      real(kind=dp)        :: rand_val', &
'         call random_seed(size = n)', &
'         allocate(seed(n))', &
'         call random_seed(get=seed)', &
'         first=1', &
'         last=10', &
'         allocate(count(last-first+1))', &
'         ! To have a discrete uniform distribution on the integers', &
'         ! [first, first+1, ..., last-1, last] carve the continuous', &
'         ! distribution up into last+1-first equal sized chunks,', &
'         ! mapping each chunk to an integer.', &
'         !', &
'         ! One way is:', &
'         !   call random_number(rand_val)', &
'         ! choose one from last-first+1 integers', &
'         !   rand_int = first + FLOOR((last+1-first)*rand_val)', &
'            count=0', &
'            ! generate a lot of random integers from 1 to 10 and count them.', &
'            ! with a large number of values you should get about the same', &
'            ! number of each value', &
'            do i=1,100000000', &
'               call random_number(rand_val)', &
'               rand_int=first+floor((last+1-first)*rand_val)', &
'               if(rand_int.ge.first.and.rand_int.le.last)then', &
'                  count(rand_int)=count(rand_int)+1', &
'               else', &
'                  write(*,*)rand_int,'' is out of range''', &
'               endif', &
'            enddo', &
'            write(*,''(i0,1x,i0)'')(i,count(i),i=1,size(count))', &
'      end program demo_random_number', &
'', &
'  Results:', &
'', &
'    1 10003588 2 10000104 3 10000169 4 9997996 5 9995349 6 10001304 7 10001909', &
'    8 9999133 9 10000252 10 10000196', &
'', &
'STANDARD', &
'  Fortran 95', &
'', &
'SEE ALSO', &
'  RANDOM_SEED(3)', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022        random_number(3fortran)', &
'']

shortname="random_number"
call process()


case('160','random_seed')

textblock=[character(len=256) :: &
'', &
'random_seed(3fortran)                                    random_seed(3fortran)', &
'', &
'NAME', &
'  RANDOM_SEED(3) - [MATHEMATICS:RANDOM] Initialize a pseudo-random number', &
'  sequence', &
'', &
'SYNOPSIS', &
'                               October 09, 2022          random_seed(3fortran)', &
'']

shortname="random_seed"
call process()


case('161','range')

textblock=[character(len=256) :: &
'', &
'range(3fortran)                                                range(3fortran)', &
'', &
'NAME', &
'  RANGE(3) - [NUMERIC MODEL] Decimal exponent range of a real kind', &
'', &
'SYNOPSIS', &
'  result = range(x)', &
'', &
'            integer function range (x)', &
'', &
'             TYPE(kind=KIND),intent(in) :: x', &
'', &
'CHARACTERISTICS', &
'  where TYPE is real or complex and KIND is any kind supported by TYPE.', &
'', &
'DESCRIPTION', &
'  RANGE(3) returns the decimal exponent range in the model of the type of X.', &
'', &
'OPTIONS', &
'  o  X : Shall be of type real or complex.', &
'', &
'RESULT', &
'  The return value is of type integer and of the default integer kind.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_range', &
'      use,intrinsic :: iso_fortran_env, only : dp=>real64,sp=>real32', &
'      implicit none', &
'      real(kind=sp)    :: x(2)', &
'      complex(kind=dp) :: y', &
'         print *, precision(x), range(x)', &
'         print *, precision(y), range(y)', &
'      end program demo_range', &
'', &
'  Results:', &
'', &
'    6 37', &
'', &
'  15', &
'    307', &
'', &
'STANDARD', &
'  Fortran 95', &
'', &
'SEE ALSO', &
'  DIGITS(3), EPSILON(3), EXPONENT(3), FRACTION(3), HUGE(3), MAXEXPONENT(3),', &
'  MINEXPONENT(3), NEAREST(3), PRECISION(3), RADIX(3), RRSPACING(3), SCALE(3),', &
'  SET_EXPONENT(3), SPACING(3), TINY(3)', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022                range(3fortran)', &
'']

shortname="range"
call process()


case('162','rank')

textblock=[character(len=256) :: &
'', &
'rank(3fortran)                                                  rank(3fortran)', &
'', &
'NAME', &
'  RANK(3) - [ARRAY:INQUIRY] Rank of a data object', &
'', &
'SYNOPSIS', &
'  result = rank(a)', &
'', &
'           integer function rank(a)', &
'', &
'            type(TYPE(kind=**)),intent(in) :: a(..)', &
'', &
'CHARACTERISTICS', &
'  o  A can be of any type TYPE and rank.', &
'', &
'  o  a kind designated as ** may be any supported kind value for the type', &
'', &
'DESCRIPTION', &
'  RANK(3) returns the rank of a scalar or array data object.', &
'', &
'  The rank of an array is the number of dimensions it has (zero for a scalar).', &
'', &
'OPTIONS', &
'  o  A is the data object to query the dimensionality of. The rank returned', &
'     may be from 0 to 16.', &
'', &
'     The argument A may be any data object type, including an assumed-rank', &
'     array.', &
'', &
'RESULT', &
'  For arrays, their rank is returned; for scalars zero is returned.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_rank', &
'      implicit none', &
'', &
'      ! a bunch of data objects to query', &
'      integer           :: a', &
'      real, allocatable :: b(:,:)', &
'      real, pointer     :: c(:)', &
'      complex           :: d', &
'', &
'      ! make up a type', &
'      type mytype', &
'         integer :: int', &
'         real :: float', &
'         character :: char', &
'      end type mytype', &
'      type(mytype) :: any_thing(1,2,3,4,5)', &
'', &
'        ! basics', &
'         print *, ''rank of scalar a='',rank(a)', &
'         ! you can query this array even though it is not allocated', &
'         print *, ''rank of matrix b='',rank(b)', &
'         print *, ''rank of vector pointer c='',rank(c)', &
'         print *, ''rank of complex scalar d='',rank(d)', &
'', &
'        ! you can query any type, not just intrinsics', &
'         print *, ''rank of any arbitrary type='',rank(any_thing)', &
'', &
'        ! an assumed-rank object may be queried', &
'         call query_int(10)', &
'         call query_int([20,30])', &
'         call query_int( reshape([40,50,60,70],[2,2]) )', &
'', &
'        ! you can even query an unlimited polymorphic entity', &
'         call query_anything(10.0)', &
'         call query_anything([.true.,.false.])', &
'         call query_anything( reshape([40.0,50.0,60.0,70.0],[2,2]) )', &
'', &
'      contains', &
'', &
'      subroutine query_int(data_object)', &
'      ! It is hard to do much with something dimensioned', &
'      ! name(..) if not calling C except inside of a', &
'      ! SELECT_RANK construct but one thing you can', &
'      ! do is call the inquiry functions ...', &
'      integer,intent(in) :: data_object(..)', &
'      character(len=*),parameter :: all=''(*(g0,1x))''', &
'', &
'         if(rank(data_object).eq.0)then', &
'            print all,&', &
'            & ''passed a scalar to an assumed rank,  &', &
'            & rank='',rank(data_object)', &
'         else', &
'            print all,&', &
'            & ''passed an array to an assumed rank,  &', &
'            & rank='',rank(data_object)', &
'         endif', &
'', &
'      end subroutine query_int', &
'', &
'      subroutine query_anything(data_object)', &
'      class(*),intent(in) ::data_object(..)', &
'      character(len=*),parameter :: all=''(*(g0,1x))''', &
'        if(rank(data_object).eq.0)then', &
'          print all,&', &
'          &''passed a scalar to an unlimited polymorphic rank='', &', &
'          & rank(data_object)', &
'        else', &
'          print all,&', &
'          & ''passed an array to an unlimited polymorphic, rank='', &', &
'          & rank(data_object)', &
'        endif', &
'      end subroutine query_anything', &
'', &
'      end program demo_rank', &
'', &
'  Results:', &
'', &
'          rank of scalar a=           0', &
'          rank of matrix b=           2', &
'          rank of vector pointer c=           1', &
'          rank of complex scalar d=           0', &
'          rank of any arbitrary type=           5', &
'', &
'    passed a scalar to an assumed rank,', &
'      rank= 0', &
'', &
'    passed an array to an assumed rank,', &
'      rank= 1', &
'', &
'    passed an array to an assumed rank,', &
'      rank= 2 passed a scalar to an unlimited polymorphic rank= 0 passed an', &
'      array to an unlimited polymorphic, rank= 1 passed an array to an', &
'      unlimited polymorphic, rank= 2', &
'', &
'STANDARD', &
'SEE ALSO', &
'  Array inquiry:', &
'', &
'  o  SIZE(3) - Determine the size of an array', &
'', &
'  o  RANK(3) - Rank of a data object', &
'', &
'  o  SHAPE(3) - Determine the shape of an array', &
'', &
'  o  UBOUND(3) - Upper dimension bounds of an array', &
'', &
'  o  LBOUND(3) - Lower dimension bounds of an array', &
'', &
'  State Inquiry:', &
'', &
'  o  ALLOCATED(3) - Status of an allocatable entity', &
'', &
'  o  IS_CONTIGUOUS(3) - Test if object is contiguous', &
'', &
'  Kind Inquiry:', &
'', &
'  o  KIND(3) - Kind of an entity', &
'', &
'  Bit Inquiry:', &
'', &
'  o  STORAGE_SIZE(3) - Storage size in bits', &
'', &
'  o  BIT_SIZE(3) - Bit size inquiry function', &
'', &
'  o  BTEST(3) - Tests a bit of an integer value.', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022                 rank(3fortran)', &
'']

shortname="rank"
call process()


case('163','real')

textblock=[character(len=256) :: &
'', &
'real(3fortran)                                                  real(3fortran)', &
'', &
'NAME', &
'  REAL(3) - [TYPE:NUMERIC] Convert to real type', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                 real(3fortran)', &
'']

shortname="real"
call process()


case('164','reduce')

textblock=[character(len=256) :: &
'', &
'reduce(3fortran)                                              reduce(3fortran)', &
'', &
'NAME', &
'  REDUCE(3) - [TRANSFORMATIONAL] General reduction of an array', &
'', &
'SYNOPSIS', &
'  There are two forms to this function:', &
'', &
'         result = reduce(array, operation [,mask]  [,identity]  [,ordered] )', &
'', &
'  or', &
'', &
'         result = reduce (array, operation &', &
'         & [,dim] [,mask] [,identity] [,ordered] )', &
'', &
'          type(TYPE(kind=KIND)) function reduce &', &
'          & (array, operation, dim, mask, identity, ordered )', &
'', &
'           type(TYPE(kind=KIND)),intent(in) :: array', &
'           pure function                  :: operation', &
'           integer,intent(in),optional    :: dim', &
'           logical,optional               :: mask', &
'           type(TYPE),intent(in),optional :: identity', &
'           logical,intent(in),optional    :: ordered', &
'', &
'CHARACTERISTICS', &
'  where TYPE may be of any type. TYPE must be the same for ARRAY and IDENTITY.', &
'', &
'DESCRIPTION', &
'  REDUCE(3) reduces a list of conditionally selected values from an array to a', &
'  single value by iteratively applying a binary function.', &
'', &
'  Common in functional programming, a REDUCE function applies a binary', &
'  operator (a pure function with two arguments) to all elements cumulatively.', &
'', &
'  REDUCE is a "higher-order" function; ie. it is a function that receives', &
'  other functions as arguments.', &
'', &
'  The REDUCE function receives a binary operator (a function with two', &
'  arguments, just like the basic arithmetic operators). It is first applied to', &
'  two unused values in the list to generate an accumulator value which is', &
'  subsequently used as the first argument to the function as the function is', &
'  recursively applied to all the remaining selected values in the input array.', &
'', &
'OPTIONS', &
'  o  ARRAY : An array of any type and allowed rank to select values from.', &
'', &
'  o  OPERATION : shall be a pure function with exactly two arguments; each', &
'     argument shall be a scalar, nonallocatable, nonpointer, nonpolymorphic,', &
'     nonoptional dummy data object with the same type and type parameters as', &
'     ARRAY. If one argument has the ASYNCHRONOUS, TARGET, or VALUE attribute,', &
'     the other shall have that attribute. Its result shall be a nonpolymorphic', &
'     scalar and have the same type and type parameters as ARRAY. OPERATION', &
'     should implement a mathematically associative operation. It need not be', &
'     commutative.', &
'', &
'   NOTE', &
'  If OPERATION is not computationally associative, REDUCE without', &
'  ORDERED=.TRUE. with the same argument values might not always produce the', &
'  same result, as the processor can apply the associative law to the', &
'  evaluation.', &
'', &
'  Many operations that mathematically are associative are not when applied to', &
'  floating-point numbers. The order you sum values in may affect the result,', &
'  for example.', &
'', &
'  o  DIM : An integer scalar with a value in the range 1<= DIM <= n, where n', &
'     is the rank of ARRAY.', &
'', &
'     o  MASK : (optional) shall be of type logical and shall be conformable', &
'        with ARRAY.', &
'', &
'        When present only those elements of ARRAY are passed to OPERATION for', &
'        which the corresponding elements of MASK are true, as if *array was', &
'        filtered with PACK(3).', &
'', &
'     o  IDENTITY : shall be scalar with the same type and type parameters as', &
'        ARRAY. If the initial sequence is empty, the result has the value', &
'        IDENTIFY if IDENTIFY is present, and otherwise, error termination is', &
'        initiated.', &
'', &
'     o  ORDERED : shall be a logical scalar. If ORDERED is present with the', &
'        value .true., the calls to the OPERATOR function begins with the first', &
'        two elements of ARRAY and the process continues in row-column order', &
'        until the sequence has only one element which is the value of the', &
'        reduction. Otherwise, the compiler is free to assume that the', &
'        operation is commutative and may evaluate the reduction in the most', &
'        optimal way.', &
'', &
'RESULT', &
'  The result is of the same type and type parameters as ARRAY. It is scalar if', &
'  DIM does not appear.', &
'', &
'  If DIM is present, it indicates the one dimension along which to perform the', &
'  reduction, and the resultant array has a rank reduced by one relative to the', &
'  input array.', &
'', &
'EXAMPLES', &
'  The following examples all use the function MY_MULT, which returns the', &
'  product of its two real arguments.', &
'', &
'         program demo_reduce', &
'         implicit none', &
'         character(len=*),parameter :: f=''("[",*(g0,",",1x),"]")''', &
'         integer,allocatable :: arr(:), b(:,:)', &
'', &
'         ! Basic usage:', &
'            ! the product of the elements of an array', &
'            arr=[1, 2, 3, 4 ]', &
'            write(*,*) arr', &
'            write(*,*) ''product='', reduce(arr, my_mult)', &
'            write(*,*) ''sum='', reduce(arr, my_sum)', &
'', &
'         ! Examples of masking:', &
'            ! the product of only the positive elements of an array', &
'            arr=[1, -1, 2, -2, 3, -3 ]', &
'            write(*,*)''positive value product='',reduce(arr, my_mult, mask=arr>0)', &
'         ! sum values ignoring negative values', &
'            write(*,*)''sum positive values='',reduce(arr, my_sum, mask=arr>0)', &
'', &
'         ! a single-valued array returns the single value as the', &
'         ! calls to the operator stop when only one element remains', &
'            arr=[ 1234 ]', &
'            write(*,*)''single value sum'',reduce(arr, my_sum )', &
'            write(*,*)''single value product'',reduce(arr, my_mult )', &
'', &
'         ! Example of operations along a dimension:', &
'         !  If B is the array   1 3 5', &
'         !                      2 4 6', &
'            b=reshape([1,2,3,4,5,6],[2,3])', &
'            write(*,f) REDUCE(B, MY_MULT),''should be [720]''', &
'            write(*,f) REDUCE(B, MY_MULT, DIM=1),''should be [2,12,30]''', &
'            write(*,f) REDUCE(B, MY_MULT, DIM=2),''should be [15, 48]''', &
'', &
'         contains', &
'', &
'         pure function my_mult(a,b) result(c)', &
'         integer,intent(in) :: a, b', &
'         integer            :: c', &
'            c=a*b', &
'         end function my_mult', &
'', &
'         pure function my_sum(a,b) result(c)', &
'         integer,intent(in) :: a, b', &
'         integer            :: c', &
'            c=a+b', &
'         end function my_sum', &
'', &
'         end program demo_reduce', &
'', &
'  Results:', &
'', &
'           >  1 2 3 4', &
'           >  product= 24', &
'           >  sum=     10', &
'           >  positive value sum= 6', &
'           >  sum positive values= 6', &
'           >  single value sum     1234', &
'           >  single value product 1234', &
'           > [720, should be [720],', &
'           > [2, 12, 30, should be [2,12,30],', &
'           > [15, 48, should be [15, 48],', &
'', &
'STANDARD', &
'  Fortran 2018', &
'', &
'SEE ALSO', &
'  o  co_reduce(3)', &
'', &
'RESOURCES', &
'  o  associative:wikipedia', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022               reduce(3fortran)', &
'']

shortname="reduce"
call process()


case('165','repeat')

textblock=[character(len=256) :: &
'', &
'repeat(3fortran)                                              repeat(3fortran)', &
'', &
'NAME', &
'  REPEAT(3) - [CHARACTER] Repeated string concatenation', &
'', &
'SYNOPSIS', &
'                               October 09, 2022               repeat(3fortran)', &
'']

shortname="repeat"
call process()


case('166','reshape')

textblock=[character(len=256) :: &
'', &
'reshape(3fortran)                                            reshape(3fortran)', &
'', &
'NAME', &
'  RESHAPE(3) - [ARRAY:RESHAPE] Function to reshape an array', &
'', &
'SYNOPSIS', &
'                               October 09, 2022              reshape(3fortran)', &
'']

shortname="reshape"
call process()


case('167','rrspacing')

textblock=[character(len=256) :: &
'', &
'rrspacing(3fortran)                                        rrspacing(3fortran)', &
'', &
'NAME', &
'  RRSPACING(3) - [MODEL_COMPONENTS] Reciprocal of the relative spacing', &
'', &
'SYNOPSIS', &
'  result = rrspacing(x)', &
'', &
'           elemental real(kind=KIND) function rrspacing(x)', &
'', &
'            real(kind=KIND),intent(in) :: x', &
'', &
'CHARACTERISTICS', &
'  The return value is of the same type and kind as X.', &
'', &
'DESCRIPTION', &
'  RRSPACING(3) returns the reciprocal of the relative spacing of model numbers', &
'  near X.', &
'', &
'OPTIONS', &
'  o  X : Shall be of type real.', &
'', &
'RESULT', &
'  The return value is of the same type and kind as X. The value returned is', &
'  equal to ABS(FRACTION(X)) * FLOAT(RADIX(X))**DIGITS(X).', &
'', &
'STANDARD', &
'  Fortran 95', &
'', &
'SEE ALSO', &
'  DIGITS(3), EPSILON(3), EXPONENT(3), FRACTION(3), HUGE(3), MAXEXPONENT(3),', &
'  MINEXPONENT(3), NEAREST(3), PRECISION(3), RADIX(3), RANGE(3), SCALE(3),', &
'  SET_EXPONENT(3), SPACING(3), TINY(3)', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022            rrspacing(3fortran)', &
'']

shortname="rrspacing"
call process()


case('168','same_type_as')

textblock=[character(len=256) :: &
'', &
'same_type_as(3fortran)                                  same_type_as(3fortran)', &
'', &
'NAME', &
'  SAME_TYPE_AS(3) - [STATE] Query dynamic types for equality', &
'', &
'SYNOPSIS', &
'                               October 09, 2022         same_type_as(3fortran)', &
'']

shortname="same_type_as"
call process()


case('169','scale')

textblock=[character(len=256) :: &
'', &
'scale(3fortran)                                                scale(3fortran)', &
'', &
'NAME', &
'  SCALE(3) - [MODEL_COMPONENTS] Scale a real value by a whole power of the', &
'  radix', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                scale(3fortran)', &
'']

shortname="scale"
call process()


case('170','scan')

textblock=[character(len=256) :: &
'', &
'scan(3fortran)                                                  scan(3fortran)', &
'', &
'NAME', &
'  SCAN(3) - [CHARACTER:SEARCH] Scan a string for the presence of a set of', &
'  characters', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                 scan(3fortran)', &
'']

shortname="scan"
call process()


case('171','selected_char_kind')

textblock=[character(len=256) :: &
'', &
'selected_char_kind(3fortran)                      selected_char_kind(3fortran)', &
'', &
'NAME', &
'  SELECTED_CHAR_KIND(3) - [KIND] Select character kind such as "Unicode"', &
'', &
'SYNOPSIS', &
'  result = selected_char_kind(name)', &
'', &
'           integer function selected_char_kind(name)', &
'', &
'            character(len=*),intent(in) :: name', &
'', &
'CHARACTERISTICS', &
'DESCRIPTION', &
'  SELECTED_CHAR_KIND(3) returns the kind value for the character set named', &
'  NAME, if a character set with such a name is supported, or -1 otherwise.', &
'', &
'OPTIONS', &
'  o  NAME : A name to query the processor kind value of , and/or to determine', &
'     if it is supported. NAME is interpreted without respect to case or', &
'     trailing blanks.', &
'', &
'     Currently, supported character sets include "ASCII" and "DEFAULT" and', &
'     "ISO_10646" (Universal Character Set, UCS-4) which is commonly known as', &
'     "Unicode". Supported names other than "DEFAULT" are processor dependent.', &
'', &
'RESULT', &
'  If a name is not supported, -1 is returned. Otherwise', &
'', &
'  o  If NAME has the value "DEFAULT", then the result has a value equal to', &
'     that of the kind type parameter of default character. This name is always', &
'     supported.', &
'', &
'  o  If NAME has the value "ASCII", then the result has a value equal to that', &
'     of the kind type parameter of ASCII character.', &
'', &
'  o  If NAME has the value "ISO_10646", then the result has a value equal to', &
'     that of the kind type parameter of the ISO 10646 character kind', &
'     (corresponding to UCS-4 as specified in ISO/IEC 10646).', &
'', &
'  o  If NAME is a processor-defined name of some other character kind', &
'     supported by the processor, then the result has a value equal to that', &
'     kind type parameter value.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_selected_char_kind', &
'      use iso_fortran_env', &
'      implicit none', &
'', &
'      intrinsic date_and_time,selected_char_kind', &
'', &
'      integer, parameter :: default = selected_char_kind ("default")', &
'      integer, parameter :: ascii =   selected_char_kind ("ascii")', &
'      integer, parameter :: ucs4  =   selected_char_kind (''ISO_10646'')', &
'      integer, parameter :: utf8  =   selected_char_kind (''utf-8'')', &
'', &
'      character(len=26, kind=ascii ) :: alphabet', &
'      character(len=30, kind=ucs4  ) :: hello_world', &
'      character(len=30, kind=ucs4  ) :: string', &
'', &
'         write(*,*)''ASCII     '',&', &
'          & merge(''Supported    '',''Not Supported'',ascii /= -1)', &
'         write(*,*)''ISO_10646 '',&', &
'          & merge(''Supported    '',''Not Supported'',ucs4 /= -1)', &
'         write(*,*)''UTF-8     '',&', &
'          & merge(''Supported    '',''Not Supported'',utf8 /= -1)', &
'', &
'         if(default.eq.ascii)then', &
'             write(*,*)''ASCII is the default on this processor''', &
'         endif', &
'', &
'        ! the kind precedes the value, somewhat like a BOZ constant', &
'         alphabet = ascii_"abcdefghijklmnopqrstuvwxyz"', &
'         write (*,*) alphabet', &
'', &
'         hello_world = ucs4_''Hello World and Ni Hao -- '' &', &
'                       // char (int (z''4F60''), ucs4)     &', &
'                       // char (int (z''597D''), ucs4)', &
'', &
'        ! an  encoding option is required on OPEN for non-default I/O', &
'         if(ucs4 /= -1 )then', &
'            open (output_unit, encoding=''UTF-8'')', &
'            write (*,*) trim (hello_world)', &
'         else', &
'            write (*,*) ''cannot use utf-8''', &
'         endif', &
'', &
'         call create_date_string(string)', &
'         write (*,*) trim (string)', &
'', &
'      contains', &
'', &
'      ! The following produces a Japanese date stamp.', &
'      subroutine create_date_string(string)', &
'      intrinsic date_and_time,selected_char_kind', &
'      integer,parameter :: ucs4 = selected_char_kind("ISO_10646")', &
'      character(len=1,kind=ucs4),parameter :: &', &
'             nen =   char(int( z''5e74'' ),ucs4), & ! year', &
'             gatsu = char(int( z''6708'' ),ucs4), & ! month', &
'             nichi = char(int( z''65e5'' ),ucs4)    ! day', &
'           character(len= *, kind= ucs4) string', &
'           integer values(8)', &
'           call date_and_time(values=values)', &
'           write(string,1) values(1),nen,values(2),gatsu,values(3),nichi', &
'         1 format(i0,a,i0,a,i0,a)', &
'      end subroutine create_date_string', &
'', &
'      end program demo_selected_char_kind', &
'', &
'  Results:', &
'', &
'  The results are very processor-dependent', &
'', &
'       ASCII     Supported', &
'       ISO_10646 Supported', &
'       UTF-8     Not Supported', &
'       ASCII is the default on this processor', &
'       abcdefghijklmnopqrstuvwxyz', &
'       Hello World and Ni Hao --', &
'       2022105', &
'', &
'STANDARD', &
'  Fortran 2003', &
'', &
'SEE ALSO', &
'  ACHAR(3)', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022   selected_char_kind(3fortran)', &
'']

shortname="selected_char_kind"
call process()


case('172','selected_int_kind')

textblock=[character(len=256) :: &
'', &
'selected_int_kind(3fortran)                        selected_int_kind(3fortran)', &
'', &
'NAME', &
'  SELECTED_INT_KIND(3) - [KIND] Choose integer kind', &
'', &
'SYNOPSIS', &
'  result = selected_int_kind(r)', &
'', &
'  integer function selected_int_kind(r)', &
'', &
'           integer(kind=KIND),intent(in) :: r', &
'', &
'CHARACTERISTICS', &
'DESCRIPTION', &
'  SELECTED_INT_KIND(3) return the kind value of the smallest integer type that', &
'  can represent all values ranging from -10**R (exclusive) to 10**R', &
'  (exclusive). If there is no integer kind that accommodates this range,', &
'  selected_int_kind returns -1.', &
'', &
'OPTIONS', &
'  o  R : Shall be a scalar and of type integer.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_selected_int_kind', &
'      implicit none', &
'      integer,parameter :: k5 = selected_int_kind(5)', &
'      integer,parameter :: k15 = selected_int_kind(15)', &
'      integer(kind=k5) :: i5', &
'      integer(kind=k15) :: i15', &
'', &
'          print *, huge(i5), huge(i15)', &
'', &
'          ! the following inequalities are always true', &
'          print *, huge(i5) >= 10_k5**5-1', &
'          print *, huge(i15) >= 10_k15**15-1', &
'      end program demo_selected_int_kind', &
'', &
'  Results:', &
'', &
'           2147483647  9223372036854775807', &
'', &
'   T', &
'   T', &
'STANDARD', &
'  Fortran 95', &
'', &
'SEE ALSO', &
'  AINT(3), ANINT(3), INT(3), NINT(3), CEILING(3), FLOOR(3)', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022    selected_int_kind(3fortran)', &
'']

shortname="selected_int_kind"
call process()


case('173','selected_real_kind')

textblock=[character(len=256) :: &
'', &
'selected_real_kind(3fortran)                      selected_real_kind(3fortran)', &
'', &
'NAME', &
'  SELECTED_REAL_KIND(3) - [KIND] Choose real kind', &
'', &
'SYNOPSIS', &
'                               October 09, 2022   selected_real_kind(3fortran)', &
'']

shortname="selected_real_kind"
call process()


case('174','set_exponent')

textblock=[character(len=256) :: &
'', &
'set_exponent(3fortran)                                  set_exponent(3fortran)', &
'', &
'NAME', &
'  SET_EXPONENT(3) - [MODEL_COMPONENTS] Set the exponent of the model', &
'', &
'SYNOPSIS', &
'                               October 09, 2022         set_exponent(3fortran)', &
'']

shortname="set_exponent"
call process()


case('175','shape')

textblock=[character(len=256) :: &
'', &
'shape(3fortran)                                                shape(3fortran)', &
'', &
'NAME', &
'  SHAPE(3) - [ARRAY:INQUIRY] Determine the shape of an array', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                shape(3fortran)', &
'']

shortname="shape"
call process()


case('176','shifta')

textblock=[character(len=256) :: &
'', &
'shifta(3fortran)                                              shifta(3fortran)', &
'', &
'NAME', &
'  SHIFTA(3) - [BIT:SHIFT] Shift bits right with fill', &
'', &
'SYNOPSIS', &
'                               October 09, 2022               shifta(3fortran)', &
'']

shortname="shifta"
call process()


case('177','shiftl')

textblock=[character(len=256) :: &
'', &
'shiftl(3fortran)                                              shiftl(3fortran)', &
'', &
'NAME', &
'  SHIFTL(3) - [BIT:SHIFT] Shift bits left', &
'', &
'SYNOPSIS', &
'                               October 09, 2022               shiftl(3fortran)', &
'']

shortname="shiftl"
call process()


case('178','shiftr')

textblock=[character(len=256) :: &
'', &
'shiftr(3fortran)                                              shiftr(3fortran)', &
'', &
'NAME', &
'  SHIFTR(3) - [BIT:SHIFT] Shift bits right', &
'', &
'SYNOPSIS', &
'                               October 09, 2022               shiftr(3fortran)', &
'']

shortname="shiftr"
call process()


case('179','sign')

textblock=[character(len=256) :: &
'', &
'sign(3fortran)                                                  sign(3fortran)', &
'', &
'NAME', &
'  SIGN(3) - [NUMERIC] Sign copying function', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                 sign(3fortran)', &
'']

shortname="sign"
call process()


case('180','sin')

textblock=[character(len=256) :: &
'', &
'sin(3fortran)                                                    sin(3fortran)', &
'', &
'NAME', &
'  SIN(3) - [MATHEMATICS:TRIGONOMETRIC] Sine function', &
'', &
'SYNOPSIS', &
'  result = sin(x)', &
'', &
'           elemental TYPE(kind=KIND) function sin(x)', &
'', &
'            TYPE(kind=KIND) :: x', &
'', &
'CHARACTERISTICS', &
'  where TYPE may be real or complex and KIND may be any kind supported by the', &
'  associated type.', &
'', &
'  The returned value will be of the same type and kind as the argument.', &
'', &
'DESCRIPTION', &
'  SIN(3) computes the sine of an angle given the size of the angle in radians.', &
'', &
'  The sine of an angle in a right-angled triangle is the ratio of the length', &
'  of the side opposite the given angle divided by the length of the', &
'  hypotenuse.', &
'', &
'OPTIONS', &
'  o  X : The angle in radians to compute the sine of.', &
'', &
'RESULT', &
'  o  RESULT : The return value contains the sine of X.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program sample_sin', &
'      implicit none', &
'      real :: x = 0.0', &
'         x = sin(x)', &
'      end program sample_sin', &
'', &
'HAVERSINE FORMULA', &
'  From the article on "Haversine formula" in Wikipedia:', &
'', &
'      The haversine formula is an equation important in navigation,', &
'      giving great-circle distances between two points on a sphere from', &
'      their longitudes and latitudes.', &
'', &
'  So to show the great-circle distance between the Nashville International', &
'  Airport (BNA) in TN, USA, and the Los Angeles International Airport (LAX) in', &
'  CA, USA you would start with their latitude and longitude, commonly given as', &
'', &
'      BNA: N 36 degrees 7.2'',   W 86 degrees 40.2''', &
'      LAX: N 33 degrees 56.4'',  W 118 degrees 24.0''', &
'', &
'  which converted to floating-point values in degrees is:', &
'', &
'           Latitude Longitude', &
'', &
'    o  BNA 36.12, -86.67', &
'', &
'    o  LAX 33.94, -118.40', &
'', &
'  And then use the haversine formula to roughly calculate the distance along', &
'  the surface of the Earth between the locations:', &
'', &
'  Sample program:', &
'', &
'      program demo_sin', &
'      implicit none', &
'      real :: d', &
'          d = haversine(36.12,-86.67, 33.94,-118.40) ! BNA to LAX', &
'          print ''(A,F9.4,A)'', ''distance: '',d,'' km''', &
'      contains', &
'      function haversine(latA,lonA,latB,lonB) result (dist)', &
'      !', &
'      ! calculate great circle distance in kilometers', &
'      ! given latitude and longitude in degrees', &
'      !', &
'      real,intent(in) :: latA,lonA,latB,lonB', &
'      real :: a,c,dist,delta_lat,delta_lon,lat1,lat2', &
'      real,parameter :: radius = 6371 ! mean earth radius in kilometers,', &
'      ! recommended by the International Union of Geodesy and Geophysics', &
'', &
'      ! generate constant pi/180', &
'      real, parameter :: deg_to_rad = atan(1.0)/45.0', &
'         delta_lat = deg_to_rad*(latB-latA)', &
'         delta_lon = deg_to_rad*(lonB-lonA)', &
'         lat1 = deg_to_rad*(latA)', &
'         lat2 = deg_to_rad*(latB)', &
'         a = (sin(delta_lat/2))**2 + &', &
'                & cos(lat1)*cos(lat2)*(sin(delta_lon/2))**2', &
'         c = 2*asin(sqrt(a))', &
'         dist = radius*c', &
'      end function haversine', &
'      end program demo_sin', &
'', &
'  Results:', &
'', &
'          distance: 2886.4446 km', &
'', &
'STANDARD', &
'  FORTRAN 77', &
'', &
'SEE ALSO', &
'  ASIN(3), COS(3), TAN(3)', &
'', &
'RESOURCES', &
'  o  Wikipedia:sine and cosine', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022                  sin(3fortran)', &
'']

shortname="sin"
call process()


case('181','sinh')

textblock=[character(len=256) :: &
'', &
'sinh(3fortran)                                                  sinh(3fortran)', &
'', &
'NAME', &
'  SINH(3) - [MATHEMATICS:TRIGONOMETRIC] Hyperbolic sine function', &
'', &
'SYNOPSIS', &
'  result = sinh(x)', &
'', &
'           elemental TYPE(kind=KIND) function sinh(x)', &
'', &
'            TYPE(kind=KIND) :: x', &
'', &
'CHARACTERISTICS', &
'  o  TYPE may be real or complex', &
'', &
'  o  KIND may be any kind supported by the associated type.', &
'', &
'  o  The returned value will be of the same type and kind as the argument.', &
'', &
'DESCRIPTION', &
'  SINH(3) computes the hyperbolic sine of X.', &
'', &
'  The hyperbolic sine of x is defined mathematically as:', &
'', &
'           sinh(x) = (exp(x) - exp(-x)) / 2.0', &
'', &
'  If X is of type complex its imaginary part is regarded as a value in', &
'  radians.', &
'', &
'OPTIONS', &
'  o  X : The type shall be real or complex.', &
'', &
'RESULT', &
'  The return value has same type and kind as X.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_sinh', &
'      use, intrinsic :: iso_fortran_env, only : &', &
'      & real_kinds, real32, real64, real128', &
'      implicit none', &
'      real(kind=real64) :: x = - 1.0_real64', &
'      real(kind=real64) :: nan, inf', &
'      character(len=20) :: line', &
'', &
'         print *, sinh(x)', &
'         print *, (exp(x)-exp(-x))/2.0', &
'', &
'         ! sinh(3) is elemental and can handle an array', &
'         print *, sinh([x,2.0*x,x/3.0])', &
'', &
'         ! a NaN input returns NaN', &
'         line=''NAN''', &
'         read(line,*) nan', &
'         print *, sinh(nan)', &
'', &
'         ! a Inf input returns Inf', &
'         line=''Infinity''', &
'         read(line,*) inf', &
'         print *, sinh(inf)', &
'', &
'         ! an overflow returns Inf', &
'         x=huge(0.0d0)', &
'         print *, sinh(x)', &
'', &
'      end program demo_sinh', &
'', &
'  Results:', &
'', &
'        -1.1752011936438014', &
'        -1.1752011936438014', &
'        -1.1752011936438014       -3.6268604078470190      -0.33954055725615012', &
'                             NaN', &
'                        Infinity', &
'                        Infinity', &
'', &
'STANDARD', &
'  Fortran 95 , for a complex argument Fortran 2008', &
'', &
'SEE ALSO', &
'  ASINH(3)', &
'', &
'RESOURCES', &
'  o  Wikipedia:hyperbolic functions', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022                 sinh(3fortran)', &
'']

shortname="sinh"
call process()


case('182','size')

textblock=[character(len=256) :: &
'', &
'size(3fortran)                                                  size(3fortran)', &
'', &
'NAME', &
'  SIZE(3) - [ARRAY:INQUIRY] Determine the size of an array', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                 size(3fortran)', &
'']

shortname="size"
call process()


case('183','spacing')

textblock=[character(len=256) :: &
'', &
'spacing(3fortran)                                            spacing(3fortran)', &
'', &
'NAME', &
'  SPACING(3) - [MODEL_COMPONENTS] Smallest distance between two numbers of a', &
'  given type', &
'', &
'SYNOPSIS', &
'  result = spacing(x)', &
'', &
'           elemental real(kind=KIND) function spacing(x)', &
'', &
'            real(kind=KIND), intent(in) :: x', &
'', &
'CHARACTERISTICS', &
'  The result is of the same type as the input argument X.', &
'', &
'DESCRIPTION', &
'  SPACING(3) determines the distance between the argument X and the nearest', &
'  adjacent number of the same type.', &
'', &
'OPTIONS', &
'  o  X : Shall be of type real.', &
'', &
'RESULT', &
'  The result is of the same type as the input argument X.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_spacing', &
'      implicit none', &
'      integer, parameter :: sgl = selected_real_kind(p=6, r=37)', &
'      integer, parameter :: dbl = selected_real_kind(p=13, r=200)', &
'', &
'         write(*,*) spacing(1.0_sgl)', &
'         write(*,*) nearest(1.0_sgl,+1.0),nearest(1.0_sgl,+1.0)-1.0', &
'', &
'         write(*,*) spacing(1.0_dbl)', &
'      end program demo_spacing', &
'', &
'  Results:', &
'', &
'  Typical values ...', &
'', &
'           1.1920929E-07', &
'            1.000000      1.1920929E-07', &
'           0.9999999     -5.9604645E-08', &
'           2.220446049250313E-016', &
'', &
'STANDARD', &
'  Fortran 95', &
'', &
'SEE ALSO', &
'  DIGITS(3), EPSILON(3), EXPONENT(3), FRACTION(3), HUGE(3), MAXEXPONENT(3),', &
'  MINEXPONENT(3), NEAREST(3), PRECISION(3), RADIX(3), RANGE(3), RRSPACING(3),', &
'  SCALE(3), SET_EXPONENT(3), TINY(3)', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022              spacing(3fortran)', &
'']

shortname="spacing"
call process()


case('184','spread')

textblock=[character(len=256) :: &
'', &
'spread(3fortran)                                              spread(3fortran)', &
'', &
'NAME', &
'  SPREAD(3) - [ARRAY:CONSTRUCTION] Add a dimension and replicate data', &
'', &
'SYNOPSIS', &
'                               October 09, 2022               spread(3fortran)', &
'']

shortname="spread"
call process()


case('185','sqrt')

textblock=[character(len=256) :: &
'', &
'sqrt(3fortran)                                                  sqrt(3fortran)', &
'', &
'NAME', &
'  SQRT(3) - [MATHEMATICS] Square-root function', &
'', &
'SYNOPSIS', &
'  result = sqrt(x)', &
'', &
'           elemental TYPE(kind=KIND) function sqrt(x)', &
'', &
'            TYPE(kind=KIND),intent(in) :: x', &
'', &
'CHARACTERISTICS', &
'  o  TYPE may be real or complex.', &
'', &
'  o  KIND may be any kind valid for the declared type.', &
'', &
'DESCRIPTION', &
'  SQRT(3) computes the principal square root of X.', &
'', &
'  In mathematics, a square root of a number X is a number Y such that Y*Y = X.', &
'', &
'  The number whose square root is being considered is known as the radicand.', &
'', &
'  Every nonnegative number x has two square roots of the same unique', &
'  magnitude, one positive and one negative. The nonnegative square root is', &
'  called the principal square root.', &
'', &
'  The principal square root of 9 is 3, for example, even though (-3)*(-3) is', &
'  also 9.', &
'', &
'  A real radicand must be positive.', &
'', &
'  Square roots of negative numbers are a special case of complex numbers,', &
'  where the components of the radicand need not be positive in order to have a', &
'  valid square root.', &
'', &
'OPTIONS', &
'  o  X : If X is real its value must be greater than or equal to zero.  The', &
'     type shall be real or complex.', &
'', &
'RESULT', &
'  The return value is of type real or complex. The kind type parameter is the', &
'  same as X.', &
'', &
'  A result of type complex is the principal value with the real part greater', &
'  than or equal to zero. When the real part of the result is zero, the', &
'  imaginary part has the same sign as the imaginary part of X.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_sqrt', &
'      use, intrinsic :: iso_fortran_env, only : real_kinds, &', &
'       & real32, real64, real128', &
'      implicit none', &
'      real(kind=real64) :: x, x2', &
'      complex :: z, z2', &
'', &
'        ! basics', &
'         x = 2.0_real64', &
'         ! complex', &
'         z = (1.0, 2.0)', &
'         write(*,*)''input values '',x,z', &
'', &
'         x2 = sqrt(x)', &
'         z2 = sqrt(z)', &
'         write(*,*)''output values '',x2,z2', &
'', &
'        ! elemental', &
'        write(*,*)''elemental'',sqrt([64.0,121.0,30.0])', &
'', &
'        ! alternatives', &
'         x2 = x**0.5', &
'         z2 = z**0.5', &
'         write(*,*)''alternatively'',x2,z2', &
'', &
'      end program demo_sqrt', &
'', &
'  Results:', &
'', &
'          input values    2.00000000000000      (1.000000,2.000000)', &
'          output values    1.41421356237310      (1.272020,0.7861513)', &
'          elemental   8.000000       11.00000       5.477226', &
'          alternatively   1.41421356237310      (1.272020,0.7861513)', &
'', &
'STANDARD', &
'  FORTRAN 77', &
'', &
'SEE ALSO', &
'  EXP(3), LOG(3), LOG10(3)', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022                 sqrt(3fortran)', &
'']

shortname="sqrt"
call process()


case('186','storage_size')

textblock=[character(len=256) :: &
'', &
'storage_size(3fortran)                                  storage_size(3fortran)', &
'', &
'NAME', &
'  STORAGE_SIZE(3) - [BIT:INQUIRY] Storage size in bits', &
'', &
'SYNOPSIS', &
'                               October 09, 2022         storage_size(3fortran)', &
'']

shortname="storage_size"
call process()


case('187','sum')

textblock=[character(len=256) :: &
'', &
'sum(3fortran)                                                    sum(3fortran)', &
'', &
'NAME', &
'  SUM(3) - [ARRAY:REDUCTION] Sum the elements of an array', &
'', &
'SYNOPSIS', &
'                               October 09, 2022                  sum(3fortran)', &
'']

shortname="sum"
call process()


case('188','system_clock')

textblock=[character(len=256) :: &
'', &
'system_clock(3fortran)                                  system_clock(3fortran)', &
'', &
'NAME', &
'  SYSTEM_CLOCK(3) - [SYSTEM:TIME] Return numeric data from a real-time clock.', &
'', &
'SYNOPSIS', &
'                               October 09, 2022         system_clock(3fortran)', &
'']

shortname="system_clock"
call process()


case('189','tan')

textblock=[character(len=256) :: &
'', &
'tan(3fortran)                                                    tan(3fortran)', &
'', &
'NAME', &
'  TAN(3) - [MATHEMATICS:TRIGONOMETRIC] Tangent function', &
'', &
'SYNOPSIS', &
'  result = tan(x)', &
'', &
'       elemental TYPE(kind=KIND) function tan(x)', &
'', &
'        TYPE(kind=KIND),intent(in) :: x', &
'', &
'CHARACTERISTICS', &
'  o  TYPE may be real or complex', &
'', &
'  o  KIND may be any kind supported by the associated type.', &
'', &
'  o  The returned value will be of the same type and kind as the argument X.', &
'', &
'DESCRIPTION', &
'  TAN(3) computes the tangent of X.', &
'', &
'OPTIONS', &
'  o  X : The angle in radians to compute the tangent of for real input.  If X', &
'     is of type complex, its real part is regarded as a value in radians.', &
'', &
'RESULT', &
'  The return value is the tangent of the value X.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_tan', &
'      use, intrinsic :: iso_fortran_env, only : real_kinds, &', &
'      & real32, real64, real128', &
'      implicit none', &
'      real(kind=real64) :: x = 0.165_real64', &
'           write(*,*)x, tan(x)', &
'      end program demo_tan', &
'', &
'  Results:', &
'', &
'           0.16500000000000001       0.16651386310913616', &
'', &
'STANDARD', &
'  FORTRAN 77 . For a complex argument, Fortran 2008 .', &
'', &
'SEE ALSO', &
'  ATAN(3), ATAN2(3), COS(3), SIN(3)', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022                  tan(3fortran)', &
'']

shortname="tan"
call process()


case('190','tanh')

textblock=[character(len=256) :: &
'', &
'tanh(3fortran)                                                  tanh(3fortran)', &
'', &
'NAME', &
'  TANH(3) - [MATHEMATICS:TRIGONOMETRIC] Hyperbolic tangent function', &
'', &
'SYNOPSIS', &
'  result = tanh(x)', &
'', &
'           elemental TYPE(kind=KIND) function tanh(x)', &
'', &
'            TYPE(kind=KIND),intent(in) :: x', &
'', &
'CHARACTERISTICS', &
'  o  X may be real or complex and any associated kind supported by the', &
'     processor.', &
'', &
'  o  The returned value will be of the same type and kind as the argument.', &
'', &
'DESCRIPTION', &
'  TANH(3) computes the hyperbolic tangent of X.', &
'', &
'OPTIONS', &
'  o  X : The value to compute the Hyperbolic tangent of.', &
'', &
'RESULT', &
'  Returns the hyperbolic tangent of X.', &
'', &
'  If X is complex, the imaginary part of the result is regarded as a radian', &
'  value.', &
'', &
'  If X is real, the return value lies in the range', &
'', &
'            -1 <= tanh(x) <= 1.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_tanh', &
'      use, intrinsic :: iso_fortran_env, only : &', &
'      & real_kinds, real32, real64, real128', &
'      implicit none', &
'      real(kind=real64) :: x = 2.1_real64', &
'         write(*,*)x, tanh(x)', &
'      end program demo_tanh', &
'', &
'  Results:', &
'', &
'            2.1000000000000001       0.97045193661345386', &
'', &
'STANDARD', &
'  FORTRAN 77 , for a complex argument Fortran 2008', &
'', &
'SEE ALSO', &
'  ATANH(3)', &
'', &
'RESOURCES', &
'  o  Wikipedia:hyperbolic functions', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022                 tanh(3fortran)', &
'']

shortname="tanh"
call process()


case('191','this_image')

textblock=[character(len=256) :: &
'', &
'this_image(3fortran)                                      this_image(3fortran)', &
'', &
'NAME', &
'  THIS_IMAGE(3) - [COLLECTIVE] Cosubscript index of this image', &
'', &
'SYNOPSIS', &
'  result = this_image()()', &
'', &
'  or', &
'', &
'       result = this_image(distance)', &
'', &
'  or', &
'', &
'        result = this_image(coarray, dim)', &
'', &
'         integer function this_image( distance ,coarray, dim )', &
'', &
'          type(TYPE(kind=**),optional :: coarray[*]', &
'          integer,intent(in),optional :: distance', &
'          integer,intent(in),optional :: dim', &
'', &
'CHARACTERISTICS', &
'  o  a kind designated as ** may be any supported kind value for the type', &
'', &
'  o  DISTANCE (not permitted together with COARRAY).', &
'', &
'  o  COARRAY can be of any type. If DIM is present it is required.', &
'', &
'  o  if DIM if present, coarray is required.', &
'', &
'DESCRIPTION', &
'  THIS_IMAGE(3) returns the cosubscript for this image.', &
'', &
'OPTIONS', &
'  o  DISTANCE : Nonnegative scalar integer (not permitted together with', &
'     COARRAY).', &
'', &
'  o  COARRAY : if DIM present, required).', &
'', &
'  o  DIM : If present, DIM shall be between one and the corank of COARRAY.', &
'', &
'RESULT', &
'  Default integer. If COARRAY is not present, it is scalar; if DISTANCE is not', &
'  present or has value 0, its value is the image index on the invoking image', &
'  for the current team, for values smaller or equal distance to the initial', &
'  team, it returns the image index on the ancestor team which has a distance', &
'  of DISTANCE from the invoking team. If DISTANCE is larger than the distance', &
'  to the initial team, the image index of the initial team is returned.', &
'  Otherwise when the COARRAY is present, if DIM is not present, a rank-1 array', &
'  with corank elements is returned, containing the cosubscripts for COARRAY', &
'  specifying the invoking image. If DIM is present, a scalar is returned, with', &
'  the value of the DIM element of THIS_IMAGE(COARRAY).', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_this_image', &
'      implicit none', &
'      integer :: value[*]', &
'      integer :: i', &
'         value = this_image()', &
'         sync all', &
'         if (this_image() == 1) then', &
'            do i = 1, num_images()', &
'               write(*,''(2(a,i0))'') ''value['', i, ''] is '', value[i]', &
'            end do', &
'         endif', &
'      end program demo_this_image', &
'', &
'  Results:', &
'', &
'         value[1] is 1', &
'', &
'STANDARD', &
'  Fortran 2008. With DISTANCE argument, TS 18508', &
'', &
'SEE ALSO', &
'  NUM_IMAGES(3), IMAGE_INDEX(3)', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022           this_image(3fortran)', &
'']

shortname="this_image"
call process()


case('192','tiny')

textblock=[character(len=256) :: &
'', &
'tiny(3fortran)                                                  tiny(3fortran)', &
'', &
'NAME', &
'  TINY(3) - [NUMERIC MODEL] Smallest positive number of a real kind', &
'', &
'SYNOPSIS', &
'  result = tiny(x)', &
'', &
'           real(kind=KIND) function tiny(x)', &
'', &
'            real(kind=KIND) :: x', &
'', &
'CHARACTERISTICS', &
'  where KIND may be any kind supported by type real', &
'', &
'DESCRIPTION', &
'  TINY(3) returns the smallest positive (non zero) number of the type and kind', &
'  of X.', &
'', &
'OPTIONS', &
'  o  X : Shall be of type real.', &
'', &
'RESULT', &
'  The smallest positive value for the real type of the specified kind.', &
'', &
'  The return value is of the same type and kind as X.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_tiny', &
'      implicit none', &
'         print *, ''default real is from'', tiny(0.0), ''to'',huge(0.0)', &
'         print *, ''doubleprecision is from '', tiny(0.0d0), ''to'',huge(0.0d0)', &
'      end program demo_tiny', &
'', &
'  Results:', &
'', &
'       default real is from 1.17549435E-38 to 3.40282347E+38', &
'       doubleprecision is from 2.2250738585072014E-308 to', &
'       1.7976931348623157E+308', &
'', &
'STANDARD', &
'  Fortran 95', &
'', &
'SEE ALSO', &
'  DIGITS(3), EPSILON(3), EXPONENT(3), FRACTION(3), HUGE(3), MAXEXPONENT(3),', &
'  MINEXPONENT(3), NEAREST(3), PRECISION(3), RADIX(3), RANGE(3), RRSPACING(3),', &
'  SCALE(3), SET_EXPONENT(3), SPACING(3)', &
'', &
'  fortran-lang intrinsic descriptions', &
'', &
'                               October 09, 2022                 tiny(3fortran)', &
'']

shortname="tiny"
call process()


case('193','trailz')

textblock=[character(len=256) :: &
'', &
'trailz(3fortran)                                              trailz(3fortran)', &
'', &
'NAME', &
'  TRAILZ(3) - [BIT:COUNT] Number of trailing zero bits of an integer', &
'', &
'SYNOPSIS', &
'  result = trailz(i)', &
'', &
'        elemental integer function trailz(i)', &
'', &
'         integer(kind=KIND),intent(in) :: i', &
'', &
'CHARACTERISTICS', &
'  o  I is an integer of any kind.', &
'', &
'  o  the result is an integer of default kind', &
'', &
'DESCRIPTION', &
'  TRAILZ(3) returns the number of trailing zero bits of an integer value.', &
'', &
'OPTIONS', &
'  o  I : the value to count trailing zero bits in', &
'', &
'RESULT', &
'  The number of trailing rightmost zero bits in an integer value after the', &
'  last non-zero bit.', &
'', &
'             >      right-most non-zero bit', &
'             >                 V', &
'             >  |0|0|0|1|1|1|0|1|0|0|0|0|0|0|', &
'             >  ^               |___________| trailing zero bits', &
'             >   bit_size(i)', &
'', &
'  If all the bits of I are zero, the result is the size of the input value in', &
'  bits, ie. BIT_SIZE(I).', &
'', &
'  The result may also be seen as the position of the rightmost 1 bit in I,', &
'  starting with the rightmost bit being zero and counting to the left.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_trailz', &
'', &
'      ! some common integer kinds', &
'      use, intrinsic :: iso_fortran_env, only : &', &
'       & integer_kinds, int8, int16, int32, int64', &
'', &
'      implicit none', &
'', &
'      ! a handy format', &
'      character(len=*),parameter :: &', &
'       & show = ''(1x,"value=",i4,", value(bits)=",b32.32,1x,", trailz=",i3)''', &
'', &
'      integer             :: i', &
'      integer(kind=int64) :: bigi', &
'        ! basics', &
'         write(*,*)''Note default integer is'',bit_size(0),''bits''', &
'         print  show,  -1, -1,  trailz(-1)', &
'         print  show,   0,  0,  trailz(0)', &
'         print  show,   1,  1,  trailz(1)', &
'         print  show,  96, 96,  trailz(96)', &
'        ! elemental', &
'         print *, ''elemental and any integer kind:''', &
'         bigi=2**5', &
'         write(*,*) trailz( [ bigi, bigi*256, bigi/2 ] )', &
'         write(*,''(1x,b64.64)'')[ bigi, bigi*256, bigi/2 ]', &
'', &
'      end program demo_trailz', &
'', &
'  Results:', &
'', &
'          Note default integer is          32 bits', &
'          value=  -1, value(bits)=11111111111111111111111111111111 , trailz=  0', &
'          value=   0, value(bits)=00000000000000000000000000000000 , trailz= 32', &
'          value=   1, value(bits)=00000000000000000000000000000001 , trailz=  0', &
'          value=  96, value(bits)=00000000000000000000000001100000 , trailz=  5', &
'          elemental and any integer kind:', &
'                    5          13           4', &
'          0000000000000000000000000000000000000000000000000000000000100000', &
'          0000000000000000000000000000000000000000000000000010000000000000', &
'          0000000000000000000000000000000000000000000000000000000000010000', &
'', &
'STANDARD', &
'  Fortran 2008', &
'', &
'SEE ALSO', &
'  BIT_SIZE(3), POPCNT(3), POPPAR(3), LEADZ(3)', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022               trailz(3fortran)', &
'']

shortname="trailz"
call process()


case('194','transfer')

textblock=[character(len=256) :: &
'', &
'transfer(3fortran)                                          transfer(3fortran)', &
'', &
'NAME', &
'  TRANSFER(3) - [TYPE:MOLD] Transfer bit patterns', &
'', &
'SYNOPSIS', &
'                               October 09, 2022             transfer(3fortran)', &
'']

shortname="transfer"
call process()


case('195','transpose')

textblock=[character(len=256) :: &
'', &
'transpose(3fortran)                                        transpose(3fortran)', &
'', &
'NAME', &
'  TRANSPOSE(3) - [ARRAY:MANIPULATION] Transpose an array of rank two', &
'', &
'SYNOPSIS', &
'  result = transpose(matrix)', &
'', &
'           type(TYPE(kind=KIND) transpose(matrix)', &
'', &
'            type(TYPE(kind=KIND),intent(in) :: matrix(:,:)', &
'', &
'CHARACTERISTICS', &
'  o  MATRIX can be of any type but must have a rank of two.', &
'', &
'  o  The result will be the same type and kind as MATRIX and the reversed', &
'     shape of the input array.', &
'', &
'DESCRIPTION', &
'  TRANSPOSE(3) transposes an array of rank two.', &
'', &
'  An array is transposed by interchanging the rows and columns of the given', &
'  matrix. That is, element (i,j) of the result has the value of element (j,i)', &
'  of the input for all (i,j).', &
'', &
'OPTIONS', &
'  o  MATRIX : The array to transpose', &
'', &
'RESULT', &
'  The transpose of the input array. The result has the same type as MATRIX,', &
'  and has shape [ m, n ] if MATRIX has shape [ n, m ].', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_transpose', &
'      implicit none', &
'      integer,save :: xx(3,5)= reshape([&', &
'          1,  2,  3,  4,  5,    &', &
'         10, 20, 30, 40, 50,    &', &
'         11, 22, 33, 44, -1055  &', &
'       ],shape(xx),order=[2,1])', &
'', &
'      call print_matrix_int(''xx array:'',xx)', &
'      call print_matrix_int(''xx array transposed:'',transpose(xx))', &
'', &
'      contains', &
'', &
'      subroutine print_matrix_int(title,arr)', &
'      ! print small 2d integer arrays in row-column format', &
'      implicit none', &
'      character(len=*),intent(in)  :: title', &
'      integer,intent(in)           :: arr(:,:)', &
'      integer                      :: i', &
'      character(len=:),allocatable :: biggest', &
'         write(*,*)trim(title)  ! print title', &
'         biggest=''           ''  ! make buffer to write integer into', &
'         ! find how many characters to use for integers', &
'         write(biggest,''(i0)'')ceiling(log10(real(maxval(abs(arr)))))+2', &
'         ! use this format to write a row', &
'         biggest=''(" > [",*(i''//trim(biggest)//'':,","))''', &
'         ! print one row of array at a time', &
'         do i=1,size(arr,dim=1)', &
'            write(*,fmt=biggest,advance=''no'')arr(i,:)', &
'            write(*,''(" ]")'')', &
'         enddo', &
'      end subroutine print_matrix_int', &
'', &
'      end program demo_transpose', &
'', &
'  Results:', &
'', &
'          xx array:', &
'          > [     1,     2,     3,     4,     5 ]', &
'          > [    10,    20,    30,    40,    50 ]', &
'          > [    11,    22,    33,    44, -1055 ]', &
'          xx array transposed:', &
'          > [     1,    10,    11 ]', &
'          > [     2,    20,    22 ]', &
'          > [     3,    30,    33 ]', &
'          > [     4,    40,    44 ]', &
'          > [     5,    50, -1055 ]', &
'', &
'STANDARD', &
'  Fortran 95', &
'', &
'SEE ALSO', &
'  o  MERGE(3) - Merge variables', &
'', &
'  o  PACK(3) - Pack an array into an array of rank one', &
'', &
'  o  SPREAD(3) - Add a dimension and replicate data', &
'', &
'  o  UNPACK(3) - Scatter the elements of a vector', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022            transpose(3fortran)', &
'']

shortname="transpose"
call process()


case('196','trim')

textblock=[character(len=256) :: &
'', &
'trim(3fortran)                                                  trim(3fortran)', &
'', &
'NAME', &
'  TRIM(3) - [CHARACTER:WHITESPACE] Remove trailing blank characters of a', &
'  string', &
'', &
'SYNOPSIS', &
'  result = trim(string)', &
'', &
'           character(len=:,kind=KIND) function trim(string)', &
'', &
'            character(len=*,kind=KIND),intent(in) :: string', &
'', &
'CHARACTERISTICS', &
'  KIND can be any kind supported for the character type. The result has the', &
'  same kind as the input argument STRING.', &
'', &
'DESCRIPTION', &
'  TRIM(3) removes trailing blank characters from a string.', &
'', &
'OPTIONS', &
'  o  STRING : A string to trim', &
'', &
'RESULT', &
'  The result is the same as STRING except trailing blanks are removed.', &
'', &
'  If STRING is composed entirely of blanks or has zero length, the result has', &
'  zero length.', &
'', &
'EXAMPLES', &
'  Sample program:', &
'', &
'      program demo_trim', &
'      implicit none', &
'      character(len=:), allocatable :: str, strs(:)', &
'      character(len=*),parameter :: brackets=''( *("[",a,"]":,1x) )''', &
'      integer :: i', &
'', &
'         str=''   trailing    ''', &
'         print brackets, str,trim(str) ! trims it', &
'', &
'         str=''   leading''', &
'         print brackets, str,trim(str) ! no effect', &
'', &
'         str=''            ''', &
'         print brackets, str,trim(str) ! becomes zero length', &
'         print *,  len(str), len(trim(''               ''))', &
'', &
'        ! array elements are all the same length, so you often', &
'        ! want to print them', &
'         strs=[character(len=10) :: "Z"," a b c","ABC",""]', &
'', &
'         write(*,*)''untrimmed:''', &
'         ! everything prints as ten characters; nice for neat columns', &
'         print brackets, (strs(i), i=1,size(strs))', &
'         print brackets, (strs(i), i=size(strs),1,-1)', &
'         write(*,*)''trimmed:''', &
'         ! everything prints trimmed', &
'         print brackets, (trim(strs(i)), i=1,size(strs))', &
'         print brackets, (trim(strs(i)), i=size(strs),1,-1)', &
'', &
'      end program demo_trim', &
'', &
'  Results:', &
'', &
'          > [   trailing    ] [   trailing]', &
'          > [   leading] [   leading]', &
'          > [            ] []', &
'          >           12           0', &
'          >  untrimmed:', &
'          > [Z         ] [ a b c    ] [ABC       ] [          ]', &
'          > [          ] [ABC       ] [ a b c    ] [Z         ]', &
'          >  trimmed:', &
'          > [Z] [ a b c] [ABC] []', &
'          > [] [ABC] [ a b c] [Z]', &
'', &
'STANDARD', &
'  Fortran 95', &
'', &
'SEE ALSO', &
'  Functions that perform operations on character strings, return lengths of', &
'  arguments, and search for certain arguments:', &
'', &
'  o  ELEMENTAL: ADJUSTL(3), ADJUSTR(3), INDEX(3), SCAN(3), VERIFY(3)', &
'', &
'  o  NONELEMENTAL: LEN_TRIM(3), LEN(3), REPEAT(3), TRIM(3)', &
'', &
'  fortran-lang intrinsic descriptions (license: MIT) @urbanjost', &
'', &
'                               October 09, 2022                 trim(3fortran)', &
'']

shortname="trim"
call process()


case('197','ubound')

textblock=[character(len=256) :: &
'', &
'ubound(3fortran)                                              ubound(3fortran)', &
'', &
'NAME', &
'  UBOUND(3) - [ARRAY:INQUIRY] Upper dimension bounds of an array', &
'', &
'SYNOPSIS', &
'                               October 09, 2022               ubound(3fortran)', &
'']

shortname="ubound"
call process()


case('198','unpack')

textblock=[character(len=256) :: &
'', &
'unpack(3fortran)                                              unpack(3fortran)', &
'', &
'NAME', &
'  UNPACK(3) - [ARRAY:CONSTRUCTION] Scatter the elements of a vector into an', &
'  array using a mask', &
'', &
'SYNOPSIS', &
'                               October 09, 2022               unpack(3fortran)', &
'']

shortname="unpack"
call process()


case('199','verify')

textblock=[character(len=256) :: &
'', &
'verify(3fortran)                                              verify(3fortran)', &
'', &
'NAME', &
'  VERIFY(3) - [CHARACTER:SEARCH] Position of a character in a string of', &
'  characters that does not appear in a given set of characters.', &
'', &
'SYNOPSIS', &
'                               October 09, 2022               verify(3fortran)', &
'']

shortname="verify"
call process()

case default
   allocate (character(len=256) :: textblock(0))
end select
contains
subroutine process()
if(present(topic))then
   if(topic)then
      textblock=[character(len=len(shortname)) :: shortname]
   endif
endif

if(present(prefix))then
   if(prefix)then
      do i=1,size(textblock)
         textblock(i)= shortname//':'//trim(textblock(i))
      enddo
   endif
endif

if(present(m_help))then
   if(m_help)then
      textblock=[character(len=len(textblock)+1) :: ' ',textblock] ! add blank line to put shortname into
      textblock=' '//textblock                                     ! shift to right by one character
      textblock(1)=shortname
   endif
endif
end subroutine process
end function help_intrinsics_one
!===================================================================================================================================
!()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()=
!===================================================================================================================================
subroutine sort_name(lines)
!@(#) sort_name(3fp):sort strings(a-z) over specified field using shell sort starting with [ character
character(len = *)                :: lines(:)
   character(len = :),allocatable :: ihold
   integer                        :: n, igap, i, j, k, jg
   n = size(lines)
   if(n.gt.0)then
      allocate(character(len = len(lines(1))) :: ihold)
   else
      ihold = ''
   endif
   igap = n
   INFINITE: do
      igap = igap/2
      if(igap.eq.0) exit INFINITE
      k = n-igap
      i = 1
      INNER: do
         j = i
         INSIDE: do
            jg = j+igap
            if( lle( lower(lines(j)), lower(lines(jg)) ) )exit INSIDE
            ihold = lines(j)
            lines(j) = lines(jg)
            lines(jg) = ihold
            j = j-igap
            if(j.lt.1) exit INSIDE
         enddo INSIDE
         i = i+1
         if(i.gt.k) exit INNER
      enddo INNER
   enddo INFINITE
end subroutine sort_name
!===================================================================================================================================
!()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()=
!===================================================================================================================================
elemental pure function lower(str) result (string)
!@(#) M_strings::lower(3f): Changes a string to lowercase over specified range
character(*), intent(In)     :: str
character(len(str))          :: string
integer                      :: i
   string = str
   do i = 1, len_trim(str)     ! step thru each letter in the string
      select case (str(i:i))
      case ('A':'Z')
         string(i:i) = char(iachar(str(i:i))+32) ! change letter to miniscule
      case default
      end select
   end do
end function lower
!===================================================================================================================================
!()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()=
!===================================================================================================================================
end module M_intrinsics
!===================================================================================================================================
!()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()=
!===================================================================================================================================
