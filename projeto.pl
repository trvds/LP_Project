% Tiago Rodriges Vieira da Silva  99335

:- [codigo_comum, puzzles_publicos].


% combinacao_soma(N, Els, Soma, Combs)
combinacoes_soma(N, Els, Soma, Combs) :-
    findall(Comb, (combinacao(N, Els, Comb), sum_list(Comb, Sum), Sum == Soma), Combs).


% permutacoes_soma(N, Els, Soma, Perms)
permutacoes_soma(N, Els, Soma, Perms) :-
    combinacao_soma(N, Els, Soma, Combs),
    findall(Perm, (combinacao(N, Els, Comb), member(Comb, Combs), permutation(Comb, Perm)) , Unsorted_Perms),
    sort(Unsorted_Perms, Perms).


% espaco
espaco(Soma, Variaveis).

% espaco_fila(Fila, Esp, H_V)
espaco_fila(Fila, Esp, h) :-
    append([_, [Somas], Variaveis, [Prox_Soma], _], Fila),
    is_list(Somas),
    nth1(1, Somas, Soma),
    is_list(Prox_Soma),
    nao_tem_lista(Variaveis),
    Variaveis \= [],   
    Esp = espaco(Soma, Variaveis).   

espaco_fila(Fila, Esp, h) :-
    append([_, [Somas], Variaveis], Fila),
    is_list(Somas),
    nth1(1, Somas, Soma),
    nao_tem_lista(Variaveis),
    Variaveis \= [],   
    Esp = espaco(Soma, Variaveis).   

espaco_fila(Fila, Esp, v) :-
    append([_, [Somas], Variaveis, [Prox_Soma], _], Fila),
    is_list(Somas),
    nth1(2, Somas, Soma),
    is_list(Prox_Soma),
    nao_tem_lista(Variaveis),
    Variaveis \= [],   
    Esp = espaco(Soma, Variaveis).   

espaco_fila(Fila, Esp, v) :-
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
espacos_fila(h, Fila, Espacos) :-
    bagof(Esp, Esp^espaco_fila(Fila, Esp, v), Espacos), !.

espacos_fila(h, Fila, Espacos) :-
    Espacos = [], !.

espacos_fila(v, Fila, Espacos) :-
    bagof(Esp, Esp^espaco_fila(Fila, Esp, h), Espacos), !.

espacos_fila(v, Fila, Espacos) :-
    Espacos = [], !.



