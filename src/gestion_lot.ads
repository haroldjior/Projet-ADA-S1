with gestion_date, outils; use gestion_date, outils;

package gestion_lot is

   --Nombre maximum de lots
   nb_lot : constant := 7;

   --Record qui lit le numéro de lot, le type de produit du lot, sa date de fabrication,
   --le nombre d'exemplaires en stock, le nombre d'exemplaires déjà vendus, et le prix d'un exemplaire
   type T_lot is record
      num_lot  : integer := 0;
      produit  : T_produit;
      date_fab : T_date;
      stock    : integer := -1;
      nb_vendu : integer := 0;
      prix_ex  : Integer := 0;
   end record;

   --Tableau de T_lot de taille nb_lot
   type T_tab_lot is array (integer range 1 .. nb_lot) of T_lot;

   type T_tab_produit is array (T_produit) of natural;

   --Initialisation à 0 du tableau de lot, à utiliser systématiquement au début du main
   procedure init_tab_lot (tab_lot : in out T_tab_lot);

   --Initialisation du tableau des capacités de production, à utiliser systématiquement au début du main
   procedure init_tab_capa_prod (tab_capa_prod : in out T_tab_produit);

   --Visualisation du tableau des capacités de production
   procedure visu_tab_capa_prod (tab_capa_prod : in T_tab_produit);

   --Saisie d'un lot
   procedure nouv_lot
     (tab_lot       : in out T_tab_lot;
      date          : in out T_date;
      tab_capa_prod : in out T_tab_produit;
      tab_stock     : in out T_tab_produit);

   --Affichage d'un lot, utilisée dans visu_tab_lot et visu_lot_produit
   procedure affichage_lot (lot : in T_lot);

   --Initialisation du tableau de stock, regroupant la totalité des stocks pour chaque produit
   --utilisée si le fichier de sauvegarde n'existe pas
   procedure init_tab_stock (tab_stock : in out T_tab_produit);

   --Mise a jour du tableau de stock, regroupant la totalité des stocks pour chaque produit
   procedure maj_tab_stock
     (tab_lot : in T_tab_lot; tab_stock : in out T_tab_produit);

   --Supression d'un lot basé sur son numéro de lot
   procedure sup_lot_num (tab_lot : in out T_tab_lot);

   --Suppression de tous les lots fabriqués avant une date précise
   procedure sup_lot_date
     (tab_lot  : in out T_tab_lot;
      date     : out T_date;
      tab_mois : in out T_tab_mois);

   --Modification des capacités de produciton
   procedure modif_capa_prod (tab_capa_prod : in out T_tab_produit);

   --Visualisation du registre des lots
   procedure visu_tab_lot (tab_lot : in T_tab_lot);

   --Visualisation des lots pour un produit donné
   procedure visu_lot_produit (tab_lot : in T_tab_lot);

   --Visualisation des produits manquants en stock
   procedure visu_produit_manquant (tab_lot : in T_tab_lot);

end gestion_lot;
