pro eis_md_pipeline::md_ccsds_split_check, files
;  perform(*LOG, $state, "$HOME/bin/ccsds_merge_md_split_check $merge_dir > $merge_dir/md_split_check.txt") ;
  *self.local_logger->shell, '${HOME}/bin/ccsds_merge_split_check ' + self.merge_dir + ' > ' + self.merge_dir + '/' + self.md_split_check_log

;  perform(*LOG, $state, "$HOME/bin/md_join_merge.py $merge_dir/md_split_check.txt") ;
  *self.local_logger->shell, '${HOME}/bin/md_join_merge.py ' + self.md_split_check_log

;  @joined_files = `ls $HOME/tmp/join/ | grep eis_md`       ;
  files = file_search(self.join_dir + '/eis_md*', count=count)

;  $log_msg_str = "Number of joined files: " . @joined_files ;
  self->log,' Number of joined files: ' + strtrim(string(count), 2)

  if count eq 0 then begin
     msg = 'No joined files - quitting'
     self->log, msg
;;;     self->exit, 1, msg
  endif

  *self.local_logger->shell, '/bin/rm ' + self.merge_dir + '/eis_md*'
  *self.local_logger->shell, '/bin/mv ' + self.join_dir + '/eis_md* ' + self.merge_dir

;  openw, lun, self.joined_files_log, /get_lun, error=err
;  writeu, lun, files
;  close, lun, /force
;  free_lun, lun
end

pro eis_md_pipeline::md_missing_packet_check
;  perform(*LOG, $state, "$HOME/bin/pipeline_md_hdr_dump $merge_dir > $merge_dir/md_hdr_check.txt");
; Do the mission data header dump, which also updates the
; engineering.txt file
  *self.local_logger->shell, '${HOME}/bin/pipeline_md_hdr_dump ' + self.merge_dir + ' > ' + self.merge_dir + '/md_hdr_check.txt'

; perform(*LOG, $state, "$HOME/bin/pipeline_ccsds_check $merge_dir > $merge_dir/ccsds_hdr_check.txt");
; Do the ccsds check which detects missing packets, updating
; missing_packets.txt
  *self.local_logger->shell, '${HOME}/bin/pipeline_ccsds_check ' + self.merge_dir + ' > ' + self.merge_dir + '/ccsds_hdr_check.txt'
  *self.md_checker->check_ccsds, self.merge_dir, self.ccsds_check_log

  *self.local_logger->shell, 'Do non-compressed check, move files?'
  *self.local_logger->shell, 'Move damaged files to the nursery'
  *self.local_logger->shell, 'Move headless files aside'
  *self.local_logger->shell, 'Move incomplete files aside'

  files = file_search(self.merge_dir + '/eis_md*', count=count)
  self->log, 'Number of compressed files: ' + strtrim(string(count), 2)
  self.compressed_files_count = count
end

pro eis_md_pipeline::check_data, files
  *self.local_logger->stage_title, 'Mission data check'
  self->md_ccsds_split_check, files
  self->md_missing_packet_check
end
