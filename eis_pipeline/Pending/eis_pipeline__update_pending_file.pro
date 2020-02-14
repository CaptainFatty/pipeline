;+
; NAME: eis_pipeline__update_pending_file.pro
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

pro eis_pipeline::update_pending_file
  self->trace, 'eis_pipeline__define::update_pending_file'
  self->log, 'Updating pending file: ' + self.pending_file
  openw, lu, self.pending_file, /get_lun, /append, error=err
  if err ne 0 then begin
  	*self.local_logger->log, 'Can''t open pending_file'
  endif else begin
  	print, lu, self.sdate + ' ' + self.edate + ' ' + self.stime + ' ' + self.etime
  	close, lu
  	free_lun, lu
    self->log, 'Updated pending file'
  endelse
end
