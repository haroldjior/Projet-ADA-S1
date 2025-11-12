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

   --Affichage de la nature du produit d'un T_lot
   procedure affichage_produit (lot : in T_lot) is
   begin
      if lot.produit = T_produit'val (0) then
         put ("Lait tonique");
      elsif lot.produit = T_produit'val (1) then
         put ("Demaquillant");
      elsif lot.produit = T_produit'val (2) then
         put ("Creme visage");
      elsif lot.produit = T_produit'val (3) then
         put ("Gel douche");
      elsif lot.produit = T_produit'val (4) then
         put ("Lait corporel");
      end if;
   end affichage_produit;

   --Saisie d'un lot
   procedure saisie_lot
     (tab_lot     : in out T_tab_lot;
      date        : in out T_date;
      tab_mois    : in out T_tab_mois;
      max_num_lot : in out integer)
   is
      s      : string (1 .. 14);
      k, x   : integer;
      n      : integer := 1;
      trouve : boolean := false;
      valide : boolean;
      lot    : integer;
   begin

      --Recherche de la première case vide du tab_lot
      while not (trouve) loop
         if tab_lot (n).stock = -1 then
            trouve := true;
            x := n;
         end if;
         n := n + 1;
      end loop;

      if trouve then

         --Recherche du plus haut numéro de lot
         lot := tab_lot'First.num_lot;
         for i in tab_lot'range loop
            if tab_lot (i).num_lot > lot then
               lot := tab_lot (i).num_lot;
            end if;
         end loop;

         --Initialisation du numéro de lot
         tab_lot (x).num_lot := lot + 1;

         --Saisie du type de produit
         loop
            valide := true;
            put ("Type de produit : ");
            get_line (s, k);
            if (to_lower (s (1 .. k)) = "lait tonique")
              or (to_lower (s (1 .. k)) = "demaquillant")
              or (to_lower (s (1 .. k)) = "creme visage")
              or (to_lower (s (1 .. k)) = "gel douche")
              or (to_lower (s (1 .. k)) = "lait corporel")
            then
               if to_lower (s (1 .. k)) = "lait tonique" then
                  tab_lot (x).produit := T_produit'val (0);
               elsif to_lower (s (1 .. k)) = "demaquillant" then
                  tab_lot (x).produit := T_produit'val (1);
               elsif to_lower (s (1 .. k)) = "creme visage" then
                  tab_lot (x).produit := T_produit'val (2);
               elsif to_lower (s (1 .. k)) = "gel douche" then
                  tab_lot (x).produit := T_produit'val (3);
               elsif to_lower (s (1 .. k)) = "lait corporel" then
                  tab_lot (x).produit := T_produit'val (4);
               end if;
            else
               valide := false;
            end if;
            exit when valide;
            Put_Line ("/!\ Nom de produit invalide");
         end loop;

         --Saisie de la date de fabrication
         Put_Line ("Date de fabrication : ");
         saisie_date (date, tab_mois);
         tab_lot (x).date_fab.jour := date.jour;
         tab_lot (x).date_fab.mois := date.mois;
         tab_lot (x).date_fab.annee := date.annee;

         --Saisie du stock initial
         loop
            begin
               put ("Initialisation du stock : ");
               get (tab_lot (x).stock);
               skip_line;
               exit when tab_lot (x).stock > 0;
               if tab_lot (x).stock = 0 then
                  Put_Line
                    ("/!\ Vous ne pouvez pas intialiser les stocks à 0");
               elsif tab_lot (x).stock < 0 then
                  Put_Line
                    ("/!\ Valeur de stock invalide, veuillez entrer un entier positif");
               end if;
            exception
               when ada.IO_Exceptions.Data_Error =>
                  skip_line;
                  Put_Line
                    ("/!\ Valeur de stock invalide, veuillez entrer un entier positif");
            end;
         end loop;

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
      else
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

   --Visualisation du registre des lots
   procedure visu_lot (tab_lot : in T_tab_lot) is
      tmp : T_lot;
   begin
      for i in tab_lot'range loop
         if tab_lot (i).stock /= -1 then
            put ("Numero de lot : ");
            put (tab_lot (i).num_lot, 1);
            new_line;
            put ("Nature du produit : ");
            tmp := tab_lot (i);
            affichage_produit (tmp);
            new_line;
            put_line ("Date de fabrication :");
            put (tab_lot (i).date_fab.jour, 2);
            put (" ");
            put (T_liste_mois'image (tab_lot (i).date_fab.mois));
            put (" ");
            put (tab_lot (i).date_fab.annee, 4);
            new_line;
            put ("Nombre d'exemplaires en stock : ");
            put (tab_lot (i).stock, 3);
            new_line;
            put ("Nombre d'exemplaires vendus : ");
            put (tab_lot (i).nb_vendu, 3);
            new_line;
            put ("Prix d'un exemplaire : ");
            put (tab_lot (i).prix_ex, 2);
            new_line;
         end if;
         new_line;
      end loop;
   end visu_lot;

end gestion_lot;
