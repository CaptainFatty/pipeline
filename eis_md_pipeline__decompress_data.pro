pro eis_md_pipeline::md_decomp, count, files, rescued=rescued
  *self.decompressor->initialise, self.decompress_log, /mrege, verbose_level=verbose_level, rescued=rescued
;  openw, rat, '/Volumes/Data/Hinode/decompression/development_decomp_record.txt', /get_lun, /append
  openw, rat, self.decompression_master_record, /get_lun, /append
  for i = 0, count - 1 do begin
     *self.decompressor->perform_decompression, files[i], rescued=rescued
     if *self.decompressor->report, rat ; Check internally, do only if success?
     *self.decompressor->tidy_up
  endfor
  close, rat,
  free_lun, rat
end

; type = ok or rescued
pro eis_md_pipeline::decompress_data, rescued=rescued
  *self.local_logger->stage_title, 'Mission data decompress'
  if keyword_set(rescued) then src_dir = self.rescued_dir else src_dir = self.received_dir
  files = file_search(src_dir + '/eis_md_*', count=count)
  if keyword_set(rescued) then self.compressed_files_count = count else self.rescued_compressed_files_count = count
  if count eq 0 then begin
     
  end else begin
;     if *self.decompressor eq ptr_new() then self.decompressor = ptr_new(obj_new('eis_md_decompressor'))
     if keyword_set(rescued) then dest_dir = self.rescued_decompressed_dir else src_dir = self.decompressed_dir
     self->md_decomp, count, files, rescued=rescued
     files = file_search(dest_dir + '/eis_md_*', count=count)
     if keyword_set(rescued) then begin
        self.decompressed_files_count = count
        self->log, 'Number of decompressed files: ' + strtrim(string(count), 2)
     end else begin
        self.rescued_decompressed_files_count = count
        self->log, 'Number of rescued decompressed files: ' + strtrim(string(count), 2)
     endelse
  endelse
end
