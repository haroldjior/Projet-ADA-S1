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
      stock    : integer;
      nb_vendu : integer;
      prix_ex  : integer;
   end record;

   --Tableau de T_lot de taille nb_lot
   type T_tab_lot is array (integer range 1 .. nb_lot) of T_lot;

end gestion_lot;
