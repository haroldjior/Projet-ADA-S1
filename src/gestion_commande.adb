with ada.text_io, ada.integer_text_io, gestion_date, outils, ada.IO_Exceptions;
use ada.text_io, ada.integer_text_io, gestion_date, outils;


--a faire : finir la procedure nouv_commande, comprendre comment faire la procedure annul_commande


package body gestion_commande is

   --Initialisation du tableau de commande
   procedure init_tab_com (tab_commande : in out T_tab_commande) is
   begin
      for i in tab_commande'range loop
         tab_commande (i).num_com := -1;
      end loop;
   end init_tab_com;

   --Affichage d'une commande T_commande, utilisé dans visu_tab_commande et visu_com_attente
   procedure affichage_commande (com : in T_commande) is
   begin

      put ("Numero de commande : ");
      put (com.num_com);
      new_line;

      put ("Nom du client : ");
      put ("En construction");
      new_line;

      put_line ("Composition de la commande :");
      for j in T_tab_compo_com'range loop
         affichage_produit (j);
         put (" : ");
         put (com.tab_compo_com (j), 3);
         new_line;
      end loop;

      put ("Date de la commande : ");
      affichage_date (com.date_com);
      new_line;

      put ("Nombre de jour d'attente : ");
      put (com.attente);
      new_line;

   end affichage_commande;

   --Enregistrement d'une nouvelle commande
   procedure nouv_commande
     (tab_commande : in out T_tab_commande; date : in T_date)
   is
      --ajouter T_tab_client en paramètre in
      x       : integer;
      ncom    : integer := 0;
      nom_cli : client;
      existe  : boolean := false;
   begin

      --Saisie du nom client
      saisie_nom_client (nom_cli);

      --Vérification si le client est dans le registre
      --  for i in tab_client'range loop
      --  if tab_client(i).nom_client = nom_cli then
      --  existe := true;
      --  exit;
      --  end if;
      --  end loop;

      --debug
      existe := true;

      if existe then
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
         for i in T_tab_compo_com'range loop
            affichage_produit (i);
            put (" : ");
            get (tab_commande (x).tab_compo_com (i));
            skip_line;
         end loop;

         --Enregistrement de la date de la commande
         tab_commande (x).date_com := date;

         --Initialisation du temps d'attente (en jour)
         tab_commande (x).attente := 0;

      else
         put_line ("Ce client n'existe pas");
      end if;
   end nouv_commande;

   procedure annul_commande (tab_commande : in out T_tab_commande) is
   begin
      null;
   end annul_commande;

   procedure visu_tab_commande (tab_commande : in T_tab_commande) is
   begin
      for i in tab_commande'range loop
         if tab_commande (i).num_com /= -1 then
            affichage_commande (tab_commande (i));
         end if;
      end loop;
   end visu_tab_commande;

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

   procedure visu_client_commande (tab_commande : in T_tab_commande) is
      prod          : T_produit;
      tab_compo_com : T_tab_compo_com;
   begin
      saisie_produit (prod);
      put_line ("Clients ayant commandes ce produit :");
      for i in tab_commande'range loop
         for j in tab_compo_com'range loop
            if (prod = j) and (tab_commande (i).tab_compo_com (j) > 0) then
               affichage_nom_client (tab_commande (i).nom_client);
               new_line;
            end if;
         end loop;
      end loop;
   end visu_client_commande;

end gestion_commande;
