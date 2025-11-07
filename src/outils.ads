with ada.text_io, ada.integer_text_io; use ada.text_io, ada.integer_text_io;

package outils is

   subtype T_nom_client is string (1 .. 100);

   type client is record
      nom_Client : T_nom_client;
      k          : integer := 0;
   end record;

   procedure saisie_nom_client (C : in out client);

end outils;
