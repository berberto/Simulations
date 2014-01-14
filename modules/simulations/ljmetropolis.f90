

module ljmetr

    use kinds,      only: dp
    use ljmod
    use jackknife,  only: JK, JK_cluster, JK_init !, JK_function
    implicit none

    public
    
    integer :: nth      ! thermalization sweeps
    integer :: nsw      ! effective sweeps
    integer :: skip     ! skipped sweeps (for uncorrelated data)
    integer :: ndat     ! effective size of the final sample
    
    ! interface for the autocorrelation function
    interface
        function ac (x,t)
            use kinds, only: dp
            real(dp) :: ac
            integer :: i, D, t
            real(dp), dimension(:), allocatable :: x
        end function ac
    end interface

contains

    function autocorrelation (x, t)
        real(dp) :: autocorrelation
        integer :: t
        real(dp), dimension(:), pointer :: x

        integer :: i
        real(dp), dimension(3) :: temp = (/ 0, 0, 0 /)
        
        do i=0, ndat-t, 1
            temp(3) = temp(3) + x(i)*x(i+t)/(ndat - t)
            temp(1) = temp(1) + x(i)/(ndat - t)
            temp(2) = temp(2) + x(i)*x(i)/(ndat - t)
        end do
    end function autocorrelation
    

!
!   Routine implementing the Metropolis algorithm for a thermal distribution.
!
    subroutine thmetropolis (ptcls, k)
        !use kinds, only: dp
        !use ljmod, only: particle, delta, pstn_new, poten, side
        !implicit none
    
        type(particle), dimension(:) :: ptcls
        integer :: i,k
        real(dp), dimension(:), allocatable :: u
        real(dp) :: t1, t2
        real(dp), external :: delta_interaction
    
        allocate(u(4))
        call ranlxdf(u,4)
    
        do i=1, 3, 1
            pstn_new(i) = ptcls(k)%pstn(i) + delta*(2*u(i)-1)
            t1 = pstn_new(i)/side
            call rintf(pstn_new(i), t2)
            pstn_new(i) = pstn_new(i) - side*t2
        end do
    
        t1 = delta_interaction(ptcls,k)
        t2 = exp(-t1)
            
        if(t2 >= u(4)) then
            ptcls(k)%pstn = pstn_new
            poten = poten + t1
        end if
    
        deallocate(u)

    end subroutine thmetropolis

end module ljmetr
