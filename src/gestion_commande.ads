with outils, gestion_date, gestion_lot; use outils, gestion_date, gestion_lot;

package gestion_commande is

   max_com : constant := 3; -- *nb_c car 3 commandes par client

   --Tableau de composition d'une commande, produit en indice,
   -- contient un entier qui représente le nombre d'exemplaire
   type T_tab_compo_com is array (T_produit) of integer;

   --Record qui définit une commande par son numéro de lot, le nom du clienrt qui passe la commande,
   -- la composition de la commande, la date à laquelle la commmande à été passée et le temps d'attente en jour
   type T_commande is record
      num_com       : integer;
      nom_client    : client;
      tab_compo_com : T_tab_compo_com;
      date          : T_date;
      attente       : integer;
   end record;

   --Tableau de commande de taille 3*nb_c car 3 commandes max par client
   type T_tab_commande is array (integer range 1 .. max_com) of T_commande;

   --Enregistrement d'une nouvelle commande
   procedure nouv_commande (tab_commande : in out T_tab_commande);

end gestion_commande;
