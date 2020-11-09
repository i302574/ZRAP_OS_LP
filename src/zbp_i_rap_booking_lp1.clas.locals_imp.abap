CLASS lhc_Booking DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS calcBookingID FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Booking~calcBookingID.

    METHODS calcTotalPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Booking~calcTotalPrice.

ENDCLASS.

CLASS lhc_Booking IMPLEMENTATION.

  METHOD calcBookingID.
  ENDMETHOD.

  METHOD calcTotalPrice.
  ENDMETHOD.

ENDCLASS.
