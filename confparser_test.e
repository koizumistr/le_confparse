class CONFPARSER_TEST

insert
   ARGUMENTS

create {ANY}
   make

feature {ANY}
   make
      local
         c: CONFPARSER; conf: TEXT_FILE_READ; i: INTEGER
      do
         create conf.connect_to(argument(1))
         if conf.is_connected then
            create c.read(conf)
         end

         conf.disconnect

         from
            i := c.dict.lower
         until
            i > c.dict.upper
         loop
            std_output.put_string(c.dict.key(i) + ": " + c.dict.item(i) + "%N")
            i := i + 1
         end
      end

end -- class CONFPARSER_TEST
