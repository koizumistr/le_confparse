class CONFPARSER

create {ANY}
   read, make_from_file, make_from_path

feature {ANY}
   make_from_file (f: TEXT_FILE_READ)
      require
         file_attached: f /= Void
         file_connected: f.is_connected
      do
         create dict.make
         parse_file(f)
      ensure
         dict_not_void: dict /= Void
      end

   make_from_path (path: STRING)
      require
         path_attached: path /= Void
      local
         file: TEXT_FILE_READ
      do
         create dict.make
         create file.connect_to(path)
         if file.is_connected then
            parse_file(file)
            file.disconnect
         end
      ensure
         dict_not_void: dict /= Void
      end

   for_each (action: PROCEDURE[TUPLE[STRING, STRING]])
      do
         dict.for_each(action)
      end

   read (f: TEXT_FILE_READ)
      obsolete "Use 'make_from_file' instead"
      do
         make_from_file(f)
      end

   dict: HASHED_DICTIONARY[STRING, STRING]

feature {}
   parse_file (f: TEXT_FILE_READ)
      local
         line_num: INTEGER; line: STRING
      do
         from
            line_num := 1
         until
            f.end_of_input
         loop
            f.read_line
            line := f.last_string
            if line.count = 0 then
               -- nop
            elseif line.has_prefix("#") or line.has_prefix("--") then
               -- comment
            elseif line.first.is_separator then
               warn(line_num.to_string, "Warning: no key")
            else
               parse_line(line_num.to_string, line)
            end

            if err then
               crash
            end

            line_num := line_num + 1
            is_warned := False
            err := False
         end
      end

   parse_line (line_num, line: STRING)
      local
         key, value: STRING
      do
         create key.make_empty
         from
         until
            line.is_empty or else line.first.is_separator
         loop
            key.add_last(line.first)
            line.remove_first
         end

         line.left_adjust
         create value.make_empty
         if not line.is_empty and then line.first = '"' then
            line.remove_first
            from
            until
               line.is_empty or else line.first = '"'
            loop
               value.add_last(line.first)
               line.remove_first
            end

            if line.is_empty then
               warn(line_num, "Error: malformed value")
               err := True
            end
         else
            from
            until
               line.is_empty or else line.first.is_separator
            loop
               value.add_last(line.first)
               line.remove_first
            end
            if value.is_empty then
               warn(line_num, "Error: no value")
               err := True
            end

            line.left_adjust
            if line.is_empty then
               -- OK
            elseif line.has_prefix("#") or line.has_prefix("--") then
               -- comment OK
            else
               warn(line_num, "Error: malformed value")
               err := True
            end
         end

         if not (is_warned or err) then
            dict.put(value, key)
         end
      end

   is_warned, err: BOOLEAN

   warn (position, message: STRING)
      do
         std_error.put_string(message + " at " + position + "%N")
         is_warned := True
      end

end -- class CONFPARSER
