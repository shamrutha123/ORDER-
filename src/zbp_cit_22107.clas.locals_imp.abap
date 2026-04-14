CLASS lhc_SalesOrderHdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR SalesOrderHdr RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR SalesOrderHdr RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE SalesOrderHdr.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE SalesOrderHdr.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE SalesOrderHdr.

    METHODS read FOR READ
      IMPORTING keys FOR READ SalesOrderHdr RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK SalesOrderHdr.

    METHODS rba_Salesitem FOR READ
      IMPORTING keys_rba FOR READ SalesOrderHdr\_Salesitem FULL result_requested RESULT result LINK association_links.

    METHODS cba_Salesitem FOR MODIFY
      IMPORTING entities_cba FOR CREATE SalesOrderHdr\_Salesitem.

ENDCLASS.

CLASS lhc_SalesOrderHdr IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
    IF requested_authorizations-%create EQ if_abap_behv=>auth-allowed.
      result-%create = if_abap_behv=>auth-allowed.
    ENDIF.
  ENDMETHOD.

  METHOD create.
    DATA: ls_sales_hdr TYPE zci_dh_107.
    DATA(lo_util) = zci_uu_107=>get_instance(  ).

    LOOP AT entities INTO DATA(ls_entities).
      " Explicitly typed CORRESPONDING to resolve context derivation error
      ls_sales_hdr = CORRESPONDING zci_dh_107( ls_entities MAPPING FROM ENTITY ).

      IF ls_sales_hdr-sales_order IS NOT INITIAL.
        SELECT SINGLE FROM zci_dh_107 FIELDS sales_order
          WHERE sales_order = @ls_sales_hdr-sales_order
          INTO @DATA(ls_db_check).

        IF sy-subrc NE 0.
          lo_util->set_hdr_value(
            EXPORTING im_sales_hdr = ls_sales_hdr
            IMPORTING ex_created   = DATA(lv_created) ).

          IF lv_created EQ abap_true.
            APPEND VALUE #( %cid = ls_entities-%cid
                            SalesDocument = ls_sales_hdr-sales_order ) TO mapped-salesorderhdr.
          ENDIF.
        ELSE.
          APPEND VALUE #( %cid = ls_entities-%cid
                          SalesDocument = ls_sales_hdr-sales_order ) TO failed-salesorderhdr.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD update.
    DATA(lo_util) = zci_uu_107=>get_instance(  ).
    LOOP AT entities INTO DATA(ls_entities).
      " Explicitly typed CORRESPONDING
      DATA(ls_sales_hdr) = CORRESPONDING zci_dh_107( ls_entities MAPPING FROM ENTITY ).
      IF ls_sales_hdr-sales_order IS NOT INITIAL.
        lo_util->set_hdr_value( EXPORTING im_sales_hdr = ls_sales_hdr ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    DATA: ls_hdr_key TYPE zci_uu_107=>ty_sales_hdr.
    DATA(lo_util) = zci_uu_107=>get_instance(  ).

    LOOP AT keys INTO DATA(ls_key).
      ls_hdr_key-salesdocument = ls_key-SalesDocument.
      lo_util->set_hdr_deletion_flag( im_so_delete = abap_true ).
      lo_util->set_hdr_t_deletion( im_sales_doc = ls_hdr_key ).

      APPEND VALUE #( SalesDocument = ls_key-SalesDocument ) TO mapped-salesorderhdr.
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    LOOP AT keys INTO DATA(ls_key).
      SELECT SINGLE FROM zci_dh_107 FIELDS * WHERE sales_order = @ls_key-SalesDocument
        INTO @DATA(ls_hdr).
      IF sy-subrc = 0.
        APPEND CORRESPONDING #( ls_hdr ) TO result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_Salesitem.
  ENDMETHOD.

  METHOD cba_Salesitem.
    DATA: ls_sales_itm TYPE zci_dii_107.
    DATA(lo_util) = zci_uu_107=>get_instance(  ).

    LOOP AT entities_cba INTO DATA(ls_entities_cba).
      LOOP AT ls_entities_cba-%target INTO DATA(ls_item_create).
        " Explicitly typed CORRESPONDING for child entity
        ls_sales_itm = CORRESPONDING zci_dii_107( ls_item_create MAPPING FROM ENTITY ).
        ls_sales_itm-sales_order = ls_entities_cba-SalesDocument.

        IF ls_sales_itm-sales_order IS NOT INITIAL AND ls_sales_itm-sales_order_item IS NOT INITIAL.
          lo_util->set_itm_value(
            EXPORTING im_sales_itm = ls_sales_itm
            IMPORTING ex_created   = DATA(lv_created) ).

          IF lv_created = abap_true.
            APPEND VALUE #( %cid = ls_item_create-%cid
                            SalesDocument = ls_sales_itm-sales_order
                            SalesItemnumber = ls_sales_itm-sales_order_item ) TO mapped-salesorderitm.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
