package outils is

   --Type pour le nom du client
   subtype T_nom_client is string (1 .. 100);

   --Record qui lie le nom du client et sa taille
   type client is record
      nom_Client : T_nom_client := (others => ' ');
      k          : integer := 0;
   end record;

   --Procedure de saisie du nom du client, avec vérification de sa validité
   procedure saisie_nom_client (C : in out client);

   --Affichage du nom d'un client
   procedure affichage_nom_client (c : in client);

   --Type énuméré de la liste des produits
   --LT = Lotion tonique; D = Démaquillant; CV = Crème visage; GD = Gel douche; LC = Lait corporel
   type T_produit is (LT, D, CV, GD, LC);

   --Saisie d'un produit, utilisée dans
   -- package gestion_lot : saisie_lot, modif_capa_prod, visu_lot_produit
   procedure saisie_produit (produit : in out T_produit);

   --Affichage de la nature d'un produit donné, utilisée dans
   -- package gestion_lot : affichage_lot et visu_produit_manquant
   procedure affichage_produit (produit : in T_produit);

end outils;
