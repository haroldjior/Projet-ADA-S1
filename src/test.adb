with ada.text_io,
     ada.integer_text_io,
     gestion_date,
     gestion_lot,
     gestion_commande,
     gestion_client,
     gestion_achat,
     outils;
use ada.text_io,
    ada.integer_text_io,
    gestion_date,
    gestion_lot,
    gestion_commande,
    gestion_client,
    gestion_achat,
    outils;

procedure test is
   date          : T_date;
   tab_mois      : T_tab_mois;
   liste_mois    : T_liste_mois;
   c             : client;
   tab_client    : T_tab_client;
   tab_commande  : T_tab_commande;
   tab_capa_prod : T_tab_produit;
   tab_lot       : T_tab_lot;
   tab_stock     : T_tab_produit;
   possible      : boolean;
   achat         : T_achat;
begin
   ini_tab_mois (tab_mois, liste_mois);
   init_tab_capa_prod (tab_capa_prod);
   saisie_date (date, tab_mois);
   init_tab_stock (tab_stock);
   nouv_lot (tab_lot, date, tab_capa_prod, tab_stock);
   visu_tab_lot (tab_lot);
   ajout_client (tab_client);
   nouv_commande (tab_commande, date, tab_client);
   visu_tab_commande (tab_commande);
   for i in tab_commande'range loop
      possible := livr_possible (tab_commande (i), tab_stock);
   end loop;
   if possible then
      put ("possible");
   else
      put ("pas possible");
   end if;
   livraison (tab_commande, tab_stock, date, tab_lot, tab_client);
   visu_tab_lot (tab_lot);
end test;
