; in __initialise
;pro eis_md_pipeline::init_logs
;;;;  eis_local = '/nasA_solar1/work/eis/localdata'
;  eis_local = '/Volumes/Data/Hinode/tmp'
;  logs = eis_local + '/log'
;  self.log_dir = logs + '/pipeline'
;  self.shutter_dir = logs + '/shutter'
;  self.local_log = logs + '/local_log.txt'
;end

; in __initialise
;pro eis_md_pipeline::open_logs
;;  openw, lun, self.local_log, /get_lun, error=err
;;  self.local_log_unit = lun
;  success = *self.local_logger->open_log('/Users/mcrw/tmp/local_log.txt') ; temp
;end

; in __tidy_up.pro
;pro eis_md_pipeline::close_logs
;;  lu = self.local_log_unit
;;  close, lu, /force
;;  free_lun, lu
;  *self.local_logger->close_output
;end

;pro eis_md_pipeline::initialise, how=interactive, flag=flag, sdate=sdate, edate=edate, stime=stime, etime=etime
;;pro eis_md_pipeline::initialise
;  if keyword_set(interactive) then begin
;
;  end else begin
;
;  endelse
;
;  if keyword_set(force_reformat) then print, 'Force reformat' else print, 'No force'
;
;  self->init_logs
;  self.decompressor = ptr_new(obj_new('eis_md_decompressor'))
;  self.md_checker = ptr_new(obj_new('eis_md_ccsds_checker'))
;  self.local_logger = ptr_new(obj_new('eis_logger'))
;  *self.md_checker->initialise, self.local_logger
;  self->open_logs
;
;  self.sdtp = '${HOME}/sdtp '
;
;  self.force_reformat = 0
;  self.fetch_only = 0
;end

;pro eis_md_pipeline::main_log, msg
;  print, msg ; for now
;end
;
pro eis_md_pipeline::log, msg, title=title
  *self.local_logger->log, msg, title=title
;  lu = self.local_log_unit
;  if not keyword_set(title) then msg1 = '	' + msg else msg1 = msg
;  print, msg1
;;  printf, lu, msg1
end

pro eis_md_pipeline::main_log, msg
  print, 'Main Log: ' + msg                    ; for now
;  *self.main_logger->log, msg
end
;
;; Instead of spawn could use the $
;; form of the command.
pro eis_md_pipeline::shell, action
  self->log, action
;;;  spawn, action, result, /noshell
end
;
pro eis_md_pipeline::stage_title, title
  self->log, ''
  date_time = systime()
  self->log, date_time + ' *** ' + title, /title
end

; in __clear_old_data.pro
;pro eis_md_pipeline::clear_merge_directories
;  self->shell, '/bin/cd ' + self.merge_dir + ' && /bin/rm -f eis_md_* eis_status* eis_dmp*'
;  *self.local_logger->shell, '/bin/cd ' + self.join_dir  + ' && /bin/rm -f eis_md*'
;end
;
;pro eis_md_pipeline::clear_fits_directories
;  *self.local_logger->shell, '/bin/cd ' + self.fits_dir  + ' && /bin/rm -f eis_l0*'
;end
;
;pro eis_md_pipeline::clear_old_data
;;  *self.local_logger->stage_title, 'Removing old data'
;  self->stage_title, 'Removing old data'
;  self->clear_merge_directories
;;  self->clear_rescue_directories
;;  self->clear_fits_directories
;;  self->clear_temporary_log_directories
;end

pro eis_md_pipeline::update_pending_file
  openw, lu, self.pending_file, /get_lun, /append
  print, lu, self.sdate + ' ' + self.edate + ' ' + self.stime + ' ' + self.etime
  close, lu
  free_lun, lu
end

; in __fetch_data.pro
;pro eis_md_pipeline::record_received_files, files
;  print, 'eis_md_pipeline::record_received_files: ', files
;;  openu, lun, self.received_files_log, /get_lun
;;  writeu, lun, files
;;  close, lun, /force
;;  free_lun, lun
;end
;
;; OUT: files, count
;pro eis_md_pipeline::fetch_data, files, count
;  *self.local_logger->stage_title, 'Fetching data'
;  *self.local_logger->shell, self.sdtp + ' merge usc34 band=3 sdate=' + self.sdate + ' edate=' + self.edate + 'stime=' + self.stime + ' etime=' + self.etime
;  files = file_search(self.merge_dir + '/eis_md_*', count=count)
;  self->log, 'Number of files received: ' + strtrim(string(count), 2)
;  self->record_received_files, files
;  if count eq 0 then begin
;     msg = 'No mission data files received'
;     self->log, msg
;     self->update_track_file, self.sdate, self.edate
;;;;     self->exit, 99, msg
;  endif
;end

; in __check_data.pro
;pro eis_md_pipeline::md_ccsds_split_check, files
;;  perform(*LOG, $state, "$HOME/bin/ccsds_merge_md_split_check $merge_dir > $merge_dir/md_split_check.txt") ;
;  *self.local_logger->shell, '${HOME}/bin/ccsds_merge_split_check ' + self.merge_dir + ' > ' + self.merge_dir + '/' + self.md_split_check_log
;
;;  perform(*LOG, $state, "$HOME/bin/md_join_merge.py $merge_dir/md_split_check.txt") ;
;  *self.local_logger->shell, '${HOME}/bin/md_join_merge.py ' + self.md_split_check_log
;
;;  @joined_files = `ls $HOME/tmp/join/ | grep eis_md`       ;
;  files = file_search(self.join_dir + '/eis_md*', count=count)
;
;;  $log_msg_str = "Number of joined files: " . @joined_files ;
;  self->log,' Number of joined files: ' + strtrim(string(count), 2)
;
;  if count eq 0 then begin
;     msg = 'No joined files - quitting'
;     self->log, msg
;;;;     self->exit, 1, msg
;  endif
;
;  *self.local_logger->shell, '/bin/rm ' + self.merge_dir + '/eis_md*'
;  *self.local_logger->shell, '/bin/mv ' + self.join_dir + '/eis_md* ' + self.merge_dir
;
;;  openw, lun, self.joined_files_log, /get_lun, error=err
;;  writeu, lun, files
;;  close, lun, /force
;;  free_lun, lun
;end
;
;pro eis_md_pipeline::md_missing_packet_check
;;  perform(*LOG, $state, "$HOME/bin/pipeline_md_hdr_dump $merge_dir > $merge_dir/md_hdr_check.txt");
;; Do the mission data header dump, which also updates the
;; engineering.txt file
;  *self.local_logger->shell, '${HOME}/bin/pipeline_md_hdr_dump ' + self.merge_dir + ' > ' + self.merge_dir + '/md_hdr_check.txt'
;
;; perform(*LOG, $state, "$HOME/bin/pipeline_ccsds_check $merge_dir > $merge_dir/ccsds_hdr_check.txt");
;; Do the ccsds check which detects missing packets, updating
;; missing_packets.txt
;  *self.local_logger->shell, '${HOME}/bin/pipeline_ccsds_check ' + self.merge_dir + ' > ' + self.merge_dir + '/ccsds_hdr_check.txt'
;  *self.md_checker->check_ccsds, self.merge_dir, self.ccsds_check_log
;
;  *self.local_logger->shell, 'Do non-compressed check, move files?'
;  *self.local_logger->shell, 'Move damaged files to the nursery'
;  *self.local_logger->shell, 'Move headless files aside'
;  *self.local_logger->shell, 'Move incomplete files aside'
;
;  files = file_search(self.merge_dir + '/eis_md*', count=count)
;  self->log, 'Number of compressed files: ' + strtrim(string(count), 2)
;  self.compressed_files_count = count
;end
;
;pro eis_md_pipeline::check_data, files, count
;  *self.local_logger->stage_title, 'Mission data check'
;  self->md_ccsds_split_check, files
;  self->md_missing_packet_check
;end

; in __decompress_data.pro
;pro eis_md_pipeline::md_decomp, count, files, rescued=rescued
;  *self.decompressor->initialise, self.decompress_log, /mrege, verbose_level=verbose_level, rescued=rescued
;  openw,rat,'/Volumes/Data/Hinode/decompression/development_decomp_record.txt',/get_lun,/append
;  for i = 0, count - 1 do begin
;     *self.decompressor->perform_decompression, files[i], merge=merge, rescued=rescued
;     if *self.decompressor->report, rat ; Check internally, do only if success?
;     *self.decompressor->tidy_up
;  endfor
;  close, rat,
;  free_lun, rat
;end
;
;; type = ok or rescued
;pro eis_md_pipeline::decompress_data, rescued=rescued
;  *self.local_logger->stage_title, 'Mission data decompress'
;  if keyword_set(rescued) then src_dir = self.nursery else src_dir = self.merge_dir
;  files = file_search(src_dir + '/eis_md_*', count=count)
;  if keyword_set(rescued) then self.compressed_files_count = count else self.rescued_compressed_files_count = count
;  if count eq 0 then begin
;     
;  end else begin
;     self->md_decomp, count, files, rescued=rescued
;     if keyword_set(rescued) then dest_dir = self.decompressed_nursery else src_dir = self.decompressed_dir
;     files = file_search(dest_dir + '/eis_md_*', count=count)
;     if keyword_set(rescued) then begin
;        self.decompressed_files_count = count
;        self->log, 'Number of decompressed files: ' + strtrim(string(count), 2)
;     end else begin
;        self.rescued_decompressed_files_count = count
;        self->log, 'Number of rescued decompressed files: ' + strtrim(string(count), 2)
;     endelse
;  endelse
;end

; in __reformat_data.pro
;pro eis_md_pipeline::make_md_fits, count, files, rescued=rescued
;  for i = 0, count - 1 do begin
;     data = obj_new('eis_data', files[i], datasource='ccsds', hdr=hdr)
;     exp_info = (hdr[0])->getexp_info()
;     seq_id = exp_info.seq_id
;     rast_id = exp_info.rast_id
;     plan = obj_new('eis_plan')
;     if keyword_set(rescued) then begin
;        eis_mkfits, data, hdr, /doplan, /dospcd, fitsdir=self.fits_dir, outfile=self.fits_reformat_log, /rescued
;        self->log, 'eis_mkfits, data, hdr, /doplan, /dospcd, fitsdir=self.fits_dir, outfile=self.fits_reformat_log, /rescued'
;     end else begin
;        eis_mkfits, data, hdr, /doplan, /dospcd, fitsdir=self.fits_dir, outfile=self.fits_reformat_log
;        self->log, 'eis_mkfits, data, hdr, /doplan, /dospcd, fitsdir=self.fits_dir, outfile=self.fits_reformat_log'
;     endelse
;     if n_elements(logfile) ne 0 then printf, lu, files[i] + ' ' + outfile
;     obj_destroy, plan ; or move out of loop?
;     obj_destroy, data
;  endfor
;end
;
;pro eis_md_pipeline::reformat_data, rescued=rescued
;  *self.local_logger->stage_title, 'Mission data reformat'
;  if self.decompressed_files_count eq 0 then begin
;
;  end else begin
;     self->make_md_fits, count, files, rescued=rescued
;     files = file_search(self.fits_dir + '/eis_l0*', count=count)
;     self->log, 'Number of fits files: ' + strtrim(string(count), 2)
;  endelse
;end

; in __rescue_damaged_data.pro
;pro eis_md_pipeline::rescue_damaged_data
;  self->decompress_data, /rescued
;  self->reformat_data, /rescued
;end

; in __compress_fits.pro
;pro eis_md_pipeline::compress_fits
;  *self.local_logger->stage_title, 'Compress fits files'
;  *self.local_logger->shell, '/bin/cd ' + self.fits_dir + ' && gzip -f *'
;  *self.local_logger->shell, '/bin/cd ' + self.rescued_fits_dir + ' && gzip -f *'
;end

; in __update_soda.pro
;pro eis_md_pipeline::update_soda
;  *self.local_logger->stage_title, 'Update soda'
;
;end

; in __remove_ql.pro
;pro eis_md_pipeline::remove_ql
;  *self.local_logger->stage_title, 'Remove ql'
;
;end

; in __generate_reports.pro
;pro eis_md_pipeline::generate_reports
;  *self.local_logger->stage_title, 'Generate reports'
;
;end

; in __move_reports_to_darts.pro
;pro eis_md_pipeline::move_reports_to_darts
;  *self.local_logger->stage_title, 'Move reports to DARTS'
;
;end

; in __tidy_up
;pro eis_md_pipeline::tidy_up
;  *self.local_logger->stage_title, 'Tidy up'
;  self->close_logs
;end

; in __exit.pro
;pro eis_md_pipeline::exit, val, msg
;  *self.local_logger->stage_title, 'Exit'
;  self->main_log, 'Finished: ' + strtrim(string(val), 2) + ' ' + msg
;  *self.decompressor->exit
;  self->tidy_up
;;  self->close_logs
;  *self.md_checker->tear_down
;  ; release objects
;  obj_destroy, *self.decompressor
;  obj_destroy, *self.md_checker
;  obj_destroy, *self.local_logger
;end

function eis_md_pipeline::force_reformat
  return, self.force_reformat eq 1
end

pro eis_md_pipeline::set_flag, flag

end

pro eis_md_pipeline::set_interactive, flag

end

pro eis_md_pipeline::set_date_time, sdate=sdate, edate=edate, stime=stime, etime=etime
  self.sdate = sdate
  self.edate = edate
  self.stime = stime
  self.etime = etime
end

pro eis_md_pipeline::debug
  print, 'eis_md_pipeline::debug'
  print, 'master_dir                  : ' + self.master_dir
  print, 'log_dir                     : ' + self.log_dir
  print, 'merge_dir                   : ' + self.merge_dir
  print, 'received_dir                : ' + self.received_dir
  print, 'join_dir                    : ' + self.join_dir
  print, 'decompressed_dir            : ' + self.decompressed_dir
  print, 'fits_dir                    : ' + self.fits_dir
  print, 'nursery_dir                 : ' + self.nursery_dir
  print, 'rescued_dir                 : ' + self.rescued_dir
  print, 'rescued_decompressed_dir    : ' + self.rescued_decompressed_dir
  print, 'rescued_fits_dir            : ' + self.rescued_fits_dir
  print, 'local_log                   : ' + self.local_log
  print, 'received_files_log          : ' + self.received_files_log
  print, 'md_split_check_log          : ' + self.md_split_check_log
  print, 'joined_files_log            : ' + self.joined_files_log
  print, 'ccsds_check_log             : ' + self.ccsds_check_log
  print, 'decompression_log           : ' + self.decompression_log
  print, 'decompression_master_record : ' + self.decompression_master_record
  print, 'reformat_log                : ' + self.reformat_log
  print, 'shutter_log                 : ' + self.shutter_log
  print, 'sdtp                        : ' + self.sdtp
  print, 'join                        : ' + self.join
  print, ''
  print, 'sdate                       : ' + self.sdate
  print, 'edate                       : ' + self.edate
  print, 'stime                       : ' + self.stime
  print, 'etime                       : ' + self.etime

end

pro eis_md_pipeline__define

  struct = { eis_md_pipeline,                       $

             main_log                         : '', $

             master_dir                       : '', $
             log_dir                          : '', $
             merge_dir                        : '', $
             received_dir                     : '', $
             join_dir                         : '', $
             decompressed_dir                 : '', $
             fits_dir                         : '', $
             nursery_dir                      : '', $
             rescued_dir                      : '', $
             rescued_decompressed_dir         : '', $
             rescued_fits_dir                 : '', $

             local_log                        : '', $
             received_files_log               : '', $
             md_split_check_log               : '', $
             joined_files_log                 : '', $
             ccsds_check_log                  : '', $
             decompression_log                : '', $
             decompression_master_record      : '', $
             reformat_log                     : '', $
             shutter_log                      : '', $
             
             sdtp                             : '', $
             join                             : '', $

             received_files_count             : 0L, $
             compressed_files_count           : 0L, $
             decompressed_files_count         : 0L, $
             fits_files_count                 : 0L, $
             rescued_compressed_files_count   : 0L, $
             rescued_decompressed_files_count : 0L, $
             rescued_fits_files_count         : 0L, $

             sdate                            : '', $
             edate                            : '', $
             stime                            : '', $
             etime                            : '', $

             interactive                      : 0,  $
             scheduled                        : 0,  $

             force_reformat                   : 0L, $
             fetch_only                       : 0L, $
             testing                          : '', $
             special                          : '', $

             decompressor                     : ptr_new(obj_new()), $
             reformatter                      : ptr_new(obj_new()), $
             md_checker                       : ptr_new(obj_new()), $

             summary                          : DICTIONARY(), $
             main_logger                      : ptr_new(obj_new()), $
             local_logger                     : ptr_new(obj_new())  }
  
end
