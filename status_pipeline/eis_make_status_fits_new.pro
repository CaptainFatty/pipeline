;+
; NAME: eis_make_status_fits.pro
;
; PURPOSE: To convert solar-B ccsds status packet archives into
;          level-0 fits format.
;          Converts ICU/PSU, CAM, MHC and Eis specific parameters of
;          HK1 status packets.
;      
; CATEGORY: Engineering
;
; CALLING SEQUENCE: eis_make_status_fits, 'status_archive' [,output=output]
;
; INPUTS: Filename string of the status archive
;
; KEYWORD PARAMETERS: Set output (string) to an existing directory
; where the fits output will be written. Default to '/tmp'.
;
; OUTPUTS: One fits file per status APID in either /tmp or the
; directory specified by output.
;
; CALLS: Various SSW fits routines.
;
; COMMON BLOCKS:None.
;
; PROCEDURE:
;
; RESTRICTIONS: Uses SolarSoft
;               To do: history keywords and updating
;
; MODIFICATION HISTORY:
;	17/09/06 mcrw   v2.0
;                       New version based on version 1.1
;                       Does not split ccsds header up
;
; Needs altering so that the mhc mechanisms first/last position can be
; put in
;-

pro unpack_primary_ccsds_header, packet_array, apid, sequence_count, length
	temp = packet_array.apid
	byteorder, temp, /ntohs
	apid = uint(temp) and '3FFF'X
	temp = packet.scount
	byteorder, temp, /ntohs
	sequence_count = uint(temp) and '3FFF'X
	temp = packet_array.plength
	byteorder, temp, /ntohs
	length = uint(temp)
end

pro eis_unpack_sc_time, packet_array, sc_time
	temp = packet_array.sc_time
	byteorder, temp, /ntohl
	sc_time = ulong(temp)
end

;
; Convert yyyymmddThhmmss to yyyy-mm-ddThh:mm:ss.000
;
function eis_convert_utc,ut_str
    yr_str = strmid(ut_str, 0, 4)
    mo_str = strmid(ut_str, 4, 2)
    da_str = strmid(ut_str, 6, 2)
    hr_str = strmid(ut_str, 9, 2)
    mi_str = strmid(ut_str, 11, 2)
    se_str = strmid(ut_str, 13, 2)
    return, yr_str+'-'+mo_str+'-'+da_str+'T'+hr_str+':'+mi_str+':'+se_str+'.000'
end


; Utility functions to extract bytes and bits.
; offset is the byte offset into the packet from location 0
; Extracts a byte from the array at offset location. Last 2 parameters
; unused but provided to make a standard calling sequence.
function eis_extractByte, dataArray, offset, startBit, numBits
    return, dataArray[offset, *]
end

; Extracts a 2-byte word
function eis_extractWord, dataArray, offset, startBit, numBits
    return, ishft(fix(dataArray[offset, *]), 8) or fix(dataArray[offset + 1, *])
end

; Extracts a 4-byte word
function eis_extractDoubleWord, dataArray, offset, startBit, numBits
    return, long(ishft(long(dataArray[offset,     *]), 24) or $
            ishft(long(dataArray[offset + 1, *]), 16) or $
            ishft(long(dataArray[offset + 2, *]),  8) or $
                  long(dataArray[offset + 3, *]))
end

; Extracts the top 4 bits from a byte
function eis_extractMsNibble, dataArray, offset, startBit, numBits
    return, byte(ishft(dataArray[offset, *], -4))
end

; Extracts the bottom 4 bits from a byte
function eis_extractLsNibble, dataArray, offset, startBit, numBits
    return, byte(dataArray[offset, *] and 15)
end

; Extracts n-bits from anywhere in a byte. No error checking.
; Bit order is: bit 0 (2^7) .. bit 7 (2^0), unfortunately
function eis_extractBitsFromByte, dataArray, offset, startBit, numBits
    foo = dataArray[offset, *]
    range = (startBit + numBits) - 1
    shift = 0 - (7 - range) ; negative for right shift
    mask = (2 ^ numBits) - 1
    return, byte(ishft(foo, shift) and mask)
end

; Extract n-bits from a 16 bit word. Starting offset is first byte
; of word
function eis_extractBitsFromWord, dataArray, offset, startBit, numBits
    word_array = eis_extractWord(dataArray, offset, startBit, numBits)
    range = (startBit + numBits) - 1
    shift = 0 - (15 - range) ; negative for right shift
    mask = (2 ^ numBits) - 1
    return, fix(ishft(word_array, shift) and mask)
end

function eis_extract24Bits, dataArray, offset, startBit, numBits
    long_array = eis_extractDoubleWord(dataArray, offset, startBit, numBits)
    return, long(ishft(long_array, -8) and '00FFFFFF'X)
end

;------------------------------------------------------------------------------------------

; Little test routines
;function eis_extractTcRecPktc, dataArray
;    return, extractWord(dataArray, 8)
;end

;function eis_extractEisMode, dataArray
;    return, extractMsNibble(dataArray, 1)
;end

;function eis_convertIcuCurrent, rawArray, polyArray
;    scale = 2.5 / 256
;    return, ((rawArray * scale) * polyArray[0] + polyArray[1])
;end

;------------------------------------------------------------------------------------------

function eis_get_status_grt, filename
	return, strmid(filename, 8, 8) + strmid(filename, 17, 6)
end

pro eis_get_status_sc_time, packet_arry, sc_start, sc_end
	sc_time_array = eis_unpack_sc_time(packet_array)
	sc_start = sc_time_array[0]
	sc_end   = sc_time_array[n_elements(sc_time_array) - 1]
end

; Add some standard keywords to the primary hdu.
; Spacecraft time comes from data
pro eis_add_primary_header_keywords, header, filename, packet_array, interval, fits_filename
;pro eis_add_primary_header_keywords, data, header, type, grt, sc_start, ut_start, sc_end, ut_end, ti_conv
;print, '--- : eis_add_primary_header_keywords'

    fxaddpar, header, 'origin', 'ISAS', 'Institute where file was written'
    fxaddpar, header, 'telescop', 'Hinode', 'Satellite name (Solar-B)'
    fxaddpar, header, 'instrume', 'EIS','EUV Imaging Spectrometer'
    fxaddpar, header, 'program', 'eis_make_status_fits','Program used to generate the file'
    fxaddpar, header, 'version', '2.0', 'Program version'
    fxaddpar, header, 'release', 'Preliminary', 'Confidence level'

    ; Use the sctime array and grt to add start and end
    ; times for the archive
    grt = eis_get_status_grt(filename)
    fxaddpar, header, 'gndtime', grt, 'Ground receive time'

	eis_get_status_sc_time, packet_array, sc_start, sc_end
    fxaddpar, header, 'ti0', string(sc_start, format='(Z08)'), 'Archive start time - Spacecraft time (TI)'
    fxaddpar, header, 'ti1', string(sc_end,format='(Z08)'), 'Archive end time - Spacecraft time (TI)'

	ut_start = eis_ti2utc(sc_start, grt)
    ut_end = eis_ti2utc(sc_end, grt)
    ut_start1 = eis_convert_utc(ut_start)
    ut_end1   = eis_convert_utc(ut_end)

;;;    yr_str = strmid(ut_start, 0, 8)
;;;    hr_str = strmid(ut_start, 9, 6)
;;;    ut_start1 = eis2cal(yr_str+hr_str)
;;;    yr_str = strmid(ut_end, 0, 8)
;;;    hr_str = strmid(ut_end, 9, 6)
;;;    ut_end1 = eis2cal(yr_str+hr_str)

;    fxaddpar, header, 'date_obs', ut_start1, 'Archive start time (UT)'
;    fxaddpar, header, 'date_end', ut_end1, 'Archive end time (UT)'

    fxaddpar, header, 'date_obs', ut_start1, 'Archive start time (UT)'
    fxaddpar, header, 'date_end', ut_end1, 'Archive end time (UT)'
    fxaddpar, header, 'ti_conv', ti_conv eq 1 ? 'T' : 'F', 'Conversion to UT success'

    ; Add packet frequency
    fxaddpar, header, 'interval', interval, 'Packet frequencey (seconds)'

end

; Make a binary table extension for the spacecraft time and ccsds
; seequence counter for each APID type
;pro eis_mk_ccsds_bintable_extension, sctime, seqCount, fitsFile
pro eis_mk_ccsds_bintable_extension, stsData, fitsFile, type, grt, sc_time, ut_str, sc_time_end, ut_end,ti_conv
;    print, '--- Create bintable header for spacecraft'

    errmsg = ''
    fxbhmake, header, 1, 'SPACECRAFT', 'Ccsds Packet Information', errmsg=errmsg, /date, /initialize, /extver, /extlevel    
    if errmsg ne '' then print, '*** fxbhmake error: ' + errmsg

;    fxaddpar, header, 'UNIT', 'None', 'Units for parameters in this extension'

    eis_add_primary_header_keywords, stsData, header, type, grt, sc_time, ut_str, sc_time_end, ut_end,ti_conv

    sctime = eis_extractDoubleWord(stsData, 6, 0, 0)
    minv = min(sctime)
    maxv = max(sctime)

    ; Create the column description
    fxbaddcol, sc_col, header, sctime, $
      'TIME', 'MDP Time',              $
      tdmin = minv,                 $
      tdmax = maxv

    seqCount = eis_extractWord(stsData, 2, 0, 0)
    seqCount = seqCount and '3FFF'X
    minv = min(seqCount)
    maxv = max(seqCount)

    ; Create the column description
    fxbaddcol, seq_col, header, seqCount, $
      'SEQ_COUNTER', 'Ccsds Sequence Counter',              $
      tdmin = minv,                 $
      tdmax = maxv

    ; Create the fits header
    errmsg = ''
    fxbcreate, alun, fitsFile, header, errmsg = errmsg
    if errmsg ne '' then print, '*** fxbcreate error: ' + errmsg

    ; Write out the data
    errmsg = ''
    fxbwrite, alun, sctime, sc_col, 1, errmsg=errmsg
    if errmsg ne '' then print, '*** fxbwrite error: ' + errmsg

    errmsg = ''
    fxbwrite, alun, seqCount, seq_col, 1, errmsg=errmsg
    if errmsg ne '' then print, '*** fxbwrite error: ' + errmsg

    ; Finish up
    errmsg = ''
    fxbfinish, alun, errmsg=errmsg
    if errmsg ne '' then print, 'Error: ' + errmsg

; Debug
;print
;print, 'HEADER:'
;print, header

end

; Make bintable extensions for the MHC subcomm table - unfinished.
pro eis_mk_subcomm_extension, stsData, paramFile, fitsFile
return
;    print, '--- Create bintable header for subcomm table'

    errmsg = ''
    fxbhmake, header, 1, 'SUBCOMM VALUES', 'Subcomm table elements', errmsg=errmsg, /date, /initialize, /extver, /extlevel    
    if errmsg ne '' then print, '*** fxbhmake error: ' + errmsg

    fxaddpar, header, 'UNIT', 'None', 'Units for parameters in this extension'

    minv = min(sctime)
    maxv = max(sctime)

    ; Create the column description
    fxbaddcol, sc_col, header, sctime, $
      'TIME', 'MDP Time',              $
      tdmin = minv,                 $
      tdmax = maxv

    minv = min(seqCount)
    maxv = max(seqCount)

    ; Create the column description
    fxbaddcol, seq_col, header, seqCount, $
      'SEQ_COUNTER', 'Ccsds Sequence Counter',              $
      tdmin = minv,                 $
      tdmax = maxv

    ; Create the fits header
    errmsg = ''
    fxbcreate, alun, fitsFile, header, errmsg = errmsg
    if errmsg ne '' then print, '*** fxbcreate error: ' + errmsg

    ; Write out the data
    errmsg = ''
    fxbwrite, alun, sctime, sc_col, 1, errmsg=errmsg
    if errmsg ne '' then print, '*** fxbwrite error: ' + errmsg

    errmsg = ''
    fxbwrite, alun, seqCount, seq_col, 1, errmsg=errmsg
    if errmsg ne '' then print, '*** fxbwrite error: ' + errmsg

    ; Finish up
    errmsg = ''
    fxbfinish, alun, errmsg=errmsg
    if errmsg ne '' then print, 'Error: ' + errmsg

end

; Make a binary table extension, complete with data
;;;pro eis_mk_bintable_extension, data, parameterFile, fitsFile
pro eis_mk_bintable_extension, data, parameterFile, fitsFile, type, grt, sc_time, ut_str, sc_time_end, ut_end,ti_conv
;print, '--- eis_mk_simple_bintable_extension'

    ; Open the parameter file which contains the fits definitions
    openr, lun, parameterFile, /get_lun

    ; Read in extension header details
    extName = ''
    extComment = ''
    numParams = 0B
    unit = ''
    desc = ''
    cuni = ''
    readf, lun, extName
    readf, lun, extComment
    readf, lun, numParams
;    readf, lun, unit
;    readf, lun, desc
;    readf, lun, cuni

    num_readings = n_elements(data[0,*])
    ; Create the parameter objects and read in their details
    param = objarr(numParams)
    for i = 0, numParams - 1 do begin
        obj = obj_new('eis_status_parameter')
        obj->read, lun
        obj->setData,data, num_readings
;;;        obj->describe ; Debug
        param[i] = obj
    endfor

    ; Close parameter file
    close, lun
    free_lun, lun

    ; Make the bintable extension header
;    print, '--- Create bintable header for ' + extName
    errmsg = ''
    fxbhmake, header, 1, extName, extComment, errmsg=errmsg, /date, /initialize, /extver, /extlevel
    if errmsg ne '' then print, '*** fxbhmake error: ' + errmsg
;;;    fxaddpar, header, 'UNIT', unit, 'Units for parameters in this extension'

    eis_add_primary_header_keywords, data, header, type, grt, sc_time, ut_str, sc_time_end, ut_end,ti_conv


    ; Create the column description
    for i = 0, numParams - 1 do begin
        fxbaddcol, col, header, param[i]->data(), $
          param[i]->name(), param[i]->comment(),  $
          tunit = param[i]->unit(),               $
          tdmin = param[i]->minval(),             $
          tdmax = param[i]->maxval()
    endfor

    ; Create the fits header
    errmsg = ''
    fxbcreate, alun, fitsFile, header, errmsg = errmsg
    if errmsg ne '' then print, '*** fxbcreate error: ' + errmsg

    ; col is an output really?!?! *** Check fxbwrite ***
    ; Write out the data
    errmsg = ''
    for col = 1, numParams do begin
        fxbwrite, alun, param[col - 1]->data(), col, 1, errmsg=errmsg
    endfor
    if errmsg ne '' then print, '*** fxbwrite error: ' + errmsg

    ; Finish up, fxbfinish disposes of alun
    errmsg = ''
    fxbfinish, alun, errmsg=errmsg
    if errmsg ne '' then print, '*** fxbfinish error: ' + errmsg

    ; Get rid of the objects
    obj_destroy,param
end

; General procedure for writing out the fits extensions
pro eis_mkStsFits, file, stsData, fitsBase, parameterBase, type, pfiles

    ; File will have a filename:
    ;     eis_sts_yyyymmdd_hhmmssttmm
    ; and will create a fits file with name:
    ;     eis_sts1_yyymmdd_hhmmss.fits
    ; for a status 1 archive
    ; hk1, hk2, hk3, sts1, sts2, sts3

    ; Do spacecraft time conversions here to send to add_primary_header
    ; Get the first scpacecraft time (ti)
    sc_time = (eis_extractDoubleWord(stsData, 6, 0, 0))[0]
;print, 'sc_time = ', sc_time

    last_sample = n_elements(stsData[0,*]) - 1
;print, 'last_sample = ', last_sample
    sc_time_end = (eis_extractDoubleWord(stsData, 6, 0, 0))[last_sample]

;print, 'sc_time_end = ', sc_time_end

    ; Create the fits file filename
    break_file, file, disk_log, dir, filnam, ext, fversion, node

    yr_str = strmid(filnam, 8, 8)
    hr_str = strmid(filnam, 17, 6)
    grt = yr_str + hr_str
;;;;    ut_str = eis_ti2utc(string(sc_time), grt)
    ut_str = eis_ti2utc(sc_time, grt)

;;;;    ut_end   = eis_ti2utc(string(sc_time_end), yr_str + hr_str)
    ut_end   = eis_ti2utc(sc_time_end, yr_str + hr_str)

    converted_ok = strpos(ut_str, 'T', 8)
    if converted_ok ne -1 then begin ; Good conversion
        new_ut_str = ut_str
;;;        strput,ut_str,'_',8
        strput,new_ut_str,'_',8
        ; Make fits file name from ut string
        fitsFile = fitsBase + 'eis_' + type + '_' + new_ut_str + '.fits'
        ; More processing for header (convered ok etc)
        ti_conv = 1
    endif else begin
        ; Make fits file name from grt string
        fitsFile = fitsBase + 'eis_' + type + '_' + yr_str + '_' + hr_str + '.fits'
        ; More processing for header, bad case
        ti_conv = 0
    endelse

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    fitsFile = fitsBase + 'eis_' + type + '_' + ut_str + '.fits'

    ; Make the primary header
;    print, 'eis_mkStsFits: making FITS header for type ' + type ; Debug
    fxhmake, header, /initialize, /date, /extend

    ; Add primary header keywords
    eis_add_primary_header_keywords, stsData, header, type, grt, sc_time, ut_str, sc_time_end, ut_end, ti_conv
    
    ; Write the header to file
    fxwrite, fitsFile, header

    ; Loop through the parameter filename array writing out the extensions
    for i = 0, n_elements(pfiles) - 1 do begin
;;;        eis_mk_bintable_extension, stsData, parameterBase + pfiles[i], fitsFile
        eis_mk_bintable_extension, stsData, parameterBase + pfiles[i], fitsFile, type, grt, sc_time, ut_str, sc_time_end, ut_end,ti_conv
    endfor

    ; Not done yet
;    if keyword_set(sub) then $
;      eis_mk_subcom_extension, stsData, parameterBase+'/mhc_subcom_vals', fitsFile

    ; Chuck in the spacecraft parameters
;;;    eis_mk_ccsds_bintable_extension, sctime, seqCountArray, fitsFile
    eis_mk_ccsds_bintable_extension, stsData, fitsFile, type, grt, sc_time, ut_str, sc_time_end, ut_end,ti_conv
end


pro unpack_psu_voltages, pa, ens, mpa, p2, p5, p15, n15, m28
	p2 = pad(pa.p2v5, ens, mpa)
	p5 = pa.p5v
	p15 = pa.p15v
	n15 = pa.n15v
	m28 = pa.mbus28v
end

pro mk_psu_voltages_extension, fits_file, header, packet_data, missing_packets_array, expected_number_of_samples
	unpack_psu_voltages, packet_array, expected_number_of_samples, missing_packets_array, p2, p5, p15, n15, m28
	fxbaddcol, col, header, p2,  'p2v5',    '+2.5 voltage',  tunit='v', tdmin=min(p2),   tdmax=max(p2)
	fxbaddcol, col, header, p5,  'p5v',     '+2.5 voltage',  tunit='v', tdmin=min(p5),   tdmax=max(p5)
	fxbaddcol, col, header, p15, 'p15v',    '+2.5 voltage',  tunit='v', tdmin=min(p15),   tdmax=max(p15)
	fxbaddcol, col, header, n15, 'n15v',    '+2.5 voltage',  tunit='v', tdmin=min(n15),   tdmax=max(n15)
	fxbaddcol, col, header, m28, 'mbus28v', 'main bus +28 voltage',  tunit='v', tdmin=min(m28),   tdmax=max(m28)

  ; Create the fits header
  create_header, alun, fits_file, header

  ; Write the columns data
  fits_write, alun, p2,  1, 1, 'p2v5'
  fits_write, alun, p5,  2, 1, 'p5v'
  fits_write, alun, p15, 3, 1, 'p15v'
  fits_write, alun, n15, 4, 1, 'n15v'
  fits_write, alun, m28, 5, 1, 'mbus28v'

  ; Finish up, fxbfinish disposes of alun
  errmsg = ''
  fxbfinish, alun, errmsg=errmsg
  if errmsg ne '' then print, '*** fxbfinish error: ' + errmsg
	
end


pro eis_find_missing_data, packet_array, missing_packets_array, sequence_count=sequence_count
	if keyword_set(sequence_count) then begin
		temp = packet_array.scount
		byteorder, temp, /ntohs
		sc = uint(temp and '3FFF'X)
		nos = n_elements(sc)
		discontinuity = where(sc[0:nos - 2] - sc[1:nos - 1] ne -1, dcount)
  		dp=discontinuity+1
		gap_length=sc[dp]-sc[discontinuity]
	    gap_indices=where(gap_length ne 0 and gap_length ne -16383, rg_count)
  		real_gaps=gap_length[gap_indices]
 	 	n_gaps = n_elements(real_gaps)-1

end

; Make the fits file for the icu/psu APID
pro eis_mk_icu_fits, filename, packet_array, fits_base

	eis_decode_date_time, packet_array, date_time
	
;	actual_number_of_samples   = n_elements(packet_array.sc)
	expected_number_of_samples = (60 * 60 * 24) / 2
	
	fits_file = eis_create_status_fits_file, date_time
	
	; Unpack ccsds headers now to get info for primary header
	;unpack_ccsds_header, packet_array, apid, sc, length

	eis_find_missing_data, packet_array, missing_packets_array, /sequence_count
	
	; Make the primary header
	errmsg = ''
	fxbhmake, header, 1, 'ICU', 'ICU status parameters', errmsg=errmsg, /date, /initialize, /extver, /extlevel, /extend
	if errmsg ne '' then print, '*** fxbhmake error: ' + errmsg

	; Add primary header keywords
	eis_add_primary_header_keywords, header, date_time, missing_packets_array, 2
;	eis_add_primary_header_keywords, header, filename, packet_array, 2
;    eis_add_primary_header_keywords, stsData, header, type, grt, sc_time, ut_str, sc_time_end, ut_end, ti_conv


;	defsysv, '!cls_start_date', sd
;	defsysv, '!cls_end_date',   ed

	; Open fits file
	
	; Write the header to file
	fxwrite, fits_file, header

	mk_psu_voltages_extension,   fits_file, header, packet_data, missing_packets_array, expected_number_of_samples
	mk_psu_currents_extension,   fits_file, header, packet_data, missing_packets_array, expected_number_of_samples
	mk_psu_temps_extension,      fits_file, header,	packet_data, missing_packets_array, expected_number_of_samples
	mk_icu_misc_extension,       fits_file, header, packet_data, missing_packets_array, expected_number_of_samples
	mk_icu_status_extension,     fits_file, header, packet_data, missing_packets_array, expected_number_of_samples
	mk_psu_status_extension,     fits_file, header, packet_data, missing_packets_array, expected_number_of_samples
	mk_hm_status_extension,      fits_file, header, packet_data, missing_packets_array, expected_number_of_samples
	mk_icu_interfaces_extension, fits_file, header, packet_data, missing_packets_array, expected_number_of_samples
	mk_icu_errors_extension,     fits_file, header, packet_data, missing_packets_array, expected_number_of_samples
	mk_icu_science_extension,    fits_file, header, packet_data, missing_packets_array, expected_number_of_samples
	mk_bintable_extension,       fits_file, header, 'spacecraft', packet_data, missing_packets_array, expected_number_of_samples

end

pro eis_mkIcuPsuFits, file, sts1Data, fitsBase, parameterBase
;pro eis_mkIcuPsuFits, packet_array, fits_base
    ; Initialise the parameter filename array and basename string
    parameterFilenames = strarr(11)
    parameterFilenames[0]  = '/psu_voltages'
    parameterFilenames[1]  = '/psu_currents'
    parameterFilenames[2]  = '/psu_temperatures'
    parameterFilenames[3]  = '/icu_misc'
    parameterFilenames[4]  = '/icu_status'
    parameterFilenames[5]  = '/psu_status'
    parameterFilenames[6]  = '/hm_status'
    parameterFilenames[7]  = '/icu_interfaces'
    parameterFilenames[8]  = '/icu_errors'
    parameterFilenames[9]  = '/icu_counters'
    parameterFilenames[10] = '/icu_science'

    eis_mkStsFits, file, sts1Data, fitsBase, parameterBase, 'sts1', parameterFilenames
end

; Make the fits file for the cam APID
pro eis_mkCamFits, file, sts2Data, fitsBase, parameterBase

    ; Initialise the parameter filename array and basename string
    parameterFilenames = strarr(8)
    parameterFilenames[0] = '/cam_voltages'
    parameterFilenames[1] = '/cam_currents'
    parameterFilenames[2] = '/cam_biases'
    parameterFilenames[3] = '/cam_psu_voltages'
    parameterFilenames[4] = '/cam_psu_currents'
    parameterFilenames[5] = '/cam_icu_parameters'
    parameterFilenames[6] = '/cam_misc'
    parameterFilenames[7] = '/cam_temperatures'

    eis_mkStsFits, file, sts2Data, fitsBase, parameterBase, 'sts2', parameterFilenames
end

; Make the fits file for the mhc APID
pro eis_mkMhcFits, file, sts3Data, fitsBase, parameterBase

    ; Initialise the parameter filename array and basename string
    parameterFilenames = strarr(10)
    parameterFilenames[0] = '/mhc_references'
    parameterFilenames[1] = '/mhc_voltages'
    parameterFilenames[2] = '/mhc_currents'
    parameterFilenames[3] = '/mhc_temperatures_gp0'
    parameterFilenames[4] = '/mhc_temperatures_gp2'
    parameterFilenames[5] = '/mhc_mechanisms'
    parameterFilenames[6] = '/mhc_status'
    parameterFilenames[7] = '/mhc_counters'
    parameterFilenames[8] = '/mhc_qcm'
    parameterFilenames[9] = '/mhc_subcom'

    eis_mkStsFits, file, sts3Data, fitsBase, parameterBase, 'sts3', parameterFilenames
end

; Make the fits file for the hk1 APID
pro eis_mkHk1Fits, file, hk1Data, fitsBase, parameterBase

    ; Initialise the parameter filename array and basename string
    parameterFilenames = strarr(3)
    parameterFilenames[0] = '/hk1_temperatures'
    parameterFilenames[1] = '/hk1_status'
    parameterFilenames[2] = '/hk1_mdp'

    eis_mkStsFits, file, hk1Data, fitsBase, parameterBase, 'hk1', parameterFilenames
end

; Make the fits file for the hk2 APID
pro eis_mkHk2Fits, file, hk2Data, fitsBase, parameterBase

    ; Initialise the parameter filename array and basename string
    parameterFilenames = strarr(1)
    parameterFilenames[0] = '/hk2_ufs'

    eis_mkStsFits, file, hk2Data, fitsBase, parameterBase, 'hk2', parameterFilenames
end

; Make the fits file for the hk aocs pro 1 APID (440)
pro eis_mkHkAocs1Fits, file, hkAocs1Data, fitsBase, parameterBase

    ; Initialise the parameter filename array and basename string
    parameterFilenames = strarr(1)
    parameterFilenames[0] = '/hk_acu'

    eis_mkStsFits, file, hkAocs1Data, fitsBase, parameterBase, 'aocs1', parameterFilenames
end

;------------------------------------------------------------------------------------------

pro get_data, file, suffix, pkt_struct, pkt_size, packet_array

print, 'Opening ' + file + suffix

	packet = pkt_struct
	openr, lu, file + suffix, /get_lun
	f = fstat(lu)
	number_of_packets = f.size / pkt_size	; Size in bytes / number bytes per sts1 packet
	if number_of_packets eq 0 then begin
		print, 'No packets in archive for '
		return
	endif

print, 'Number of packets is ', number_of_packets

	packet_array = replicate(pkt_struct, number_of_packets)
	count = 0L
	on_ioerror, foodone
	while count lt number_of_packets do begin
		readu, lu, packet
		packet_array[count] = packet
		count = count + 1
	endwhile
	print, 'No error'
	print, '... finished. Found ', count, ' packets'
	close, lu
	free_lun, lu
	return
foodone:
	print, '... finished. Found ', count, ' packets'
	close, lu
	free_lun, lu
	print, !ERR, !ERROR, ' ', !ERR_STRING
end

; Main procedure
pro eis_make_status_fits_new, file, output=output

	; Create the packet structures
	
	sts1_pkt = {sts1_pkt, $
				apid:0, scount:0, plength:0, sc_time:0L, $
				sw_id:0B, mode:0B, status_pc:0, mdp_time:0L, tc_rec:0, cmd_if_err:0B, ccd_buf:0B,$
				tc_fail:0, tc_fail_id:0B, cmd_buf:0B, xrt_ff:0B, mem_dmp:0B, xrt_x:0B, xrt_y:0B, $
				seqi:0B, seq:0B, lli:0B, md_buf:0B, exp_no:0, fine_pos:0, icu_vf:0B, icu_errf:0B,$
				xrt_err:0B, asrc:0B, port_rd:0, ll_err:0, cmd_h:0, ee_stat:0B, ft_err:0B,        $
				psu_mark:0B, p28v:0B, ccda:0B, ccdb:0B, proc:0B, unused:0B, p2v5:0B, p5v:0B,     $
				p15v:0B, n15v:0B, p2v5i:0B, p5i:0B, p15i:0B, n15i:0B, mbus28v:0B, mbus28i:0B,    $
				ee_rcopy:0B, ee_pcopy:0B, spare:0, hm_ool:0, psu_to:0, bc1:0B, bc2:0B, bc3:0B,   $
				cmd_len:0B, cmd_if1:0B, md_if1:0B, stat_if1:0B, wd_if1:0B, cmd_if2:0B, md_if2:0B,$
				stat_if2:0B, wd_if2:0B, m422_if:0, cam_if:0, roe_if1:0, roe_if2:0, hsl_if1:0,    $
				hsl_if2:0, m422_if2:0, seq_abort:0, seq_rem:0B, cmd_intf:0B, mhc_if_err:0,       $
				et_err:0B, hc_target:0B, hc_duty:0B, spare1:0B}

;	sts1_pkt = {sts1_pkt, $
;				apid:0, scount:0, plength:0, sc_time:0L, $
;				bytes:bytarr(100)}
;				
	sts2_pkt = {sts2_pkt, $
				apid:0, scount:0, plength:0, sc_time:0L, $
				p5v1_dig:0B, p2v5_dig:0B, p5v_ana:0B, p5v_anb:0B, n5v_ana:0B, n5v_anb:0B,        $
				p36va:0B, p36vb:0B, p12v_a:0B, p12v_b:0B, voda:0B, vrda:0B, vssa:0B,             $
				vodb:0B, vrdb:0B, vssb:0B, p5vi_dig:0B, p2v5i_dig:0B, p5vi_ana:0B, p5vi_anb:0B,  $
				n5vi_ana:0B, n5vi_anb:0B, p36vi_a:0B, p36vi_b:0B, p12vi_a:0B, p12vi_b:0B,        $
				upt:0B, lot:0B, n10v_a:0B, n10v_b:0B, spare:0, vod:0B, vrd:0B, vss:0B, reg1:0B,  $
				reg2:0B, spare1:0, seu:0B, p39V:0B, p39vi:0B, p7v:0B, n8v:0B, p8v:0B, p13V:0B,   $
				p7vi:0B, n8vi:0B, p8vi:0B, p13vi:0B, spare2:0, buf_add:0L, buf_count:0L,         $
				alive:0L, xrt_x:0, xrt_y:0, cmir_pos:0, fmir_off:0, fmir_slp:0L, cmir_slp:0L,    $
				res_px:0, res_nx:0, resp:0, stime:0, span:0, xfov:0, xf:0, yf:0, xbin_pk:0L,     $
				ybin_pk:0L, etxf:0, etyf:0, etxbin_pk:0L, etybin_pk:0L, spares:bytarr(34)}
				
	sts3_pkt = {sts3_pkt, $
				apid:0, scount:0, plength:0, sc_time:0L, $
				sgop:0, p5vd:0, p15va:0, n15va:0, p15vm:0, grapos:0, ss_step:0, p120_pzt:0,      $
				sgv_ref:0, p5vdi:0, p15vai:0, n15vai:0, cmir_steps:0, gndiref:0, rdci:0, t0:0,   $
				t1:0, t2:0, t3:0, t4:0, t5:0, t6:0, t7:0, t8:0, t9:0, t10:0, t11:0, t12:0, ref:0,$
				cal:0, hzt0:0, hzt1:0, hzt2:0, hzt3:0, hzt4:0, hzt5:0, hzt6:0, hzt7:0, hzt8:0,   $
				hzt9:0, hzt10:0, hzt11:0, hzt12:0, hzt13:0, hzt14:0, hzt15:0, gndref:0,          $
				cmirpos:0, sspos:0, mtr_opt_enc:0, act_opt_enc:0, gra_sw:0, expt1:0, expt2:0,    $
				pzt_drv:0, act_stat:0, cal_src:0, htr_stat:0, qcm_msw:0, qcm_lsw:0,  $
				qct1:0, qct2:0, qcm_clk:0, rec:0, ack:0, nack:0, cmd_id:0, sec_msw:0, sec_lsw:0, $
				time_msw:0, time_lsw:0, sys_stat:0, vac:0, pindex:0, param:0}

;	sts3_pkt = {sts3_pkt, $
;				apid:0, scount:0, plength:0, sc_time:0L, $
;				words:intarr(75)}

	hk1_pkt = {hk1_pkt, $
				apid:0, scount:0, plength:0, sc_time:0L, $
				bytes:bytarr(426)}
				
	hk2_pkt = {hk2_pkt, $
				apid:0, scount:0,plength:0,sc_time:0L, $
				bytes:bytarr(426)}
				
	hk440_pkt = {hk440_pkt, $
				apid:0, scount:0,plength:0,sc_time:0L, $
				bytes:bytarr(426)}

    ; Make a fits file for each APID type...
    if keyword_set(output) then begin
        fits_base = output
    end else begin
        fits_base = '/tmp/' ; Where to write the fits file
    endelse

	get_data, file, '_sts1', sts1_pkt, 110, packet_array
;;;	if n_elements(packet_array) gt 0 then eis_mk_icu_fits, file, packet_array, fits_base
	get_data, file, '_sts2', sts2_pkt, 160, packet_array
;;;	if n_elements(packet_array) gt 0 then eis_mk_cam_fits, file, packet_array, fits_base
	get_data, file, '_sts3', sts3_pkt, 160, packet_array
;;;	if n_elements(packet_array) gt 0 then eis_mk_mhc_fits, file, packet_array, fits_base
	get_data, file, '_hk1',  hk1_pkt,  436, packet_array
;;;	if n_elements(packet_array) gt 0 then eis_mk_hk1_fits, file, packet_array, fits_base
	get_data, file, '_hk2',  hk2_pkt,  436, packet_array
;;;	if n_elements(packet_array) gt 0 then eis_mk_hk2_fits, file, packet_array, fits_base
	get_data, file, '_440',  hk440_pkt,  436, packet_array
;;;	if n_elements(packet_array) gt 0 then eis_mk_440_fits, file, packet_array, fits_base

;	file_suffix = ['_sts1', '_sts2', '_sts3', '_hk1', '_hk2', '_440']
;	packets     = [sts1_pkt, sts2_pkt, sts3_pkt, hk1_pkt, hk2_pkt, hk440_pkt]
;	packet_str  = [{sts1_pkt}, {sts2_pkt}, {sts3_pkt}, {hk1_pkt}, {hk2_pkt}, {hk440_pkt}]
;	packet_size = [110, 160, 160, 436, 436, 436]

	
	return


    ; Extract gnd receive time from filename
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    grt = '20060811113116' ; Dummy for testing

    ; Ccsds packet stuff
    ccsdsHeader = bytarr(10)	; Split so we can get ccsds seq count (not in hk1)


    if sts1Count gt 0 then eis_mkIcuPsuFits,    file, sts1Data,   fitsBase, parameterBase
    if sts2Count gt 0 then eis_mkCamFits,       file, sts2Data,   fitsBase, parameterBase
    if sts3Count gt 0 then eis_mkMhcFits,       file, sts3Data,   fitsBase, parameterBase
    if hk1count  gt 0 then eis_mkHk1Fits,       file, hk1Data,    fitsBase, parameterBase
    if hk2count  gt 0 then eis_mkHk2Fits,       file, hk2Data,    fitsBase, parameterBase
    if hk440count  gt 0 then eis_mkHkAocs1Fits, file, hk440Data,  fitsBase, parameterBase

end
