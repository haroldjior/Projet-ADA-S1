with ada.text_io,
     ada.integer_text_io,
     ada.Sequential_IO,
     ada.directories,
     gestion_lot,
     gestion_client,
     gestion_commande;
use ada.text_io,
    ada.integer_text_io,
    ada.directories,
    gestion_lot,
    gestion_client,
    gestion_commande;

package body gestion_sauvegarde is

   use fichier_sauvegarde;

   procedure sauvegarde_donnees
     (lot  : in T_tab_lot;
      cli  : in T_tab_client;
      com  : in T_tab_commande;
      capa : in T_tab_produit)
   is
      --ach  : gestion_achat.T_tab_compo_achat;
      --prod : gestion_achat.T_tab_compo_achat;

      sau : fichier_sauvegarde.file_type;
      S   : T_sauvegarde;
   begin
      Put_Line ("debut de la sauvegarde");
      if exists ("fichier_sauvegarde") then
         Put_Line ("fichier existant, ouverture");
         open (sau, out_file, "fichier_sauvegarde");
      else
         Put_Line ("fichier inexistant, creation");
         create (sau, name => "fichier_sauvegarde");
      end if;

      S.sauv_lot := Lot;
      S.sauv_client := cli;
      S.sauv_capa_prod := capa;
      S.sauv_com := com;

      Write (sau, S);
      Close (sau);

   end sauvegarde_donnees;

   procedure restauration
     (lot  : out T_tab_lot;
      cli  : out T_tab_client;
      com  : out T_tab_commande;
      capa : out T_tab_produit)
   is
      sau : fichier_sauvegarde.file_type;
      S   : T_sauvegarde;
   begin
      if exists ("fichier_sauvegarde") then
         Put_Line ("fichier existant, restauration donnees");
         open (sau, in_file, "fichier_sauvegarde");
         Read (sau, S);
         lot := S.sauv_lot;
         cli := S.sauv_client;
         capa := S.sauv_capa_prod;
         com := S.sauv_com;
         Close (sau);

      else
         put_line ("fichier de sauvegarde inexistant");
      end if;

   end restauration;

end gestion_sauvegarde;
