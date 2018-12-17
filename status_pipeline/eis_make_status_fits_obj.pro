; Main procedure
; date_str = 'yyyymmdd'
; timing_dir is where the timing files can be found
; in_dir is where the split hk files are
; output is where to put the fits files
;pro eis_make_status_fits_obj, date_str, timing_dir, in_dir, output=output
;
;    ; Make a fits file for each APID type...
;    if keyword_set(output) then begin
;        fits_base = output
;    end else begin
;        fits_base = '/tmp/' ; Where to write the fits file
;    endelse
;
	fits='$HOME/work/localdata/pipeline/fits/'
	src='$HOME/work/localdata/merge/filtered/'
	timing='$HOME/work/localdata/merge/timing/'
	
	sts1_reformatter = obj_new('sts1_reformatter', fits) 
	sts1_reformatter.reformat(src + 'eis_sts1_20120509_123000', timing + 'sts1_20120509_123000.tim')
	sts1_reformatter.reformat(src + 'eis_sts1_20120509_140000', timing + 'sts1_20120509_140000.tim')
	
OR
		
	sts1_data=['eis_sts1_20120509_123400', '...']
	sts1_timing=['sts1_20120509_123400.tim, '...]

	sts1_reformatter = obj_new('sts1_reformatter', fits) 
	
	for file=0,15 do begin
		sts1_reformatter->reformat(src+sts1_data[file], timing+sts1_timing[file])
		...
	endfor
	
OR

	sts1=0
	sts2=1
	...
	eis_make_status_fits, sts1, 'eis_sts_20120509_00001_sts1', timing+'sts1_20120509_000000.tim', output='foo' 
	...
	eis_make_status_fits, sts2, 'eis_sts_20120509_00001_sts2', timing+'sts2_20120509_000000.tim', output='foo' 
	
OR

	eis_make_status_fits, 'sts1', 'eis_sts_20120509_00001_sts1', timing+'sts1_20120509_000000.tim', output='foo' 
	...
	eis_make_status_fits, 'sts2', 'eis_sts_20120509_00001_sts2', timing+'sts2_20120509_000000.tim', output='foo' 
	
OR

	eis_make_status_fits_sts1, 'eis_sts_20120509_00001_sts1', timing+'sts1_20120509_000000.tim', interval=2, num_packets=500, 'fits_dir'
	...
	eis_make_status_fits_sts2, 'eis_sts_20120509_00001_sts2', timing+'sts2_20120509_000000.tim', output='foo' 

	
	
	
	
	
	
	
	
	
	
	
	------------------------
	
	sts1_reformatter = obj_new('sts1_reformatter', date_str, timing_dir, in_dir, fits_base)
	sts2_reformatter = obj_new('sts2_reformatter', date_str, timing_dir, in_dir, fits_base)
	sts3_reformatter = obj_new('sts3_reformatter', date_str, timing_dir, in_dir, fits_base)
	hk1_reformatter = obj_new('hk1_reformatter', date_str, timing_dir, in_dir, fits_base)
	hk2_reformatter = obj_new('hk2_reformatter', date_str, timing_dir, in_dir, fits_base)
	hk3_reformatter = obj_new('hk3_reformatter', date_str, timing_dir, in_dir, fits_base)
	sot_reformatter = obj_new('sot_reformatter', date_str, timing_dir, in_dir, fits_base)
	mdp_reformatter = obj_new('mdp_reformatter', date_str, timing_dir, in_dir, fits_base)

	for ref_time = 0, 15 do begin
		sts1_reformatter->reformat(ref_time)
		sts2_reformatter->reformat(ref_time)
		sts3_reformatter->reformat(ref_time)
		hk1_reformatter->reformat(ref_time)
		hk2_reformatter->reformat(ref_time)
		hk3_reformatter->reformat(ref_time)
		sot_reformatter->reformat(ref_time)
		mdp_reformatter->reformat(ref_time)
	endfor
	
	obj_destroy, sts1_reformatter
	obj_destroy, sts2_reformatter
	obj_destroy, sts3_reformatter
	obj_destroy, hk1_reformatter
	obj_destroy, hk2_reformatter
	obj_destroy, hk3_reformatter
	obj_destroy, sot_reformatter
	obj_destroy, mdp_reformatter

end
