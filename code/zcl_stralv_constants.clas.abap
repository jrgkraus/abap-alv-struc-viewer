class zcl_stralv_constants definition
  public
  abstract
  create public .

  public section.

    constants:
      begin of fieldname,
        value       type fieldname value 'FIELDVALUE',
        label       type fieldname value 'FIELDLABEL',
        description type fieldname value 'FIELDDESCR',
        ref_field   type lvc_fname value 'REF_FIELD',
        ref_table   type lvc_fname value 'REF_TABLE',
        maxlen      type lvc_fname value 'MAXLEN   ',
        t_styles    type lvc_fname value 'T_STYLES ',
        t_colors    type lvc_fname value 'T_COLORS ',
      end of fieldname.

    constants struct_name type ddobjname value 'ZST_STRALV_TAB_LINE'.

    constants:
      begin of metrics,
        output_length type i value 15,
      end of metrics.

    constants:
      begin of datatype,
        currency type datatype_d value 'CUKY',
        unit     type datatype_d value 'UNIT',
      end of datatype.
  protected section.
  private section.
endclass.



class zcl_stralv_constants implementation.
endclass.
