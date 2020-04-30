; pro fits_write, lu, data, col, row, name
;   errmsg = ''
;   fxbwrite, lu, data, col, row, errmsg=errmsg
;   if errmsg ne '' then print, '*** fxbwrite error for ' + name + ': ' + errmsg
; end

; function eis_status_pipeline::get_status_grt, filename
; ;;;???    break_file, filename, disk_log, dir, filnam, ext, fversion, node
; 	return, strmid(filename, 8, 8) + strmid(filename, 17, 6)
; end

; pro eis_status_pipeline::set_status_sc_times
; 	sc_time_array = eis_unpack_sc_time(*self.packet_array)
; 	self.sc_start = sc_time_array[0]
; 	self.sc_end   = sc_time_array[n_elements(sc_time_array) - 1]
; end

; pro eis_status_pipeline::set_status_ut_times
; 	self.ut_start  = eis_ti2utc(self.sc_start, self.grt)
;     self.ut_end    = eis_ti2utc(self.sc_end, self.grt)
;     self.ut_start1 = self->convert_utc(self.ut_start)
;     self.ut_end1   = self->convert_utc(self.ut_end)
; end

; pro eis_status_pipeline::set_date_information
;     self.grt = self->get_status_grt(self.filename)
; 	self->set_status_sc_times
; 	self->set_status_ut_times
; end

; pro unpack_primary_ccsds_header, apid, sequence_count, length
; 	temp = (*self.packet_array).apid
; 	byteorder, temp, /ntohs
; 	apid = uint(temp) and '3FFF'X
; 	temp = (*self.packet_array).scount
; 	byteorder, temp, /ntohs
; 	sequence_count = uint(temp) and '3FFF'X
; 	temp = (*self.packet_array).plength
; 	byteorder, temp, /ntohs
; 	length = uint(temp)
; end

; pro eis_status_pipeline::unpack_sc_time, packet_array, sc_time
; 	temp = (*self.packet_array).sc_time
; 	byteorder, temp, /ntohl
; 	sc_time = ulong(temp)
; end

;
; Convert yyyymmddThhmmss to yyyy-mm-ddThh:mm:ss.000
;
; function eis_status_pipeline::convert_utc, ut_str
;     yr_str = strmid(ut_str, 0, 4)
;     mo_str = strmid(ut_str, 4, 2)
;     da_str = strmid(ut_str, 6, 2)
;     hr_str = strmid(ut_str, 9, 2)
;     mi_str = strmid(ut_str, 11, 2)
;     se_str = strmid(ut_str, 13, 2)
;     return, yr_str+'-'+mo_str+'-'+da_str+'T'+hr_str+':'+mi_str+':'+se_str+'.000'
; end

; pro eis_status_pipeline::create_fits_filename ; ,self.date_info, self.fits_file
;
;     ; Create the fits file filename
; ;;;???    break_file, file, disk_log, dir, filnam, ext, fversion, node
;
;     converted_ok = strpos(self.ut_start, 'T', 8)
;     if converted_ok ne -1 then begin ; Good conversion
;         ut_str = self.ut_start
;         strput, ut_str, '_', 8
;         ; Make fits file name from ut string
;         self.fits_file = self.fits_base + 'eis' + self.file_type + '_' + ut_str + '.fits'
;         ; More processing for header (convered ok etc)
;        self.ti_conv = 1
;     endif else begin
;         ; Make fits file name from grt string
;         self.fits_file = self.fits_base + 'eis' + self.file_type + '_' + yr_str + '_' + hr_str + '.fits'
;         ; More processing for header, bad case
;         self.ti_conv = 0
;     endelse
; end

; pro eis_status_pipeline::add_primary_header_keywords, packet_array
; ;print, '--- : eis_add_primary_header_keywords'
;     header = self->header()
;     fxaddpar, header, 'origin', 'ISAS', 'Institute where file was written'
;     fxaddpar, header, 'telescop', 'Hinode', 'Satellite name (Solar-B)'
;     fxaddpar, header, 'instrume', 'EIS','EUV Imaging Spectrometer'
;     fxaddpar, header, 'program', 'eis_make_status_fits_new','Program used to generate the file'
;     fxaddpar, header, 'version', '1.0', 'Program version'
;     fxaddpar, header, 'release', 'Final', 'Confidence level'
;
;     ; Use the sctime array and grt to add start and end
;     ; times for the archive
;     fxaddpar, header, 'gndtime', self.grt, 'Ground receive time'
;
;     fxaddpar, header, 'ti0', string(self.sc_start, format='(Z08)'), 'Archive start time - Spacecraft time (TI)'
;     fxaddpar, header, 'ti1', string(self.sc_end,format='(Z08)'), 'Archive end time - Spacecraft time (TI)'
;
; ;;;    yr_str = strmid(ut_start, 0, 8)
; ;;;    hr_str = strmid(ut_start, 9, 6)
; ;;;    ut_start1 = eis2cal(yr_str+hr_str)
; ;;;    yr_str = strmid(ut_end, 0, 8)
; ;;;    hr_str = strmid(ut_end, 9, 6)
; ;;;    ut_end1 = eis2cal(yr_str+hr_str)
;
; ;    fxaddpar, header, 'date_obs', ut_start1, 'Archive start time (UT)'
; ;    fxaddpar, header, 'date_end', ut_end1, 'Archive end time (UT)'
;
;     fxaddpar, header, 'date_obs', self.ut_start1, 'Archive start time (UT)'
;     fxaddpar, header, 'date_end', self.ut_end1, 'Archive end time (UT)'
;     fxaddpar, header, 'ti_conv', self.ti_conv eq 1 ? 'T' : 'F', 'Conversion to UT success'
;
;     ; Add packet frequency
;     fxaddpar, header, 'interval', self.pint, 'Packet frequencey (seconds)'
; end

; function eis_status_pipeline::read_timing_file, file
; 	es=read_ascii(file)
; 	d=es.field1
;
; 	print, 'File: ', file
; 	print, 'Amount of data ', n_elements(d)
; 	return, d
; ;	for f in `ls 20110722_*.log`; do ~/tmp/baz.pl $f MDP > $f'.out.MDP'; done
; end

; function eis_status_pipeline::archive_start_time, index
;   return, self.start_times[index]
; ;	return, (self->archive_start_times())[index]
; end

; function eis_status_pipeline::archive_start_times
;   return, self.start_times
; ;	return, ['0000', '0130', '0300', '0430', '0600', '0730', '0900', '1030', '1200', '1330', '1500', '1630', '1800', '1930', '2100', '2230']
; end

; Elapsed number of seconds at the start of each archive.
; function eis_status_pipeline::archive_elapsed_timing, index
;   return, self.elapsed_time[index]
; ;	return, (self->archive_elapsed_timings1())[index]
; end

; Elapsed number of seconds at the start of each archive.
; function eis_status_pipeline::archive_elapsed_timings
;   return, self.elapsed_time
; ;	return, [0, 5400, 10800, 16200, 21600, 27000, 32400, 37800, 43200, 48600, 54000, 59400, 64800, 70200, 75600, 81000]
; end

pro eis_status_pipeline::create_gap_information, timing_data, number_of_gaps, gap_starts, gap_lengths, ref_time
;;;	self->method2, timing_data, self.archive_start_times[ref_time], self.pint

	print, 'Method 2'

	len   = n_elements(timing_data)
	start = self.archive_start_times[ref_time]

	d1 = timing_data - start
	next_start = start + (90 * 60L)

	timings = d1

	timings_diff = timings[1:len-1] - timings[0:len-2]

	; Make sure we don't pick up flase gaps when the timing between
	; successive packets is not constant.
	gap_starts = where(timings_diff gt pint + (pint/2), number_of_gaps)

	timing_diff_at_front = fix(d1[0] / pint)
	if timing_diff_at_front eq pint then timing_diff_at_front = timing_diff_at_front - 1
	missing_from_front = timing_diff_at_front
	; Get number of seconds between last element and start of next period
	timing_diff_at_back = fix(next_start - timing_data[len-1])
	if timing_diff_at_back eq pint then timing_diff_at_back = timing_diff_at_back - 1
	missing_from_back  = fix(timing_diff_at_back / pint)

	;  print, 'Data = ', data
	print, 'Next start = ', next_start
	print, 'last data = ', timing_data[len-1]

	print, 'Missing from front ', missing_from_front
	print, 'Missing from back  ', missing_from_back

	ends_missing = missing_from_front + missing_from_back
	print, 'Ends missing = ', ends_missing
	print, 'number_of_gaps OR ends_missing = ', number_of_gaps or ends_missing
	if number_of_gaps eq 0 and ends_missing eq 0 then begin
		print, 'NO GAPS	array length ', len
		return
	endif

	; Fails if only ends are missing...
	if number_of_gaps ne 0 then begin
		gap_lengths = (fix(timings[gap_starts+1] - timings[gap_starts]) / pint) - 1
     	print, 'Gaps start at ', gap_starts
	    print, 'Lengths are   ', gap_lengths

	    c = n_elements(gap_starts)
	    for i = 0, c-1 do print, timings[gap_starts[i]:gap_starts[i]+1]

	    print, 'Array len ', len + total(gap_lengths) + missing_from_front + missing_from_back
		self.front = missing_from_fron
		self.back  = missing_from_back
	 endif else gap_starts=[0]
	;;;;;;;;;;;;  res = align_data(timing_data, timings_gaps, gap_lengths, missing_from_front, missing_from_back, count)
;	self.timings_gaps = timings_gaps
;	self.gap_lengths  = gap_lengths
;	self.missing_from_front = missing_from_front
;	self.missing_from_back  = missing_from_back
;	self.count = count
end

; Read the timings file.
; start is start time for the file in seconds
; pint is the packet interval in seconds
pro eis_status_pipeline::missing_packets, file, start, pint
  es=read_ascii(file)
  d=es.field1

  print, 'File: ', file
  print, 'Amount of data ', n_elements(d)
  print, 'Start ', start

;;;  method1, d, pint
  method2, d, start, pint
  print

end

function eis_status_pipeline::method2, timing_data, start, pint
  print, 'Method 2'

  len = n_elements(timing_data)
  d1 = timing_data - start
;;;  packets_expected = (90 * 60) / pint
  next_start = start + (90 * 60L)

  timings = d1

  timings_diff = timings[1:len-1] - timings[0:len-2]

  ; Make sure we don't pick up flase gaps when the timing between
  ; successive packets is not constant.
  timings_gaps = where(timings_diff gt pint + (pint/2), count)

  timing_diff_at_front = fix(d1[0] / pint)
  if timing_diff_at_front eq pint then timing_diff_at_front = timing_diff_at_front - 1
  missing_from_front = timing_diff_at_front
  ; Get number of seconds between last element and start of next period
  timing_diff_at_back = fix(next_start - timing_data[len-1])
  if timing_diff_at_back eq pint then timing_diff_at_back = timing_diff_at_back - 1
  missing_from_back  = fix(timing_diff_at_back / pint)

;  print, 'Data = ', data
  print, 'Next start = ', next_start
  print, 'last data = ', timing_data[len-1]

  print, 'Missing from front ', missing_from_front
  print, 'Missing from back  ', missing_from_back

  ends_missing = missing_from_front + missing_from_back
  print, 'Ends missing = ', ends_missing
  print, 'count OR ends_missing = ', count or ends_missing
  if count eq 0 and ends_missing eq 0 then begin
     print, 'NO GAPS	array length ', len
     return, 0
  endif

  ; Fails if only ends are missing...
  if count ne 0 then begin
     gap_lengths = (fix(timings[timings_gaps+1] - timings[timings_gaps]) / pint) - 1

     print, 'Gaps start at ', timings_gaps
     print, 'Lengths are   ', gap_lengths

     c = n_elements(timings_gaps)
     for i = 0, c-1 do print, timings[timings_gaps[i]:timings_gaps[i]+1]

     print, 'Array len ', len + total(gap_lengths) + missing_from_front + missing_from_back
  endif else timings_gaps=[0]
;;;;;;;;;;;;  res = align_data(timing_data, timings_gaps, gap_lengths, missing_from_front, missing_from_back, count)
	self.timings_gaps = timings_gaps
	self.gap_lengths  = gap_lengths
	self.missing_from_front = missing_from_front
	self.missing_from_back  = missing_from_back
	self.count = count
  return, 1
end

function eis_status_pipeline::ends_missing, data, front, back

  data_length = n_elements(data)
  ;;; Above gives data length of 2701 instead of 2700 for 2 second
  ;;; data, so take 1 off????
  new_array = make_array(data_length + front + back-1, /float, value = !values.f_nan)
  new_array[front:front+data_length-1] = data
  return, new_array

end

; Will only be called when gaps have been detected or when only the
; front and/or back elements are missing.
; count is the number of missing elements.
; data is the original housekeeping data.
; gap_indices is an array of indices into data where a gap starta.
; gap_lengths is an array of the number of missing elements in each
; gap.
; front and back are counts of the number of missing elements at the
; front and back of the data array.
function status_reformatter::align_data, data, gap_indices, gap_lengths, front, back, count

  ; Deal with the case where only the end portion(s) is/are missing.
  ends_only_missing = (front or back) and (count eq 0)
  print, 'ends_only_missing = ', ends_only_missing
  if ends_only_missing then return, self->ends_missing(data, front, back)

	if count eq 0 then return, float(data)

print,'align_data: gap_indices, gap_lengths = ', gap_indices, gap_lengths

  ; Create a new float array with all Nans, the size including the
  ; length of the missing elements.
  data_length = n_elements(data)

  ;;; Above gives data length of 2701 instead of 2700 for 2 second
  ;;; data, so take 1 off????
;;;  new_array = make_array(data_length + total(gap_lengths) + front + back-1, /float, value = !values.f_nan)
  new_array = make_array(data_length + total(gap_lengths) + front + back, /float, value = !values.f_nan)

  ; Point the destination pointer at the begining of the
  ; new array, taking into account any missing bits at the front.
  dest = front

  ; Points to the beginning of the data array
  src  = 0

  previous_gap_start = -1
;
;  for i = 0, count - 1 do begin
;     length_until_gap = gap_indices[i] - previous_gap_index
;print,'i length_until_gap src dest ', i, length_until_gap, src, dest
;     new_array[dest:dest + length_until_gap] = data[src:src + length_until_gap]
;
;;     src  = src + length_until_gap + 1
;     dest = dest + length_until_gap + gap_lengths[i] + 1
;
;     src  = gap_indices[i] + 1
;;     src  = src + length_until_gap
;;     dest = dest + length_until_gap + gap_lengths[i]
;
;     previous_gap_index = gap_indices[i]
;  endfor

  for i = 0, count - 1 do begin
     amount_to_copy = gap_indices[i] - (previous_gap_start)
     previous_gap_start = gap_indices[i]
print,'i amount_to_copy gap_start src dest ', i, amount_to_copy, previous_gap_start, src, dest
     new_array[dest:dest + amount_to_copy - 1] = data[src:src + amount_to_copy-1]

     src  = gap_indices[i] + 1
     dest = dest + gap_lengths[i] + amount_to_copy
  endfor

  ; Now copy the remaining data after the last gap.
  ; Both pointers are pointing to the correct locations.
  ; Calculate how much data is left and copy it.
;  data_remaining = (data_length - 1) - src	; gt 0 if more data
;  data_remaining = (data_length) - src	; gt 0 if more data
  data_remaining = data_length - previous_gap_start - 1
  if data_remaining gt 0 then begin
     print,'DATA REMAINING ', data_remaining
     print, 'Dest, src = ', dest, src
; dest is wrong in case of data3
     ; More data is left to be copied
     new_array[dest:dest + data_remaining - 1] = data[src:src + data_remaining - 1]
  endif

  return, new_array

end


;pro status_reformatter::find_missing_data_time, packet_array, sequence_count=sequence_count
;	tmp = packet_array.sc_time
;	byteorder, tmp, /ntohl
;	tmp = ulong(tmp)
;	n = n_elements(tmp)
;	discontinuity = where(tmp[1:n-2]-tmp[0:n-1] gt 64, c)
;
;end
;
;pro status_reformatter::find_missing_data_sequence, packet_array, sequence_count=sequence_count
;	temp = packet_array.scount
;	byteorder, temp, /ntohs
;	sc = uint(temp and '3FFF'X)
;	nos = n_elements(sc)
;	discontinuity = where(sc[0:nos - 2] - sc[1:nos - 1] ne -1, dcount)
;	self.discontinuity = ptr_new(discontinuity)
;	dp=discontinuity+1
;	gap_length=sc[dp]-sc[discontinuity]
 ;   gap_indices=where(gap_length ne 0 and gap_length ne -16383, rg_count)
  ;  self.gap_indices = ptr_new(gap_indices)
;	real_gaps=gap_length[gap_indices]
;	self.real_gaps = ptr_new(real_gaps)
; 	self.n_gaps = n_elements(real_gaps)-1
;
; 	transfer_index = { src_strt:0L,src_end:0L, dst_strt:0L, dst_end:0L }
; 	transfer_indices = replicate(transfer_index, self.n_gaps + 1)
;	source_start_index = 0
;	source_end_index = 0
;	dest_start_index = 0
;	dest_end_index = 0
; 	for i = 0, self.ngaps do begin
;		source_end_index = discontinuity[gap_indices[i]]
;		dest_end_index   = dest_start_index + (source_end_index - source_start_index)
 ;		transfer_indices[i].src_strt = source_end_index
;		transfer_indices[i].src_end  = source_end_index
; 		transfer_indices[i].dst_strt = dest_start_index
; 		transfer_indices[i].dst_end  = dest_start_index
;		dest_start_index = dest_end_index + real_gaps[i]
;		source_start_index = source_end_index + 1
; 	endfor
;	; Now all that may be left is one more good run of numbers
;	source_start_index = source_end_index + 1
;	if source_start_index le an then begin
;		i = self.n_gaps + 1
;		last_count = n_elements(temp[source_start_index:*])	;;;;;;;!!!!!!!!!!!!
;		source_end_index = source_start_index+last_count - 1
;		dest_start_index = dest_end_index + *self.real_gaps[self.n_gaps - 1]
;		dest_end_index = dest_start_index + last_count - 1
 ;		transfer_indices[i].src_strt = source_end_index
;		transfer_indices[i].src_end  = source_end_index
; 		transfer_indices[i].dst_strt = dest_start_index
; 		transfer_indices[i].dst_end  = dest_start_index
;	endif
;	self.transfer_indices = ptr_new(transfer_indices)
;end

;pro status_reformatter::find_missing_data, packet_array
;	if keyword_set(sequence_count) then begin
;		self->find_missing_data_sequence, packet_array
; 	 endif else begin
; 	 	self->find_missing_data_time, packet_array
; 	 end else
;end
;
;function status_reformatter::pad, data
;	array = fltarr(self.expected_n)
;	array[*] = !VALUES.F_NAN
;
;; use real_gaps to index into dp
;	source_start_index = 0
;	source_end_index = 0
;	dest_start_index = 0
;	dest_end_index = 0
;	for i = 0, self.n_gaps do begin
;		source_end_index = *self.discontinuity[*self.gap_indices[i]]
;		dest_end_index   = dest_start_index + (source_end_index - source_start_index)
;
;		array[dest_start_index:dest_end_index] = data[source_start_index:source_end_index]
;
;		dest_start_index = dest_end_index+real_gaps[i]
;		source_start_index = source_end_index+1
;	endfor
;
;	; Now all that may be left is one more good run of numbers
;	source_start_index = source_end_index + 1
;	if source_start_index le an then begin
;		last_count = n_elements(c[source_start_index:*])	;;;;;;;!!!!!!!!!!!!
;
;		source_end_index = source_start_index+last_count - 1
;		dest_start_index = dest_end_index + *self.real_gaps[self.n_gaps - 1]
;		dest_end_index = dest_start_index + last_count - 1
;		array[dest_start_index:dest_end_index] = data[source_start_index:source_end_index]
;
;	endif
;
;	return, array
;
;end

;;;pro status_reformatter::get_data, file, suffix, pkt_struct, pkt_size, packet_array
; function eis_status_pipeline::get_data, ref_time, pkt_struct, packet_data, timing_data
;
; 	time_string = self.archive_start_times[ref_time]
;
; 	timing_file = self.timing_directory + '/' + self.date_string + '_' + time_string + '.log' + self.file_type
;
; 	data_file = self.source_directory + '/eis_sts_' + self.date_string + '_' + time_string + '??????' + self.file_type
;
; 	; See how many packets are in the archive.
; 	print, 'Opening ' + data_file
; 	openr, lu, data_file, /get_lun
; 	f = fstat(lu)
; 	number_of_packets = f.size / self.packet_size
; 	if number_of_packets eq 0 then begin
; 		print, 'No packets in archive for ' + file
; 		return, 0
; 	endif
; 	print, 'Number of packets is ', number_of_packets
;
; 	packet = pkt_struct
; 	packet_data = replicate(pkt_struct, number_of_packets)
; 	count = 0L
; 	on_ioerror, data_done
; 	while count lt number_of_packets do begin
; 		readu, lu, packet
; 		packet_array[count] = packet
; 		count = count + 1
; 	endwhile
; 	print, 'No error'
; 	print, '... finished. Found ', count, ' packets'
; ;    self.packet_data = ptr_new(packet_array)
; 	close, lu
; 	free_lun, lu
;
; 	; Now read in the timing data file
; 	timing_data = self->read_timing_file(timing_file)
; 	return, 1
;
; data_done:
; 	print, '... finished. Found ', count, ' packets'
; 	close, lu
; 	free_lun, lu
; 	print, !ERR, !ERROR, ' ', !ERR_STRING
; 	return, 0
; end

;pro eis_status_pipeline::initialise, main_logger
;  self->eis_pipeline::initialise
;end

; pro eis_status_pipeline::finish
; 	; Finish up, fxbfinish disposes of alun
; 	alun = self.fits_lun
; 	errmsg = ''
; 	fxbfinish, alun, errmsg=errmsg
; 	if errmsg ne '' then print, '*** fxbfinish error: ' + errmsg
; end

; pro eis_status_pipeline::cleanup
; 	print, 'data cleaning up'
; ;	ptr_free, self.packet_data
; ;	ptr_free, self.discontinuity
; ;	ptr_free, self.gap_indices
; ;	ptr_free, self.header
; ;	ptr_free, self.real_gaps
; ;	ptr_free, self.transfer_indices
; end

pro eis_status_pipeline::debug
  self->eis_pipeline::debug
  print
  print, 'eis_status_pipeline__define::debug'
  print, 'timings_directory            : ' + self.timings_directory
  print, 'packet_source_directory      : ' + self.packet_source_directory
  print, 'destination_directory        : ' + self.destination_directory
  print, 'split_directory              : ' + self.split_directory
  print, 'date_string                  : ' + self.date_string
  print, 'timing_split_script          : ' + self.timing_split_script
end

; [energies, polars, azimuths, spin] (but only 32 azimuths used)
pro eis_status_pipeline__define

  struct = { eis_status_pipeline,       $
	  timings_directory		      : '', $
	  packet_source_directory	  : '', $
	  destination_directory       : '', $
      split_directory             : '', $
	  date_string				  : '', $

; in eis_pipeline
;     reformatter          : ptr_new(obj_new()), $

    start_times           : make_array(16, /string), $ ;strarr(16), $
    end_times             : strarr(16),              $
    elapsed_time          : make_array(16, /ulong),  $
    split_file_types      : strarr(8),               $
    status_apids          : strarr(8),               $

    timing_file_types     : strarr(8),               $
    timing_split_script   : '',                      $

    ;reformatters          : strarr(8) ,             $
    reformatters          : strarr(8),               $

    ccsds_reader          : ptr_new(obj_new()),      $
    ccsds_writer          : ptr_new(obj_new()),      $

    inherits eis_pipeline }

end
