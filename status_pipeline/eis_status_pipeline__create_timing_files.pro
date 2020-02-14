;+
; NAME: eis_status_pipeline::create_timing_files.pro
;
; PURPOSE: Reads an ascii file containing Hinode status packet timing
; information and creates timing files for each type of status packet
;
; CATEGORY: Engineering
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
; COMMON BLOCKS: None.
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

pro eis_status_pipeline::create_timing_files
  self->trace, 'eis_status_pipeline__split_files::create_timing_files'

  self->log, 'Creating timing files in ' + self.timing_directory + ' to ' + self.timing_files_directory

  files = FILE_SEARCH(self.timing_directory + '/' + '*log', count=file_count)
  if file_count eq 0 then begin
    self->log, 'No timing files found to split'
    return
  endif else begin
     self->log, 'Pretending to split timing files...'
  endelse

end
