with ada.text_io, ada.integer_text_io; use ada.text_io, ada.integer_text_io;

package outils is

   --Type pour le nom du client
   subtype T_nom_client is string (1 .. 100);

   --Record qui lie le nom du client et sa taille
   type client is record
      nom_Client : T_nom_client;
      k          : integer := 0;
   end record;

   --Procedure de saisie du nom du client, avec vérification de sa validité
   procedure saisie_nom_client (C : in out client);

end outils;
