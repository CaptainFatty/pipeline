;+
; NAME: eis_pipeline__define.pro
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


;function eis_pipeline::force_reformat
;  self->trace, 'eis_pipeline__define::force_reformat'
;  return, self.force_reformat eq 1
;end

;pro eis_pipeline::initialise, trace
;  if keyword_set(trace) then self.trace = 1
;end

;pro eis_pipeline::print_flags, title, flag_array
;  foreach flag, flag_array do begin
;     if flag ne '' then title = title + flag + ' '
;  endforeach
;  print, title
;end

;pro eis_pipeline::debug
;  print, 'eis_pipeline__define::debug'
;  print, 'bin                         : ' + self.bin
;  print, 'main_log                    : ' + self.main_log
;  print, 'master_dir                  : ' + self.master_dir
;  print, 'log_dir                     : ' + self.log_dir
;  print, 'merge_dir                   : ' + self.merge_dir
;  print, 'received_dir                : ' + self.received_dir
;  print, 'fits_dir                    : ' + self.fits_dir
;  print, 'local_log                   : ' + self.local_log
;  print, 'received_files_log          : ' + self.received_files_log
;  print, 'packet_source_directory     : ' + self.packet_source_directory
;  print, 'destination_directory       : ' + self.destination_directory
;  print, 'split_directory             : ' + self.split_directory
;  print, 'date_string                 : ' + self.date_string
;  print, 'flag                        : ' + self.flag
;;  print, 'known_flags                 : ' + self.known_flags ; !!!
;;  print, 'set_flags                   : ' + self.set_flags ; !!!
;
;  self->print_flags, 'known_flags                 : ',self.known_flags
;  self->print_flags, 'set_flags                   : ',self.set_flags
;  
;  print, 'pending_file                : ' + self.pending_file
;  print, 'sdtp                        : ' + self.sdtp
;  print, 'received_files_count        : ' + strtrim(string(self.received_files_count), 2)
;  print, 'fits_files_count            : ' + strtrim(string(self.fits_files_count), 2)
;  print, 'sdate                       : ' + self.sdate
;  print, 'edate                       : ' + self.edate
;  print, 'stime                       : ' + self.stime
;  print, 'etime                       : ' + self.etime
;  print, 'interactive                 : ' + strtrim(string(self.interactive), 2)
;  print, 'scheduled                   : ' + strtrim(string(self.scheduled), 2)
;  print, 'force_reformat              : ' + strtrim(string(self.force_reformat), 2)
;  print, 'fetch_only                  : ' + strtrim(string(self.fetch_only), 2)
;  print, 'testing                     : ' + self.testing
;  print, 'special                     : ' + self.special
;end

;function eis_pipeline::init, main_logger, trace=trace, verbose=verbose
;  if keyword_set(verbose) then begin
;     self->set_verbose, verbose
;     self->trace, 'eis_pipeline::init'
;  endif
;  if keyword_set(trace) then begin
;     self->set_trace, trace
;;     self->trace, 'eis_pipeline::init'
;  endif
;  self.main_logger = main_logger
;
;;  self->init_paths
;;  self->init_logs
;
;;  self->initialize
;  
;  return, 1
;end

pro eis_pipeline__define
  print,'eis_pipeline::eis_pipeline__define'
  struct = { eis_pipeline,                  $

             bin                      : '', $
             sdtp                     : '', $

             master_dir               : '', $
             log_dir                  : '', $
             merge_dir                : '', $
             received_dir             : '', $
             fits_dir                 : '', $
             
             packet_source_directory  : '', $
             destination_directory    : '', $

             ; move to eis_mission_pipeline
             split_directory          : '', $

             date_string	      : '', $
             
             main_log                 : '', $
             local_log                : '', $
             received_files_log       : '', $
             
             flag                     : '',  $
;             known_flags              : ['no-soda','fetch-only','no-fetch','no-split','fits-only','no-update','no-update-plots','no-update-trends','no-update-qcm','no-update-ss','testing','special'], $
             known_flags              : strarr(7), $
             set_flags                : strarr(7), $

             ; Move this lot to eis_mission_pipeline
;             no_soda                  : 0B, $
;             fetch_only               : 0B, $
;             no_fetch                 : 0B, $
;             fits_only                : 0B, $
;             force_reformat           : 0, $
;;             testing                  : 0B, $
;;             special                  : 0B, $
;             testing                  : '', $
;             special                  : '', $
             
;            ccsds_check_log      : '', $
;            reformat_log         : '', $
             
             pending_file             : '', $
                          
             received_files_count     : 0L, $
             fits_files_count         : 0L, $
             
             sdate                    : '', $
             edate                    : '', $
             stime                    : '', $
             etime                    : '', $
             
             interactive              : 0,  $
             scheduled                : 0,  $
                          
             reformatter              : ptr_new(obj_new()), $
             
;             summary              : DICTIONARY(), $
             main_logger              : ptr_new(obj_new()), $
             local_logger             : ptr_new(obj_new()), $
             
             inherits base_object }

end
