pro eis_md_pipeline::compress_fits
  self->log, 'eis_md_pipeline__compress_fits::compress_fits'
  *self.local_logger->stage_title, 'Compress fits files'
  *self.local_logger->shell, '/bin/cd ' + self.fits_dir + ' && gzip -f *'
  *self.local_logger->shell, '/bin/cd ' + self.rescued_fits_dir + ' && gzip -f *'
end
