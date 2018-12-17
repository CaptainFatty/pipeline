pro sts1_reformatter::unpack_psu_voltages, p2, p5, p15, n15, m28
;	p2  = (*self.packet_data).p2v5
;	p5  = (*self.packet_data).p5v
;	p15 = (*self.packet_data).p15v
;	n15 = (*self.packet_data).n15v
;	m28 = (*self.packet_data).mbus28v
;	byteorder, p2,  /ntohs
;	byteorder, p5,  /ntohs
;	byteorder, p15, /ntohs
;	byteorder, n15, /ntohs
;	byteorder, m28, /ntohs
	p2  = (*self.packet).data[60]
	p5  = (*self.packet).data[61]
	p15 = (*self.packet).data[62]
	n15 = (*self.packet).data[63]
	m28 = (*self.packet).data[65]
end

pro sts1_reformatter::psu_voltages_extension
	self->unpack_psu_voltages, p2, p5, p15, n15, m28
	fxbaddcol, col, self.header, p2,  'p2v5',    '+2.5 voltage',          tunit='v', tdmin=min(p2),  tdmax=max(p2)
	fxbaddcol, col, self.header, p5,  'p5v',     '+2.5 voltage',          tunit='v', tdmin=min(p5),  tdmax=max(p5)
	fxbaddcol, col, self.header, p15, 'p15v',    '+2.5 voltage',          tunit='v', tdmin=min(p15), tdmax=max(p15)
	fxbaddcol, col, self.header, n15, 'n15v',    '+2.5 voltage',          tunit='v', tdmin=min(n15), tdmax=max(n15)
	fxbaddcol, col, self.header, m28, 'mbus28v', 'main bus +28 voltage',  tunit='v', tdmin=min(m28), tdmax=max(m28)

	; Create the fits header
	create_header, alun, self.fits_file, self.header
p
	; Get locations of missing data for pad to use
	self->find_missing_data, p2
	
	; Write the columns data
	self->status_reformatter::fits_write, alun, self->status_reformatter::align_data(p2, gap_indices, gap_lengths, self.front, self.back, number_of_gaps),  1, 1, 'p2v5'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(p2),  1, 1, 'p2v5'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(p5),  2, 1, 'p5v'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(p15), 3, 1, 'p15v'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(n15), 4, 1, 'n15v'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(m28), 5, 1, 'mbus28v'

	self.fits_lun = alun
		
end

pro sts1_reformatter::unpack_psu_currents, p2, p5, p15, n15, m28
	p2  = (*self.packet_data).p2v5i
	p5  = (*self.packet_data).p5i
	p15 = (*self.packet_data).p15i
	n15 = (*self.packet_data).n15i
	m28 = (*self.packet_data).mbus28i
end

pro sts1_reformatter::psu_currents_extension
	self->unpack_psu_currents, p2, p5, p15, n15, m28
	fxbaddcol, col, self.header, p2,  'p2v5i',   '+2.5 volt current',          tunit='A', tdmin=min(p2),  tdmax=max(p2)
	fxbaddcol, col, self.header, p5,  'p5i',     '+2.5 volt current',          tunit='A', tdmin=min(p5),  tdmax=max(p5)
	fxbaddcol, col, self.header, p15, 'p15i',    '+2.5 volt current',          tunit='A', tdmin=min(p15), tdmax=max(p15)
	fxbaddcol, col, self.header, n15, 'n15i',    '+2.5 volt current',          tunit='A', tdmin=min(n15), tdmax=max(n15)
	fxbaddcol, col, self.header, m28, 'mbus28i', 'main bus +28 volt current',  tunit='A', tdmin=min(m28), tdmax=max(m28)

	; Create the fits header
	create_header, alun, self.fits_file, self.header

	; Write the columns data
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(p2),  1, 2, 'p2v5i'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(p5),  2, 2, 'p5i'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(p15), 3, 2, 'p15i'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(n15), 4, 2, 'n15i'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(m28), 5, 2, 'mbus28i'

	self.fits_lun = alun
		
end

pro sts1_reformatter::unpack_psu_temps, a, b, proc
	a    = (*self.packet_data).ccda
	b    = (*self.packet_data).ccdb
	proc = (*self.packet_data).proc
end

pro sts1_reformatter::psu_temps_extension
	self->unpack_psu_temps, a, b, proc
	fxbaddcol, col, self.header, a,    'ccda', 'CCD A temperature',      tunit='C', tdmin=min(a),    tdmax=max(a)
	fxbaddcol, col, self.header, b,    'ccdb', 'CCD B temperature',      tunit='C', tdmin=min(b),    tdmax=max(b)
	fxbaddcol, col, self.header, proc, 'proc', 'Processor temperature',  tunit='C', tdmin=min(proc), tdmax=max(proc)

	; Create the fits header
	create_header, alun, self.fits_file, self.header

	; Write the columns data
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(a),    1, 3, 'ccda'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(b),    2, 3, 'ccdb'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(proc), 3, 3, 'proc'

	self.fits_lun = alun
		
end

pro sts1_reformatter::unpack_icu_misc, id, port_rd, bc1, bc2, bc3, cmd_len, target, duty_cycle
	tmp = (*self.packet_data).eis_mode
	byteorder, tmp, /ntohs
	id = ishift(tmp, -4)
	tmp = (*self.packet_data).port_rd
	byteorder, tmp, /ntohs
	port_rd = tmp
	bc1 = (*self.packet_data).bc1
	bc2 = (*self.packet_data).bc2
	bc3 = (*self.packet_data).pbc3
	cmd_len = (*self.packet_data).cmd_len
	target = (*self.packet_data).hc_target
	duty_cycle = (*self.packet_data).hc_duty
end

pro sts1_reformatter::icu_misc_extension
	self->unpack_icu_misc, id, port_rd, bc1, bc2, bc3, cmd_len, target, duty_cycle
	fxbaddcol, col, self.header, id,         'icu_sw_id',     'CCD A temperature',           tunit='',  tdmin=min(id),         tdmax=max(id)
	fxbaddcol, col, self.header, port_rd,    'port_read',     'CCD B temperature',           tunit='',  tdmin=min(port_rd),    tdmax=max(port_rd)
	fxbaddcol, col, self.header, bc1,        'last_bc1_r',    'Processor temperature',       tunit='',  tdmin=min(bc1),        tdmax=max(bc1)
	fxbaddcol, col, self.header, bc2,        'last_bc2_r',    'Processor temperature',       tunit='',  tdmin=min(bc2),        tdmax=max(bc2)
	fxbaddcol, col, self.header, bc3,        'last_bc3_r',    'Processor temperature',       tunit='',  tdmin=min(bc3),        tdmax=max(bc3)
	fxbaddcol, col, self.header, cmd_len,    'cmd_len_r',     'Processor temperature',       tunit='',  tdmin=min(cmd_len),    tdmax=max(cmd_len)
	fxbaddcol, col, self.header, target,     'hc_target_t',   'Bake-out target temperature', tunit='C', tdmin=min(target),     tdmax=max(target)
	fxbaddcol, col, self.header, duty_cycle, 'hc_duty_cycle', 'Bake-out duty cycle',         tunit='',  tdmin=min(duty_cycle), tdmax=max(duty_cycle)

	; Create the fits header
	create_header, alun, self.fits_file, self.header

	; Write the columns data
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(id),         1, 4, 'icu_sw_id'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(port_rd),    2, 4, 'port_read'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(bc1),        3, 4, 'last_bc1_r'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(bc2),        4, 4, 'last_bc2_r'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(bc3),        5, 4, 'last_bc2_r'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(cmd_len),    6, 4, 'cmd_len_r'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(target),     7, 4, 'hc_target_t'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(duty_cycle), 8, 4, 'hc_duty_cycle'

	self.fits_lun = alun
		
end

pro sts1_reformatter::unpack_status, mode, ccdbufts, ccdbufte, ccdbuftwr, ccdbuftrd, et, cmdbuf, xfs
	tmp = (*self.packet_data).eis_mode
	byteorder, tmp, /ntohs
	mode = tmp and 15
	tmp = (*self.packet_data).ccd_buf
	ccdbufts = ishift(tmp, -7)
	ccdnufte = ishift(tmp, -6) and 1
	ccdbufwr = ishift(tmp, -5) and 1
	ccdbufrd = ishift(tmp, -4) and 1
	et       = tmp and 3
	cmdbuf = (*self.packet_data).cmd_buf
	tmp = (*self.packet_data).xrt_ff
	xfs = ishft(tmp, -6) and 3
end
pro sts1_reformatter::unpack_status1, efs, hm, aec, mem, seq, modee, rec, x, y, md
	tmp = (*self.packet_data).xrt_ff
	efs = ishift(tmp, -4) and 3
	hm  = ishift(tmp, -2) and 3
	aec = tmp and 3
	tmp = (*self.packet_data).mem_dmp
	mem = ishift(tmp, -6) and 3
	seq = ishift(tmp, -3) and 7
	modee = ishift(tmp, -2) and 3
	rec = tmp and 1
	x = (*self.packet_data).xrt_x
	y = (*self.packet_data).xrt_y
	md = (*self.packet_data).md_buf
end
pro sts1_reformatter::unpack_status2, ivf, pvf, cvf, mvf, asrc, mld, hc, ee1, ee2, eecpr, eecpp, mon
	tmp = (*self.packet_data).icu_vf
	ivf = ishift(tmp, -6) and 3
	pvf = ishift(tmp, -4) and 3
	cvf = ishift(tmp, -2) and 3
	mvf = tmp and 3
	tmp = (*self.packet_data).asrc
	asrc = ishift(tmp, -6) and 3
	mld = ishift(tmp, -4) and 3
	hc = ishift(tmp, -2) and 3
	tmp = (*self.packet_data).ee_stat
	ee1 = ishift(tmp, -4) and 15
	ee2 = tmp and 15
	eecpr = (*self.packet_data).ee_rcopy
	eecpp = ishift((*self.packet_data).ee_pcopy, -6) and 3
	tmp = (*self.packet_data).psu_to
	byteorder, tmp, /ntohs
	mon = ishift(tmp, -14) and 3
end

pro sts1_reformatter::icu_status_extension
	self->unpack_status, mode, ccdbufs, ccdbufte, ccdbufwr, ccdbufrd, et, cmdbuf, xfs
	self->unpack_status1, efs, hm, aec, mem, seq, modee, rec, x, y, md
	self->unpack_status2, ivf, pvf, cvf, mvf, asrc, mld, hc, ee1, ee2, eecpr, eecpp, mon
	fxbaddcol, col, self.header, mode,     'EIS_MODE',             'EIS mode',   tunit='',  tdmin=min(mode),       tdmax=max(mode)
	fxbaddcol, col, self.header, ccdbufs,  'CCD_BUF_TEST_STAT',    '',           tunit='',  tdmin=min(),    tdmax=max()
	fxbaddcol, col, self.header, ccdbufte, 'CCD_BUF_TEST_ERR',     '',       tunit='',  tdmin=min(),        tdmax=max()
	fxbaddcol, col, self.header, ccdbufwr, 'CCD_BUF_TEST_WR_ERR',  '',       tunit='',  tdmin=min(),        tdmax=max()
	fxbaddcol, col, self.header, ccdbufrd, 'CCD_BUF_TEST_RD_ERR',  '',       tunit='',  tdmin=min(),        tdmax=max()
	fxbaddcol, col, self.header, et,       'ET_STAT',              '',       tunit='',  tdmin=min(),    tdmax=max()
	fxbaddcol, col, self.header, cmdbuf,   'CMD_BUF_STAT',         '', tunit='', tdmin=min(),     tdmax=max()
	fxbaddcol, col, self.header, xfs,      'XRT_FF_STAT',          '',         tunit='',  tdmin=min(), tdmax=max()
	fxbaddcol, col, self.header, efs,      'EIS_FF_STAT',          '',          tunit='',  tdmin=min(), tdmax=max()
	fxbaddcol, col, self.header, hm,       'HM_MON_STAT',          '',          tunit='',  tdmin=min(), tdmax=max()
	fxbaddcol, col, self.header, aec,      'AEC_STAT',             '',          tunit='',  tdmin=min(), tdmax=max()
	fxbaddcol, col, self.header, mem,      'MEM_DMP_STAT',         '',          tunit='',  tdmin=min(), tdmax=max()
	fxbaddcol, col, self.header, seq,      'SEQ_STAT',             '',          tunit='',  tdmin=min(), tdmax=max()
	fxbaddcol, col, self.header, modee,    'MODE_EN_STAT',         '',          tunit='',  tdmin=min(), tdmax=max()
	fxbaddcol, col, self.header, rec,      'XRT_FF_REC',           '',          tunit='',  tdmin=min(), tdmax=max()
	fxbaddcol, col, self.header, x,        'XRT_X_COR',            '',          tunit='',  tdmin=min(), tdmax=max()
	fxbaddcol, col, self.header, y,        'XRT_Y_COR',            '',          tunit='',  tdmin=min(), tdmax=max()
	fxbaddcol, col, self.header, md,       'MD_BUF_STAT',          '',          tunit='',  tdmin=min(), tdmax=max()
	fxbaddcol, col, self.header, ivf,      'ICU_VF',               '',          tunit='',  tdmin=min(), tdmax=max()
	fxbaddcol, col, self.header, pvf,      'PSU_VF',               '',          tunit='',  tdmin=min(), tdmax=max()
	fxbaddcol, col, self.header, cvf,      'CAM_VF',               '',          tunit='',  tdmin=min(), tdmax=max()
	fxbaddcol, col, self.header, mvf,      'MHC_VF',               '',          tunit='',  tdmin=min(), tdmax=max()
	fxbaddcol, col, self.header, asrc,     'ASRC_STAT',            '',          tunit='',  tdmin=min(), tdmax=max()
	fxbaddcol, col, self.header, mld,      'MHC_LOAD_STAT',        '',          tunit='',  tdmin=min(), tdmax=max()
	fxbaddcol, col, self.header, hc,       'HC_STAT',              '',          tunit='',  tdmin=min(), tdmax=max()
	fxbaddcol, col, self.header, ee1,      'EEPROM_STAT1',         '',          tunit='',  tdmin=min(), tdmax=max()
	fxbaddcol, col, self.header, ee2,      'EEPROM_STAT2',         '',          tunit='',  tdmin=min(), tdmax=max()
	fxbaddcol, col, self.header, eecpr,    'EPROM_COPY_REQ_STAT',  '',          tunit='',  tdmin=min(), tdmax=max()
	fxbaddcol, col, self.header, eecpp,    'EPROM_COPY_PROG_STAT', '',          tunit='',  tdmin=min(), tdmax=max()
	fxbaddcol, col, self.header, mon,      'CAM_MHC_PWR_ON',       '',          tunit='',  tdmin=min(), tdmax=max()

	; Create the fits header
	create_header, alun, self.fits_file, self.header

	; Write the columns data
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(mode),     1, 5, 'EIS_MODE'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(ccdbufs),  2, 5, 'CCD_BUF_TEST_STAT'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(ccdbufte), 3, 5, 'CCD_BUF_TEST_ERR'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(ccdbufwr), 4, 5, 'CCD_BUF_TEST_WR_ERR'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(ccdbufrd), 5, 5, 'CCD_BUF_TEST_RD_ERR'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(et),       6, 5, 'ET_STAT'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(cmdbuf),   7, 5, 'CMD_BUF_STAT'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(xfs),      8, 5, 'XRT_FF_STAT'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(efs),      9, 5, 'EIS_FF_STAT'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(hm),      10, 5, 'HM_MON_STAT'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(aec),     11, 5, 'AEC_STAT'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(mem),     12, 5, 'MEM_DMP_STAT'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(seq),     13, 5, 'SEQ_STAT'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(modee),   14, 5, 'MODE_EN_STAT'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(rec),     15, 5, 'XRT_FF_REC'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(x),       16, 5, 'XRT_X_COR'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(y),       17, 5, 'XRT_Y_COR'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(md),      18, 5, 'MD_BUF_STAT'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(ivf),     19, 5, 'ICU_VF'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(pvf),     20, 5, 'PSU_VF'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(cvf),     21, 5, 'CAM_VF'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(mvf),     22, 5, 'MHC_VF'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(asrc),    23, 5, 'ASRC_STAT'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(mld),     24, 5, 'MHC_LOAD_STAT'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(hc),      25, 5, 'HC_STAT'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(ee1),     26, 5, 'EEPROM_STAT1'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(ee2),     27, 5, 'EEPROM_STAT2'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(eecpr),   28, 5, 'EPROM_COPY_REQ_STAT'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(eecpp),   29, 5, 'EPROM_COPY_PROG_STAT'
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(),        30, 5, 'CAM_MHC_PWR_ON'

	self.fits_lun = alun
		
end


pro sts1_reformatter::unpack_psu_status, mk, ben, aen, b, a, h28, m28, e28, mhtr, chtr, p39, n8, p7, p8, p13
	tmp = (*self.packet_data).eis_mode

end
pro sts1_reformatter::psu_status_extension
	self->unpack_psu_status, mk, ben, aen, b, a, h28, m28, e28, mhtr, chtr, p39, n8, p7, p8, p13
	
	fxbaddcol, col, self.header, mode,       'eis_mode',   'EIS mode',                    tunit='',  tdmin=min(mode),       tdmax=max(mode)
	
	; Create the fits header
	create_header, alun, self.fits_file, self.header

	; Write the columns data
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(mode),       1, 6, 'eis_mode'
end

pro sts1_reformatter::unpack_hm_status, alrt, pto, cto, mto, pol, col, mol, p
	tmp = (*self.packet_data).eis_mode

end
pro sts1_reformatter::hm_status_extension
	self->unpack_hm_status, alrt, pto, cto, mto, pol, col, mol, p

	fxbaddcol, col, self.header, mode,       'eis_mode',   'EIS mode',                    tunit='',  tdmin=min(mode),       tdmax=max(mode)
	
	; Create the fits header
	create_header, alun, self.fits_file, self.header

	; Write the columns data
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(mode),       1, 7, 'eis_mode'
end

pro sts1_reformatter::unpack_icu_if, cmd1, md1, st1, wd1, cmd2, md2, st2, wd2, m1, r1, r2, h1, h2, m2
	tmp = (*self.packet_data).eis_mode

end
pro sts1_reformatter::icu_if_extension
	self->unpack_icu_if, cmd1, md1, st1, wd1, cmd2, md2, st2, wd2, m1, r1, r2, h1, h2, m2

	fxbaddcol, col, self.header, mode,       'eis_mode',   'EIS mode',                    tunit='',  tdmin=min(mode),       tdmax=max(mode)
	
	; Create the fits header
	create_header, alun, self.fits_file, self.header

	; Write the columns data
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(mode),       1, 8, 'eis_mode'
end

pro sts1_reformatter::unpack_icu_errors, ec, cmd, psu, tc, icu, xrt, hc, hcto, ll, cmdh
	tmp = (*self.packet_data).eis_mode

end
pro sts1_reformatter::unpack_icu_errors1, ft, win, parm, aect, cam, seq, cmd, mhc, ee, et
	tmp = (*self.packet_data).eis_mode

end
pro sts1_reformatter::icu_errors_extension
	self->unpack_icu_errors, ec, cmd, psu, tc, icu, xrt, hc, hcto, ll, cmdh
	self->unpack_icu_errors1, ft, win, parm, aect, cam, seq, cmd, mhc, ee, et

	fxbaddcol, col, self.header, mode,       'eis_mode',   'EIS mode',                    tunit='',  tdmin=min(mode),       tdmax=max(mode)
	
	; Create the fits header
	create_header, alun, self.fits_file, self.header

	; Write the columns data
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(mode),       1, 9, 'eis_mode'
end

pro sts1_reformatter::unpack_icu_counters, mdp, st, tc, ras, seq, exp
	tmp = (*self.packet_data).eis_mode

end
pro sts1_reformatter::icu_counters_extension
	self->unpack_icu_counters, mdp, st, tc, ras, seq, exp

	fxbaddcol, col, self.header, mode,       'eis_mode',   'EIS mode',                    tunit='',  tdmin=min(mode),       tdmax=max(mode)
	
	; Create the fits header
	create_header, alun, self.fits_file, self.header

	; Write the columns data
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(mode),       1, 10, 'eis_mode'
end

pro sts1_reformatter::unpack_icu_science, i, p, ll
	tmp = (*self.packet_data).eis_mode

end
pro sts1_reformatter::icu_science_extension
	self->unpack_icu_science, i, p, ll

	fxbaddcol, col, self.header, mode,       'eis_mode',   'EIS mode',                    tunit='',  tdmin=min(mode),       tdmax=max(mode)
	
	; Create the fits header
	create_header, alun, self.fits_file, self.header

	; Write the columns data
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(mode),       1, 11, 'eis_mode'
end

pro sts1_reformatter::unpack_spacecraft, sctime, counter
	tmp = (*self.packet_data).eis_mode

end
pro sts1_reformatter::spacecraft_extension
	self->unpack_spacecraft, sctime, counter

	fxbaddcol, col, self.header, mode,       'eis_mode',   'EIS mode',                    tunit='',  tdmin=min(mode),       tdmax=max(mode)
	
	; Create the fits header
	create_header, alun, self.fits_file, self.header

	; Write the columns data
	self->status_reformatter::fits_write, alun, self->status_reformatter::pad(mode),       1, 12, 'eis_mode'
end

pro sts1_reformatter::create_sts1_extensions, packet_data, timing_data
	
	self->create_gap_information, timing_data, number_of_gaps, gap_starts, gap_lengths, ref_time
	
	self->psu_voltages_extension
	self->psu_currents_extension
	self->psu_temps_extension
	self->icu_misc_extension
	self->icu_status_extension
	self->psu_status_extension
	self->hm_status_extension
	self->icu_if_extension
	self->icu_errors_extension
	self->icu_counters_extension
	self->icu_science_extension
	self->sts1_spacecraft_extension
	self->status_reformatter::finish

end
