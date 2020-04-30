;+
; NAME: eis_pipeline__tidy_up.pro
;
; PURPOSE: Tidy up routines for the mission data pipeline.
;          Closes log files and disposes of objects.
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

pro eis_pipeline::close_logs
  self->trace, 'eis_pipeline__tidy_up::close_logs'
  self->log, ''
;  self->log, 'eis status pipeline finished'
;  self->log, ''

;  lu = self.local_log_unit
;  close, lu, /force
;  free_lun, lu
  *self.local_logger->close_output
  *self.main_logger->close_output
end

pro eis_pipeline::tidy_up, status_str
  self->trace, 'eis_pipeline__tidy_up::tidy_up'
;  *self.local_logger->stage_title, 'Tidy up'
  self->close_logs
end
