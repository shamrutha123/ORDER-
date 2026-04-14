CLASS lsc_ZCI_DH107 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZCI_DH107 IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
    " 1. Retrieve the manual transaction data from the Buffer Utility
    DATA(lo_util) = zci_uu_107=>get_instance(  ).

    lo_util->get_hdr_value( IMPORTING ex_sales_hdr = DATA(ls_sales_hdr) ).
    lo_util->get_itm_value( IMPORTING ex_sales_itm = DATA(ls_sales_itm) ).
    lo_util->get_hdr_t_deletion( IMPORTING ex_sales_docs = DATA(lt_sales_hdr_del) ).
    lo_util->get_itm_t_deletion( IMPORTING ex_sales_info = DATA(lt_sales_itm_del) ).
    lo_util->get_deletion_flags( IMPORTING ex_so_hdr_del = DATA(lv_so_hdr_del) ).

    " 2. Save or Update Header persistent table
    IF ls_sales_hdr IS NOT INITIAL.
      MODIFY zci_dh_107 FROM @ls_sales_hdr.
    ENDIF.

    " 3. Save or Update Item persistent table
    IF ls_sales_itm IS NOT INITIAL.
      MODIFY zci_dii_107 FROM @ls_sales_itm.
    ENDIF.

    " 4. Handle Deletions manually
    IF lv_so_hdr_del = abap_true.
      " Delete full header and all associated items
      LOOP AT lt_sales_hdr_del INTO DATA(ls_del_hdr).
        DELETE FROM zci_dh_107 WHERE sales_order = @ls_del_hdr-salesdocument.
        DELETE FROM zci_dii_107 WHERE sales_order = @ls_del_hdr-salesdocument.
      ENDLOOP.
    ELSE.
      " Delete specific individual items
      LOOP AT lt_sales_itm_del INTO DATA(ls_del_itm).
        DELETE FROM zci_dii_107 WHERE sales_order = @ls_del_itm-salesdocument
                                 AND sales_order_item = @ls_del_itm-salesitemnumber.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup.
    " Essential: Clear the singleton buffer to prepare for the next user interaction
    zci_uu_107=>get_instance(  )->cleanup_buffer(  ).
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
