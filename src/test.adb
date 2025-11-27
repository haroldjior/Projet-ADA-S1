with ada.text_io, ada.integer_text_io, gestion_date, gestion_lot;
use ada.text_io, ada.integer_text_io, gestion_date, gestion_lot;

procedure test is
   date          : T_date;
   tab_mois      : T_tab_mois;
   liste_mois    : T_liste_mois;
   tab_lot       : T_tab_lot;
   produit       : T_produit;
   tab_capa_prod : T_tab_capa_prod;
begin
   ini_tab_mois (tab_mois, liste_mois);
   init_tab_lot (tab_lot);
   init_tab_capa_prod (tab_capa_prod);
   saisie_lot (tab_lot, date, tab_mois, tab_capa_prod);
   modif_capa_prod (tab_capa_prod);
   saisie_lot (tab_lot, date, tab_mois, tab_capa_prod);
   visu_tab_lot (tab_lot);
end test;
