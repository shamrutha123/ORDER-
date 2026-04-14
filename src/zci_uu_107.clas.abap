CLASS zci_uu_107 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    " Types for Header and Item keys based on your database tables
    TYPES: BEGIN OF ty_sales_hdr,
             salesdocument TYPE vbeln,
           END OF ty_sales_hdr.

    TYPES: BEGIN OF ty_sales_item,
             salesdocument    TYPE vbeln,
             salesitemnumber  TYPE posnr,
           END OF ty_sales_item.

    " Table Types for buffering multiple entries
    TYPES: tt_sales_header TYPE STANDARD TABLE OF ty_sales_hdr WITH DEFAULT KEY.
    TYPES: tt_sales_items  TYPE STANDARD TABLE OF ty_sales_item WITH DEFAULT KEY.

    " Singleton Instance Access
    CLASS-METHODS get_instance
      RETURNING VALUE(ro_instance) TYPE REF TO zci_uu_107.

    " Buffer Methods for Header
    METHODS set_hdr_value
      IMPORTING im_sales_hdr TYPE zci_dh_107
      EXPORTING ex_created   TYPE abap_boolean.

    METHODS get_hdr_value
      EXPORTING ex_sales_hdr TYPE zci_dh_107.

    " Buffer Methods for Item
    METHODS set_itm_value
      IMPORTING im_sales_itm TYPE zci_dii_107
      EXPORTING ex_created   TYPE abap_boolean.

    METHODS get_itm_value
      EXPORTING ex_sales_itm TYPE zci_dii_107.

    " Buffer Methods for Deletion
    METHODS set_hdr_deletion_flag
      IMPORTING im_so_delete TYPE abap_boolean.

    METHODS get_deletion_flags
      EXPORTING ex_so_hdr_del TYPE abap_boolean.

    METHODS set_hdr_t_deletion
      IMPORTING im_sales_doc TYPE ty_sales_hdr.

    METHODS get_hdr_t_deletion
      EXPORTING ex_sales_docs TYPE tt_sales_header.

    METHODS set_itm_t_deletion
      IMPORTING im_sales_itm_info TYPE ty_sales_item.

    METHODS get_itm_t_deletion
      EXPORTING ex_sales_info TYPE tt_sales_items.

    METHODS cleanup_buffer.

  PRIVATE SECTION.
    CLASS-DATA: go_instance TYPE REF TO zci_uu_107.

    " Buffer Variables to hold data during the transaction
    DATA: ms_sales_hdr    TYPE zci_dh_107,
          ms_sales_itm    TYPE zci_dii_107,
          mv_so_hdr_del   TYPE abap_boolean,
          mt_sales_header TYPE tt_sales_header,
          mt_sales_items  TYPE tt_sales_items.
ENDCLASS.

CLASS zci_uu_107 IMPLEMENTATION.

  METHOD get_instance.
    IF go_instance IS NOT BOUND.
      " Fixed spacing for RAP environment
      go_instance = NEW #(  ).
    ENDIF.
    ro_instance = go_instance.
  ENDMETHOD.

  METHOD set_hdr_value.
    IF ms_sales_hdr-sales_order IS INITIAL.
      ms_sales_hdr = im_sales_hdr.
      ex_created = abap_true.
    ELSE.
      ex_created = abap_false.
    ENDIF.
  ENDMETHOD.

  METHOD get_hdr_value.
    ex_sales_hdr = ms_sales_hdr.
  ENDMETHOD.

  METHOD set_itm_value.
    ms_sales_itm = im_sales_itm.
    ex_created = abap_true.
  ENDMETHOD.

  METHOD get_itm_value.
    ex_sales_itm = ms_sales_itm.
  ENDMETHOD.

  METHOD set_hdr_deletion_flag.
    mv_so_hdr_del = im_so_delete.
  ENDMETHOD.

  METHOD get_deletion_flags.
    ex_so_hdr_del = mv_so_hdr_del.
  ENDMETHOD.

  METHOD set_hdr_t_deletion.
    APPEND im_sales_doc TO mt_sales_header.
  ENDMETHOD.

  METHOD get_hdr_t_deletion.
    ex_sales_docs = mt_sales_header.
  ENDMETHOD.

  METHOD set_itm_t_deletion.
    APPEND im_sales_itm_info TO mt_sales_items.
  ENDMETHOD.

  METHOD get_itm_t_deletion.
    ex_sales_info = mt_sales_items.
  ENDMETHOD.

  METHOD cleanup_buffer.
    CLEAR: ms_sales_hdr, ms_sales_itm, mv_so_hdr_del, mt_sales_header, mt_sales_items.
  ENDMETHOD.

ENDCLASS.
