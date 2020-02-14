;+
; NAME: eis_pipeline__set_flag.pro
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

pro eis_pipeline::set_flag, flag
  self->trace, 'eis_pipeline_flag_handling::set_flag,' + ' ' + flag
  index = self->known(flag)
  if index ne 0 then begin
;     self->log, 'Setting flag to ' + '''' + flag + ''''
     print, 'Setting flag to ' + '''' + flag + ''''
     self.set_flags[index - 1] = flag
  endif else begin
;     self->log, 'Unknown flag ''' + flag + ''' - not set'
     print, 'Unknown flag ''' + flag + ''' - not set'
  endelse
end

;pro eis_pipeline::set_flag, flag
;  self->trace, 'eis_pipeline__define::set_flag'
;  self->log, 'Setting flag to ' + '''' + flag + ''''
;end
