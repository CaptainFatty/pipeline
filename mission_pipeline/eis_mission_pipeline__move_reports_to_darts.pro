;+
; NAME: eis_mission_pipeline__move_reports_to_darts.pro
;
; PURPOSE: Moves the generated report files from their temporary location to
;          the correct location in DARTS according to their filename.
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

pro eis_mission_pipeline::move_reports_to_darts
  self->log, 'eis_mission_pipeline__move_reports_to_darts::move_reports_to_darts'
  *self.local_logger->stage_title, 'Move reports to DARTS'

end
