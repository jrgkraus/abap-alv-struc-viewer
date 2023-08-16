class ZCX_STRALV_UNKNOWN_FIELD definition
  public
  inheriting from ZCX_STRALV_ERROR
  create public .

public section.

  constants ZCX_STRALV_UNKNOWN_FIELD type SOTR_CONC value '005056B16FE81EDE8ED5BA3713780530' ##NO_TEXT.
  data NAME type LVC_FNAME .

  methods CONSTRUCTOR
    importing
      !TEXTID like TEXTID optional
      !PREVIOUS like PREVIOUS optional
      !NAME type LVC_FNAME optional .
protected section.
private section.
ENDCLASS.



CLASS ZCX_STRALV_UNKNOWN_FIELD IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
TEXTID = TEXTID
PREVIOUS = PREVIOUS
.
 IF textid IS INITIAL.
   me->textid = ZCX_STRALV_UNKNOWN_FIELD .
 ENDIF.
me->NAME = NAME .
  endmethod.
ENDCLASS.
