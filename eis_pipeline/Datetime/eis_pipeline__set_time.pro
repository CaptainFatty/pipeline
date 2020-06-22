;+
; NAME: eis_pipeline__set_date_time.pro
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

pro eis_pipeline::set_time, stime=stime, etime=etime
  self->trace, 'eis_pipeline__define::set_time'
  self.stime = stime
  self.etime = etime
end
