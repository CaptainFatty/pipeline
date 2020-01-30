;;; What doe sthis do?
pro eis_status_pipeline::perform_join, files, joined_files
  self->trace, 'eis_status_pipeline__fetch_data::perform_join'
end

pro eis_status_pipeline::record_received_files, files
  self->trace, 'eis_status_pipeline__fetch_data::record_received_files'
;  print, 'eis_md_pipeline::record_received_files: ', files
  self->log, 'eis_md_pipeline::record_received_files: ', files
  openu, lun, self.received_files_log, /get_lun, error=err
  if err ne 0 then begin
    self->log, 'Can''t open received files log'
  endif else begin
    writeu, lun, files
    close, lun, /force
    free_lun, lun
  endelse
end

; OUT: files, count
pro eis_status_pipeline::fetch_data, received_files
  self->trace, 'eis_status_pipeline__fetch_data::fetch_data'
  ;*self.local_logger->stage_title, 'Fetching data'
;  self->stage_title, 'Fetching data'
  ; self->stage_title, 'Fetch new data'

  index = 0
  end_date = self.sdate
  while index lt 16 do begin
    if index eq 15 then end_date = self.edate
    self->shell, self.sdtp + ' merge usc34 band=3 sdate=' + self.sdate + ' edate=' + end_date + ' stime=' + self.start_times[index] + ' etime=' + self.end_times[index]
    index = index + 1
  endwhile

  received_files = file_search(self.received_dir + '/eis_sts*', count=count)
  self->log, 'Number of files received in ' + self.received_dir + ': ' + strtrim(string(count), 2)
  if count ne 0 then begin
    self->record_received_files, received_files
  endif
  self.received_files_count = count
  if count eq 0 then begin
     msg = 'No status data files received'
     self->log, msg
     if not self.interactive then self->update_pending_file
;;;;;;;;;;;;;     self->exit, 99, msg
  endif

end
