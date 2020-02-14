;+
; NAME: eis_pipeline__parse_date_time.pro
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

function eis_pipeline::parse_date_time, sdate, edate, stime, etime
  ret = 1
;  if keyword_set(sdate) then ret = ret and 1 else ret = ret and 0
;  if keyword_set(edate) then ret = ret and 1 else ret = ret and 0
;  if keyword_set(stime) then ret = ret and 1 else ret = ret and 0
;  if keyword_set(etime) then ret = ret and 1 else ret = ret and 0
  self->trace, 'eis_pipeline__define::parse_date_time'
  print, 'Returning ', ret
  return, ret
end
