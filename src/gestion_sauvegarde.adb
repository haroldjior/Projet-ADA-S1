with ada.text_io,
     ada.integer_text_io,
     ada.Sequential_IO,
     ada.directories,
     outils,
     gestion_date,
     gestion_lot,
     gestion_client,
     gestion_commande;
use ada.text_io,
    ada.integer_text_io,
    ada.directories,
    outils,
    gestion_date,
    gestion_lot,
    gestion_client,
    gestion_commande;
with outils;

package body gestion_sauvegarde is

   use fichier_sauvegarde;

   procedure sauvegarde_donnees
     (lot  : in T_tab_lot;
      cli  : in T_tab_client;
      com  : in T_tab_commande;
      capa : in T_tab_produit;
      date : in T_date)
   is

      sau : fichier_sauvegarde.file_type;
      S   : T_sauvegarde;
   begin
      Put_Line ("Sauvegarde des donnees...");
      if exists ("fichier_sauvegarde") then
         Put_Line ("Fichier existant, ouverture...");
         open (sau, out_file, "fichier_sauvegarde");
      else
         Put_Line ("Fichier inexistant, creation...");
         create (sau, name => "fichier_sauvegarde");
         S.sauv_date := date;
      end if;

      S.sauv_lot := Lot;
      S.sauv_client := cli;
      S.sauv_capa_prod := capa;
      S.sauv_com := com;

      Write (sau, S);
      Close (sau);

      put_line ("Sauvegarde reussie !");
   end sauvegarde_donnees;

   procedure restauration
     (lot      : out T_tab_lot;
      cli      : out T_tab_client;
      com      : out T_tab_commande;
      capa     : out T_tab_produit;
      date     : in T_date;
      tab_mois : in T_tab_mois)
   is
      sau : fichier_sauvegarde.file_type;
      S   : T_sauvegarde;
      ant : boolean := false;
   begin
      if exists ("fichier_sauvegarde") then

         Put_Line ("Fichier existant, restauration donnees...");
         open (sau, in_file, "fichier_sauvegarde");
         Read (sau, S);

         if date.annee < S.sauv_date.annee then
            ant := true;
         elsif date.annee = S.sauv_date.annee then
            if T_liste_mois'pos (date.mois)
              < T_liste_mois'pos (S.sauv_date.mois)
            then
               ant := true;
            elsif T_liste_mois'pos (date.mois)
              = T_liste_mois'pos (S.sauv_date.mois)
            then
               if date.jour < S.sauv_date.jour then
                  ant := true;
               end if;
            end if;
         end if;

         if not ant then
            lot := S.sauv_lot;
            cli := S.sauv_client;
            capa := S.sauv_capa_prod;
            com := S.sauv_com;
         else
            put_line
              ("/!\ Erreur : date du jour anterieure a la date de sauvegarde");
         end if;

         Close (sau);

      else
         put_line ("/!\ Erreur : fichier de sauvegarde inexistant");
      end if;

   end restauration;

   procedure restauration_US
     (lot  : out T_tab_lot;
      cli  : out T_tab_client;
      com  : out T_tab_commande;
      capa : out T_tab_produit) is
   begin

      put_line ("Restauration des donnees des US...");

      --Initialisation des capacités de production
      capa (LT) := 10;
      capa (D) := 8;
      capa (CV) := 12;
      capa (GD) := 10;
      capa (LC) := 12;

      --Initialisation des lots

      --Lot n°1
      lot (1).num_lot := 1;
      lot (1).produit := GD;
      lot (1).date_fab.jour := 15;
      lot (1).date_fab.mois := decembre;
      lot (1).date_fab.annee := 2025;
      lot (1).stock := 10;
      lot (1).nb_vendu := 0;
      lot (1).prix_ex := 15;

      --Lot n°2
      lot (2).num_lot := 2;
      lot (2).produit := LC;
      lot (2).date_fab.jour := 16;
      lot (2).date_fab.mois := decembre;
      lot (2).date_fab.annee := 2025;
      lot (2).stock := 12;
      lot (2).nb_vendu := 0;
      lot (2).prix_ex := 18;

      --Lot n°3
      lot (3).num_lot := 3;
      lot (3).produit := LT;
      lot (3).date_fab.jour := 17;
      lot (3).date_fab.mois := decembre;
      lot (3).date_fab.annee := 2025;
      lot (3).stock := 10;
      lot (3).nb_vendu := 0;
      lot (3).prix_ex := 22;

      --Lot n°4
      lot (4).num_lot := 4;
      lot (4).produit := D;
      lot (4).date_fab.jour := 17;
      lot (4).date_fab.mois := decembre;
      lot (4).date_fab.annee := 2025;
      lot (4).stock := 8;
      lot (4).nb_vendu := 0;
      lot (4).prix_ex := 32;

      --Lot n°5
      lot (5).num_lot := 5;
      lot (5).produit := LT;
      lot (5).date_fab.jour := 17;
      lot (5).date_fab.mois := decembre;
      lot (5).date_fab.annee := 2025;
      lot (5).stock := 10;
      lot (5).nb_vendu := 0;
      lot (5).prix_ex := 22;

      --Initalisation des clients

      --Client n°1
      cli (1).nom_du_Client.nom_Client (1 .. 10) := "belle peau";
      cli (1).nom_du_Client.k := 10;
      cli (1).nb_com := 1;
      cli (1).fact := 0;
      cli (1).montant_achat := 0;

      --Client n°2
      cli (2).nom_du_Client.nom_Client (1 .. 8) := "zenitude";
      cli (2).nom_du_Client.k := 8;
      cli (2).nb_com := 0;
      cli (2).fact := 0;
      cli (2).montant_achat := 0;

      --CLient n°3
      cli (3).nom_du_Client.nom_Client (1 .. 13) := "belle de jour";
      cli (3).nom_du_Client.k := 13;
      cli (3).nb_com := 2;
      cli (3).fact := 0;
      cli (3).montant_achat := 0;

      --Client n°4
      cli (4).nom_du_Client.nom_Client (1 .. 11) := "beauty fool";
      cli (4).nom_du_Client.k := 11;
      cli (4).nb_com := 0;
      cli (4).fact := 0;
      cli (4).montant_achat := 0;

      --CLient n°5
      cli (5).nom_du_Client.nom_Client (1 .. 20) := "douceur et cocooning";
      cli (5).nom_du_Client.k := 20;
      cli (5).nb_com := 3;
      cli (5).fact := 0;
      cli (5).montant_achat := 0;

      --Initialisation des commandes

      --Commande n°1
      com (1).num_com := 1;
      com (1).nom_client := cli (1).nom_du_Client;
      com (1).tab_compo_com (LT) := 2;
      com (1).tab_compo_com (D) := 1;
      com (1).tab_compo_com (CV) := 0;
      com (1).tab_compo_com (GD) := 3;
      com (1).tab_compo_com (LC) := 5;
      com (1).date_com.jour := 12;
      com (1).date_com.mois := novembre;
      com (1).date_com.annee := 2025;
      com (1).attente := 35;

      --Commande n°2
      com (2).num_com := 2;
      com (2).nom_client := cli (5).nom_du_Client;
      com (2).tab_compo_com (LT) := 3;
      com (2).tab_compo_com (D) := 0;
      com (2).tab_compo_com (CV) := 4;
      com (2).tab_compo_com (GD) := 1;
      com (2).tab_compo_com (LC) := 2;
      com (2).date_com.jour := 20;
      com (2).date_com.mois := novembre;
      com (2).date_com.annee := 2025;
      com (2).attente := 27;

      --Commande n°3
      com (3).num_com := 3;
      com (3).nom_client := cli (3).nom_du_Client;
      com (3).tab_compo_com (LT) := 10;
      com (3).tab_compo_com (D) := 0;
      com (3).tab_compo_com (CV) := 0;
      com (3).tab_compo_com (GD) := 0;
      com (3).tab_compo_com (LC) := 0;
      com (3).date_com.jour := 25;
      com (3).date_com.mois := novembre;
      com (3).date_com.annee := 2025;
      com (3).attente := 22;

      --Commande n°4
      com (4).num_com := 4;
      com (4).nom_client := cli (5).nom_du_Client;
      com (4).tab_compo_com (LT) := 0;
      com (4).tab_compo_com (D) := 4;
      com (4).tab_compo_com (CV) := 0;
      com (4).tab_compo_com (GD) := 0;
      com (4).tab_compo_com (LC) := 0;
      com (4).date_com.jour := 25;
      com (4).date_com.mois := novembre;
      com (4).date_com.annee := 2025;
      com (4).attente := 22;

      --Commande n°5
      com (5).num_com := 5;
      com (5).nom_client := cli (3).nom_du_Client;
      com (5).tab_compo_com (LT) := 0;
      com (5).tab_compo_com (D) := 4;
      com (5).tab_compo_com (CV) := 4;
      com (5).tab_compo_com (GD) := 0;
      com (5).tab_compo_com (LC) := 0;
      com (5).date_com.jour := 1;
      com (5).date_com.mois := decembre;
      com (5).date_com.annee := 2025;
      com (5).attente := 16;

      --Commande n°6
      com (6).num_com := 6;
      com (6).nom_client := cli (5).nom_du_Client;
      com (6).tab_compo_com (LT) := 2;
      com (6).tab_compo_com (D) := 3;
      com (6).tab_compo_com (CV) := 4;
      com (6).tab_compo_com (GD) := 5;
      com (6).tab_compo_com (LC) := 6;
      com (6).date_com.jour := 17;
      com (6).date_com.mois := decembre;
      com (6).date_com.annee := 2025;
      com (6).attente := 0;

      put_line ("Restauration reussie !");

   end restauration_US;

end gestion_sauvegarde;
