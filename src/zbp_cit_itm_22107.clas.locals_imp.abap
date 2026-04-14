CLASS lhc_SalesOrderItm DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE SalesOrderItm.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE SalesOrderItm.

    METHODS read FOR READ
      IMPORTING keys FOR READ SalesOrderItm RESULT result.

    METHODS rba_Salesheader FOR READ
      IMPORTING keys_rba FOR READ SalesOrderItm\_Salesheader FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_SalesOrderItm IMPLEMENTATION.

  METHOD update.
    DATA: ls_sales_itm TYPE zci_dii_107.
    DATA(lo_util) = zci_uu_107=>get_instance(  ).

    LOOP AT entities INTO DATA(ls_entities).
      " Explicitly typed CORRESPONDING to map entity fields to database structure
      ls_sales_itm = CORRESPONDING zci_dii_107( ls_entities MAPPING FROM ENTITY ).

      IF ls_sales_itm-sales_order IS NOT INITIAL.
        lo_util->set_itm_value(
          EXPORTING im_sales_itm = ls_sales_itm
          IMPORTING ex_created   = DATA(lv_created) ).

        IF lv_created = abap_true.
          APPEND VALUE #( SalesDocument    = ls_sales_itm-sales_order
                          SalesItemnumber = ls_sales_itm-sales_order_item ) TO mapped-salesorderitm.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    DATA: ls_item_key TYPE zci_uu_107=>ty_sales_item.
    DATA(lo_util) = zci_uu_107=>get_instance(  ).

    LOOP AT keys INTO DATA(ls_key).
      ls_item_key-salesdocument   = ls_key-SalesDocument.
      ls_item_key-salesitemnumber = ls_key-SalesItemnumber.

      " Store item deletion details in the buffer
      lo_util->set_itm_t_deletion( im_sales_itm_info = ls_item_key ).

      APPEND VALUE #( SalesDocument    = ls_key-SalesDocument
                      SalesItemnumber = ls_key-SalesItemnumber ) TO mapped-salesorderitm.
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    LOOP AT keys INTO DATA(ls_key).
      SELECT SINGLE FROM zci_dii_107 FIELDS * WHERE sales_order      = @ls_key-SalesDocument
          AND sales_order_item = @ls_key-SalesItemnumber
        INTO @DATA(ls_itm).

      IF sy-subrc = 0.
        APPEND CORRESPONDING #( ls_itm ) TO result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD rba_Salesheader.
    " Typically empty in a manual unmanaged scenario
  ENDMETHOD.

ENDCLASS.
