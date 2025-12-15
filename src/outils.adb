with ada.text_io, ada.integer_text_io, ada.characters.handling;
use ada.text_io, ada.integer_text_io, ada.characters.handling;

package body outils is

   --Saisie du nom du client, avec gestion de la validité du nom
   procedure saisie_nom_client (C : in out client) is
      s : T_nom_client := (others => ' ');
      k : integer := 0;
      x : integer := 0;
   begin

      --Saisie du nom du client
      loop
         loop
            put ("Nom du client : ");
            get_line (s, k);
            s := to_lower (s);
            exit when k > 0;
            put ("/!\ Erreur : la saisie du nom ne peut pas etre vide");
         end loop;

         x := 0;

         --Vérification si le nom commence ou fini par un espace
         if (s (s'First) = ' ') or (s (k) = ' ') then
            x := x + 1;
         end if;

         --Verification si le nom comporte uniquement des lettres, des chiffres ou des espaces
         for i in 1 .. k loop
            if s (i) not in 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | ' ' then
               x := x + 1;
            end if;

            --Verification si le nom ne contient pas deux espaces consécutifs
            if (i > 1) and (i < k) then
               if (s (i) = ' ') and ((s (i - 1) = ' ') or s (i + 1) = ' ') then
                  x := x + 1;
               end if;
            end if;
         end loop;

         --Enregistrement du nom si il ne contient aucune erreur
         if x = 0 then
            C.nom_Client (1 .. k) := s (1 .. k);
            C.k := k;
            exit;
         else
            put_line ("Le nom du client n'est pas valide");
         end if;
      end loop;
   end saisie_nom_client;

   --Affichage d'un nom de client
   procedure affichage_nom_client (c : in client) is
   begin
      put (c.nom_Client (1 .. c.k));
   end affichage_nom_client;

   --Saisie d'un produit, utilisée dans
   -- package gestion_lot : saisie_lot, modif_capa_prod, visu_lot_produit
   procedure saisie_produit (produit : in out T_produit) is
      s      : string (1 .. 14);
      k      : integer;
      valide : Boolean;
   begin
      loop
         valide := true;
         put ("Type de produit : ");
         get_line (s, k);
         if to_lower (s (1 .. k)) = "lotion tonique" then
            produit := T_produit'val (0);
         elsif to_lower (s (1 .. k)) = "demaquillant" then
            produit := T_produit'val (1);
         elsif to_lower (s (1 .. k)) = "creme visage" then
            produit := T_produit'val (2);
         elsif to_lower (s (1 .. k)) = "gel douche" then
            produit := T_produit'val (3);
         elsif to_lower (s (1 .. k)) = "lait corporel" then
            produit := T_produit'val (4);
         else
            valide := false;
            new_line;
            Put_Line ("/!\ Nom de produit invalide");
            new_line;
         end if;
         exit when valide;
      end loop;
   end saisie_produit;

   --Affichage de la nature du produit d'un lot, utilisée dans
   -- package gestion_lot : affichage_lot, visu_produit_manquant
   procedure affichage_produit (produit : in T_produit) is
   begin
      if produit = T_produit'val (0) then
         Put ("Lotion tonique");
      elsif produit = T_produit'val (1) then
         Put ("Demaquillant");
      elsif produit = T_produit'val (2) then
         Put ("Creme visage");
      elsif produit = T_produit'val (3) then
         Put ("Gel douche");
      elsif produit = T_produit'val (4) then
         Put ("Lait corporel");
      end if;
   end affichage_produit;
end outils;
