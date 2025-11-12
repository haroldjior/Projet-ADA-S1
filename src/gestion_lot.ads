with gestion_date; use gestion_date;

package gestion_lot is

   --Nombre maximum de lots
   nb_lot : constant := 7;

   --Type énuméré de la liste des produits
   --LT = Lait tonique; D = Démaquillant; CV = Crème visage; GD = Gel douche; LC = Lait corporel
   type T_produit is (LT, D, CV, GD, LC);

   --Record qui lit le numéro de lot, le type de produit du lot, sa date de fabrication,
   --le nombre d'exemplaires en stock, le nombre d'exemplaires déjà vendus, et le prix d'un exemplaire
   type T_lot is record
      num_lot  : integer;
      produit  : T_produit;
      date_fab : T_date;
      stock    : integer;  -- = -1 si T_lot vide
      nb_vendu : integer;  -- = -1 si T_lot vide
      prix_ex  : integer;  -- = -1 si T_lot vide
   end record;

   --Tableau de T_lot de taille nb_lot
   --si case vide alors stock = -1
   type T_tab_lot is array (integer range 1 .. nb_lot) of T_lot;

   --Initialisation à 0 du tableau de lot
   procedure init_tab_lot (tab_lot : in out T_tab_lot);

   --Affichage de la nature du produit d'un T_lot
   procedure affichage_produit (lot : in T_lot);

   --Saisie d'un lot
   procedure saisie_lot
     (tab_lot     : in out T_tab_lot;
      date        : in out T_date;
      tab_mois    : in out T_tab_mois;
      max_num_lot : in out integer);

   --Supression d'un lot basé sur son numéro de lot
   procedure sup_lot_num (tab_lot : in out T_tab_lot);

   --Suppression de tous les lots d'une certaine date de fabrication
   procedure sup_lot_date
     (tab_lot  : in out T_tab_lot;
      date     : out T_date;
      tab_mois : in out T_tab_mois);

   --Visualisation du registre des lots
   procedure visu_lot (tab_lot : in T_tab_lot);

end gestion_lot;
