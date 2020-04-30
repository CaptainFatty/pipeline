;+
; NAME: eis_status_pipeline::split_files.pro
;
; PURPOSE: Reads a binary file containing Hinode status ccsds telemetry packets and creates 
; files containing each type of ccsds packet.
;
; CATEGORY: Engineering
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

pro eis_status_pipeline::split_files
  self->trace, 'eis_status_pipeline__split_files::split_files'

  self.ccsds_reader = ptr_new(obj_new('eis_ccsds_reader'))
  self.ccsds_writer = ptr_new(obj_new('eis_ccsds_writer'))

  self->log, 'Splitting files in ' + self.packet_source_directory + ' to ' + self.split_directory

  files = FILE_SEARCH(self.packet_source_directory + '/' + 'eis_sts*', count=file_count)
  if file_count eq 0 then begin
    self->log, 'No files found to split'
    obj_destroy, *self.ccsds_writer
    obj_destroy, *self.ccsds_reader
    return
  endif else begin
    foreach file, files do begin
      ok = *self.ccsds_reader->open_for_reading(file)
      if not ok then begin
        self->log, 'Can''t open ' + file + ' for reading'
        break
      endif else begin
        break_file, file, disk_log, dir, filename, ext, fversion, node
        apid_index = 0
        foreach status_type, self.split_file_types do begin
          output_file = self.split_directory + '/' + filename + '_' + status_type
          ;help, output_file
          ok = *self.ccsds_writer->open_for_writing(output_file)
          self->log, 'ccsds writer opened ' + output_file + ' ok'

          self->log, 'Splitting ' + file + ' into ' + status_type

          while (1) do begin
            if *self.ccsds_reader->next_packet(packet, with_apid=self.status_apids[apid_index]) then begin
              ;print, 'Got a packet'
              *self.ccsds_writer->write_packet, packet
            endif else begin
              ;print, 'Bye'
              break
            endelse
          endwhile

          apid_index = apid_index + 1
          *self.ccsds_reader->rewind
          *self.ccsds_writer->close_files

        endforeach
        *self.ccsds_reader->close_files
      endelse
    endforeach
    obj_destroy, *self.ccsds_writer
    obj_destroy, *self.ccsds_reader
  endelse

end
