% Tiago Rodriges Vieira da Silva  99335

:- [codigo_comum, puzzles_publicos].


% combinacoes_soma(N, Els, Soma, Combs)
combinacoes_soma(N, Els, Soma, Combs) :-
    findall(Comb, (combinacao(N, Els, Comb), sum_list(Comb, Sum), Sum == Soma), Combs).


% permutacoes_soma(N, Els, Soma, Perms)
permutacoes_soma(N, Els, Soma, Perms) :-
    combinacoes_soma(N, Els, Soma, Combs),
    findall(Perm, (combinacao(N, Els, Comb), member(Comb, Combs), permutation(Comb, Perm)) , Unsorted_Perms),
    sort(Unsorted_Perms, Perms).


% espaco
% espaco(Soma, Variaveis).

% espaco_fila(Fila, Esp, H_V)
espaco_fila(Fila, Esp, v) :-
    append([_, [Somas], Variaveis, [Prox_Soma], _], Fila),
    is_list(Somas),
    nth1(1, Somas, Soma),
    is_list(Prox_Soma),
    nao_tem_lista(Variaveis),
    Variaveis \= [],   
    Esp = espaco(Soma, Variaveis).   

espaco_fila(Fila, Esp, v) :-
    append([_, [Somas], Variaveis], Fila),
    is_list(Somas),
    nth1(1, Somas, Soma),
    nao_tem_lista(Variaveis),
    Variaveis \= [],   
    Esp = espaco(Soma, Variaveis).   

espaco_fila(Fila, Esp, h) :-
    append([_, [Somas], Variaveis, [Prox_Soma], _], Fila),
    is_list(Somas),
    nth1(2, Somas, Soma),
    is_list(Prox_Soma),
    nao_tem_lista(Variaveis),
    Variaveis \= [],   
    Esp = espaco(Soma, Variaveis).   

espaco_fila(Fila, Esp, h) :-
    append([_, [Somas], Variaveis], Fila),
    is_list(Somas),
    nth1(2, Somas, Soma),
    nao_tem_lista(Variaveis),
    Variaveis \= [],   
    Esp = espaco(Soma, Variaveis).   


% nao_tem_listas(Lista)
nao_tem_lista([]).

nao_tem_lista([X|R]) :-
    \+ is_list(X),
    nao_tem_lista(R).


%espacos_fila(H_V, Fila, Espacos)
espacos_fila(v, Fila, Espacos) :-
    bagof(Esp, Esp^espaco_fila(Fila, Esp, v), Espacos), !.

espacos_fila(v, _ , Espacos) :-
    Espacos = [], !.

espacos_fila(h, Fila, Espacos) :-
    bagof(Esp, Esp^espaco_fila(Fila, Esp, h), Espacos), !.

espacos_fila(h, _ , Espacos) :-
    Espacos = [], !.


% espacos_puzzle(Puzzle, Espacos)
espacos_puzzle(Puzzle, Espacos) :-
    mat_transposta(Puzzle, Puzzle_T),
    append(Puzzle, Puzzle_L),
    append(Puzzle_T, Puzzle_LT),
    espacos_fila(h, Puzzle_L, Esp),
    espacos_fila(v, Puzzle_LT, Esp_T),
    append(Esp, Esp_T, Espacos).


% espacos_com_posicoes_comuns(Espacos, Esp, Esps_com)
espacos_com_posicoes_comuns([], _ , []) :- !.

espacos_com_posicoes_comuns([Espaco | R], Esp1, [Espaco| Q]) :-
    espaco_posicao_comum(Esp1, Espaco),
    Esp1 \== Espaco,
    espacos_com_posicoes_comuns(R, Esp1, Q), !.

espacos_com_posicoes_comuns([ _ | R], Esp1, Q) :-
    espacos_com_posicoes_comuns(R, Esp1, Q), !.

espaco_posicao_comum(Esp1, Espaco) :-
    Espaco = espaco( _ , Esp_Vars),
    Esp1 = espaco( _ , Variaveis),
    posicao_comum(Esp_Vars, Variaveis).


% posicao_comum(Var, Variaveis)
posicao_comum( _ , []) :- false.

posicao_comum(Var, [Pos| _ ]) :-
    membro(Pos, Var), !.

posicao_comum(Var, [ _ |R]) :-
    posicao_comum(Var, R).


% verifica que um elemento e membro sem unificar
% (baseado no enunciado das aulas da Prof. Remedios)
membro(E, [P| _ ]) :- E == P.
membro(E, [_ | R]) :- membro(E, R).


% permutacoes_soma_espacos(Espacos, Perms_soma)
permutacoes_soma_espacos( _ , []).


permutacoes_soma_espacos([Espaco|Espacos], [Perm|Perms]) :-
    Perm = [Espaco, Permutacao],
    Els = [1,2,3,4,5,6,7,8,9],
    Espaco = espaco(Soma, Variaveis),
    length(Variaveis, N),
    permutacoes_soma(N, Els, Soma, Permutacao),
    permutacoes_soma_espacos(Espacos, Perms).


% permutacao_possivel_espaco(Perm, Esp, Espacos, Perms_soma)
permutacao_possivel_espaco(Perm, Esp, Espacos, Perms_soma) :-
    espacos_com_posicoes_comuns(Espacos, Esp, Esps_coms),
    bagof(Perm_Esp, Esp^(member(PS_Esp, Perms_soma), PS_Esp = [Esp , Perm_Esp]), [Perm_Esp]),
    member(Perm, Perm_Esp),
    bagof(Index, Esp_com^(member(Esp_com, Esps_coms), nth1(Index, Esps_coms, Esp_com)), Indexes),
    forall(member(Index, Indexes),
    (
        nth1(Index, Esps_coms, Esp_com),
        nth1(Index, Perm, N),
        member(PS, Perms_soma),
        PS = [Esp_com, Perm_PS],
        append(Perm_PS, Var_com),
        member(N, Var_com)
    )).


% permutacoes_possiveis_espaco(Espacos, Perms_soma, Esp, Perms_poss)
permutacoes_possiveis_espaco(Espacos, Perms_soma, Esp, Perms_poss) :-
    bagof(Perm, permutacao_possivel_espaco(Perm, Esp, Espacos, Perms_soma), Temp),
    list_to_set(Temp, Temp2),
    Esp = espaco( _ , Vars),
    Perms_poss = [Vars, Temp2].


% permutacoes_possiveis_espacos(Espacos, Perms_poss_esps)
permutacoes_possiveis_espacos(Espacos, Perms_poss_esps) :-
    permutacoes_soma_espacos(Espacos, Perms_soma),
    maplist(permutacoes_possiveis_espaco(Espacos, Perms_soma),Espacos,Perms_poss_esps). 


% numeros_comuns(Lst_Perms, Numeros_comuns)
numeros_comuns(Lst_Perms, Numeros_comuns) :-
    nth1(1, Lst_Perms, Perm1),
    findall(Par,(
        member(N, Perm1),
        nth1(Index, Perm1, N),
        Par = (Index, N)
    ), Numeros_Temp),
    list_to_set(Numeros_Temp, Numeros),
    aux_numeros_comuns(Lst_Perms, Numeros, Numeros_comuns). 


aux_numeros_comuns([], Numeros, Numeros).

aux_numeros_comuns([Perm|R], Numeros, Numeros_comuns) :-
    include(condicao(Perm) , Numeros, Numeros1),
    aux_numeros_comuns(R, Numeros1, Numeros_comuns).

condicao(Perm, Par) :-
    Par = (Index, N),
    nth1(Index, Perm, N).


% atribui_comuns(Perms_Possiveis)
atribui_comuns([]).

atribui_comuns([Perms_Possivel|R]) :-
    nth1(1, Perms_Possivel, Vars),
    nth1(2, Perms_Possivel, Perms),
    numeros_comuns(Perms, Nums_com),
    unificar(Nums_com, Vars),
    atribui_comuns(R).

unificar([], _).

unificar([Par|R], Vars) :-
    Par = (Index, N),
    nth1(Index, Vars, N),
    unificar(R, Vars).


% retira_impossiveis(Perms_Possiveis, Novas_Perms_Possiveis)
retira_impossiveis([], []).

retira_impossiveis([Esp_Perm|R], [Novo_Esp_Perm|Q]) :-
    Esp_Perm = [Vars, Perm],
    include(check_comuns(Vars), Perm, Novo_Perm),
    Novo_Esp_Perm = [Vars, Novo_Perm],
    retira_impossiveis(R, Q).


check_comuns([], _).

check_comuns([Var|R], [Elem_Perm|Q]) :-
    Var == Elem_Perm,
    check_comuns(R, Q).

check_comuns([Var|R], [ _ |Q]) :-
    var(Var),
    check_comuns(R, Q).

