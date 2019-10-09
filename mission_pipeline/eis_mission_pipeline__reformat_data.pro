;+
; NAME: eis_md_pipeline__reformat_data.pro
;
; PURPOSE: Calls eis_mkfits to format the data into FITS files.
;
; CATEGORY: Science
;
; CALLING SEQUENCE: None
;
; INPUTS: None
;
; KEYWORD PARAMETERS: rescued
;
; OUTPUTS: None
;
; CALLS: eis_mkfits, make_md_fits
;
; COMMON BLOCKS: None.
;
; PROCEDURE:
;
; RESTRICTIONS: Uses SolarSoft
;
; MODIFICATION HISTORY:
;	  23/11/05 mcrw	wrote
;   14/08/06 mcrw	added documentation
;
;-

pro eis_md_pipeline::reformat_data, rescued=rescued
  self->log, 'eis_md_pipeline__reformat_data::reformat_data'
  *self.local_logger->stage_title, 'Mission data reformat'
  if self.decompressed_files_count eq 0 then begin

  end else begin
     self.reformatter = ptr_new(obj_new('eis_mission_reformatter'))
     *self.reformatter->initialize, self.local_logger, trace=trace ; give split_directory and fits_dir here too
     *self.reformatter->reformat, count, files, rescued=rescued
     files = file_search(self.fits_dir + '/eis_l0*', count=count)
     self->log, 'Number of fits files: ' + strtrim(string(count), 2)
  endelse
end
