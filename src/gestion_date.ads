package gestion_date is

   --Type enuméré de la liste des mois
   type T_liste_mois is
     (janvier,
      fevrier,
      mars,
      avril,
      mai,
      juin,
      juillet,
      aout,
      septembre,
      octobre,
      novembre,
      decembre);

   --Record pour lier le mois avec son nombre de jours
   type T_mois is record
      mois    : T_liste_mois;
      nb_jour : integer;
   end record;

   --Tableau du record pour saisir les 12 mois
   type T_tab_mois is array (integer range 1 .. 12) of T_mois;

   --Record pour le format de date
   type T_date is record
      jour  : integer range 1 .. 31;
      mois  : T_liste_mois;
      annee : Positive;
   end record;

   --Procedure d'initialisation du tableau T_tab_mois sans la particularité du mois de fevrier qui est fait dans la procedure saisie_date
   procedure ini_tab_mois
     (tab_mois : in out T_tab_mois; liste_mois : in T_liste_mois);

   --Procedure de saisie d'une date, champ par champ, avec controle de sa validité
   procedure saisie_date (date : in out T_date; tab_mois : in out T_tab_mois);
end gestion_date;
