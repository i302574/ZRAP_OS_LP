@EndUserText.label: 'travel BO projection view'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity Zc_Rap_Travel_Lp1 as projection on zi_rap_travel_lp1 as Travel
{
    key TravelUuid,
    @Search.defaultSearchElement: true
    TravelId,
    @Search.defaultSearchElement: true
    @ObjectModel.text.element: ['AgencyName']
    @Consumption.valueHelpDefinition: [{ entity.name: '/DMO/I_Agency',
                                         entity.element: 'AgencyID' }]
    AgencyId,
    _Agency.Name as AgencyName,
    @Search.defaultSearchElement: true
    @ObjectModel.text.element: ['CustomerName']
    @Consumption.valueHelpDefinition: [{ entity.name: '/DMO/I_Customer',
                                         entity.element: 'CustomerID' }]
    CustomerId,
    _Customer.LastName as CustomerName,
    BeginDate,
    EndDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    BookingFee,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    TotalPrice,
    @Consumption.valueHelpDefinition: [{ entity.name: 'I_Currency',
                                         entity.element: 'Currency' }]
    CurrencyCode,
    Description,
    TravelStatus,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    LocalLastChangedAt,
    /* Associations */
    _Agency,
    _Booking : redirected to composition child zc_rap_booking_lp1,
    _Currency,
    _Customer    
}
