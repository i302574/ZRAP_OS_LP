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
      " Please note that this is just an example for calculating a field during _onSave_.
    " This approach does NOT ensure for gap free or unique travel IDs! It just helps to provide a readable ID.
    " The key of this business object is a UUID, calculated by the framework.

    " check if TravelID is already filled
    READ ENTITIES OF zi_rap_travel_lp1 IN LOCAL MODE
      ENTITY Travel
        FIELDS ( TravelID ) WITH CORRESPONDING #( keys )
      RESULT DATA(travels).

    " remove lines where TravelID is already filled.
    DELETE travels WHERE TravelID IS NOT INITIAL.

    " anything left ?
    CHECK travels IS NOT INITIAL.

    " Select max travel ID
    SELECT SINGLE
        FROM  zrap_atrav_lp1
        FIELDS MAX( travel_id ) AS travelID
        INTO @DATA(max_travelid).

    " Set the travel ID
    MODIFY ENTITIES OF zi_rap_travel_lp1 IN LOCAL MODE
    ENTITY Travel
      UPDATE
        FROM VALUE #( FOR travel IN travels INDEX INTO i (
          %tky              = travel-%tky
          TravelID          = max_travelid + i
          %control-TravelID = if_abap_behv=>mk-on ) )
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD setInitialStatus.
      " Read relevant travel instance data
    READ ENTITIES OF zi_rap_travel_lp1 IN LOCAL MODE
      ENTITY Travel
        FIELDS ( TravelStatus ) WITH CORRESPONDING #( keys )
      RESULT DATA(travels).

    " Remove all travel instance data with defined status
    DELETE travels WHERE TravelStatus IS NOT INITIAL.
    CHECK travels IS NOT INITIAL.

    " Set default travel status
    MODIFY ENTITIES OF zi_rap_travel_lp1 IN LOCAL MODE
    ENTITY Travel
      UPDATE
        FIELDS ( TravelStatus )
        WITH VALUE #( FOR travel IN travels
                      ( %tky         = travel-%tky
                        TravelStatus = travel_status-open ) )
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD valAgency.
    "read relevant travel instance data
    READ ENTITIES OF zi_rap_travel_lp1 IN LOCAL MODE
        ENTITY Travel
            FIELDS ( AgencyId ) WITH CORRESPONDING #(  keys )
        RESULT DATA(travels).

    DATA agencies TYPE SORTED TABLE OF /dmo/agency WITH UNIQUE KEY agency_id.

    "optimization for DB select: extract distinct non-initial agency IDs
    agencies = CORRESPONDING #( travels DISCARDING DUPLICATES
                                        MAPPING agency_id = AgencyId EXCEPT * ).
    DELETE agencies WHERE agency_id IS INITIAL.

    IF agencies is NOT INITIAL.
        "check if ID exists
      SELECT FROM /dmo/agency FIELDS agency_id
        FOR ALL ENTRIES IN @agencies
        WHERE agency_id = @agencies-agency_id
        INTO TABLE @data(agencies_db).
    ENDIF.

    LOOP at travels INTO DATA(travel).
    "clear state messages that might exist
        APPEND VALUE #( %tky = travel-%tky
                    %state_area = 'VALIDATE_AGENCY' )
           to reported-travel.
        if travel-AgencyId is initial or
           NOT line_exists( agencies_db[ agency_id = travel-AgencyId ] ).
           APPEND VALUE #( %tky = travel-%tky ) to failed-travel.
           APPEND VALUE #( %tky = travel-%tky
                           %state_area = 'VALIDATE_AGENCY'
                           %msg =  NEW zcm_rap_msg_lp1(
                                            severity = if_abap_behv_message=>severity-error
                                            textid = zcm_rap_msg_lp1=>agency_unknown
                                            agencyid = travel-AgencyId  )
                           %element-AgencyID = if_abap_behv=>mk-on )
                  to reported-travel.
        ENDIF.
     ENDLOOP.
  ENDMETHOD.

  METHOD valCustomer.
      "read relevant travel instance data
    READ ENTITIES OF zi_rap_travel_lp1 IN LOCAL MODE
        ENTITY Travel
            FIELDS ( CustomerId ) WITH CORRESPONDING #(  keys )
        RESULT DATA(travels).

    DATA customers  TYPE SORTED TABLE OF /dmo/customer WITH UNIQUE KEY customer_id.

    "optimization for DB select: extract distinct non-initial agency IDs
    customers = CORRESPONDING #( travels DISCARDING DUPLICATES
                                        MAPPING customer_id = CustomerId EXCEPT * ).
    DELETE customers WHERE customer_id IS INITIAL.

    IF customers is NOT INITIAL.
        "check if ID exists
      SELECT FROM /dmo/customer FIELDS customer_id
        FOR ALL ENTRIES IN @customers
        WHERE customer_id = @customers-customer_id
        INTO TABLE @data(customers_db).
    ENDIF.

    LOOP at travels INTO DATA(travel).
    "clear state messages that might exist
        APPEND VALUE #( %tky = travel-%tky
                    %state_area = 'VALIDATE_CUSTOMER' )
           to reported-travel.
        if travel-CustomerId is initial or
           NOT line_exists( customers_db[ customer_id = travel-CustomerId ] ).
           APPEND VALUE #( %tky = travel-%tky ) to failed-travel.
           APPEND VALUE #( %tky = travel-%tky
                           %state_area = 'VALIDATE_CUSTOMER'
                           %msg =  NEW zcm_rap_msg_lp1(
                                            severity = if_abap_behv_message=>severity-error
                                            textid = zcm_rap_msg_lp1=>customer_unknown
                                            customerid = travel-CustomerId  )
                           %element-CustomerID = if_abap_behv=>mk-on )
                  to reported-travel.
        ENDIF.
     ENDLOOP.
  ENDMETHOD.

  METHOD valDates.
  " Read relevant travel instance data
    READ ENTITIES OF zi_rap_travel_lp1 IN LOCAL MODE
      ENTITY Travel
        FIELDS ( TravelID BeginDate EndDate ) WITH CORRESPONDING #( keys )
      RESULT DATA(travels).

    LOOP AT travels INTO DATA(travel).
      " Clear state messages that might exist
      APPEND VALUE #(  %tky        = travel-%tky
                       %state_area = 'VALIDATE_DATES' )
        TO reported-travel.

      IF travel-EndDate < travel-BeginDate.
        APPEND VALUE #( %tky = travel-%tky ) TO failed-travel.
        APPEND VALUE #( %tky               = travel-%tky
                        %state_area        = 'VALIDATE_DATES'
                        %msg               = NEW zcm_rap_msg_lp1(
                                                 severity  = if_abap_behv_message=>severity-error
                                                 textid    = zcm_rap_msg_lp1=>date_interval
                                                 begindate = travel-BeginDate
                                                 enddate   = travel-EndDate
                                                 travelid  = travel-TravelID )
                        %element-BeginDate = if_abap_behv=>mk-on
                        %element-EndDate   = if_abap_behv=>mk-on ) TO reported-travel.

      ELSEIF travel-BeginDate < cl_abap_context_info=>get_system_date( ).
        APPEND VALUE #( %tky               = travel-%tky ) TO failed-travel.
        APPEND VALUE #( %tky               = travel-%tky
                        %state_area        = 'VALIDATE_DATES'
                        %msg               = NEW zcm_rap_msg_lp1(
                                                 severity  = if_abap_behv_message=>severity-error
                                                 textid    = zcm_rap_msg_lp1=>begdat_before_sysdat
                                                 begindate = travel-BeginDate )
                        %element-BeginDate = if_abap_behv=>mk-on ) TO reported-travel.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD acceptTravel.
    MODIFY ENTITIES OF zi_rap_travel_lp1 IN LOCAL MODE
         ENTITY Travel
             UPDATE
                 FIELDS ( TravelStatus )
                 WITH VALUE #( FOR key IN keys
                                 ( %tky = key-%tky
                                   TravelStatus = travel_status-accepted ) )
         FAILED failed
         REPORTED reported.

    "fill the response table
    READ ENTITIES OF zi_rap_travel_lp1 IN LOCAL MODE
     ENTITY Travel
         ALL FIELDS WITH CORRESPONDING #( keys )
     RESULT DATA(travels).

    result = VALUE #(  FOR travel IN travels
                        ( %tky = travel-%tky
                          %param = travel ) ).

  ENDMETHOD.

  METHOD rejectTravel.
    MODIFY ENTITIES OF zi_rap_travel_lp1 IN LOCAL MODE
       ENTITY Travel
           UPDATE
               FIELDS ( TravelStatus )
               WITH VALUE #( FOR key IN keys
                               ( %tky = key-%tky
                                 TravelStatus = travel_status-canceled ) )
       FAILED failed
       REPORTED reported.

    "fill the response table
    READ ENTITIES OF zi_rap_travel_lp1 IN LOCAL MODE
     ENTITY Travel
         ALL FIELDS WITH CORRESPONDING #( keys )
     RESULT DATA(travels).

    result = VALUE #(  FOR travel IN travels
                        ( %tky = travel-%tky
                          %param = travel ) ).
  ENDMETHOD.

  METHOD recalcTotalPrice.
  ENDMETHOD.

  METHOD get_features.
  ENDMETHOD.

ENDCLASS.
