with ada.text_io, ada.integer_text_io, gestion_date, gestion_lot;
use ada.text_io, ada.integer_text_io, gestion_date, gestion_lot;

procedure test is
   date        : T_date;
   tab_mois    : T_tab_mois;
   liste_mois  : T_liste_mois;
   tab_lot     : T_tab_lot;
   max_num_lot : integer := 0;
begin
   ini_tab_mois (tab_mois, liste_mois);
   init_tab_lot (tab_lot);
   saisie_lot (tab_lot, date, tab_mois, max_num_lot);
   sup_lot_date (tab_lot, date, tab_mois);
end test;
