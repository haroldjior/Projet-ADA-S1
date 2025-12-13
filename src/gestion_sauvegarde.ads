with gestion_lot, gestion_client, gestion_commande, Ada.Sequential_IO;
use gestion_lot, gestion_client, gestion_commande;

package gestion_sauvegarde is

   type T_sauvegarde is record
      sauv_lot       : T_tab_lot;
      sauv_capa_prod : T_tab_produit;
      sauv_client    : T_tab_client;
      sauv_com       : T_tab_commande;
   end record;

   package fichier_sauvegarde is new Ada.Sequential_IO (T_sauvegarde);

   procedure sauvegarde_donnees
     (lot  : in T_tab_lot;
      cli  : in T_tab_client;
      com  : in T_tab_commande;
      capa : in T_tab_produit);

   procedure restauration
     (lot  : out T_tab_lot;
      cli  : out T_tab_client;
      com  : out T_tab_commande;
      capa : out T_tab_produit);

   procedure restauration_US
     (lot  : out T_tab_lot;
      cli  : out T_tab_client;
      com  : out T_tab_commande;
      capa : out T_tab_produit);

end gestion_sauvegarde;
