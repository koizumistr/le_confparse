class CONFPARSER_TEST_NEW

insert
   ARGUMENTS

create {ANY}
   make

feature {ANY}
   make
      local
         conf: CONFPARSER; i: INTEGER
      do
         create conf.make_from_path(argument(1))
         from
            i := conf.dict.lower
         until
            i > conf.dict.upper
         loop
            std_output.put_string(conf.dict.key(i) + ": " + conf.dict.item(i) + "%N")
            i := i + 1
         end

         std_output.put_string("============================%N")
         conf.for_each(agent print_key_val(?, ?))
      end

   print_key_val (val, key: STRING)
      do
         std_output.put_string(key + ": " + val + "%N")
      end

end -- class CONFPARSER_TEST_NEW
