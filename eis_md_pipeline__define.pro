pro eis_md_pipeline::init_logs
  eis_local = '/nasA_solar1/work/eis/localdata'
  logs = eis_local + '/log'
  self.log_dir = logs + '/pipeline'
  self.shutter_dir = logs + '/shutter'
end

pro eis_md_pipeline::init, how=interactive, flag=flag, sdate=sdate, edate=edate, stime=stime etime=etime
  if keyword_set(interactive) then begin

  end else begin

  endelse

  self->init_logs
  self.decompressor = obj_new('eis_md_decompressor')

end

pro eis_md_pipeline::shell, action
  lu = self.main_log_unit
  print, lu, action
  spawn, action, result, /noshell
end

pro eis_md_pipeline::log, msg
  lu = self.local_log_unit
  print, lu, msg
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
  self->clear_rescue_directories
  self->clear_fits_directories
  self->clear_temporary_log_directories
end

pro eis_md_pipeline::fetch_data
  self->stage_title, 'Fetching data'
  self->shell, self.sdtp + ' merge usc34 band=3 sdate=' + self.sdate + ' edate=' + self.edate + 'stime=' + self.stime + ' etime=' + self.etime
end

pro eis_md_pipeline::record_received_files, files
  openu, lun, self.received_files_log, /get_lun
  writeu, lun, files
  close, lun, /force
  free_lun, lun
end

pro eis_md_pipeline::ccsds_split_check, files
;  perform(*LOG, $state, "$HOME/bin/ccsds_merge_md_split_check $merge_dir > $merge_dir/md_split_check.txt") ;
  self->shell, '${HOME}/bin/ccsds_merge_split_check ' + self.merge_directory + ' > ' + self.merge_directory + '/' + self.md_split_check_log

;  perform(*LOG, $state, "$HOME/bin/md_join_merge.py $merge_dir/md_split_check.txt") ;
  self->shell, '${HOME}/bin/md_join_merge.py ' + self.md_split_check_log

;  @joined_files = `ls $HOME/tmp/join/ | grep eis_md`       ;
  files = file_search(self.join_directory + '/eis_md*', count=count)

;  $log_msg_str = "Number of joined files: " . @joined_files ;
  self->log,' Number of joined files: ' + strtrim(string(count), 2)

  if count eq 0 then begin
     msg = 'No joined files - quitting'
     self->log, msg
     self->exit, 1, msg
  endif

  self->shell, '/bin/rm ' + self.merge_directory + '/eis_md*'
  self->shell, '/bin/mv ' + self.join_directory + '/eis_md* ' + self.merge_directory

  openw, lun, self.joined_files_log, /get_lun, error=err
  writeu, lun, files
  close, lun, /force
  free_lun, lun
end

pro eis_md_pipeline::missing_packet_check
;  perform(*LOG, $state, "$HOME/bin/pipeline_md_hdr_dump $merge_dir > $merge_dir/md_hdr_check.txt");
; Do the mission data header dump, which also updates the
; engineering.txt file
  self->shell, '${HOME}/bin/pipeline_md_hdr_dump ' + self.merge_directory + ' > ' + self.merge_directory + '/md_hdr_check.txt'

; perform(*LOG, $state, "$HOME/bin/pipeline_ccsds_check $merge_dir > $merge_dir/ccsds_hdr_check.txt");
; Do the ccsds check which detects missing packets, updating
; missing_packets.txt
  self->shell, '${HOME}/bin/pipeline_ccsds_check ' + self.merge_directory + ' > ' self.merge_directory + '/ccsds_hdr_check.txt'

  self->shell, 'Do non-compressed check, move files?'
  self->shell, 'Move damaged files to the nursery'
  self->shell, 'Move headless files aside'
  self->shell, 'Move incomplete files aside'

  files = file_search(self.merge_directory + '/eis_md*', count=count)
  self->log, 'Number of compressed files: ' + strtrim(string(count), 2)
  self.compressed_files = count
end

pro eis_md_pipeline::check_data
  self->stage_title, 'Mission data check'
  files = file_search(self.merge_directory + '/eis_md_*', count=count)
  if count eq 0 then begin
     msg = 'No mission data files received'
     self->log, msg
     self->update_track_file, self.sdate, self.edate
     self->exit, 99, msg
  end if
  self->log, 'Number of files received: ' + strtrim(string(count), 2)
  self->record_received_files, files
  self->md_ccsds_split_check, files
  self->md_missing_packet_check
end

pro eis_md_pipeline::md_decomp, count, files, type=rescued
  *self.decompressor->initialise, self.decompress_log, type=rescue
  for i = 0, count - 1 do begin
     *self.decompressor->perform_decompression, files[i], type=rescued
  endfor
end

; type = ok or rescued
pro eis_md_pipeline::decompress_data, type=rescued
  self->stage_title, 'Mission data decompress'
  if keyword_set(rescued) then src_dir = self.nursery else src_dir = self.merge_directory
  files = file_search(src_dir + '/eis_md_*', count=count)
  if keyword_set(rescued) then self.compressed_file_count = count else self.rescued_compressed_file_count = count
  if count eq 0 then begin
     
  end else begin
     self->md_decomp, count, files, type=rescued
     if keyword_set(rescued) then dest_dir = self.decompressed_nursery else src_dir = self.decompressed_directory
     files = file_search(dest_dir + '/eis_md_*', count=count)
     if keyword_set(rescued) then begin
        self.decompressed_file_count = count
        self->log, 'Number of decompressed files: ' + strtrim(string(count), 2)
     end else begin
        self.rescued_decompressed_file_count = count
        self->log, 'Number of rescued decompressed files: ' + strtrim(string(count), 2)
     endelse
  end else
end

pro eis_md_pipeline::make_md_fits, count, files, type=rescue
  for i = 0, count - 1 do begin
     data = obj_new('eis_data', files[i], datasource='ccsds', hdr=hdr)
     exp_info = (hdr[0])->getexp_info()
     seq_id = exp_info.seq_id
     rast_id = exp_info.rast_id
     plan = obj_new('eis_plan')
     eis_mkfits, data, hdr, /doplan, /dospcd, fitsdir=self.fits_directory, outfile=self.fits_reformat_log
     if n_elements(logfile) ne 0 then printf, lu, files[i] + ' ' + outfile
     obj_destroy, plan ; or move out of loop?
     obj_destroy, data
  endfor
end

pro eis_md_pipeline::reformat_data, type=rescue
  self->stage_title, 'Mission data reformat'
  if !decompressed_files eq 0 then begin

  end else begin
     self->make_md_fits, count, files
     files = file_search(self.fits_directory + '/eis_l0*', count=count)
     self->log, 'Number of fits files: ' + strtrim(string(count), 2)
  endelse
end

pro eis_md_pipeline::resuce_damaged_data

end

pro eis_md_pipeline::compress_fits
  self->stage_title, 'Compress fits files'
  self->shell, '/bin/cd ' + self.fits_directory + ' && gzip -f *'
  self->shell, '/bin/cd ' + self.rescued_fits_directory + ' && gzip -f *'
end

pro eis_md_pipeline::update_soda

end

pro eis_md_pipeline::remove_ql

end

pro eis_md_pipeline::generate_reports

end

pro eis_md_pipeline::tidy_up

end

pro eis_md_pipeline::exit, val, msg
  self->main_log, 'Finished: ' + strtrim(string(val), 2) + ' ' + msg
  self->close_logs
  ; release objects
end

pro eis_md_pipeline__define

  struct = { eis_md_pipeline, $
             pipeline_log : ' ', $
             foo          : ' ', $
             
             decompressor : ptr_new(obj_new()), $
             reformatter  : ptr_new(obj_new())  }

end
