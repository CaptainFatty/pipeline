pro eis_md_pipeline::perform_join, files, joined_files

end

pro eis_md_pipeline::record_received_files, files
  print, 'eis_md_pipeline::record_received_files: ', files
;  openu, lun, self.received_files_log, /get_lun
;  writeu, lun, files
;  close, lun, /force
;  free_lun, lun
end

; OUT: files, count
pro eis_md_pipeline::fetch_data, joined_files
  *self.local_logger->stage_title, 'Fetching data'
  *self.local_logger->shell, self.sdtp + ' merge usc34 band=3 sdate=' + self.sdate + ' edate=' + self.edate + ' stime=' + self.stime + ' etime=' + self.etime
  files = file_search(self.received_dir + '/eis_md_*', count=count)
  self->log, 'Number of files received: ' + strtrim(string(count), 2)
  self->record_received_files, files
  self.received_files_count = count
  if count eq 0 then begin
     msg = 'No mission data files received'
     self->log, msg
     if not self.interactive then self->update_pending_file
     self->exit, 99, msg
  endif

  self->perform_join, files, joined_files
end
