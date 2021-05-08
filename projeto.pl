% Tiago Rodriges Vieira da Silva  99335

:- [codigo_comum].


% combinacao_soma(N, Els, Soma, Combs)
combinacao_soma(N, Els, Soma, Combs) :-
    findall(Comb, (combinacao(N, Els, Comb), sum_list(Comb, Sum), Sum == Soma), Combs).


% permutacoes_soma(N, Els, Soma, Perms)
permutacoes_soma(N, Els, Soma, Perms) :-
    combinacao_soma(N, Els, Soma, Combs),
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

