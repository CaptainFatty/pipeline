;+
; NAME: eis_pipeline__flag_handling.pro
;
; PURPOSE: Super class for the EIS mission data and status data pipelines
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

function eis_pipeline::check_flag, flag_array, flag
  self->trace, 'eis_pipeline_flag_handling::check_flag'
  ret = 0
  foreach f, flag_array, index do begin
;;;     print, 'index = ' + strtrim(string(index),2) + ' f = ' + f + ', flag = ' + flag
     if flag eq f then begin
        ret = index + 1
        break
     endif
  endforeach
  print, 'eis_pipeline::check_flag for ' + flag + ' returning ' + strtrim(string(ret),2)
  return, ret ne 0
end
