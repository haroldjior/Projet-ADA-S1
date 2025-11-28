with ada.text_io, ada.integer_text_io; use ada.text_io, ada.integer_text_io;

package body outils is

   procedure saisie_nom_client (C : in out client) is

      s : T_nom_client;
      k : integer := 0;
      x : integer := 0;

   begin
      loop
         put ("Nom du client :");
         get_line (s, k);
         x := 0;
         for i in 1 .. k loop
            if s (i) not in 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | ' ' then
               x := x + 1;
            end if;
         end loop;

         if x = 0 then
            C.nom_Client := s;
            put ("nom valide");
            exit;
         else
            put ("Le nom du client n'est pas valide");
            new_line;
         end if;
      end loop;

   end saisie_nom_client;
end outils;
