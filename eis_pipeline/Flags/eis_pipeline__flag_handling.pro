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

;function eis_pipeline::check_flag, flag_array, flag
;  self->trace, 'eis_pipeline_flag_handling::check_flag'
;  ret = 0
;  foreach f, flag_array, index do begin
;     if flag eq f then begin
;        ret = index + 1
;        break
;     endif
;  endforeach
;  print, 'eis_pipeline::check_flag for ' + flag + ' returning ' + strtrim(string(ret),2)
;  return, ret
;end

;function eis_pipeline::known, flag
;  self->trace, 'eis_pipeline_flag_handling::known'
;  return, self->check_flag(self.known_flags, flag)
;end

;function eis_pipeline::flag_set, flag
;  self->trace, 'eis_pipeline_flag_handling::flag_set'
;  return, self->check_flags(self.set_flags, flag)
;end
;
; function eis_pipeline::force_reformat
;   self->trace, 'eis_pipeline__define::force_reformat'
;   return, self.force_reformat eq 1
; end

;pro eis_pipeline::set_flag, flag
;  self->trace, 'eis_pipeline_flag_handling::set_flag'
;  index = self->known(flag)
;  if index ne 0 then begin
;     self->log, 'Setting flag to ' + '''' + flag + ''''
;     self.set_flags[index - 1] = flag
;  endif else begin
;     self->log, 'Unknown flag ''' + flag + ''' - not set'
;  endelse
;end

;pro eis_pipeline::set_interactive, flag
;  self->trace, 'eis_pipeline_flag_handling::set_interactive'
;  self.interactive = 1
;end

; pro eis_pipeline::set_date_time, sdate=sdate, edate=edate, stime=stime, etime=etime
;   ;;;self->trace, 'eis_pipeline__define::set_date_time'
;   self.sdate = sdate
;   self.edate = edate
;   self.stime = stime
;   self.etime = etime
; end
;
; function eis_pipeline::parse_date_time, sdate, edate, stime, etime
;   ret = 1
; ;  if keyword_set(sdate) then ret = ret and 1 else ret = ret and 0
; ;  if keyword_set(edate) then ret = ret and 1 else ret = ret and 0
; ;  if keyword_set(stime) then ret = ret and 1 else ret = ret and 0
; ;  if keyword_set(etime) then ret = ret and 1 else ret = ret and 0
;   self->trace, 'eis_pipeline__define::parse_date_time'
;   print, 'Returning ', ret
;   return, ret
; end

;end
