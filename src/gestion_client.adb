with ada.text_io,
     ada.integer_text_io,
     ada.IO_Exceptions,
     ada.characters.handling,
     outils;
use ada.text_io, ada.integer_text_io, ada.characters.handling, outils;

package body gestion_client is

   --Ajour d'un nouveau client dans le registre de clients
   procedure ajout_client (A : in out T_tab_client) is
      n, x           : integer := 0;
      existe, trouve : boolean := false;
      c              : client;
   begin

      --Saisie du nom du nouveau client
      saisie_nom_client (c);
      new_line;

      --Recherhche de la première case vide
      while not (trouve) loop
         n := n + 1;
         if n > nb_C then
            trouve := true;
         elsif (A (n).nb_com = -1) then
            trouve := true;
            x := n;
         end if;
      end loop;

      --Vérification que le nom du client n'existe pas
      for i in A'range loop
         if A (i).nom_du_Client = c then
            existe := true;
            exit;
         end if;
      end loop;

      --Enregistrement du client dans le registre
      begin
         if not (existe) then
            A (x).nom_du_Client.nom_Client := to_lower (c.nom_Client);
            A (x).nom_du_Client.k := c.k;
            A (x).nb_com := 0;
            put_line ("Le client a bien ete ajoute");
         else
            put_line ("Ce nom existe deja");
         end if;
      exception
         when Constraint_Error =>
            put_line ("Nombre maximum de client atteint");
      end;

   end ajout_client;

   --Suppression d'un client du registre de client
   procedure sup_client (tab_client : in out T_tab_client) is
      s      : T_nom_client;
      k      : integer := 0;
      existe : Boolean := false;
   begin
      put ("Nom du client a supprimer : ");
      Get_Line (s, k);
      new_line;
      for i in tab_client'Range loop
         if s (1 .. k)
           = tab_client (i).nom_du_Client.nom_Client
               (1 .. tab_client (i).nom_du_Client.k)
         then
            existe := true;
            tab_client (i).nb_com := -1;
            tab_client (i).fact := 0;
            tab_client (i).montant_achat := 0;
            tab_client (i).nom_du_Client.nom_Client := (others => ' ');
            tab_client (i).nom_du_Client.k := 0;
            put_line ("Le client a bien été supprimé");
         end if;
      end loop;
      if not (existe) then
         put_line ("Le client n'existe pas dans le registre");
      end if;
   end sup_client;

   --Enregistrement d'un règlement
   procedure reglement (tab_client : in out T_tab_client) is
      s      : T_nom_client;
      k      : integer := 0;
      somme  : natural;
      existe : boolean := false;
   begin
      put ("Nom du client : ");
      Get_Line (s, k);
      for i in tab_client'Range loop
         if s (1 .. k)
           = tab_client (i).nom_du_Client.nom_Client
               (1 .. tab_client (i).nom_du_Client.k)
         then
            put ("Dette de ce client : ");
            put (tab_client (i).fact, 4);
            New_Line;
            existe := true;
            loop
               put ("Montant que le client veut regler : ");
               begin
                  Get (somme);
                  new_line;
                  exit when somme in Natural;
               exception
                  when Constraint_Error =>
                     skip_line;
                     put_line ("Erreur, le montant doit être positif");
               end;
            end loop;
            if somme > tab_client (i).fact then
               put ("Erreur, montant trop eleve");
               new_line;
            else
               tab_client (i).fact := tab_client (i).fact - somme;
               tab_client (i).montant_achat :=
                 tab_client (i).montant_achat + somme;
            end if;
         end if;
      end loop;

      if not (existe) then
         put_line ("Le client n'existe pas dans le registre");
      end if;
   end reglement;

   --Visualisation du registre de clients
   procedure visu_tab_client (tab_client : in out T_tab_client) is
   begin
      for i in tab_client'Range loop
         if tab_client (i).nb_com /= -1 then
            put ("Nom du client : ");
            put
              (tab_client (i).nom_du_Client.nom_Client
                 (1 .. tab_client (i).nom_du_Client.k));
            new_line;
            put ("Le nombre de ses commandes est : ");
            put (tab_client (i).nb_com, 3);
            new_line;
            put ("Le montant de sa dette est de : ");
            put (tab_client (i).fact, 3);
            new_line;
            put ("Le montant de ses achats deja realise est de : ");
            put (tab_client (i).montant_achat, 3);
            new_line;
         end if;
      end loop;
   end visu_tab_client;

   --Visualisation des clients sans commandes en attentes
   procedure visu_sans_commande_attente (tab_client : in out T_tab_client) is
   begin
      put_line ("Client(s) sans commandes en attente :");
      for i in tab_client'Range loop
         if tab_client (i).nb_com /= -1 and (tab_client (i).nb_com) = 0 then
            put ("=> ");
            put (tab_client (i).nom_du_Client.nom_Client);
            new_line;
         end if;
      end loop;
   end visu_sans_commande_attente;

end gestion_client;
