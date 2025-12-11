with ada.text_io,
     ada.integer_text_io,
     Ada.Sequential_IO,
     outils,
     gestion_date,
     gestion_lot,
     gestion_commande,
     gestion_client;
use ada.text_io,
    ada.integer_text_io,
    outils,
    gestion_date,
    gestion_lot,
    gestion_commande,
    gestion_client;

package gestion_achat is

   --Compisition d'un achat
   type T_compo_achat is record
      produit : T_produit;
      num_lot : integer := -1;
      nb_ex   : integer := 0;
   end record;

   type T_tab_compo_achat is
     array (integer range 1 .. nb_lot) of T_compo_achat;

   type T_achat is record
      tab_compo_achat : T_tab_compo_achat;
      date_liv        : T_date;
      nom_client      : client;
      prix            : integer := -1;
      tps_ecoule      : integer := 0;
   end record;

   package archive_achat is new Ada.Sequential_IO (T_achat);

   --Verifie si les stock sont suffisant pour satisfaire une commande
   function livr_possible
     (com : T_commande; tab_stock : T_tab_produit) return boolean;

   function stock_suffisant
     (com : T_commande; tab_stock : T_tab_produit) return boolean;

   procedure sup_lot_vide (tab_lot : in out T_tab_lot);

   procedure sup_commande (com : in out T_commande);

   procedure maj_client
     (nom : in client; tab_client : in out T_tab_client; montant : in integer);

   procedure livraison
     (tab_commande : in out T_tab_commande;
      tab_stock    : T_tab_produit;
      date         : in T_date;
      tab_lot      : in out T_tab_lot;
      tab_client   : in out T_tab_client);

   procedure visu_achat (achat : in T_achat);

   procedure visu_achat_client (tab_client : T_tab_client);

   procedure visu_archive_achat;

   procedure visu_chiffre_affaire (tab_com : in T_tab_commande);

   procedure visu_nb_ex_vendu;

   procedure attente_moy_livraison;

end gestion_achat;
