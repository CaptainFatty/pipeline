pro eis_md_pipeline::perform_join, files, joined_files
  self->trace, 'eis_md_pipeline__fetch_data::perform_join'
end

pro eis_md_pipeline::record_received_files, files
  self->log, 'eis_md_pipeline__fetch_data::record_received_files'
  print, 'eis_md_pipeline::record_received_files: ', files
  openu, lun, self.received_files_log, /get_lun, error=err
  if err ne 0 then begin
    self->log, 'Can''t open received files log'
  endif else begin
    writeu, lun, files
    close, lun, /force
    free_lun, lun
  endelse
end

; # Index into end times array
;$index = 0;

; OUT: files, count
pro eis_md_pipeline::fetch_data, received_files
  self->trace, 'eis_md_pipeline__fetch_data::fetch_data'
  ;*self.local_logger->stage_title, 'Fetching data'
  self->stage_title, 'Fetching data'

  self->shell, self.sdtp + ' merge usc34 band=3 sdate=' + self.sdate + ' edate=' + self.edate + ' stime=' + self.stime + ' etime=' + self.etime
  files = file_search(self.received_dir + '/eis_md_*', count=count)
  self->log, 'Number of files received: ' + strtrim(string(count), 2)
  if count ne 0 then begin
    self->record_received_files, files
  endif
  self.received_files_count = count
  if count eq 0 then begin
     msg = 'No mission data files received'
     self->log, msg
     if not self.interactive then self->update_pending_file
     self->exit, 99, msg
  endif

end
