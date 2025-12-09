with ada.text_io, ada.integer_text_io, outils;
use ada.text_io, ada.integer_text_io, outils;

package gestion_client is
   nb_C : constant := 6;

   type T_client is record
      nom_du_Client : client;
      nb_com        : integer := -1;
      fact          : Integer := 0;
      montant_achat : integer := 0;
   end record;

   type T_tab_client is array (integer range 1 .. nb_C) of T_client;

   --Ajout d'un client dans le registre de client
   procedure ajout_client (A : in out T_tab_client);

   --Suppression d'un client du registre de client
   procedure sup_client (tab_client : in out T_tab_client);

   --Enregistrement d'un règlement
   procedure reglement (tab_client : in out T_tab_client);

   --Visualisation du registre de clients
   procedure visu_tab_client (tab_client : in out T_tab_client);

   --Visualisation des clients sans commandes en attentes
   procedure visu_sans_commande_attente (tab_client : in out T_tab_client);

end gestion_client;
