; Stuff
; Another comment
pro auto_mk_fits, out_dir

	eis_make_status_fits_obj, output=out_dir
	
;    files = findfile(src_dir + '/eis_sts_*', count=count)
;    if count eq 0 then begin
;        print, 'No files'
;        return
;    endif
;
;    last_file = n_elements(files) - 1
;    FOR i = 0, last_file do BEGIN
;;        print, 'Converting... ', files[i]
;        eis_make_status_fits_obj, files[i], output=out_dir
;    endfor

end
