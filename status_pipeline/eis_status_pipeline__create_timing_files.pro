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

; '/'HK3'/ { print $11 }'

; /Users/mcrw/work/localdata/sdtp/merge/timing/20200604_0000.log awk
; '/STS1'/ { print $11 }'
; /Users/mcrw/work/localdata/sdtp/merge/timing/files 20200604_0000.log

; DEPRECATE
; move to reformatter responsibility
pro eis_status_pipeline::create_timing_files
  self->trace, 'eis_status_pipeline__split_files::create_timing_files'

  self->log, 'Creating timing files in ' + self.timing_directory + ' to ' + self.timing_files_directory

  files = FILE_SEARCH(self.timing_directory + '/' + '*log', count=file_count)
  if file_count eq 0 then begin
    self->log, 'No timing files found to split'
    return
  endif else begin
;     self->log, 'Pretending to split timing files...'
     self->log, 'Splitting timing files...'
     foreach file, files do begin
        foreach type, self.timing_file_types do begin
           outfile = type + '_' + file_basename(file)
           cmd = 'awk ''/' + type + '/' + ' { print $11 }''' + ' < ' + file + ' > ' + self.timing_files_directory + '/' + outfile
;           cmd = 'awk ''/''' + type + '''/ { print $11 }'''
;           print, cmd
           self->log, cmd
           spawn, cmd
        end
     end

; sts1_timing.awk
; /STS1/  { print $11 }

  endelse

end
