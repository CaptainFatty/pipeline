;+
; NAME: eis_status_pipeline__clear_old_data.pro
;
; PURPOSE: Deletes any data left lying around by a previous reformat.
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

pro eis_status_pipeline::clear_split_directories
  self->trace, 'eis_status_pipeline__clear_old_data::clear_split_directories'
  index = 0
  while index lt 8 do begin
;    self->shell, '/bin/rm -f ' + self.split_directory + '/' + self.split_file_types[index] + '/*'
    self->log, '/bin/rm -f ' + self.split_directory + '/' + self.split_file_types[index] + '/*'
    index = index + 1
  endwhile
end

pro eis_status_pipeline::clear_old_data
  self->trace, 'eis_status_pipeline__clear_old_data::clear_old_data'
  self->eis_pipeline::clear_old_data
;  *self.local_logger->stage_title, 'Removing old data'
;  self->stage_title, 'Removing old data'
  self->clear_split_directories
end
