with ada.text_io,
     ada.integer_text_io,
     ada.IO_Exceptions,
     gestion_date,
     gestion_client,
     gestion_lot,
     outils;
use ada.text_io,
    ada.integer_text_io,
    gestion_date,
    gestion_client,
    gestion_lot,
    outils;

package body gestion_commande is

   --Affichage d'une commande T_commande, utilisé dans visu_tab_commande et visu_com_attente
   procedure affichage_commande (com : in T_commande) is
   begin

      put ("Numero de commande : ");
      put (com.num_com, 2);
      new_line;

      put ("Nom du client : ");
      put (com.nom_client.nom_Client (1 .. com.nom_client.k));
      new_line;

      put_line ("Composition de la commande :");
      for j in com.tab_compo_com'range loop
         affichage_produit (j);
         put (" : ");
         put (com.tab_compo_com (j), 3);
         new_line;
      end loop;

      put ("Date de la commande : ");
      affichage_date (com.date_com);
      new_line;

      put ("Nombre de jour d'attente : ");
      put (com.attente, 3);
      new_line;

   end affichage_commande;

   --Enregistrement d'une nouvelle commande
   procedure nouv_commande
     (tab_commande : in out T_tab_commande;
      date         : in T_date;
      tab_client   : in out T_tab_client)
   is
      --ajouter T_tab_client en paramètre in
      x, ncom, indice  : integer := 0;
      nom_cli          : client;
      existe, possible : boolean := false;
   begin

      --Saisie du nom client
      saisie_nom_client (nom_cli);

      --Vérification si le client est dans le registre
      recherche_client (tab_client, nom_cli.nom_client, existe, indice);

      if existe then

         --Verification si le client n'a pas déjà 3 commandes en attentes
         if (tab_client (indice).nb_com < 3) then
            possible := true;
         end if;

         if possible then
            --Recherche de la première case vide
            for i in tab_commande'range loop
               if tab_commande (i).num_com = -1 then
                  x := i;
               end if;
            end loop;

            --Recherche du plus haut numero de commande
            for i in tab_commande'range loop
               if tab_commande (i).num_com > ncom then
                  ncom := tab_commande (i).num_com;
               end if;
            end loop;

            --Enregistrement du numéro de commande
            tab_commande (x).num_com := ncom + 1;

            --Enregistrement du nom du client
            tab_commande (x).nom_client := nom_cli;

            --Enregistrement de la composition de la commande
            for i in T_tab_produit'range loop
               loop
                  affichage_produit (i);
                  put (" : ");
                  begin
                     get (tab_commande (x).tab_compo_com (i));
                     skip_line;
                     exit when tab_commande (x).tab_compo_com (i)'Valid;
                  exception
                     when Constraint_Error =>
                        skip_line;
                        put
                          ("Nombre d'exemplaires invalide, entrer un entier naturel");
                        new_line;
                  end;
               end loop;
            end loop;

            --Enregistrement de la date de la commande
            tab_commande (x).date_com := date;

            --Initialisation du temps d'attente (en jour)
            tab_commande (x).attente := 0;

            --Incrémentation du nombre de commande du client
            tab_client (indice).nb_com := tab_client (indice).nb_com + 1;

         else
            put_line
              ("Commande impossible, le client a deja 3 commandes en attentes");
         end if;

      else
         put_line ("Ce client n'existe pas dans le registre");
      end if;
   end nouv_commande;

   --Annulation d'une commande
   procedure annul_commande (tab_commande : in out T_tab_commande) is
      num    : integer := 0;
      trouve : Boolean := false;
   begin
      put ("Numero de commande : ");
      get (num);
      skip_line;

      for i in tab_commande'range loop
         if tab_commande (i).num_com = num then
            tab_commande (i).num_com := -1;
            trouve := true;
            exit;
         end if;
      end loop;

      if not trouve then
         put_line ("Commande non trouvee");
      end if;
   end annul_commande;

   --Visualisation du registre des commandes
   procedure visu_tab_commande (tab_commande : in T_tab_commande) is
   begin
      for i in tab_commande'range loop
         if tab_commande (i).num_com /= -1 then
            affichage_commande (tab_commande (i));
         end if;
      end loop;
   end visu_tab_commande;

   --Visualisation des commandes en attente pour un client donné
   procedure visu_com_attente_client (tab_commande : in T_tab_commande) is
      cli : client;
   begin
      saisie_nom_client (cli);
      for i in tab_commande'range loop
         if tab_commande (i).nom_client.nom_Client
              (1 .. tab_commande (i).nom_client.k)
           = cli.nom_Client (1 .. cli.k)
         then
            affichage_commande (tab_commande (i));
         end if;
      end loop;
   end visu_com_attente_client;

   --Visualisation des commandes en attente pour un produit donné
   procedure visu_com_attente_produit (tab_commande : in T_tab_commande) is
      prod : T_produit;
   begin
      saisie_produit (prod);
      for i in tab_commande'range loop
         for j in tab_commande (i).tab_compo_com'range loop
            if (prod = j) and (tab_commande (i).tab_compo_com (j) > 0) then
               affichage_commande (tab_commande (i));
            end if;
         end loop;
      end loop;
   end visu_com_attente_produit;

   --Visualisation de tous les clients ayant commandé un produit donné
   procedure visu_client_commande (tab_commande : in T_tab_commande) is
      prod          : T_produit;
      tab_compo_com : T_tab_produit;
   begin
      saisie_produit (prod);
      put_line ("Clients ayant commandes ce produit :");
      for i in tab_commande'range loop
         for j in tab_compo_com'range loop
            if (prod = j)
              and (tab_commande (i).tab_compo_com (j) > 0)
              and (tab_commande (i).num_com /= -1)
            then
               affichage_nom_client (tab_commande (i).nom_client);
               new_line;
            end if;
         end loop;
      end loop;
   end visu_client_commande;

end gestion_commande;
