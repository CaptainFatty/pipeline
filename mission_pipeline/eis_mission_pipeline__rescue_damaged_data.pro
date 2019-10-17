;+
; NAME: eis_mission_pipeline__rescue_damaged_data.pro
;
; PURPOSE: Calls the decompress and make fits procedures again this time
;          pointing to the rescued data.
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

pro eis_mission_pipeline::rescue_damaged_data
  self->log, 'eis_mission_pipeline__rescue_damaged_data::rescue_damaged_data'
  self->decompress_data, /rescued
  self->reformat_data, /rescued
end
