with outils, gestion_date, gestion_lot, gestion_client;
use outils, gestion_date, gestion_lot, gestion_client;

package gestion_commande is

   max_com : constant := 3 * nb_C;

   --Record qui définit une commande par son numéro de lot, le nom du clienrt qui passe la commande,
   -- la composition de la commande, la date à laquelle la commmande à été passée et le temps d'attente en jour
   type T_commande is record
      num_com       : integer := -1;
      nom_client    : client;
      tab_compo_com : T_tab_produit;
      date_com      : T_date;
      attente       : integer := 0;
   end record;

   --Tableau de commande de taille 3*nb_c car 3 commandes max par client
   type T_tab_commande is array (integer range 1 .. max_com) of T_commande;

   --Affichage d'une commande T_commande, utilisé dans visu_tab_commande et visu_com_attente
   procedure affichage_commande (com : in T_commande);

   --Enregistrement d'une nouvelle commande
   procedure nouv_commande
     (tab_commande : in out T_tab_commande;
      date         : in T_date;
      tab_client   : in T_tab_client);

   --Annulation d'une commande
   procedure annul_commande (tab_commande : in out T_tab_commande);

   --Visualisation du registre des commandes
   procedure visu_tab_commande (tab_commande : in T_tab_commande);

   --Visualisation des commandes en attente pour un client donné
   procedure visu_com_attente_client (tab_commande : in T_tab_commande);

   --Visualisation des commandes en attente pour un produit donné
   procedure visu_com_attente_produit (tab_commande : in T_tab_commande);

   --Visualisation de tous les clients ayant commandé un produit donné
   procedure visu_client_commande (tab_commande : in T_tab_commande);

end gestion_commande;
