@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Child Interface View for the Items'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZCI_DII107 
  as select from zci_dii_107 as salesItem
  association to parent ZCI_DH107 as _salesHeader on $projection.SalesDocument = _salesHeader.salesdocument
{
    key sales_order           as SalesDocument,   // Must match Header Alias
    key sales_order_item      as SalesItemnumber,
    material                  as Material,
    plant                     as Plant,
    storage_location          as StorageLocation,
    
    @Semantics.quantity.unitOfMeasure: 'Quantityunits'
    requested_qty             as Quantity,
    requested_unit            as Quantityunits,
    
    /* RAP Administrative fields */
    @Semantics.user.createdBy: true
    local_created_by          as LocalCreatedBy,
    @Semantics.systemDateTime.createdAt: true
    local_created_at          as LocalCreatedAt,
    @Semantics.user.lastChangedBy: true
    local_last_changed_by     as LocalLastChangedBy,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    local_last_changed_at     as LocalLastChangedAt,
    last_changed_at           as LastChangedAt,

    /* Association back to Header */
    _salesHeader
}
