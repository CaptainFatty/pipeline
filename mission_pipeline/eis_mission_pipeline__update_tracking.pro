  ; Update tracking files
pro eis_mission_pipeline::update_tracking
  self->log, 'eis_mission_pipeline__update_tracking::update_tracking'
  if (self.interactive eq false) and (self.scheduled eq true) then begin
     openw, lu, self.track_file, /get_lun
     print, lu, self.sdate + ' ' + self.edate + ' ' + self.stime + ' '  + self.etime
     close, lu
     free_lun, lu
  endif
  openw, lu, self.record_file, /get_lun, /append
  print, lu, self.sdate + ' ' + self.edate + ' ' + self.stime + ' '  + self.etime
  close, lu
  free_lun, lu
end
