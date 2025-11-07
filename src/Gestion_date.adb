with ada.text_io, ada.integer_text_io; use ada.text_io, ada.integer_text_io;

package body Gestion_date is

   procedure ini_tab_mois
     (tab_mois : in out T_tab_mois; liste_mois : in T_liste_mois) is
   begin
      for i in tab_mois'range loop
         tab_mois (i).mois := T_liste_mois'val (i - 1);
      end loop;
      for j in 1 .. 7 loop
         if T_liste_mois'pos (tab_mois (j).mois) mod 2 = 0 then
            tab_mois (j).nb_jour := 31;
         else
            tab_mois (j).nb_jour := 30;
         end if;
      end loop;
      for k in 8 .. 12 loop
         if T_liste_mois'pos (tab_mois (k).mois) mod 2 = 0 then
            tab_mois (k).nb_jour := 30;
         else
            tab_mois (k).nb_jour := 31;
         end if;
      end loop;
   end ini_tab_mois;

   procedure saisie_date (date : in out T_date; tab_mois : in out T_tab_mois)
   is
      s      : string (1 .. 10);
      k      : integer;
      d      : T_liste_mois;
      valide : Boolean := false;
   begin
      loop
         --Saisie de la date
         put_line ("Entrer la date du jour");
         put ("Jour : ");
         get (date.jour);
         skip_line;
         put ("Mois : ");
         get_line (s, k);
         d := T_liste_mois'value (s (1 .. k));
         for i in T_liste_mois loop
            if d = i then
               date.mois := i;
            end if;
         end loop;
         put ("Annee : ");
         get (date.annee);
         skip_line;

         --Initialisation du nb de jour du mois de fevrier en fonction de l'annee
         if ((date.annee mod 4 = 0) and (date.annee mod 400 = 0))
           or ((date.annee mod 4 = 0) and (date.annee mod 100 /= 0))
         then
            tab_mois (2).nb_jour := 29;
         else
            tab_mois (2).nb_jour := 28;
         end if;

         --Verification de la validité de la date saisie
         if date.jour <= tab_mois (T_liste_mois'pos (date.mois) + 1).nb_jour
         then
            valide := true;
         end if;
         exit when valide;
         Put_Line ("La date saisie est invalide");
      end loop;
   end saisie_date;

end Gestion_date;
