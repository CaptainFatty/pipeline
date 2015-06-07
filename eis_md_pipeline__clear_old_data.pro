pro eis_md_pipeline::clear_merge_directories
  self->shell, '/bin/cd ' + self.received_dir + ' && /bin/rm -f eis_md_* eis_status* eis_dmp*'
  *self.local_logger->shell, '/bin/cd ' + self.join_dir  + ' && /bin/rm -f eis_md*'
end

pro eis_md_pipeline::clear_rescue_directories
  self->shell, '/bin/cd ' + self.rescued_dir + ' && /bin/rm -f eis_md_*'
  self->shell, '/bin/cd ' + self.rescued_decompressed_dir + ' && /bin/rm -f eis_md_*'
  self->shell, '/bin/cd ' + self.rescued_fits_dir + ' && /bin/rm -f eis_md_*'
end

pro eis_md_pipeline::clear_fits_directories
  *self.local_logger->shell, '/bin/cd ' + self.fits_dir  + ' && /bin/rm -f eis_l0*'
end

pro eis_md_pipeline::clear_temporary_log_directories

end

pro eis_md_pipeline::clear_old_data
;  *self.local_logger->stage_title, 'Removing old data'
  self->stage_title, 'Removing old data'
  self->clear_merge_directories
  self->clear_rescue_directories
;  self->clear_fits_directories
;  self->clear_temporary_log_directories
end
