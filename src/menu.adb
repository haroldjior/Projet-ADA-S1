with ada.text_io,
     ada.integer_text_io,
     ada.float_text_io,
     ada.IO_Exceptions,
     ada.characters.handling,
     outils,
     gestion_date,
     gestion_commande,
     gestion_lot,
     gestion_client,
     gestion_sauvegarde,
     gestion_achat;
use ada.text_io,
    ada.integer_text_io,
    ada.float_text_io,
    ada.characters.handling,
    outils,
    gestion_date,
    gestion_commande,
    gestion_lot,
    gestion_client,
    gestion_sauvegarde,
    gestion_achat;

procedure menu is

   date          : T_date;
   tab_mois      : T_tab_mois;
   liste_mois    : T_liste_mois;
   tab_commande  : T_tab_commande;
   tab_capa_prod : T_tab_produit;
   tab_lot       : T_tab_lot;
   tab_client    : T_tab_client;
   tab_stock     : T_tab_produit;

   choix,
   choix_lot1,
   choix_lot2,
   choix_lot3,
   choix_com1,
   choix_cli1,
   choix_stat,
   choix_sauv : Character;
begin
   --Initialisation de ce qui est nécéssaire
   ini_tab_mois (tab_mois, liste_mois);
   init_tab_lot (tab_lot);
   init_tab_stock (tab_stock);

   --Saisie de la date du jour
   put_line ("===== Date du jour =====");
   saisie_date (date, tab_mois);
   new_line;
   put_line ("===== Saisie des capacites de production =====");
   saisie_tab_capa_prod (tab_capa_prod);
   new_line;

   --Menu principal
   loop
      put_line (" =============== Menu ================");
      put_line (" _____________________________________");
      put ("|      Date du jour : ");
      affichage_date (date);
      put_line ("      |");
      put_line ("| A : Gestion des lots                |");
      put_line ("| B : Gestion des clients             |");
      put_line ("| C : Gestion des commandes et achats |");
      put_line ("| D : Statistiques                    |");
      put_line ("| E : Sauvegarde/Restauration         |");
      put_line ("| F : Passage au lendemain            |");
      put_line ("| Q : Quitter                         |");
      put_line ("|_____________________________________|");
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
               put_line (" =============== Gestion des lots ==============");
               put_line (" _______________________________________________");
               put_line ("| A : Ajout d'un nouveau lot                    |");
               put_line ("| B : Destruction de lot                        |");
               put_line ("| C : Modification des capacites de production  |");
               put_line ("| D : Visualisation des capacites de production |");
               put_line ("| E : Visualisation de lots                     |");
               put_line ("| R : Retour au menu principal                  |");
               put_line ("|_______________________________________________|");
               new_line;
               put ("Votre choix : ");
               get (choix_lot1);
               skip_line;
               new_line;
               choix_lot1 := to_upper (choix_lot1);
               exit when choix_lot1 = 'R';
               case choix_lot1 is
                  when 'A'    =>
                     put_line ("===== Nouveau lot =====");
                     nouv_lot (tab_lot, date, tab_capa_prod, tab_stock);
                     new_line;

                  when 'B'    =>
                     loop
                        put_line ("===== Destruction de lot =====");
                        put_line ("A : Par numero de lot");
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
                                ("===== Suppression d'un lot par son numero =====");
                              sup_lot_num (tab_lot);
                              new_line;

                           when 'B'    =>
                              put_line
                                ("===== Suppression de tous les lots avant une date =====");
                              sup_lot_date (tab_lot, date, tab_mois);
                              new_line;

                           when others =>
                              put_line
                                ("Choix non propose, veuillez choisir une des options disponibles");
                        end case;
                     end loop;

                  when 'C'    =>
                     put_line
                       ("===== Modification des capacites de production =====");
                     modif_capa_prod (tab_capa_prod);
                     new_line;

                  when 'D'    =>
                     put_line ("===== Capacites de production =====");
                     put_line ("        -------------------");
                     visu_tab_capa_prod (tab_capa_prod);
                     put_line ("        -------------------");
                     new_line;

                  when 'E'    =>
                     loop
                        put_line ("===== Visualisation des lots =====");
                        put_line ("A : Visualisation du registre des lots");
                        put_line
                          ("B : Visualisation des lots pour un produit donne");
                        put_line
                          ("C : Visualisation des produits manquants en stock");
                        put_line ("R : Retour au menu de gestion des lots");
                        new_line;
                        put ("Votre choix : ");
                        get (choix_lot3);
                        skip_line;
                        new_line;
                        choix_lot3 := to_upper (choix_lot3);
                        exit when choix_lot3 = 'R';
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
                                ("Choix non propose, veuillez choisir une des options disponibles");
                        end case;
                     end loop;

                  when others =>
                     put_line
                       ("Choix non propose, veuillez choisir une des options disponibles");
               end case;
            end loop;

         when 'B'    =>
            loop
               put_line ("===== Gestion des clients =====");
               put_line ("A : Ajout d'un nouveau client");
               put_line ("B : Suppression d'un client");
               put_line ("C : Enregistrement d'un reglement");
               put_line ("D : Visualisation du registre des clients");
               put_line
                 ("E : Visualisation des clients sans commandes en attente");
               put_line ("R : Retour au menu principal");
               new_line;
               put ("Votre choix : ");
               get (choix_cli1);
               skip_line;
               choix_cli1 := to_upper (choix_cli1);
               exit when choix_cli1 = 'R';
               case choix_cli1 is
                  when 'A'    =>
                     put_line ("===== Ajout d'un nouveau client =====");
                     ajout_client (tab_client);
                     new_line;

                  when 'B'    =>
                     put_line ("===== Suppression d'un client =====");
                     sup_client (tab_client);
                     new_line;

                  when 'C'    =>
                     put_line ("===== Enregistrement d'un reglement =====");
                     reglement (tab_client);
                     new_line;

                  when 'D'    =>
                     put_line
                       ("===== Visualisation du regesitre des clients =====");
                     visu_tab_client (tab_client);
                     new_line;

                  when 'E'    =>
                     put_line
                       ("===== Clients sans commandes en attentes =====");
                     visu_sans_commande_attente (tab_client);
                     new_line;

                  when others =>
                     put_line
                       ("Choix non propose, veuillez choisir une des options disponibles");
               end case;
            end loop;

         when 'C'    =>
            loop
               put_line ("===== Gestion des commandes et des achats =====");
               put_line ("A : Enregistrement d'une nouvelle commande");
               put_line ("B : Annulation d'une commande");
               put_line ("C : Visualisation du registre des commandes");
               put_line
                 ("D : Visualisation des commandes en attentes d'un client");
               put_line
                 ("E : Visualisation des commandes en attentes d'un produit");
               put_line
                 ("F : Visualisation de tous les achats realises par un client");
               put_line
                 ("G : Visualisation des clients ayant commandes un produit");
               put_line ("H : Visualisation de l'archive des achats");
               put_line ("R : Retour au menu principal");
               new_line;
               put ("Votre choix");
               get (choix_com1);
               skip_line;
               choix_com1 := to_upper (choix_com1);
               exit when choix_com1 = 'R';
               case choix_com1 is
                  when 'A'    =>
                     put_line ("===== Nouvelle commande =====");
                     nouv_commande (tab_commande, date, tab_client);
                     new_line;

                  when 'B'    =>
                     put_line ("===== Annulation d'une commande =====");
                     annul_commande (tab_commande);
                     new_line;

                  when 'C'    =>
                     put_line ("===== Registre des commandes =====");
                     visu_tab_commande (tab_commande);
                     new_line;

                  when 'D'    =>
                     put_line
                       ("===== Commandes en attentes d'un client =====");
                     visu_com_attente_client (tab_commande);
                     new_line;

                  when 'E'    =>
                     put_line
                       ("===== Commandes en attentes d'un produit =====");
                     visu_com_attente_produit (tab_commande);
                     new_line;

                  when 'F'    =>
                     put_line ("===== Achats realises par un client =====");
                     visu_achat_client (tab_client);
                     new_line;

                  when 'G'    =>
                     put_line
                       ("===== Clients ayant commandes un produit =====");
                     visu_client_commande (tab_commande);
                     new_line;

                  when 'H'    =>
                     put_line ("===== Archive des achats =====");
                     visu_archive_achat;
                     new_line;

                  when others =>
                     put_line
                       ("Choix non propose, veuillez choisir une des options disponibles");
               end case;
            end loop;

         when 'D'    =>
            loop
               put_line ("===== Statistiques =====");
               put_line ("A : Chiffre d'affaire");
               put_line
                 ("B : Nombre d'exemplaires vendus pour chaque produit");
               put_line ("C : Durée moyenne entre commande et livraison");
               put_line ("R : Retour au menu principal");
               new_line;
               put ("Votre choix : ");
               get (choix_stat);
               skip_line;
               choix_stat := to_upper (choix_stat);
               exit when choix_stat = 'R';
               case choix_stat is
                  when 'A'    =>
                     put_line ("===== Chiffre d'affaire =====");
                     visu_chiffre_affaire (tab_commande);
                     new_line;

                  when 'B'    =>
                     put_line ("===== Nombre d'exemplaires vendus =====");
                     visu_nb_ex_vendu;
                     new_line;

                  when 'C'    =>
                     put_line ("===== Duree moyenne de livraison =====");
                     attente_moy_livraison;
                     new_line;

                  when others =>
                     put_line
                       ("Choix non propose, veuillez choisir une des options disponibles");
               end case;
            end loop;

         when 'E'    =>
            loop
               put_line ("===== Sauvegarde / Restauration =====");
               put_line ("A : Sauvegarde des donnnees");
               put_line ("B : Restauration des donnees");
               put_line ("C : Restauration des donnees des US");
               put_line ("R : Retour au menu principal");
               new_line;
               put ("Votre choix : ");
               get (choix_sauv);
               skip_line;
               choix_sauv := to_upper (choix_sauv);
               exit when choix_sauv = 'R';
               case choix_sauv is
                  when 'A'    =>
                     put_line ("===== Sauvegarde =====");
                     sauvegarde_donnees
                       (tab_lot, tab_client, tab_commande, tab_capa_prod);
                     new_line;

                  when 'B'    =>
                     put_line ("===== Restauration =====");
                     restauration
                       (tab_lot, tab_client, tab_commande, tab_capa_prod);
                     new_line;

                  when 'C'    =>
                     put_line ("===== Donnees des US =====");
                     restauration_US
                       (tab_lot, tab_client, tab_commande, tab_capa_prod);
                     maj_tab_stock (tab_lot, tab_stock);
                     new_line;

                  when others =>
                     put_line
                       ("Choix non propose, veuillez choisir une des options disponibles");

               end case;
            end loop;

         when 'F'    =>
            put_line ("===== Passage au lendemain =====");
            lendemain (date, tab_mois);
            livraison
              (tab_commande, tab_stock, date, tab_lot, tab_client, tab_mois);
            put ("Date du jour : ");
            affichage_date (date);
            new_line;
            new_line;

         when others =>
            put_line
              ("Choix non propose, veuillez choisir une des options disponibles");
      end case;
   end loop;
end menu;
