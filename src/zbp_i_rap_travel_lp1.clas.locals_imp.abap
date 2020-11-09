CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
  CONSTANTS:
      BEGIN OF travel_status,
        open     TYPE c LENGTH 1  VALUE 'O', " Open
        accepted TYPE c LENGTH 1  VALUE 'A', " Accepted
        canceled TYPE c LENGTH 1  VALUE 'X', " Cancelled
      END OF travel_status.

    METHODS calculateTotalPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Travel~calculateTotalPrice.

    METHODS calculateTravelID FOR DETERMINE ON SAVE
      IMPORTING keys FOR Travel~calculateTravelID.

    METHODS setInitialStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Travel~setInitialStatus.

    METHODS valAgency FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~valAgency.

    METHODS valCustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~valCustomer.

    METHODS valDates FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~valDates.

    METHODS acceptTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~acceptTravel RESULT result.

    METHODS rejectTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~rejectTravel RESULT result.

    METHODS recalcTotalPrice FOR MODIFY
      IMPORTING keys FOR ACTION Travel~recalcTotalPrice.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR Travel RESULT result.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD calculateTotalPrice.
  ENDMETHOD.

  METHOD calculateTravelID.
  ENDMETHOD.

  METHOD setInitialStatus.
  ENDMETHOD.

  METHOD valAgency.
  ENDMETHOD.

  METHOD valCustomer.
  ENDMETHOD.

  METHOD valDates.
  ENDMETHOD.

  METHOD acceptTravel.

  ENDMETHOD.

  METHOD rejectTravel.
  ENDMETHOD.

  METHOD recalcTotalPrice.
  ENDMETHOD.

  METHOD get_features.
  ENDMETHOD.

ENDCLASS.
