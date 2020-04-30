pro eis_md_pipeline::md_decomp, count, files, rescued=rescued
  *self.decompressor->initialise, self.decompress_log, verbose_level=verbose_level, rescued=rescued
;  openw, rat, '/Volumes/Data/Hinode/decompression/development_decomp_record.txt', /get_lun, /append
  openw, rat, self.decompression_master_record, /get_lun, /append
  for i = 0, count - 1 do begin
     *self.decompressor->perform_decompression, files[i]
     *self.decompressor->report, rat ; Check internally, do only if success?
     *self.decompressor->tidy_up
  endfor
  close, rat,
  free_lun, rat
end

; type = ok or rescued
pro eis_md_pipeline::decompress_data, rescued=rescued
  if keyword_set(rescued) then begin
  	 SET_PARAMETERS_TO_RESCUE
     *self.local_logger->stage_title, 'Mission data decompress for rescued files'
     src_dir = self.rescued_dir
     dest_dir = self.rescued_decompressed_dir
  endif else begin
  	 SET_PARAMETERS_TO_NORMAL
     *self.local_logger->stage_title, 'Mission data decompress'
     src_dir = self.join_dir
     src_dir = self.decompressed_dir
  endelse
  files = file_search(src_dir + '/eis_md_*', count=count)
  if keyword_set(rescued) then self.compressed_files_count = count else self.rescued_compressed_files_count = count
  if count eq 0 then begin

  end else begin
     if *self.decompressor ne !NULL then self.decompressor = ptr_new(obj_new('eis_md_decompressor'))
     self->md_decomp, count, files, rescued=rescued
     files = file_search(dest_dir + '/eis_md_*', count=count)
     if keyword_set(rescued) then begin
        self.rescued_decompressed_files_count = count
        self->log, 'Number of rescued decompressed files: ' + strtrim(string(count), 2)
     end else begin
        self.decompressed_files_count = count
        self->log, 'Number of decompressed files: ' + strtrim(string(count), 2)
     endelse
  endelse
end

define(`SET_PARAMETERS_TO_RESCUE', `     *self.local_logger->stage_title, \'Mission data decompress for rescued files\'\
     src_dir = self.rescued_dir\
     dest_dir = self.rescued_decompressed_dir')
