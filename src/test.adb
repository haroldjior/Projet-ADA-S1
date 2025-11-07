with ada.text_io, ada.integer_text_io, gestion_date;
use ada.text_io, ada.integer_text_io, gestion_date;

procedure test is
   date       : T_date;
   tab_mois   : T_tab_mois;
   liste_mois : T_liste_mois;
begin
   ini_tab_mois (tab_mois, liste_mois);
   saisie_date (date, tab_mois);
end test;
