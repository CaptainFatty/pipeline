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


function eis_pipeline::force_reformat
  self->trace, 'eis_pipeline__define::force_reformat'
  return, self.force_reformat eq 1
end

; pro eis_pipeline::initialise
;
; end

pro eis_pipeline::debug
  print, 'eis_pipeline__define::debug'
  print, 'bin                         : ' + self.bin
  print, 'main_log                    : ' + self.main_log
  print, 'master_dir                  : ' + self.master_dir
  print, 'log_dir                     : ' + self.log_dir
  print, 'merge_dir                   : ' + self.merge_dir
  print, 'received_dir                : ' + self.received_dir
  print, 'fits_dir                    : ' + self.fits_dir
  print, 'local_log                   : ' + self.local_log
  print, 'received_files_log          : ' + self.received_files_log
  print, 'flag                        : ' + self.flag
  print, 'known_flags                 : ' + self.known_flags ; !!!
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
  print, 'force_reformat              : ' + strtrim(string(self.force_reformat), 2)
  print, 'fetch_only                  : ' + strtrim(string(self.fetch_only), 2)
  print, 'testing                     : ' + self.testing
  print, 'special                     : ' + self.special
end

pro eis_pipeline__define

  struct = { eis_pipeline,              $

            bin                 : '', $
            main_log             : '', $

            master_dir           : '', $
            log_dir              : '', $
            merge_dir            : '', $
            received_dir         : '', $
            fits_dir             : '', $
;            nursery_dir          : '', $
;            rescued_dir          : '', $
;            rescued_fits_dir     : '', $

            local_log            : '', $
            received_files_log   : '', $

            flag                 : '',  $
            known_flags          : ['no_soda'], $

;            ccsds_check_log      : '', $
;            reformat_log         : '', $

			pending_file         : '', $

            sdtp                 : '', $
;            join                 : '', $

            received_files_count : 0L, $
            fits_files_count     : 0L, $
; rescued_fits_files_count         : 0L, $

            sdate                : '', $
            edate                : '', $
            stime                : '', $
            etime                : '', $

            interactive          : 0,  $
            scheduled            : 0,  $

            force_reformat       : 0, $
            fetch_only           : 0, $
            testing              : '', $
            special              : '', $

            reformatter          : ptr_new(obj_new()), $

;             summary              : DICTIONARY(), $
            main_logger          : ptr_new(obj_new()), $
            local_logger         : ptr_new(obj_new()), $

            inherits eis_object }

end
