      program demo_atomic_or
      use iso_fortran_env
      implicit none
      integer(atomic_int_kind) :: atom[*]
         call atomic_or(atom[1], int(b'10100011101'))
      end program demo_atomic_or
