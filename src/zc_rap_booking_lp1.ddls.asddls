@EndUserText.label: 'Booking BO projection view'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity zc_rap_booking_lp1 as projection on ZI_RAP_BOOKING_LP1 as Booking {
    key BookingUuid,
    TravelUuid,
    @Search.defaultSearchElement: true
    BookingId,
    BookingDate,
    @Search.defaultSearchElement: true
    @ObjectModel.text.element: ['CustomerName']
    @Consumption.valueHelpDefinition: [{ entity.name: '/DMO/I_Customer',
                                         entity.element: 'CustomerID' }]
    CustomerId,
    _Customer.LastName as CustomerName,
    @ObjectModel.text.element: ['CarrierName']
    @Consumption.valueHelpDefinition: [{ entity.name: '/DMO/I_Carrier',
                                         entity.element: 'AirlineID' }]
    CarrierId,
    _Carrier.Name as CarrierName,
    @Consumption.valueHelpDefinition: [{ entity.name: '/DMO/I_Flight',
                                         entity.element: 'ConnectionID'},
                                        { additionalBinding: [
                                            { localElement: 'CarrierId', element: 'AirlineID' }, 
                                            { localElement: 'FlightDate', element: 'FlightDate', usage: #RESULT },
                                            { localElement: 'FlightPrice', element: 'Price', usage: #RESULT },
                                            { localElement: 'CurrencyCode', element: 'CurrencyCode', usage: #RESULT }]
                                             }]
    ConnectionId,
    FlightDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    FlightPrice,
    @Consumption.valueHelpDefinition: [{ entity.name: 'I_Currency',
                                         entity.element: 'Currency' }]
    CurrencyCode,
    CreatedBy,
    LastChangedBy,
    LocalLastChangedAt,
    /* Associations */
    _Carrier,
    _Connection,
    _Currency,
    _Customer,
    _Flight,
    _Travel: redirected to parent zc_rap_travel_lp1
}
