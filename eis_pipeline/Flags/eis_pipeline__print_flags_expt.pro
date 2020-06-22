;+
; NAME: eis_pipeline__print_flags.pro
;
; PURPOSE: 
;
; CATEGORY: Science
;
; CALLING SEQUENCE: None
;
; INPUTS: None
;
; KEYWORD PARAMETERS: None
;
; OUTPUTS: None
;
; CALLS: None
;
; COMMON BLOCKS:None.
;
; PROCEDURE:
;
; RESTRICTIONS: Uses SolarSoft
;
; MODIFICATION HISTORY:
;	  23/11/05 mcrw	wrote
;   14/08/06 mcrw	added documentation
;
;-

pro eis_pipeline::print_flags_expt, title
  foreach flag, self.known_flags_expt do begin
     if flag ne '' then title = title + flag + ' '
  endforeach
  print, title
end
