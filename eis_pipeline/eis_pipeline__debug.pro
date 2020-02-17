;+
; NAME: eis_pipeline__debug.pro
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

pro eis_pipeline::debug
  self->trace, 'eis_pipeline__define::debug'
;  print, 'eis_pipeline__define::debug'
;  self->log, 'bin                         : ' + self.bin
  print, 'bin                         : ' + self.bin
  print, 'main_log                    : ' + self.main_log
  print, 'master_dir                  : ' + self.master_dir
  print, 'log_dir                     : ' + self.log_dir
  print, 'merge_dir                   : ' + self.merge_dir
  print, 'received_dir                : ' + self.received_dir
  print, 'fits_dir                    : ' + self.fits_dir
  print, 'local_log                   : ' + self.local_log
  print, 'received_files_log          : ' + self.received_files_log
  print, 'packet_source_directory     : ' + self.packet_source_directory
  print, 'destination_directory       : ' + self.destination_directory
  print, 'split_directory             : ' + self.split_directory
  print, 'date_string                 : ' + self.date_string
  print, 'flag                        : ' + self.flag
;  print, 'known_flags                 : ' + self.known_flags ; !!!
;  print, 'set_flags                   : ' + self.set_flags ; !!!

  self->print_flags, 'known_flags                 : ',self.known_flags
  self->print_flags, 'set_flags                   : ',self.set_flags
  
  print, 'pending_file                : ' + self.pending_file
  print, 'sdtp                        : ' + self.sdtp
  print, 'received_files_count        : ' + strtrim(string(self.received_files_count), 2)
  print, 'fits_files_count            : ' + strtrim(string(self.fits_files_count), 2)
  print, 'sdate                       : ' + self.sdate
  print, 'edate                       : ' + self.edate
  print, 'stime                       : ' + self.stime
  print, 'etime                       : ' + self.etime
  print, 'interactive                 : ' + strtrim(string(self.interactive), 2)
  print, 'scheduled                   : ' + strtrim(string(self.scheduled), 2)
  print, 'force_reformat              : '; + strtrim(string(self.force_reformat), 2)
  print, 'fetch_only                  : '; + strtrim(string(self.fetch_only), 2)
  print, 'testing                     : '; + self.testing
  print, 'special                     : '; + self.special
end
