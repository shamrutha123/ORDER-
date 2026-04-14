@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Header Consumption View'
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

define root view entity ZC1_107
  provider contract transactional_query
  as projection on ZCI_DH107
{
    @Search.defaultSearchElement: true
    key SalesDocument,
    
    SalesDocumentType,
    SalesOrganization,
    DistributionChannel,
    Division,
    Customer,
    OverallStatus,
    
    /* Administrative fields projected from Interface View */
    LocalCreatedBy,
    LocalCreatedAt,
    LocalLastChangedBy,
    LocalLastChangedAt,
    
  
    _salesitem : redirected to composition child ZCI_1_107
}
