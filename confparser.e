class CONFPARSER

create {ANY}
   read

feature {ANY}
   read (f: TEXT_FILE_READ)
      require
         f /= Void and f.is_connected
      local
         line, key, value: STRING; warn, err: BOOLEAN
      do
         from
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
               std_error.put_string("Warning: NO key%N")
               warn := True
            else
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
                     std_error.put_string("Error: malformed value%N")
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
                     std_error.put_string("Error: NO value%N")
                     err := True
                  end

                  line.left_adjust
                  if line.is_empty then
                     -- OK
                  elseif line.has_prefix("#") or line.has_prefix("--") then
                     -- comment OK
                  else
                     std_error.put_string("Error: malformed value%N")
                     err := True
                  end
               end
               if not (warn or err) then
                  dict.put(value, key)
               end

            end

            if err then
               crash
            end

            warn := False
            err := False
         end
      end

   dict: HASHED_DICTIONARY[STRING, STRING]
      once
         create Result.make
      end

end -- class CONFPARSER
