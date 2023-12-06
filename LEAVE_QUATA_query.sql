

====================================================================LEAVE_QUATA===============================================================


DECLARE
    SickLeaveCount INT;
    PaidLeaveCount INT;
    
BEGIN

IF (:ATTENDANCE= 'Sick Leave') THEN
        -- Calculate the count of "Sick leave" attendance for the specified employee
        SELECT COUNT(*)
        INTO SickLeaveCount
        FROM ATTENDANCE
        WHERE EMP_NO = :EMPLOYEE_NO
        AND ATTENDANCE = 'SL' 
        AND (
            (TO_CHAR(A_DATE, 'MM/DD') BETWEEN '04/01' AND '12/31' AND TO_CHAR(A_DATE, 'YYYY') = TO_CHAR(SYSDATE, 'YYYY'))
            OR
            (TO_CHAR(A_DATE, 'MM/DD') BETWEEN '01/01' AND '03/31' AND TO_CHAR(A_DATE, 'YYYY') = TO_CHAR(SYSDATE, 'YYYY') + 1)
        );

        IF SickLeaveCount < 4 THEN
            -- Execute the INSERT statement
            INSERT INTO ATTENDANCE (EMP_NO, EMP_NAME, A_DATE, ATTENDANCE)
            VALUES (:EMPLOYEE_NO, :EMPLOYEE_NAME, :A_DATE, :ATTENDANCE);
        ELSE
            -- Raise a custom error using APEX_ERROR package
            APEX_ERROR.ADD_ERROR (
                p_message => 'Employee has already taken 4 or more Sick leaves. Cannot insert additional Sick leave.',
                p_display_location => APEX_ERROR.C_INLINE_IN_NOTIFICATION
            );
        END IF;

    ELSIF (:ATTENDANCE= 'Paid Leave') THEN
        -- Calculate the count of "Paid leave" attendance for the specified employee
        SELECT COUNT(*)
        INTO PaidLeaveCount
        FROM ATTENDANCE
        WHERE EMP_NO = :EMPLOYEE_NO
        AND ATTENDANCE = 'PL' 
        AND (
            (TO_CHAR(A_DATE, 'MM/DD') BETWEEN '04/01' AND '12/31' AND TO_CHAR(A_DATE, 'YYYY') = TO_CHAR(SYSDATE, 'YYYY'))
            OR
            (TO_CHAR(A_DATE, 'MM/DD') BETWEEN '01/01' AND '03/31' AND TO_CHAR(A_DATE, 'YYYY') = TO_CHAR(SYSDATE, 'YYYY') + 1)
        );

        IF (PaidLeaveCount < 18) THEN
            -- Execute the INSERT statement
            INSERT INTO ATTENDANCE (EMP_NO, EMP_NAME, A_DATE, ATTENDANCE)
            VALUES (:EMPLOYEE_NO, :EMPLOYEE_NAME, :A_DATE, :ATTENDANCE);
        ELSE
            -- Raise a custom error using APEX_ERROR package
            APEX_ERROR.ADD_ERROR (
                p_message => 'Employee has already taken 18 Paid leaves. Cannot insert additional Paid leave.',
                p_display_location => APEX_ERROR.C_INLINE_IN_NOTIFICATION
            );
        END IF;
    ELSE
        -- Execute the INSERT statement
        INSERT INTO ATTENDANCE (EMP_NO, EMP_NAME, A_DATE, ATTENDANCE)
        VALUES (:EMPLOYEE_NO, :EMPLOYEE_NAME, :A_DATE, :ATTENDANCE);
    END IF;
END;
