;+
; NAME: eis_pipeline__get_root.pro
;
; PURPOSE: Tidy up routines for the mission data pipeline.
;          Closes log files and disposes of objects.
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


function eis_pipeline::get_root
;  self->trace, 'eis_pipeline__get_root::get_root'

	return, getenv('HOME') + '/work/localdata/sdtp/merge/'
	
end
