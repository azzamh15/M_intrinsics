          program demo_besj0
          use, intrinsic :: iso_fortran_env, only : real_kinds, &
          & real32, real64, real128
            implicit none
            real(kind=real64) :: x = 0.0_real64
            x = bessel_j0(x)
          end program demo_besj0
