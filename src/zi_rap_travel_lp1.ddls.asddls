@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Travel view'
define root view entity zi_rap_travel_lp1
  as select from zrap_atrav_lp1 as Travel

  composition [0..*] of zi_rap_booking_lp1 as _Booking
  association [0..1] to /DMO/I_Agency      as _Agency   on $projection.AgencyId = _Agency.AgencyID
  association [0..1] to /DMO/I_Customer    as _Customer on $projection.CustomerId = _Customer.CustomerID
  association [0..1] to I_Currency         as _Currency on $projection.CurrencyCode = _Currency.Currency

{
  key travel_uuid           as TravelUuid,
      travel_id             as TravelId,
      agency_id             as AgencyId,
      customer_id           as CustomerId,
      begin_date            as BeginDate,
      end_date              as EndDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      booking_fee           as BookingFee,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      total_price           as TotalPrice,
      currency_code         as CurrencyCode,
      description           as Description,
      overal_status         as TravelStatus,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      local_last_changed_at as LocalLastChangedAt,

      //      "publish associations
      _Booking,
      _Agency,
      _Customer,
      _Currency
}
