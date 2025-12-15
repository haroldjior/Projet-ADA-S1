with ada.text_io,
     ada.integer_text_io,
     ada.characters.handling,
     gestion_date,
     outils,
     ada.IO_Exceptions;
use ada.text_io,
    ada.integer_text_io,
    ada.characters.handling,
    gestion_date,
    outils;

package body gestion_lot is

   --Initialisation à 0 du tableau de lot
   procedure init_tab_lot (tab_lot : in out T_tab_lot) is
   begin
      for i in tab_lot'range loop
         tab_lot (i).num_lot := 0;
         tab_lot (i).produit := T_produit'val (0);
         tab_lot (i).date_fab.jour := 1;
         tab_lot (i).date_fab.annee := 1;
         tab_lot (i).stock := -1;
         tab_lot (i).nb_vendu := 0;
         tab_lot (i).prix_ex := 0;
      end loop;
   end init_tab_lot;

   --Saisie des capacités de production
   procedure saisie_tab_capa_prod (tab_capa_prod : in out T_tab_produit) is
      produit : T_produit;
   begin
      loop
         begin
            produit := LT;
            affichage_produit (produit);
            put (" : ");
            get (tab_capa_prod (LT));
            skip_line;
            exit when tab_capa_prod (LT)'Valid;
         exception
            when Data_Error | Constraint_Error =>
               skip_line;
               new_line;
               put_line ("/!\ Saisie invalide, entrez un entier");
               new_line;
         end;
      end loop;

      loop
         begin
            produit := D;
            affichage_produit (produit);
            put (" : ");
            get (tab_capa_prod (D));
            skip_line;
            exit when tab_capa_prod (D)'Valid;
         exception
            when Data_Error | Constraint_Error =>
               skip_line;
               new_line;
               put_line ("/!\ Saisie invalide, entrez un entier");
               new_line;
         end;
      end loop;
      loop
         begin
            produit := CV;
            affichage_produit (produit);
            put (" : ");
            get (tab_capa_prod (CV));
            skip_line;
            exit when tab_capa_prod (CV)'Valid;
         exception
            when Data_Error | Constraint_Error =>
               skip_line;
               new_line;
               put_line ("/!\ Saisie invalide, entrez un entier");
               new_line;
         end;
      end loop;
      loop
         begin
            produit := GD;
            affichage_produit (produit);
            put (" : ");
            get (tab_capa_prod (GD));
            skip_line;
            exit when tab_capa_prod (GD)'Valid;
         exception
            when Data_Error | Constraint_Error =>
               skip_line;
               new_line;
               put_line ("/!\ Saisie invalide, entrez un entier");
               new_line;
         end;
      end loop;
      loop
         begin
            produit := LC;
            affichage_produit (produit);
            put (" : ");
            get (tab_capa_prod (LC));
            skip_line;
            exit when tab_capa_prod (LC)'Valid;
         exception
            when Data_Error | Constraint_Error =>
               skip_line;
               new_line;
               put_line ("/!\ Saisie invalide, entrez un entier");
               new_line;
         end;
      end loop;
   end saisie_tab_capa_prod;

   procedure visu_tab_capa_prod (tab_capa_prod : in T_tab_produit) is
   begin
      put_line ("| Produit        |Capa|");
      put_line ("|----------------|----|");
      put ("| Lotion tonique | ");
      put (tab_capa_prod (LT), 2);
      put_line (" |");
      put ("| Demaquillant   | ");
      put (tab_capa_prod (D), 2);
      put_line (" |");
      put ("| Creme visage   | ");
      put (tab_capa_prod (CV), 2);
      put_line (" |");
      put ("| Gel douche     | ");
      put (tab_capa_prod (GD), 2);
      put_line (" |");
      put ("| Lait corporel  | ");
      put (tab_capa_prod (LC), 2);
      put_line (" |");
   end visu_tab_capa_prod;

   --Affichage d'un lot
   procedure affichage_lot (lot : in T_lot) is
      tmp : T_produit;
   begin
      put ("| ");
      put (lot.num_lot, 2);
      put (" | ");
      tmp := lot.produit;
      affichage_produit (tmp);
      if tmp = GD then
         put ("     | ");
      elsif tmp = LC then
         put ("  | ");
      elsif tmp = LT then
         put (" | ");
      elsif tmp = D then
         put ("   | ");
      elsif tmp = CV then
         put ("   | ");
      end if;
      affichage_date (lot.date_fab);
      put ("  |  ");
      put (lot.stock, 3);
      put ("  |  ");
      put (lot.nb_vendu, 3);
      put ("   |   ");
      put (lot.prix_ex, 2);
      put (" |");
      new_line;
   end affichage_lot;

   --Initialisation du tableau de stock, regroupant la totalité des stocks pour chaque produit
   --utilisée si le fichier de sauvegarde n'existe pas
   procedure init_tab_stock (tab_stock : in out T_tab_produit) is
   begin
      for i in tab_stock'range loop
         tab_stock (i) := 0;
      end loop;
   end init_tab_stock;

   --Mise a jour du tableau de stock, regroupant la totalité des stocks pour chaque produit
   procedure maj_tab_stock
     (tab_lot : in T_tab_lot; tab_stock : in out T_tab_produit) is
   begin
      for i in tab_lot'range loop
         for j in T_produit loop
            if (tab_lot (i).stock /= -1) and then (tab_lot (i).produit = j)
            then
               tab_stock (j) := tab_stock (j) + tab_lot (i).stock;
            end if;
         end loop;
      end loop;

   end maj_tab_stock;

   --Saisie d'un lot
   procedure nouv_lot
     (tab_lot       : in out T_tab_lot;
      date          : in out T_date;
      tab_capa_prod : in out T_tab_produit;
      tab_stock     : in out T_tab_produit)
   is
      s      : string (1 .. 14);
      k, x   : integer;
      n      : integer := 0;
      trouve : Integer := -1; -- -1 par défaut, 1 si trouvé, 0 si pas trouvé
      valide : boolean;
      lot    : integer;
   begin

      --Recherche de la première case vide du tab_lot
      while trouve = -1 loop
         n := n + 1;
         if n > nb_lot then
            trouve := 0;
            exit;
         end if;
         if tab_lot (n).stock = -1 then
            trouve := 1;
            x := n;
         end if;
      end loop;

      if trouve = 1 then

         --Recherche du plus haut numéro de lot
         lot := tab_lot (1).num_lot;
         for i in tab_lot'range loop
            if tab_lot (i).num_lot > lot then
               lot := tab_lot (i).num_lot;
            end if;
         end loop;

         --Initialisation du numéro de lot
         tab_lot (x).num_lot := lot + 1;

         --Saisie du type de produit
         saisie_produit (tab_lot (x).produit);

         --Saisie de la date de fabrication
         tab_lot (x).date_fab := date;

         --Initialisation du stock en fonction de la capacité de production
         tab_lot (x).stock := tab_capa_prod (tab_lot (x).produit);

         --Initialisation du nombre d'exemplaires vendus
         tab_lot (x).nb_vendu := 0;

         --Saisie du prix d'un exemplaire
         loop
            begin
               put ("Prix d'un exemplaire : ");
               get (tab_lot (x).prix_ex);
               skip_line;
               exit when tab_lot (x).prix_ex >= 0;
            exception
               when ada.IO_Exceptions.Data_Error =>
                  Skip_Line;
                  Put_Line ("/!\ Erreur : entrer un entier positif");
            end;
         end loop;
         new_line;
         maj_tab_stock (tab_lot, tab_stock);
         put_line ("Lot ajoute avec succes !");
      elsif trouve = 0 then
         put_line ("/!\ Erreur : nombre de lots maximum atteint");
      end if;

   end nouv_lot;

   --Supression d'un lot basé sur son numéro de lot
   procedure sup_lot_num (tab_lot : in out T_tab_lot) is
      n      : integer;
      trouve : boolean := false;
   begin
      loop
         begin
            put ("Numéro du lot : ");
            get (n);
            skip_line;
            new_line;
            for i in tab_lot'range loop
               if tab_lot (i).num_lot = n then
                  tab_lot (i).num_lot := 0;
                  tab_lot (i).stock := -1;
                  trouve := true;
                  put_line ("Lot supprime avec succes !");
                  exit;
               end if;
            end loop;
            if not trouve then
               put_line ("/!\ Erreur : numero de lot inexistant");
            end if;
            exit when n > 0;
         exception
            when ada.IO_Exceptions.Data_Error =>
               skip_line;
               Put_Line ("/!\ Erreur : entrer un entier positif");
         end;
      end loop;
   end sup_lot_num;

   --Suppression de tous les lots fabriqués avant une date précise
   procedure sup_lot_date
     (tab_lot  : in out T_tab_lot;
      date     : out T_date;
      tab_mois : in out T_tab_mois)
   is
      lot_sup : integer := 0;
   begin
      saisie_date (date, tab_mois);
      new_line;
      for i in tab_lot'range loop
         if tab_lot (i).stock /= -1 then
            if tab_lot (i).date_fab.annee < date.annee then
               tab_lot (i).num_lot := 0;
               tab_lot (i).stock := -1;
               lot_sup := lot_sup + 1;
            elsif tab_lot (i).date_fab.annee = date.annee then
               if T_liste_mois'pos (tab_lot (i).date_fab.mois)
                 < T_liste_mois'pos (date.mois)
               then
                  tab_lot (i).num_lot := 0;
                  tab_lot (i).stock := -1;
                  lot_sup := lot_sup + 1;
               elsif T_liste_mois'pos (tab_lot (i).date_fab.mois)
                 = T_liste_mois'pos (date.mois)
               then
                  if tab_lot (i).date_fab.jour < date.jour then
                     tab_lot (i).num_lot := 0;
                     tab_lot (i).stock := -1;
                     lot_sup := lot_sup + 1;
                  end if;
               end if;
            end if;
         end if;
      end loop;

      --Affichage du nombre de lots supprimés
      if lot_sup = 0 then
         put_line ("Aucun lots supprimes");
      else
         put (lot_sup, 2);
         put_line (" lot(s) supprime(s)");
      end if;
   end sup_lot_date;

   --Modification des capacités de production par produit
   procedure modif_capa_prod_par_produit (tab_capa_prod : in out T_tab_produit)
   is
      produit : T_produit;
      nv_capa : Natural;
      trouve  : Boolean := false;
      indice  : integer := 0;
   begin
      saisie_produit (produit);
      for i in tab_capa_prod'range loop
         if i = produit then
            indice := T_produit'pos (i);
            trouve := true;
         end if;
      end loop;
      if trouve then
         loop
            begin
               put ("Nouvelle capacite de production : ");
               get (nv_capa);
               skip_line;
               tab_capa_prod (T_produit'val (indice)) := nv_capa;
               exit when nv_capa'Valid;
            exception
               when ada.IO_Exceptions.Data_Error =>
                  skip_line;
                  put_line ("/!\ Entree invalide");
               when Constraint_Error =>
                  skip_line;
                  put_line ("/!\ Entree invalide");
            end;
         end loop;
      else
         put_line ("Aucun lot existant de ce type de produit");
      end if;
   end modif_capa_prod_par_produit;

   --Visualisation du registre des lots
   procedure visu_tab_lot (tab_lot : in T_tab_lot) is
      tmp  : T_lot;
      vide : boolean := true;
   begin

      --Verification si le tableau de lot n'est pas vide
      for i in tab_lot'range loop
         if tab_lot (i).stock /= -1 then
            vide := false;
         end if;
      end loop;

      --Si tableau non vide, on l'affiche
      if not vide then
         put_line
           ("| N° | Produit        | Fabrication | Stock | Vendus | Prix |");
         put_line
           ("|----|----------------|-------------|-------|--------|------|");
         for i in tab_lot'range loop
            if tab_lot (i).stock /= -1 then
               tmp := tab_lot (i);
               affichage_lot (tmp);
            end if;
         end loop;

      --Si tableau vide, on affiche un message informatif

      else
         put_line ("Aucun lot enregistre");
      end if;

   end visu_tab_lot;

   --Visualisation des lots pour un produit donné
   procedure visu_lot_produit (tab_lot : in T_tab_lot) is
      prod           : T_produit;
      lot            : T_lot;
      en_stock, vide : Boolean := true;
   begin

      --Saisie du produit a visualise
      saisie_produit (prod);

      --Verification si le tableau n'est pas vide
      for i in tab_lot'range loop
         if tab_lot (i).stock /= -1 then
            vide := false;
         end if;
      end loop;

      --Si le tableau n'est pas vide, on l'affiche
      if not vide then
         new_line;
         put_line
           ("| N° | Produit        | Fabrication | Stock | Vendus | Prix |");
         put_line
           ("|----|----------------|-------------|-------|--------|------|");
         for i in tab_lot'range loop
            if (tab_lot (i).stock /= -1) and (tab_lot (i).produit = prod) then
               lot := tab_lot (i);
               affichage_lot (lot);
               en_stock := True;
            end if;
         end loop;

         --Si le produit n'est pas présent dans le tableau on affiche un message informatif
         if not (en_stock) then
            new_line;
            put_line ("Produit non en stock");
         end if;

      --Si le tableau est vide, on affiche un message informatif

      else
         put_line ("Aucun lot enregistre");
      end if;

   end visu_lot_produit;

   --Visualisation des produits manquants en stock
   procedure visu_produit_manquant (tab_lot : in T_tab_lot) is
      tmp      : integer;
      en_stock : boolean;
      type T_r_visu is record
         visu_prod  : T_produit;
         visu_stock : boolean;
      end record;
      type T_tab_visu is
        array (integer
                 range T_produit'pos (T_produit'first)
                       .. T_produit'pos (T_produit'Last))
        of T_r_visu;
      tab_visu : T_tab_visu;
   begin
      --Initialisation du T_tab_visu
      for i in tab_visu'range loop
         tab_visu (i).visu_prod := T_produit'val (i);
         tab_visu (i).visu_stock := false;
      end loop;

      --Mise a jour du T_tab_visu en fonction est produit en stock
      for i in tab_lot'range loop
         if tab_lot (i).stock /= -1 then
            tab_visu (T_produit'pos (tab_lot (i).produit)).visu_stock := true;
         end if;
      end loop;

      --Affichage des produits manquants en stock
      new_line;
      Put_Line ("Produits manquants en stock : ");
      new_line;
      for i in tab_visu'range loop
         if not tab_visu (i).visu_stock then
            put ("=> ");
            affichage_produit (tab_visu (i).visu_prod);
            new_line;
         end if;
      end loop;
   end visu_produit_manquant;

end gestion_lot;
