@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Interface View for the Header'
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZCI_DH107 
  as select from zci_dh_107 as salesHeader
  
  
  composition [0..*] of ZCI_DII107 as _salesitem 
{
    key sales_order           as SalesDocument, // Alias used in projection
    order_type                as SalesDocumentType,
    sales_org                 as SalesOrganization,
    dist_channel              as DistributionChannel,
    division                  as Division,
    customer                  as Customer,
    overall_status            as OverallStatus,
    
    /* Administrative fields with required RAP semantics */
    @Semantics.user.createdBy: true
    created_by                as LocalCreatedBy,
    @Semantics.systemDateTime.createdAt: true
    created_at                as LocalCreatedAt,
    @Semantics.user.lastChangedBy: true
    last_changed_by           as LocalLastChangedBy,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    local_last_changed_at     as LocalLastChangedAt,
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed_at           as LastChangedAt,
    
    /* Exposing association to child */
    _salesitem 
}
