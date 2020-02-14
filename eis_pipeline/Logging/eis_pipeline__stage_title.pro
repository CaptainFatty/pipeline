;+
; NAME: eis_pipeline__stage_title.pro
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

pro eis_pipeline::stage_title, title
;  self->log, ''
;  date_time = systime()
;;  self->log, date_time + ' *** ' + title, /title
;  self->log, date_time + ' @@@ ' + title, /title

  (*self.local_logger)->stage_title, title
end
