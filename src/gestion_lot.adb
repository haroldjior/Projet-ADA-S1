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
         tab_lot (i).nb_vendu := -1;
         tab_lot (i).prix_ex := -1;
      end loop;
   end init_tab_lot;

   --Initialisation du tableau des capacités de production
   procedure init_tab_capa_prod (tab_capa_prod : in out T_tab_capa_prod) is
   begin
      tab_capa_prod (T_produit'val (0)) := 10;
      tab_capa_prod (T_produit'val (1)) := 8;
      tab_capa_prod (T_produit'val (2)) := 12;
      tab_capa_prod (T_produit'val (3)) := 10;
      tab_capa_prod (T_produit'val (4)) := 12;
   end init_tab_capa_prod;

   --Saisie d'un produit
   procedure saisie_produit (produit : in out T_produit) is
      s      : string (1 .. 14);
      k      : integer;
      valide : Boolean;
   begin
      loop
         valide := true;
         put ("Type de produit : ");
         get_line (s, k);
         if to_lower (s (1 .. k)) = "lotion tonique" then
            produit := T_produit'val (0);
         elsif to_lower (s (1 .. k)) = "demaquillant" then
            produit := T_produit'val (1);
         elsif to_lower (s (1 .. k)) = "creme visage" then
            produit := T_produit'val (2);
         elsif to_lower (s (1 .. k)) = "gel douche" then
            produit := T_produit'val (3);
         elsif to_lower (s (1 .. k)) = "lait corporel" then
            produit := T_produit'val (4);
         else
            valide := false;
            Put_Line ("/!\ Nom de produit invalide");
         end if;
         exit when valide;
      end loop;
   end saisie_produit;

   --Affichage de la nature du produit d'un T_lot
   procedure affichage_produit (produit : in T_produit) is
   begin
      if produit = T_produit'val (0) then
         Put_Line ("Lotion tonique");
      elsif produit = T_produit'val (1) then
         Put_Line ("Demaquillant");
      elsif produit = T_produit'val (2) then
         Put_Line ("Creme visage");
      elsif produit = T_produit'val (3) then
         Put_Line ("Gel douche");
      elsif produit = T_produit'val (4) then
         Put_Line ("Lait corporel");
      end if;
   end affichage_produit;

   --Saisie d'un lot
   procedure saisie_lot
     (tab_lot       : in out T_tab_lot;
      date          : in out T_date;
      tab_mois      : in out T_tab_mois;
      tab_capa_prod : in out T_tab_capa_prod)
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
         Put_Line ("Date de fabrication : ");
         saisie_date (date, tab_mois);
         tab_lot (x).date_fab.jour := date.jour;
         tab_lot (x).date_fab.mois := date.mois;
         tab_lot (x).date_fab.annee := date.annee;

         --Initialisation du stock en fonction de la capacité de production
         tab_lot (x).stock := tab_capa_prod (tab_lot (x).produit);
         put (tab_capa_prod (tab_lot (x).produit));

         --Initialisation du nombre d'exemplaires vendus
         tab_lot (x).nb_vendu := 0;

         --Saisie du prix d'un exemplaire
         loop
            begin
               put ("Prix d'un exemplaire : ");
               get (tab_lot (x).prix_ex);
               skip_line;
               exit when tab_lot (x).prix_ex >= 0;
               if tab_lot (x).prix_ex < 0 then
                  Put_Line
                    ("/!\ Valeur de prix invalide, veuillez entrer un entier positif");
               end if;
            exception
               when ada.IO_Exceptions.Data_Error =>
                  Skip_Line;
                  Put_Line
                    ("/!\ Valeur de prix invalide, veuillez entrer un entier positif");
            end;
         end loop;
      elsif trouve = 0 then
         put_line ("Nombre de lots maximum atteint");
      end if;

   end saisie_lot;

   --Supression d'un lot basé sur son numéro de lot
   procedure sup_lot_num (tab_lot : in out T_tab_lot) is
      n : integer;
   begin
      loop
         begin
            put ("Numéro du lot : ");
            get (n);
            skip_line;
            for i in tab_lot'range loop
               if tab_lot (i).num_lot = n then
                  tab_lot (i).num_lot := 0;
                  tab_lot (i).stock := -1;
               elsif (tab_lot (i).num_lot > 0) and (tab_lot (i).num_lot /= n)
               then
                  put_line
                    ("Destruction impossible, le numéro de lot saisie n'existe pas ou plus");
               end if;
            end loop;
            exit when n > 0;
         exception
            when ada.IO_Exceptions.Data_Error =>
               skip_line;
               Put_Line
                 ("/!\ Saisie invalide, veuillez entrer un entier positif");
         end;
      end loop;
   end sup_lot_num;

   --Affichage d'un lot
   procedure affichage_lot (lot : in T_lot) is
      tmp : T_produit;
   begin
      put ("Numero de lot : ");
      put (lot.num_lot, 1);
      new_line;
      put ("Nature du produit : ");
      tmp := lot.produit;
      affichage_produit (tmp);
      put_line ("Date de fabrication :");
      put (lot.date_fab.jour, 2);
      put (" ");
      put (T_liste_mois'image (lot.date_fab.mois));
      put (" ");
      put (lot.date_fab.annee, 4);
      new_line;
      put ("Nombre d'exemplaires en stock : ");
      put (lot.stock, 3);
      new_line;
      put ("Nombre d'exemplaires vendus : ");
      put (lot.nb_vendu, 3);
      new_line;
      put ("Prix d'un exemplaire : ");
      put (lot.prix_ex, 2);
      new_line;
   end affichage_lot;

   --Suppression de tous les lots fabriqués avant une date précise
   procedure sup_lot_date
     (tab_lot  : in out T_tab_lot;
      date     : out T_date;
      tab_mois : in out T_tab_mois) is
   begin
      put ("Date de fabrication : ");
      saisie_date (date, tab_mois);
      for i in tab_lot'range loop
         if tab_lot (i).stock /= -1 then
            if tab_lot (i).date_fab.annee < date.annee then
               tab_lot (i).num_lot := 0;
               tab_lot (i).stock := -1;
            elsif tab_lot (i).date_fab.annee = date.annee then
               if T_liste_mois'pos (tab_lot (i).date_fab.mois)
                 < T_liste_mois'pos (date.mois)
               then
                  tab_lot (i).num_lot := 0;
                  tab_lot (i).stock := -1;
               elsif T_liste_mois'pos (tab_lot (i).date_fab.mois)
                 = T_liste_mois'pos (date.mois)
               then
                  if tab_lot (i).date_fab.jour < date.jour then
                     tab_lot (i).num_lot := 0;
                     tab_lot (i).stock := -1;
                  end if;
               end if;
            end if;
         end if;
      end loop;
   end sup_lot_date;

   --Modification des capacités de produciton
   procedure modif_capa_prod (tab_capa_prod : in out T_tab_capa_prod) is
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
   end modif_capa_prod;

   --Visualisation du registre des lots
   procedure visu_tab_lot (tab_lot : in T_tab_lot) is
      tmp : T_lot;
   begin
      for i in tab_lot'range loop
         if tab_lot (i).stock /= -1 then
            tmp := tab_lot (i);
            affichage_lot (tmp);
         end if;
      end loop;
   end visu_tab_lot;

   --Visualisation des lots pour un produit donné
   procedure visu_lot_produit (tab_lot : in T_tab_lot; produit : in T_produit)
   is
      prod     : T_produit;
      lot      : T_lot;
      en_stock : Boolean := True;
   begin
      prod := produit;
      saisie_produit (prod);
      for i in tab_lot'range loop
         if (tab_lot (i).stock /= -1) and (tab_lot (i).produit = prod) then
            lot := tab_lot (i);
            affichage_lot (lot);
         else
            en_stock := False;
         end if;
      end loop;
      if not en_stock then
         put_line ("Produit non en stock");
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
      Put_Line ("Produits manquants en stock : ");
      for i in tab_visu'range loop
         if not tab_visu (i).visu_stock then
            affichage_produit (tab_visu (i).visu_prod);
         end if;
      end loop;
   end visu_produit_manquant;

end gestion_lot;
