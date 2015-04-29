pro eis_md_pipeline::close_logs
;  lu = self.local_log_unit
;  close, lu, /force
;  free_lun, lu
  *self.local_logger->close_output
end

pro eis_md_pipeline::tidy_up
  *self.local_logger->stage_title, 'Tidy up'
  self->close_logs
end
