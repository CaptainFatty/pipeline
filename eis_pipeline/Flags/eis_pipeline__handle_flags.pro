;+
; NAME: eis_pipeline__flag_handling.pro
;
; PURPOSE: Super class for the EIS mission data and status data pipelines
;
; CATEGORY: Science
;
; CALLING SEQUENCE: None
;
; INPUTS: None
;
; KEYWORD PARAMETERS: None
;
; OUTPUTS: None
;
; CALLS: None
;
; COMMON BLOCKS:None.
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

pro eis_pipeline::handle_flags, no_soda=no_soda, no_fetch=no_fetch, fetch_only=fetch_only, no_split=no_split,fits_only=fits_only
  self->trace, 'eis_pipeline::handle_flags'
  if keyword_set(no_soda) then begin
     print, 'no_soda set, setting flag'
     self->set_flag, 'no-soda'
  end

  if keyword_set(no_fetch) then begin
     print, 'no_fetch set, setting flag'
     self->set_flag, 'no-fetch'
  end

  if keyword_set(fetch_only) then begin
     print, 'fetch_only set, setting flag'
     self->set_flag, 'fetch-only'
  end

  if keyword_set(no_split) then begin
     print, 'run_eis_status_pipeline: no_split set, setting flag'
     self->set_flag, 'no-split'
  end

  if keyword_set(fits_only) then begin
     print, 'run_eis_status_pipeline: fits_only set, setting flag'
     self->set_flag, 'fits-only'
  end

end
