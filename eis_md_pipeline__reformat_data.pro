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
  *self.local_logger->stage_title, 'Mission data reformat'
  if self.decompressed_files_count eq 0 then begin

  end else begin
     self->make_md_fits, count, files, rescued=rescued
     files = file_search(self.fits_dir + '/eis_l0*', count=count)
     self->log, 'Number of fits files: ' + strtrim(string(count), 2)
  endelse
end
