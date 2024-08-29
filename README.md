# Correction Rush-02

etape 1:

- verifier le `Makefile`

etape 2:

- copier `testok`, le `*.sh` et les `*.dict` dans le dossier `ex00/`

etape 3:

- lancer `./test.sh`
- (si le programme ne s'arrete pas tous seul, c'est qu'il y a un pb de parsing)
  ^C au bout de 30 secondes environ

etape 4:

- rajouter `-g3 -fsanitize=undefined,address,leak` dans le `Makefile`
- refaire les etapes 3 (^C obligatoire au bout de 1 minute)

NOTA:

- les tests ko ne sont pas un motif suffisant pour compter faux
- il faut reinterpreter les solutions en fonction des bonus choisi
