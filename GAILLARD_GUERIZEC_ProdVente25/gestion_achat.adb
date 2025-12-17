with ada.text_io,
     ada.integer_text_io,
     Ada.Sequential_IO,
     ada.directories,
     outils,
     gestion_date,
     gestion_commande,
     gestion_lot;
use ada.text_io,
    ada.integer_text_io,
    ada.directories,
    outils,
    gestion_date,
    gestion_commande,
    gestion_lot;

package body gestion_achat is

   use archive_achat;

   function stock_suffisant
     (com : T_commande; tab_stock : T_tab_produit) return boolean
   is
      suffisant : boolean;
   begin

      for i in T_produit loop
         if com.tab_compo_com (i) <= tab_stock (i) then
            suffisant := true;
         else
            suffisant := false;
            exit;
         end if;
      end loop;

      return (suffisant);

   end stock_suffisant;

   procedure prelever_produit
     (produit         : in T_produit;
      qt_voulue       : in integer;
      tab_lot         : in out T_tab_lot;
      tab_compo_achat : in out T_tab_compo_achat;
      cout            : in out integer)
   is
      qt_rest : integer := qt_voulue;
      qt_prel : integer;
      i_compo : integer := 0;
   begin

      --Recherche de la premiere case vide de tab_compo_achat
      for i in tab_compo_achat'range loop
         if tab_compo_achat (i).num_lot = -1 then
            i_compo := i;
            exit;
         end if;
      end loop;

      for i in tab_lot'range loop
         if (tab_lot (i).stock /= -1)
           and then (qt_rest > 0)
           and then (tab_lot (i).produit = produit)
           and then (tab_lot (i).stock > 0)
         then

            if tab_lot (i).stock >= qt_rest then
               qt_prel := qt_rest;
            else
               qt_prel := tab_lot (i).stock;
            end if;

            tab_lot (i).stock := tab_lot (i).stock - qt_prel;
            tab_lot (i).nb_vendu := tab_lot (i).nb_vendu + qt_prel;

            tab_compo_achat (i_compo).produit := produit;
            tab_compo_achat (i_compo).num_lot := tab_lot (i).num_lot;
            tab_compo_achat (i_compo).nb_ex := qt_prel;
            i_compo := i_compo + 1;

            cout := cout + (qt_prel * tab_lot (i).prix_ex);

            qt_rest := qt_rest - qt_prel;
         end if;
      end loop;

   end prelever_produit;

   procedure sup_lot_vide (tab_lot : in out T_tab_lot) is
   begin
      for i in tab_lot'range loop
         if (tab_lot (i).stock = 0) then
            tab_lot (i).num_lot := 0;
            tab_lot (i).stock := -1;
            tab_lot (i).nb_vendu := 0;
         end if;
      end loop;
   end sup_lot_vide;

   procedure sup_commande (com : in out T_commande) is
   begin
      com.num_com := -1;
      com.attente := 0;
   end sup_commande;

   procedure maj_client
     (nom : in client; tab_client : in out T_tab_client; montant : in integer)
   is
   begin

      for i in tab_client'range loop
         if (tab_client (i).nb_com /= -1)
           and then tab_client (i).nom_du_Client = nom
         then
            tab_client (i).nb_com := tab_client (i).nb_com - 1;
            tab_client (i).montant_achat :=
              tab_client (i).montant_achat + montant;
            tab_client (i).fact := tab_client (i).fact + montant;
            exit;
         end if;
      end loop;
   end maj_client;

   procedure livraison
     (tab_commande : in out T_tab_commande;
      tab_stock    : T_tab_produit;
      date         : in T_date;
      tab_lot      : in out T_tab_lot;
      tab_client   : in out T_tab_client;
      tab_mois     : in T_tab_mois)
   is
      achat            : T_achat;
      possible, livree : Boolean := false;
      cout             : integer;
      archive          : archive_achat.file_type;
   begin

      if exists ("archive_achat") then
         open (archive, append_file, "archive_achat");
      else
         create (archive, append_file, "archive_achat");
      end if;

      for i in tab_commande'range loop
         if tab_commande (i).num_com /= -1 then
            possible := stock_suffisant (tab_commande (i), tab_stock);
            if possible then
               cout := 0;
               for j in achat.tab_compo_achat'range loop
                  achat.tab_compo_achat (j).nb_ex := 0;
                  achat.tab_compo_achat (j).num_lot := -1;
               end loop;
               achat.nom_client := tab_commande (i).nom_client;
               achat.date_liv := date;
               for prod in T_produit loop
                  if tab_commande (i).tab_compo_com (prod) > 0 then

                     prelever_produit
                       (prod,
                        tab_commande (i).tab_compo_com (prod),
                        tab_lot,
                        achat.tab_compo_achat,
                        cout);
                  end if;
               end loop;

               achat.prix := cout;
               achat.tps_ecoule := tab_commande (i).attente;

               write (archive, achat);

               maj_client
                 (tab_commande (i).nom_client, tab_client, achat.prix);

               put ("Commande ");
               put (tab_commande (i).num_com, 2);
               put_line (" livree !");
               livree := true;

               sup_commande (tab_commande (i));
            else
               tab_commande (i).attente :=
                 diff_date (tab_commande (i).date_com, date, tab_mois);
            end if;
         end if;
      end loop;

      sup_lot_vide (tab_lot);

      if not livree then
         put_line ("Aucune commande livree");
      end if;

      close (archive);

   end livraison;

   procedure visu_achat (achat : in T_achat) is
   begin
      put_line
        ("|----------------------|------------|---------|--------|--------------------|");
      put ("| ");
      put (achat.nom_client.nom_Client (1 .. 20));
      put (" | ");
      affichage_date (achat.date_liv);
      put (" |      ");
      put (achat.tps_ecoule, 2);
      put (" |    ");
      put (achat.prix, 3);
      put (" | ");
      for i in achat.tab_compo_achat'range loop
         if achat.tab_compo_achat (i).num_lot /= -1 then
            if i = 1 then
               if achat.tab_compo_achat (i).produit = D then
                  put (T_produit'image (achat.tab_compo_achat (i).produit));
                  put ("  - lot ");
               else
                  put (T_produit'image (achat.tab_compo_achat (i).produit));
                  put (" - lot ");
               end if;
               put (achat.tab_compo_achat (i).num_lot, 1);
               put (" :");
               put (achat.tab_compo_achat (i).nb_ex, 2);
               put (" ex  |");
               new_line;
            elsif i > 1 then
               put
                 ("|                      |            |         |        | ");
               if achat.tab_compo_achat (i).produit = D then
                  put (T_produit'image (achat.tab_compo_achat (i).produit));
                  put ("  - lot ");
               else
                  put (T_produit'image (achat.tab_compo_achat (i).produit));
                  put (" - lot ");
               end if;
               put (achat.tab_compo_achat (i).num_lot, 1);
               put (" :");
               put (achat.tab_compo_achat (i).nb_ex, 2);
               put (" ex  |");
               new_line;
            end if;
         end if;
      end loop;

   end visu_achat;

   procedure visu_achat_client (tab_client : T_tab_client) is
      archive        : archive_achat.file_type;
      nom            : client;
      achat          : T_achat;
      existe         : boolean := false;
      indice         : integer := 0;
      archive_client : Boolean := false;
   begin

      --Verification qu'un registre d'achat est creer
      if exists ("archive_achat") then
         saisie_nom_client (nom);

         --Verification si le client existe dans le registre
         recherche_client (tab_client, nom.nom_Client, existe, indice);
         if existe then
            open (archive, in_file, "archive_achat");
            while not (end_of_file (archive)) loop
               read (archive, achat);
               if tab_client (indice).nom_du_Client = achat.nom_client then
                  if not archive_client then
                     put_line
                       ("| Client               | Livraison  | Attente | Cout   | Provenance         |");
                     archive_client := true;
                  end if;
                  visu_achat (achat);
               end if;
            end loop;
            close (archive);

            --Si le client n'a pas d'archive d'achat, on affiche un message informatif
            if not archive_client then
               new_line;
               put_line ("Aucune archive achat pour ce client");
            end if;

         --Si le client n'existe pas dans le registre, on affiche un message d'erreur

         else
            new_line;
            put_line ("/!\ Erreur : client inexistant");
         end if;

      --Si il n'existe pas d'archive d'achat, on affiche un message informatif

      else
         new_line;
         put_line ("Aucune archive d'achat");
      end if;

   end visu_achat_client;

   procedure visu_archive_achat is
      archive : archive_achat.file_type;
      achat   : T_achat;
   begin

      if exists ("archive_achat") then
         put_line
           ("| Client               | Livraison  | Attente | Cout   | Provenance         |");
         open (archive, in_file, "archive_achat");
         while not (end_of_file (archive)) loop
            read (archive, achat);
            visu_achat (achat);
         end loop;
         close (archive);
      else
         put ("Aucune archive d'achat");
         new_line;
      end if;

   end visu_archive_achat;

   procedure visu_chiffre_affaire (tab_com : in T_tab_commande) is
      archive   : archive_achat.file_type;
      achat     : T_achat;
      chiff_aff : integer := 0;
   begin

      for i in tab_com'range loop
         if tab_com (i).num_com /= -1 then
            for j in tab_com (i).tab_compo_com'range loop
               if tab_com (i).tab_compo_com (j) > 0 then
                  chiff_aff := chiff_aff + tab_com (i).tab_compo_com (j);
               end if;
            end loop;
         end if;
      end loop;

      if exists ("archive_achat") then
         open (archive, in_file, "archive_achat");
         while not (end_of_file (archive)) loop
            read (archive, achat);
            chiff_aff := chiff_aff + achat.prix;
         end loop;
         close (archive);
      end if;

      put ("Chiffre d'affaire : ");
      put (chiff_aff, 5);
      put (" euros");
      new_line;

   end visu_chiffre_affaire;

   procedure visu_nb_ex_vendu is
      archive      : archive_achat.file_type;
      achat        : T_achat;
      nb_ex_vendu  : integer := 0;
      tab_ex_vendu : T_tab_produit;
   begin

      for i in T_produit loop
         tab_ex_vendu (i) := 0;
      end loop;

      if exists ("archive_achat") then
         open (archive, in_file, "archive_achat");
         while not (end_of_file (archive)) loop
            read (archive, achat);
            for i in achat.tab_compo_achat'range loop
               if achat.tab_compo_achat (i).nb_ex > 0 then
                  tab_ex_vendu (achat.tab_compo_achat (i).produit) :=
                    tab_ex_vendu (achat.tab_compo_achat (i).produit)
                    + achat.tab_compo_achat (i).nb_ex;
               end if;
            end loop;
         end loop;

         put_line ("| Produit        | Nb ex |");
         put_line ("|----------------|-------|");
         put ("| Lotion tonique |   ");
         put (tab_ex_vendu (LT), 3);
         put_line (" |");
         put ("| Demaquillant   |   ");
         put (tab_ex_vendu (D), 3);
         put_line (" |");
         put ("| Creme visage   |   ");
         put (tab_ex_vendu (CV), 3);
         put_line (" |");
         put ("| Gel douche     |   ");
         put (tab_ex_vendu (GD), 3);
         put_line (" |");
         put ("| Lait corporel  |   ");
         put (tab_ex_vendu (LC), 3);
         put_line (" |");

         close (archive);
      else
         put_line ("Aucune archive d'achat");
      end if;
   end visu_nb_ex_vendu;

   procedure attente_moy_livraison is
      archive : archive_achat.file_type;
      achat   : T_achat;
      moy, n  : integer := 0;
   begin
      if exists ("archive_achat") then
         open (archive, in_file, "archive_achat");
         while not (end_of_file (archive)) loop
            read (archive, achat);
            moy := moy + achat.tps_ecoule;
            n := n + 1;
         end loop;

         close (archive);

         --Evite la division par zéro
         if n > 0 then

            --Calcul de la moyenne
            moy := moy / n;

            --Affichage de la moyenne
            put ("Attente moyenne : ");
            put (moy, 3);
            put_line (" jour(s)");
         else
            put_line ("Aucune archive d'achat");
         end if;
      else
         put_line ("Aucune archive d'achat");
      end if;

   end attente_moy_livraison;

end gestion_achat;
