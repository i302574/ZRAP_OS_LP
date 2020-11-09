CLASS zrap_eml_test_lp1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zrap_eml_test_lp1 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

*       " step 1 - READ
*    READ ENTITIES OF ZI_RAP_Travel_lp1
*      ENTITY travel
*        FROM VALUE #( ( TravelUUID = 'E53F12D08BB6924D170009027659A94B'
*                                       ) )
*      RESULT DATA(travels).
*
*    out->write( travels ).

*" step 2 - READ with Fields
*    READ ENTITIES OF ZI_RAP_Travel_LP1
*      ENTITY travel
*        FIELDS ( AgencyID CustomerID )
*      WITH VALUE #( ( TravelUUID = 'E53F12D08BB6924D170009027659A94B' ) )
*      RESULT DATA(travels).
*    out->write( travels ).
*

*
*  " step 3 - READ with All Fields
*    READ ENTITIES OF ZI_RAP_Travel_LP1
*      ENTITY travel
*        ALL FIELDS
*      WITH VALUE #( ( TravelUUID = 'E53F12D08BB6924D170009027659A94B' ) )
*      RESULT DATA(travels).
*
*    out->write( travels ).

*     " step 4 - READ By Association
*    READ ENTITIES OF ZI_RAP_Travel_LP1
*      ENTITY travel BY \_Booking
*        ALL FIELDS WITH VALUE #( ( TravelUUID = 'E53F12D08BB6924D170009027659A94B' ) )
*      RESULT DATA(bookings).
*
*    out->write( bookings ).

*" step 5 - Unsuccessful READ
*     READ ENTITIES OF ZI_RAP_Travel_LP1
*       ENTITY travel
*         ALL FIELDS WITH VALUE #( ( TravelUUID = '11111111111111111111111111111111' ) )
*       RESULT DATA(travels)
*       FAILED DATA(failed)
*       REPORTED DATA(reported).
*
*     out->write( travels ).
*     out->write( failed ).    " complex structures not supported by the console output
*     out->write( reported ).  " complex structures not supported by the console output

* " step 6 - MODIFY Update
*     MODIFY ENTITIES OF ZI_RAP_Travel_LP1
*       ENTITY travel
*         UPDATE
*           SET FIELDS WITH VALUE
*             #( ( TravelUUID  = 'E53F12D08BB6924D170009027659A94B'
*                  Description = 'I like RAP@openSAP' ) )
*
*      FAILED DATA(failed)
*      REPORTED DATA(reported).
*
*     out->write( 'Update done' ).
*
*     " step 6b - Commit Entities
*     COMMIT ENTITIES
*       RESPONSE OF ZI_RAP_Travel_LP1
*       FAILED     DATA(failed_commit)
*       REPORTED   DATA(reported_commit).

*" step 7 - MODIFY Create
*    MODIFY ENTITIES OF ZI_RAP_Travel_lp1
*      ENTITY travel
*        CREATE
*          SET FIELDS WITH VALUE
*            #( ( %cid        = 'MyContentID_1'
*                 AgencyID    = '70012'
*                 CustomerID  = '14'
*                 BeginDate   = cl_abap_context_info=>get_system_date( )
*                 EndDate     = cl_abap_context_info=>get_system_date( ) + 10
*                 Description = 'I REALLY like RAP@openSAP' ) )
*
*     MAPPED DATA(mapped)
*     FAILED DATA(failed)
*     REPORTED DATA(reported).
*
*    out->write( mapped-travel ).
*
*    COMMIT ENTITIES
*      RESPONSE OF ZI_RAP_Travel_lp1
*      FAILED     DATA(failed_commit)
*      REPORTED   DATA(reported_commit).
*
*    out->write( 'Create done' ).
*
* " step 8 - MODIFY Delete
*    MODIFY ENTITIES OF ZI_RAP_Travel_LP1
*      ENTITY travel
*        DELETE FROM
*          VALUE
*            #( ( TravelUUID  = '026D2669A5C21EDB88CF662F8B025E95' ) )
*
*     FAILED DATA(failed)
*     REPORTED DATA(reported).
*
*    COMMIT ENTITIES
*      RESPONSE OF ZI_RAP_Travel_lp1
*      FAILED     DATA(failed_commit)
*      REPORTED   DATA(reported_commit).
*
*    out->write( 'Delete done' ).



  ENDMETHOD.
ENDCLASS.
