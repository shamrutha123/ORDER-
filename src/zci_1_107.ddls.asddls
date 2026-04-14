@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Item Consumption View'
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

define view entity ZCI_1_107
  as projection on ZCI_DII107
{
    @Search.defaultSearchElement: true
    key SalesDocument,      // Field from interface view [cite: 261]
    key SalesItemnumber,    // Field from interface view [cite: 262]
    
    @Search.defaultSearchElement: true
    Material,               // [cite: 263, 264]
    Plant,                  // [cite: 265]
    
    @Semantics.quantity.unitOfMeasure: 'Quantityunits'
    Quantity,               // [cite: 266, 267]
    Quantityunits,          // [cite: 268]
    
    /* Administrative Fields */
    LocalCreatedBy,         // [cite: 269]
    LocalCreatedAt,         // [cite: 270]
    LocalLastChangedBy,     // [cite: 271]
    LocalLastChangedAt,     // [cite: 272]
    
    /* Associations */
    // Redirects back to the Header Consumption View 
    _salesHeader : redirected to parent ZC1_107
}
