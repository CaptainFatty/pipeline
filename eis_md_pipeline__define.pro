pro eis_md_pipeline::init_logs
;;;  eis_local = '/nasA_solar1/work/eis/localdata'
  eis_local = '/Volumes/Data/Hinode/tmp'
  logs = eis_local + '/log'
  self.log_dir = logs + '/pipeline'
  self.shutter_dir = logs + '/shutter'
  self.local_log = logs + '/local_log.txt'
end

pro eis_md_pipeline::open_logs
  openw, lun, self.local_log, /get_lun, error=err
  self.local_log_unit = lun
end

pro eis_md_pipeline::close_logs
  lu = self.local_log_unit
  close, lu, /force
  free_lun, lu
end

pro eis_md_pipeline::initialise, how=interactive, flag=flag, sdate=sdate, edate=edate, stime=stime, etime=etime
;pro eis_md_pipeline::initialise
  if keyword_set(interactive) then begin

  end else begin

  endelse

  if keyword_set(force_reformat) then print, 'Force reformat' else print, 'No force'

  self->init_logs
  self.decompressor = ptr_new(obj_new('eis_md_decompressor'))
  self->open_logs

  self.sdtp = '${HOME}/sdtp '

  self.force_reformat = 0
  self.fetch_only = 0
end

pro eis_md_pipeline::main_log, msg
  print, msg ; for now
end

pro eis_md_pipeline::log, msg, title=title
  lu = self.local_log_unit
  if not keyword_set(title) then msg1 = '	' + msg else msg1 = msg
  print, msg1
;  printf, lu, msg1
end

; Instead of spawn could use the $
; form of the command.
pro eis_md_pipeline::shell, action
;  lu = self.main_log_unit
  self->log, action
;  printf, lu, action
;;;  spawn, action, result, /noshell
end

pro eis_md_pipeline::stage_title, title
  self->log, ''
  date_time = systime()
  self->log, date_time + ' *** ' + title, /title
end

pro eis_md_pipeline::clear_merge_directories
  self->shell, '/bin/cd ' + self.merge_dir + ' && /bin/rm -f eis_md_* eis_status* eis_dmp*'
  self->shell, '/bin/cd ' + self.join_dir  + ' && /bin/rm -f eis_md*'
end

pro eis_md_pipeline::clear_fits_directories
  self->shell, '/bin/cd ' + self.fits_dir  + ' && /bin/rm -f eis_l0*'
end

pro eis_md_pipeline::clear_old_data
  self->stage_title, 'Removing old data'
  self->clear_merge_directories
;  self->clear_rescue_directories
;  self->clear_fits_directories
;  self->clear_temporary_log_directories
end

pro eis_md_pipeline::update_track_file, start_date, end_date

end

pro eis_md_pipeline::record_received_files, files
  print, 'eis_md_pipeline::record_received_files: ', files
;  openu, lun, self.received_files_log, /get_lun
;  writeu, lun, files
;  close, lun, /force
;  free_lun, lun
end

pro eis_md_pipeline::fetch_data
  self->stage_title, 'Fetching data'
  self->shell, self.sdtp + ' merge usc34 band=3 sdate=' + self.sdate + ' edate=' + self.edate + 'stime=' + self.stime + ' etime=' + self.etime
  files = file_search(self.merge_dir + '/eis_md_*', count=count)
  self->log, 'Number of files received: ' + strtrim(string(count), 2)
  self->record_received_files, files
  if count eq 0 then begin
     msg = 'No mission data files received'
     self->log, msg
     self->update_track_file, self.sdate, self.edate
     self->exit, 99, msg
  endif
end

pro eis_md_pipeline::md_ccsds_split_check, files
;  perform(*LOG, $state, "$HOME/bin/ccsds_merge_md_split_check $merge_dir > $merge_dir/md_split_check.txt") ;
  self->shell, '${HOME}/bin/ccsds_merge_split_check ' + self.merge_dir + ' > ' + self.merge_dir + '/' + self.md_split_check_log

;  perform(*LOG, $state, "$HOME/bin/md_join_merge.py $merge_dir/md_split_check.txt") ;
  self->shell, '${HOME}/bin/md_join_merge.py ' + self.md_split_check_log

;  @joined_files = `ls $HOME/tmp/join/ | grep eis_md`       ;
  files = file_search(self.join_dir + '/eis_md*', count=count)

;  $log_msg_str = "Number of joined files: " . @joined_files ;
  self->log,' Number of joined files: ' + strtrim(string(count), 2)

  if count eq 0 then begin
     msg = 'No joined files - quitting'
     self->log, msg
     self->exit, 1, msg
  endif

  self->shell, '/bin/rm ' + self.merge_dir + '/eis_md*'
  self->shell, '/bin/mv ' + self.join_dir + '/eis_md* ' + self.merge_dir

;  openw, lun, self.joined_files_log, /get_lun, error=err
;  writeu, lun, files
;  close, lun, /force
;  free_lun, lun
end

pro eis_md_pipeline::md_missing_packet_check
;  perform(*LOG, $state, "$HOME/bin/pipeline_md_hdr_dump $merge_dir > $merge_dir/md_hdr_check.txt");
; Do the mission data header dump, which also updates the
; engineering.txt file
  self->shell, '${HOME}/bin/pipeline_md_hdr_dump ' + self.merge_dir + ' > ' + self.merge_dir + '/md_hdr_check.txt'

; perform(*LOG, $state, "$HOME/bin/pipeline_ccsds_check $merge_dir > $merge_dir/ccsds_hdr_check.txt");
; Do the ccsds check which detects missing packets, updating
; missing_packets.txt
  self->shell, '${HOME}/bin/pipeline_ccsds_check ' + self.merge_dir + ' > ' + self.merge_dir + '/ccsds_hdr_check.txt'

  self->shell, 'Do non-compressed check, move files?'
  self->shell, 'Move damaged files to the nursery'
  self->shell, 'Move headless files aside'
  self->shell, 'Move incomplete files aside'

  files = file_search(self.merge_dir + '/eis_md*', count=count)
  self->log, 'Number of compressed files: ' + strtrim(string(count), 2)
  self.compressed_files_count = count
end

pro eis_md_pipeline::check_data
  self->stage_title, 'Mission data check'
  self->md_ccsds_split_check, files
  self->md_missing_packet_check
end

pro eis_md_pipeline::md_decomp, count, files, rescued=rescued
  *self.decompressor->initialise, self.decompress_log, rescued=rescued
  for i = 0, count - 1 do begin
;     *self.decompressor->perform_decompression, files[i], rescued=rescued
  endfor
end

; type = ok or rescued
pro eis_md_pipeline::decompress_data, rescued=rescued
  self->stage_title, 'Mission data decompress'
  if keyword_set(rescued) then src_dir = self.nursery else src_dir = self.merge_dir
  files = file_search(src_dir + '/eis_md_*', count=count)
  if keyword_set(rescued) then self.compressed_files_count = count else self.rescued_compressed_files_count = count
  if count eq 0 then begin
     
  end else begin
     self->md_decomp, count, files, rescued=rescued
     if keyword_set(rescued) then dest_dir = self.decompressed_nursery else src_dir = self.decompressed_dir
     files = file_search(dest_dir + '/eis_md_*', count=count)
     if keyword_set(rescued) then begin
        self.decompressed_files_count = count
        self->log, 'Number of decompressed files: ' + strtrim(string(count), 2)
     end else begin
        self.rescued_decompressed_files_count = count
        self->log, 'Number of rescued decompressed files: ' + strtrim(string(count), 2)
     endelse
  endelse
end

pro eis_md_pipeline::make_md_fits, count, files, rescued=rescued
  for i = 0, count - 1 do begin
     data = obj_new('eis_data', files[i], datasource='ccsds', hdr=hdr)
     exp_info = (hdr[0])->getexp_info()
     seq_id = exp_info.seq_id
     rast_id = exp_info.rast_id
     plan = obj_new('eis_plan')
     if keyword_set(rescued) then begin
        eis_mkfits, data, hdr, /doplan, /dospcd, fitsdir=self.fits_dir, outfile=self.fits_reformat_log, /rescued
        self->log, 'eis_mkfits, data, hdr, /doplan, /dospcd, fitsdir=self.fits_dir, outfile=self.fits_reformat_log, /rescued'
     end else begin
        eis_mkfits, data, hdr, /doplan, /dospcd, fitsdir=self.fits_dir, outfile=self.fits_reformat_log
        self->log, 'eis_mkfits, data, hdr, /doplan, /dospcd, fitsdir=self.fits_dir, outfile=self.fits_reformat_log'
     endelse
     if n_elements(logfile) ne 0 then printf, lu, files[i] + ' ' + outfile
     obj_destroy, plan ; or move out of loop?
     obj_destroy, data
  endfor
end

pro eis_md_pipeline::reformat_data, rescued=rescued
  self->stage_title, 'Mission data reformat'
  if self.decompressed_files_count eq 0 then begin

  end else begin
     self->make_md_fits, count, files, rescued=rescued
     files = file_search(self.fits_dir + '/eis_l0*', count=count)
     self->log, 'Number of fits files: ' + strtrim(string(count), 2)
  endelse
end

pro eis_md_pipeline::rescue_damaged_data

end

pro eis_md_pipeline::compress_fits
  self->stage_title, 'Compress fits files'
  self->shell, '/bin/cd ' + self.fits_dir + ' && gzip -f *'
  self->shell, '/bin/cd ' + self.rescued_fits_dir + ' && gzip -f *'
end

pro eis_md_pipeline::update_soda
  self->stage_title, 'Update soda'

end

pro eis_md_pipeline::remove_ql
  self->stage_title, 'Remove ql'

end

pro eis_md_pipeline::generate_reports
  self->stage_title, 'Generate reports'

end

pro eis_md_pipeline::move_reports_to_darts
  self->stage_title, 'Move reports to DARTS'

end

pro eis_md_pipeline::tidy_up
  self->stage_title, 'Tidy up'
  self->close_logs
end

pro eis_md_pipeline::exit, val, msg
  self->stage_title, 'Exit'
  self->main_log, 'Finished: ' + strtrim(string(val), 2) + ' ' + msg
  self->close_logs
  ; release objects
  obj_destroy, *self.decompressor
end

function eis_md_pipeline::force_reformat
  return, self.force_reformat eq 1
end

pro eis_md_pipeline__define

  struct = { eis_md_pipeline,     $
             local_log      : '', $
             local_log_unit : 99, $
             fits_reformat_log : '', $

             pipeline_log   : '', $
             md_split_check_log : '', $
             joined_files_log   : '', $
             merge_dir          : '', $
             join_dir       : '', $
             fits_dir       : '', $
             log_dir        : '', $
             shutter_dir    : '', $
             received_files_log : '', $
             rescued_fits_dir   : '', $
             nursery            : '', $
             decompressed_nursery : '', $
             decompressed_dir     : '', $

             sdtp           : '', $

             compressed_files_count         : 0L, $
             rescued_compressed_files_count : 0L, $
             decompressed_files_count       : 0L, $

             sdate          : '', $
             edate          : '', $
             stime          : '', $
             etime          : '', $

             force_reformat : 0L, $
             fetch_only     : 0L, $
             testing        : '', $
             special        : '' , $

             decompressor   : ptr_new(obj_new()), $
             reformatter    : ptr_new(obj_new()) }

end
