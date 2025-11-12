with ada.text_io, ada.integer_text_io, ada.IO_Exceptions;
use ada.text_io, ada.integer_text_io;

package body gestion_date is

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

         --Saisie de la date, avec gestion d'erreur
         loop
            begin
               put ("Jour : ");
               get (date.jour);
               skip_line;
               exit when date.jour'Valid;
            exception
               when Constraint_Error =>
                  Skip_Line;
                  put_line
                    ("/!\ Jour invalide, veuillez entrer un entier compris entre 1 et 31");
               when ada.IO_Exceptions.Data_Error =>
                  skip_line;
                  put_line ("/!\ Jour invalide, veuillez entrer un entier");
            end;
         end loop;
         loop
            begin
               put ("Mois : ");
               get_line (s, k);
               d := T_liste_mois'value (s (1 .. k));
               for i in T_liste_mois loop
                  if d = i then
                     date.mois := i;
                  end if;
               end loop;
               exit when date.mois'Valid;
            exception
               when Constraint_Error =>
                  skip_line;
                  Put_Line
                    ("/!\ Mois invalide, veuillez entrer un nom de mois valide");
            end;
         end loop;
         loop
            begin
               put ("Annee : ");
               get (date.annee);
               skip_line;
               exit when date.annee'Valid;
            exception
               when ada.IO_Exceptions.Data_Error =>
                  skip_line;
                  Put_Line
                    ("/!\ Annee invalide, veuillez entrer un entier positif");
               when Constraint_Error =>
                  skip_line;
                  Put_Line
                    ("/!\ Annee invalide, veuillez entrer un entier positif");
            end;
         end loop;

         --Initialisation du nb de jour du mois de fevrier en fonction de l'annee
         if ((date.annee mod 4 = 0) and (date.annee mod 400 = 0))
           or ((date.annee mod 4 = 0) and (date.annee mod 100 /= 0))
         then
            tab_mois (2).nb_jour := 29;
         else
            tab_mois (2).nb_jour := 28;
         end if;

         --Verification de la validité de la date saisie
         if (date.jour <= tab_mois (T_liste_mois'pos (date.mois) + 1).nb_jour)
         then
            valide := true;
         end if;
         exit when valide;
         Put ("La date saisie est invalide, pas de 29 fevrier pour l'annee ");
         put (date.annee, 4);
         put_line (" !");
         Put_Line ("Veuillez entrer une date valide :");
      end loop;
   end saisie_date;

end gestion_date;
