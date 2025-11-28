with ada.text_io, ada.integer_text_io, gestion_date, outils, ada.IO_Exceptions;
use ada.text_io, ada.integer_text_io, gestion_date, outils;

package body gestion_commande is

   --Enregistrement d'une nouvelle commande
   procedure nouv_commande (tab_commande : in out T_tab_commande) is
      nom_client : client;
   begin

      saisie_nom_client (nom_client);

   end nouv_commande;

end gestion_commande;
