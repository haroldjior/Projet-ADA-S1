with ada.text_io,
     ada.integer_text_io,
     ada.float_text_io,
     ada.IO_Exceptions,
     ada.characters.handling,
     outils,
     gestion_date,
     gestion_commande,
     gestion_lot;
use ada.text_io,
    ada.integer_text_io,
    ada.float_text_io,
    ada.characters.handling,
    outils,
    gestion_date,
    gestion_commande,
    gestion_lot;

procedure menu is
   date          : T_date;
   tab_mois      : T_tab_mois;
   liste_mois    : T_liste_mois;
   tab_commande  : T_tab_commande;
   tab_capa_prod : T_tab_capa_prod;
   tab_lot       : T_tab_lot;

   choix, choix_lot1, choix_lot2, choix_lot3 : Character;
begin
   --Initialisation de ce qui est nécéssaire
   ini_tab_mois (tab_mois, liste_mois);
   init_tab_com (tab_commande);
   init_tab_capa_prod (tab_capa_prod);
   init_tab_lot (tab_lot);

   --Saisie de la date du jour
   put_line ("===== Date du jour =====");
   saisie_date (date, tab_mois);
   new_line;

   --Menu principal
   loop
      put_line ("===== Menu =====");
      put_line ("A : Gestion des lots");
      put_line ("B : Gestion des clients");
      put_line ("C : Gestion des clients et des achats");
      put_line ("D : Statistiques");
      put_line ("E : Sauvegarde/Restauration");
      put_line ("Q : Quitter");
      new_line;
      put ("Votre choix : ");
      get (choix);
      skip_line;
      new_line;
      choix := to_upper (choix);
      exit when choix = 'Q';
      case choix is
         when 'A'    =>
            loop
               put_line ("===== Gestion des lots =====");
               put_line ("A : Ajout d'un nouveau lot");
               put_line ("B : Destruction de lot");
               put_line ("C : Modification des capacités de production");
               put_line ("D : Visualisation de lots");
               put_line ("E : Retour au menu principal");
               new_line;
               put ("Votre choix : ");
               get (choix_lot1);
               skip_line;
               new_line;
               choix_lot1 := to_upper (choix_lot1);
               exit when choix_lot1 = 'E';
               case choix_lot1 is
                  when 'A'    =>
                     put_line ("===== Nouveau lot =====");
                     nouv_lot (tab_lot, date, tab_mois, tab_capa_prod);
                     new_line;

                  when 'B'    =>
                     loop
                        put_line ("===== Destruction de lot =====");
                        put_line ("A : Par numéro de lot");
                        put_line ("B : Par date de fabrication");
                        put_line ("C : Retour au menu de gestion des lots");
                        new_line;
                        put ("Votre choix : ");
                        get (choix_lot2);
                        skip_line;
                        new_line;
                        choix_lot2 := to_upper (choix_lot2);
                        exit when choix_lot2 = 'C';
                        case choix_lot2 is
                           when 'A'    =>
                              put_line
                                ("===== Suppression d'un lot par son numéro =====");
                              sup_lot_num (tab_lot);
                              new_line;

                           when 'B'    =>
                              put_line
                                ("===== Suppression de tous les lots avant une date =====");
                              sup_lot_date (tab_lot, date, tab_mois);
                              new_line;

                           when others =>
                              put_line
                                ("Choix non proposé, veuillez choisir une des options disponibles");
                        end case;
                     end loop;

                  when 'C'    =>
                     put_line
                       ("===== Modification des capacites de production =====");
                     modif_capa_prod (tab_capa_prod);
                     new_line;

                  when 'D'    =>
                     loop
                        put_line ("===== Visualisation des lots =====");
                        put_line ("A : Visualisation du registre des lots");
                        put_line
                          ("B : Visualisation des lots pour un produit donne");
                        put_line
                          ("C : Visualisation des produits manquants en stock");
                        put_line ("D : Retour au menu de gestion des lots");
                        new_line;
                        put ("Votre choix : ");
                        get (choix_lot3);
                        skip_line;
                        choix_lot3 := to_upper (choix_lot3);
                        exit when choix_lot3 = 'D';
                        case choix_lot3 is
                           when 'A'    =>
                              put_line
                                ("===== Visualisation du registre des lots =====");
                              visu_tab_lot (tab_lot);
                              new_line;

                           when 'B'    =>
                              put_line
                                ("===== Visualisation des lots pour un produit donne =====");
                              visu_lot_produit (tab_lot);
                              new_line;

                           when 'C'    =>
                              put_line
                                ("===== Visualisation des produits manquants en stocks =====");
                              visu_produit_manquant (tab_lot);
                              new_line;

                           when others =>
                              put_line
                                ("Choix non proposé, veuillez choisir une des options disponibles");
                        end case;
                     end loop;

                  when others =>
                     put_line
                       ("Choix non proposé, veuillez choisir une des options disponibles");
               end case;
            end loop;

         when 'B'    =>
            null;

         when 'C'    =>
            null;

         when 'D'    =>
            null;

         when 'E'    =>
            null;

         when others =>
            put
              ("Choix non proposé, veuillez choisir une des options disponibles");
      end case;
   end loop;
end menu;
