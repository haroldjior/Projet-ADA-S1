with ada.text_io,
     ada.integer_text_io,
     gestion_date,
     gestion_lot,
     gestion_commande,
     outils;
use ada.text_io,
    ada.integer_text_io,
    gestion_date,
    gestion_lot,
    gestion_commande,
    outils;

procedure test is
   date          : T_date;
   tab_mois      : T_tab_mois;
   liste_mois    : T_liste_mois;
   tab_lot       : T_tab_lot;
   produit       : T_produit;
   tab_capa_prod : T_tab_capa_prod;
   tab_commande  : T_tab_commande;
begin
   ini_tab_mois (tab_mois, liste_mois);
   init_tab_lot (tab_lot);
   nouv_commande (tab_commande);
end test;
