with ada.text_io,
     ada.integer_text_io,
     ada.characters.handling,
     gestion_date,
     outils;
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
         tab_lot (i).date_fab.jour := 0;
         tab_lot (i).date_fab.annee := 0;
         tab_lot (i).stock := -1;
         tab_lot (i).nb_vendu := -1;
         tab_lot (i).prix_ex := -1;
      end loop;
   end init_tab_lot;

   --Saisie d'un lot
   procedure saisie_lot
     (tab_lot     : in out T_tab_lot;
      date        : in out T_date;
      tab_mois    : in out T_tab_mois;
      max_num_lot : in out integer)
   is
      s      : string (1 .. 14);
      k      : integer;
      x      : integer := 0;
      trouve : boolean := false;
   begin

      --Recherche de la première case vide du tab_lot
      loop
         for i in tab_lot'range loop
            if tab_lot (i).stock = -1 then
               x := i;
               trouve := true;
            end if;
         end loop;
         exit when trouve;
      end loop;

      if trouve then
         --Initialisation du numéro de lot
         tab_lot (x).num_lot := max_num_lot + 1;
         max_num_lot := max_num_lot + 1;

         --Saisie du type de produit
         put ("Type de produit : ");
         get_line (s, k);
         s := to_lower (s);
         if s = "lait tonique" then
            tab_lot (x).produit := T_produit'val (0);
         elsif s = "demaquillant" then
            tab_lot (x).produit := T_produit'val (1);
         elsif s = "creme visage" then
            tab_lot (x).produit := T_produit'val (2);
         elsif s = "gel douche" then
            tab_lot (x).produit := T_produit'val (3);
         elsif s = "lait corporel" then
            tab_lot (x).produit := T_produit'val (4);
         end if;

         --Saisie de la date de fabrication
         Put_Line ("Date de fabrication : ");
         saisie_date (date, tab_mois);
         tab_lot (x).date_fab.jour := date.jour;
         tab_lot (x).date_fab.mois := date.mois;
         tab_lot (x).date_fab.annee := date.annee;

         --Saisie du stock initial
         put ("Initialisation du stock : ");
         get (tab_lot (x).stock);
         skip_line;

         --Initialisation du nombre d'exemplaires vendus
         tab_lot (x).nb_vendu := 0;

         --Saisie du prix d'un exemplaire
         put ("Prix d'un exemplaire : ");
         get (tab_lot (x).prix_ex);
         skip_line;
      else
         put_line ("Nombre de lots maximum atteint");
      end if;

   end saisie_lot;

   --Supression d'un lot basé sur son numéro de lot
   procedure sup_lot_num (tab_lot : in out T_tab_lot) is
      n : integer;
   begin
      put ("Numéro du lot : ");
      get (n);
      skip_line;
      for i in tab_lot'range loop
         if tab_lot (i).num_lot = n then
            tab_lot (i).num_lot := 0;
            tab_lot (i).stock := -1;
         end if;
      end loop;
   end sup_lot_num;

   --Suppression de tous les lots d'une certaine date de fabrication
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

end gestion_lot;
