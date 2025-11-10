**Outils**
subtype T_nom_client is string(1..100)

procedure de saisie du nom ?





**Gestion_date**

T_liste_mois is (janvier,fevrier,mars,avril,mai,juin,juillet,aout,septembre,octobre,novembre,decembre);

T_mois is record
    mois : T_liste_mois;
    nb_jour : integer;
end record;

T_tab_mois is array(integer range 1..12) of T_mois;

T_date is record
    jour : integer;
    mois : T_liste_mois;
    annee : positive;
end record;




**Gestion_client**

nb_c : constant;

T_client is record
    nom_client : T_nom_client;
    Taille_nom_client : integer;
    nb_commande : integer;
    fact : integer;
    montant_achat : integer;
end record;

T_tab_client is array(integer range 1..nb_c) of T_client;





**Gestion_lot**

nb_lot : constant;

T_produit is (#liste de produit#);

T_lot is record
    num_lot : integer;
    produit : T_produit;
    date_fab : T_date;
    stock : integer;
    vendu : integer;
    prix_ex : integer;
end record;

T_tab_lot is array (integer range 1..nb_lot) of T_lot;





**Gestion_commande**

max_com : constant;

T_compo_com is array (T_produit'range) of integer;

T_commande is record
    num_com : integer;
    nom_client : T_nom_client;
    compo_com : T_compo_com;
    date : T_date;
    com_att : integer;
end record;

T_tab_commande is array (integer range 1..max_comm) of T_commande;





**Gestion_achat**

T_compo_achat is record
    produit : T_produit;
    num_lot : integer;
    nb_ex : integer;
end record;

T_tab_compo_achat is array (integer range 1..nb_lot) of T_compo_achat;

T_achat is record
    compo : T_tab_compo_achat;
    date_liv : T_date;
    nom_client : T_nom_client;
    prix : integer;
    tps_ecoule : integer;
end record;





**Gestion_sauvegarde**

T_sauvegarde is record
    sauv_lot : T_tab_lot;
    sauv_client : T_tab_client;
    sauv_com : T_tab_commande;
end record;

package sauvegarde is new ada.sequential_io (T_sauvegarde);

package archive_achat is new ada.sequential_io (T_achat);