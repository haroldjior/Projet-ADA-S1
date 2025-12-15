with ada.text_io,
     ada.integer_text_io,
     ada.IO_Exceptions,
     outils,
     ada.characters.Handling;
use ada.text_io, ada.integer_text_io, outils, ada.characters.Handling;

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

      --Vérification que le nom du client n'existe pas
      --  existe := recherche_client (A, c.nom_Client);
      for i in A'range loop
         if A (i).nom_du_Client = c then
            existe := true;
            exit;
         end if;
      end loop;

      --Enregistrement du client dans le registre
      if not (existe) then

         for i in A'range loop
            if A (i).nb_com = -1 then
               x := i;
               trouve := true;
               exit;
            end if;
         end loop;

         if trouve then
            A (x).nom_du_Client.nom_Client := c.nom_Client;
            A (x).nom_du_Client.k := C.k;
            A (x).nb_com := 0;
            put_line ("Le client a bien ete ajoute !");
         else
            put_line ("/!\ Erreur : le registre est plein");
         end if;
      else
         put_line ("/!\ Erreur : ce client existe deja");
      end if;

   end ajout_client;

   --Suppression d'un client du registre de client
   procedure sup_client (tab_client : in out T_tab_client) is
      nom    : client;
      existe : Boolean := false;
      x      : integer := 0;
   begin
      saisie_nom_client (nom);
      new_line;
      recherche_client (tab_client, nom.nom_Client, existe, x);
      if existe then
         if (tab_client (x).nb_com = 0) and (tab_client (x).fact = 0) then
            tab_client (x).nb_com := -1;
            tab_client (x).fact := 0;
            tab_client (x).montant_achat := 0;
            tab_client (x).nom_du_Client.nom_Client := (others => ' ');
            tab_client (x).nom_du_Client.k := 0;
            put_line ("Le client a bien ete supprime !");
         else
            if tab_client (x).nb_com > 0 then
               put_line ("/!\ Suppression impossible : commande en attente");
            end if;
            if tab_client (x).fact > 0 then
               put_line ("/!\ Suppression impossible : facture non reglee");
            end if;
         end if;
      end if;

      if not existe then
         put_line ("/!\ Erreur : client inexistant");
      end if;
   end sup_client;

   --Enregistrement d'un règlement
   procedure reglement (tab_client : in out T_tab_client) is
      s      : T_nom_client;
      x      : integer := 0;
      somme  : natural;
      existe : boolean := false;
      nom    : client;
   begin
      saisie_nom_client (nom);
      recherche_client (tab_client, nom.nom_Client, existe, x);
      if existe then
         put ("Dette de ce client : ");
         put (tab_client (x).fact, 4);
         New_Line;
         loop
            put ("Montant que le client veut regler : ");
            begin
               Get (somme);
               new_line;
               exit when somme > 0;
            exception
               when Ada.IO_Exceptions.Data_Error | Constraint_Error =>
                  skip_line;
                  put_line ("/!\ Erreur de saisie : entrer un entier positif");
            end;
         end loop;
         if somme > tab_client (x).fact then
            put ("/!\ Erreur, le montant est superieur a la dette du client");
            new_line;
         else
            tab_client (x).fact := tab_client (x).fact - somme;
         end if;
      else
         new_line;
         put_line ("/!\ Erreur : le client n'existe pas dans le registre");
      end if;

   end reglement;

   --Visualisation du registre de clients
   procedure visu_tab_client (tab_client : in out T_tab_client) is
   begin
      put_line ("| Nom du client        | Nb com | Dette | Achats |");
      put_line ("|----------------------|--------|-------|--------|");
      for i in tab_client'Range loop
         if tab_client (i).nb_com /= -1 then
            put ("| ");
            put (tab_client (i).nom_du_Client.nom_Client (1 .. 20));
            put (" |   ");
            put (tab_client (i).nb_com, 3);
            put ("  |  ");
            put (tab_client (i).fact, 3);
            put ("  |   ");
            put (tab_client (i).montant_achat, 3);
            put_line ("  |");
         end if;
      end loop;
   end visu_tab_client;

   --Visualisation des clients sans commandes en attentes
   procedure visu_sans_commande_attente (tab_client : in out T_tab_client) is
   begin
      put_line ("Client(s) sans commandes en attente :");
      new_line;
      for i in tab_client'Range loop
         if tab_client (i).nb_com /= -1 and (tab_client (i).nb_com) = 0 then
            put ("=> ");
            put (tab_client (i).nom_du_Client.nom_Client);
            new_line;
         end if;
      end loop;
   end visu_sans_commande_attente;

   procedure recherche_client
     (tab_client : in T_tab_client;
      nom_client : in T_nom_client;
      existe     : out boolean;
      indice     : out integer) is
   begin
      indice := 0;
      existe := false;
      for i in tab_client'range loop
         if tab_client (i).nom_du_Client.nom_Client = nom_Client then
            existe := true;
            indice := i;
            exit;
         end if;
      end loop;
   end recherche_client;

end gestion_client;
