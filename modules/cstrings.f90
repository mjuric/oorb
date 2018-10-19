! ---------------------------------------------------
! Functions to convert between C and FORTRAN strings
!
MODULE CSTRINGS
IMPLICIT NONE

CONTAINS

! ------------------------
PURE INTEGER FUNCTION CSTR_LEN(s)  ! Returns the length of a C
CHARACTER(*), INTENT(IN) :: s      ! string (that can have any number of
INTEGER :: i                       ! NULL characters at the end)

CSTR_LEN = LEN_TRIM(s)
DO i = 1, LEN_TRIM(s)
   IF (s(i:i) == CHAR(0)) THEN
      CSTR_LEN = i - 1
      EXIT
   END IF
END DO

END FUNCTION CSTR_LEN


! ------------------------
FUNCTION FROM_CSTR(s) RESULT(s2)   ! Returns a FORTRAN string from a C
CHARACTER(*),INTENT(IN) :: s       ! string (that can have any number of
CHARACTER(CSTR_LEN(s)) :: s2       ! NULL characters at the end)
s2 = s
END FUNCTION FROM_CSTR


END MODULE CSTRINGS
