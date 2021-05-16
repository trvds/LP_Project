% Tiago Rodrigues Vieira da Silva  99335

:- [codigo_comum].


%===============================================================================
% combinacoes_soma(N, Els, Soma, Combs)
% N eh um inteiro, Els eh uma lista de inteiros, Soma eh um inteiro.
% Combs eh a lista ordenada cujos elementos sao as combinacoes N a N, dos 
% elementos de Els cuja soma eh Soma.
%===============================================================================
combinacoes_soma(N, Els, Soma, Combs) :-
    findall(Comb, 
    (   
        combinacao(N, Els, Comb),
        sum_list(Comb, Sum), Sum == Soma
    ), Combs).


%===============================================================================
% permutacoes_soma(N, Els, Soma, Perms)
% N eh um inteiro, Els eh uma lista de inteiros, Soma eh um inteiro.
% Perms eh a lista ordenada cujos elementos sao as permutacoes das combinacoes
% N a N, dos elementos de Els cuja soma eh Soma.
%===============================================================================
permutacoes_soma(N, Els, Soma, Perms) :-
    combinacoes_soma(N, Els, Soma, Combs),
    findall(Perm,
    (
        combinacao(N, Els, Comb),
        member(Comb, Combs),
        permutation(Comb, Perm)
    ), Unsorted_Perms),
    sort(Unsorted_Perms, Perms).


%===============================================================================
% espaco_fila(Fila, Esp, H_V)
% Fila eh uma fila (linha ou coluna) de um puzzle, H_V eh um dos atomos h ou v, 
% conforme se trate de uma fila horizontal ou vertical, respectivamente.
% Esp eh um espaco de Fila.
%===============================================================================
espaco_fila(Fila, Esp, v) :- aux_espaco_fila(Fila, Esp, 1).
espaco_fila(Fila, Esp, h) :- aux_espaco_fila(Fila, Esp, 2).

aux_espaco_fila(Fila, Esp, Index) :-
    append([_, [Somas], Variaveis, [Prox_Soma], _], Fila),
    is_list(Somas),
    nth1(Index, Somas, Soma),
    is_list(Prox_Soma),
    nao_tem_lista(Variaveis),
    Variaveis \= [],   
    Esp = espaco(Soma, Variaveis).   

aux_espaco_fila(Fila, Esp, Index) :-
    append([_, [Somas], Variaveis], Fila),
    is_list(Somas),
    nth1(Index, Somas, Soma),
    nao_tem_lista(Variaveis),
    Variaveis \= [],   
    Esp = espaco(Soma, Variaveis).   

%===============================================================================
% nao_tem_listas(Lst)
% Lst eh uma lista que nao possui nenhuma lista nos seus elementos
%===============================================================================
nao_tem_lista([]).

nao_tem_lista([X|R]) :-
    \+ is_list(X),
    nao_tem_lista(R).


%===============================================================================
% espacos_fila(H_V, Fila, Espacos)
% Fila eh uma fila (linha ou coluna) de uma grelha e H_V eh um dos atomos h ou v
% Espacos eh a lista de todos os espacos de Fila, da esquerda para a direita.
%===============================================================================
espacos_fila(v, Fila, Espacos) :-
    bagof(Esp, Esp^espaco_fila(Fila, Esp, v), Espacos), !.

espacos_fila(v, _ , Espacos) :-
    Espacos = [], !.

espacos_fila(h, Fila, Espacos) :-
    bagof(Esp, Esp^espaco_fila(Fila, Esp, h), Espacos), !.

espacos_fila(h, _ , Espacos) :-
    Espacos = [], !.


%===============================================================================
% espacos_puzzle(Puzzle, Espacos)
% Puzzle eh um puzzle.
% Espacos eh a lista de espacos de Puzzle.
%===============================================================================
espacos_puzzle(Puzzle, Espacos) :-
    mat_transposta(Puzzle, Puzzle_T),
    append(Puzzle, Puzzle_L),
    append(Puzzle_T, Puzzle_LT),
    espacos_fila(h, Puzzle_L, Esp),
    espacos_fila(v, Puzzle_LT, Esp_T),
    append(Esp, Esp_T, Espacos).


%===============================================================================
% espacos_com_posicoes_comuns(Espacos, Esp, Esps_com)
% Espacos eh uma lista de espacos e Esp eh um espaco.
% Esps_com eh a lista de espacos com variaveis em comum com Esp.
%===============================================================================
espacos_com_posicoes_comuns([], _ , []) :- !.

espacos_com_posicoes_comuns([Espaco|R], Esp1, [Espaco|Q]) :-
    espaco_posicao_comum(Esp1, Espaco),
    Esp1 \== Espaco,
    espacos_com_posicoes_comuns(R, Esp1, Q), !.

espacos_com_posicoes_comuns([ _ |R], Esp1, Q) :-
    espacos_com_posicoes_comuns(R, Esp1, Q), !.


%===============================================================================
% espaco_posicao_comum(Esp1, Esp2)
% [predicado auxiliar de espacos_com_posicoes_comuns/3]
% Esp1 e Esp2 sao ambos espacos com pelo menos uma posicao(variavel) em comum.
%===============================================================================
espaco_posicao_comum(Esp1, Esp2) :-
    Esp2 = espaco( _ , Vars2),
    Esp1 = espaco( _ , Vars1),
    posicao_comum(Vars2, Vars1).


%===============================================================================
% posicao_comum(Vars2, Vars1)
% [predicado auxiliar de espaco_posicao_comum/2]
% Vars2 e Vars1 sao listas com pelo menos uma posicao(variavel) em comum.
%===============================================================================
posicao_comum( _ , []) :- false.

posicao_comum(Vars, [Pos| _ ]) :-
    membro(Pos, Vars), !.

posicao_comum(Vars, [ _ |R]) :-
    posicao_comum(Vars, R).


%===============================================================================
% membro(Elem, Lista)
% verifica que Elem esta na lista Lst sem unificar
% (baseado no enunciado das aulas da Prof. Remedios)
%===============================================================================
membro(E, [P| _ ]) :- E == P.
membro(E, [_ | R]) :- membro(E, R).

%===============================================================================
% permutacoes_soma_espacos(Espacos, Perms_soma)
% Espacos eh uma lista de espacos.
% Perms_soma eh a lista de listas de 2 elementos, em que o 1o elemento eh um 
% espaco de Espacos e o 2o eh a lista ordenada de permutacoes cuja soma eh igual
% ah soma do espaco.
%===============================================================================
permutacoes_soma_espacos( _ , []).

permutacoes_soma_espacos([Espaco|Espacos], [Perm|Perms]) :-
    Perm = [Espaco, Permutacao],
    Els = [1,2,3,4,5,6,7,8,9],
    Espaco = espaco(Soma, Variaveis),
    length(Variaveis, N),
    permutacoes_soma(N, Els, Soma, Permutacao),
    permutacoes_soma_espacos(Espacos, Perms).


%===============================================================================
% permutacao_possivel_espaco(Perm, Esp, Espacos, Perms_soma)
% Perm eh uma permutacao, Esp eh um espaco, Espacos eh uma lista  de  espacos e 
% Perms_soma eh uma lista de listas tal como obtida pelo predicado anterior.
% Perm eh uma permutacao possivel para o espaco Esp.
%===============================================================================
permutacao_possivel_espaco(Perm, Esp, Espacos, Perms_soma) :-
    espacos_com_posicoes_comuns(Espacos, Esp, Esps_coms),
    bagof(Index,
    Esp_com^(
        member(Esp_com, Esps_coms),
        nth1(Index, Esps_coms, Esp_com)
    ), Indexes),
    bagof(Perm_Esp, 
    Esp^(
        member(PS_Esp, Perms_soma),
        PS_Esp = [Esp , Perm_Esp]
    ), [Perm_Esp]),
    member(Perm, Perm_Esp),
    forall(member(Index, Indexes),
    (
        nth1(Index, Esps_coms, Esp_com),
        nth1(Index, Perm, N),
        member(PS, Perms_soma),
        PS = [Esp_com, Perm_PS],
        append(Perm_PS, Var_com),
        member(N, Var_com)
    )).


%===============================================================================
% permutacoes_possiveis_espaco(Espacos, Perms_soma, Esp, Perms_poss)
% Espacos eh uma lista de espacos, Perms_soma eh uma lista de listas tal como 
% obtida pelo predicado permutacoes_soma_espacos, e Esp eh um espaco.
% Perms_poss eh uma lista de 2 elementos no seguinte formato: 
% [[variaveis de Esp], [lista de permutacoes possiveis para Esp]].
%===============================================================================
permutacoes_possiveis_espaco(Espacos, Perms_soma, Esp, Perms_poss) :-
    bagof(
        Perm,
        permutacao_possivel_espaco(Perm, Esp, Espacos, Perms_soma),
        Temp
    ),
    list_to_set(Temp, Temp2),
    Esp = espaco( _ , Vars),
    Perms_poss = [Vars, Temp2].


%===============================================================================
% permutacoes_possiveis_espacos(Espacos, Perms_poss_esps)
% Espacos eh uma lista de espacos.
% Perms_poss_esps eh a lista de permutacoes possiveis.
%===============================================================================
permutacoes_possiveis_espacos(Espacos, Perms_poss_esps) :-
    permutacoes_soma_espacos(Espacos, Perms_soma),
    maplist(
        permutacoes_possiveis_espaco(Espacos, Perms_soma), 
        Espacos, 
        Perms_poss_esps
    ). 


%===============================================================================
% numeros_comuns(Lst_Perms, Numeros_comuns)
% Lst_Perms eh uma lista de permutacoes.
% Numeros_comuns eh uma lista de pares (pos, numero), significando que todas as
% listas de Lst_Perms conteem o numero "numero" na posicao "pos".
%===============================================================================
numeros_comuns(Lst_Perms, Numeros_comuns) :-
    nth1(1, Lst_Perms, Perm1),
    findall(Par,(
        member(N, Perm1),
        nth1(Index, Perm1, N),
        Par = (Index, N)
    ), Numeros_Temp),
    list_to_set(Numeros_Temp, Numeros),
    aux_numeros_comuns(Lst_Perms, Numeros, Numeros_comuns). 


%===============================================================================
% aux_numeros_comuns(Lst_Perms, Numeros, Numeros_comuns)
% [predicado auxiliar de numeros_comuns/2]
% Lst_Perms eh uma lista de permutacoes, Numeros eh uma lista de pares
% (pos, numero) comuns do primeiro elemento de Lst_Perms.
% Numeros eh uma lista de pares (pos, numero) comuns a todas as permutacoes de
% Lst_Perms
%===============================================================================
aux_numeros_comuns([], Numeros, Numeros).

aux_numeros_comuns([Perm|R], Numeros, Numeros_comuns) :-
    include(condicao_comuns(Perm) , Numeros, Numeros1),
    aux_numeros_comuns(R, Numeros1, Numeros_comuns).


%===============================================================================
% condicao_comuns(Perm, Par)
% [predicado auxiliar de aux_numeros_comuns/2]
% Perm eh uma lista de numeros que equivale a uma permutacao.
% Par e um par (numero, pos) em que o numero "numero" esta na posicao "pos"
% na lista Perm.
%===============================================================================
condicao_comuns(Perm, Par) :-
    Par = (Index, N),
    nth1(Index, Perm, N).


%===============================================================================
% atribui_comuns(Perms_Possiveis)
% Perms_Possiveis eh uma lista de permutacoes possiveis.
% O predicado actualiza esta lista atribuindo a cada espaco numeros comuns a 
% todas as permutacoes possiveis para esse espaco.
%===============================================================================
atribui_comuns([]).

atribui_comuns([Perms_Possivel|R]) :-
    nth1(1, Perms_Possivel, Vars),
    nth1(2, Perms_Possivel, Perms),
    numeros_comuns(Perms, Nums_com),
    unificar(Nums_com, Vars),
    atribui_comuns(R).

%===============================================================================
% unificar(Nums_com, Vars)
% [predicado auxiliar de atribui_comuns/1]
% Nums_com eh uma lista de pares(pos, numero) e Vars eh uma lista de variaveis.
% Unifica cada variavel na posicao pos com o numero correspondente.
%===============================================================================
unificar([], _).

unificar([Par|R], Vars) :-
    Par = (Index, N),
    nth1(Index, Vars, N),
    unificar(R, Vars).


%===============================================================================
% retira_impossiveis(Perms_Possiveis, Novas_Perms_Possiveis)
% Perms_Possiveis eh uma lista de permutacoes possiveis.
% Novas_Perms_Possiveis eh o resultado de tirar permutacoes impossiveis de
% Perms_Possiveis
%===============================================================================
retira_impossiveis([], []).

retira_impossiveis([Esp_Perm|R], [Novo_Esp_Perm|Q]) :-
    Esp_Perm = [Vars, Perm],
    include(check_comuns(Vars), Perm, Novo_Perm),
    Novo_Esp_Perm = [Vars, Novo_Perm],
    retira_impossiveis(R, Q).

%===============================================================================
% check_comuns(Vars, Perm)
% [predicado auxiliar de retira_impossiveis/2] 
% Vars eh uma lista de variaveis e Perm eh uma permutacao
% O predicado verifica se a permutacao e possivel para a lista de variaveis.
%===============================================================================
check_comuns([], _).

check_comuns([Var|R], [Elem_Perm|Q]) :-
    Var == Elem_Perm,
    check_comuns(R, Q).

check_comuns([Var|R], [ _ |Q]) :-
    var(Var),
    check_comuns(R, Q).


%===============================================================================
% simplifica(Perms_Possiveis, Novas_Perms_Possiveis)
% Perms_Possiveis eh uma lista de permutacoes possiveis.
% Novas_Perms_Possiveis eh o resultado de simplificar Perms_Possiveis.
%===============================================================================
simplifica(Perms_Possiveis, Novas_Perms_Possiveis) :-
    atribui_comuns(Perms_Possiveis),
    retira_impossiveis(Perms_Possiveis, Temp_Perms_Possiveis),
    Perms_Possiveis == Temp_Perms_Possiveis,
    Novas_Perms_Possiveis = Temp_Perms_Possiveis.

simplifica(Perms_Possiveis, Novas_Perms_Possiveis) :-
    atribui_comuns(Perms_Possiveis),
    retira_impossiveis(Perms_Possiveis, Temp_Perms_Possiveis),
    simplifica(Temp_Perms_Possiveis, Novas_Perms_Possiveis), !.


%===============================================================================
% inicializa(Puzzle, Perms_Possiveis)
% Puzzle eh um puzzle.
% Perms_Possiveis eh a lista de permutacoes possiveis simplificada para Puzzle.
%===============================================================================
inicializa(Puzzle, Perms_Possiveis) :-
    espacos_puzzle(Puzzle, Espacos),
    permutacoes_possiveis_espacos(Espacos, Perms_poss_esps),
    simplifica(Perms_poss_esps, Perms_Possiveis).


%===============================================================================
% escolhe_menos_alternativas(Perms_Possiveis, Escolha)
% Perms_Possiveis eh uma lista de permutacoes possiveis.
% Escolha eh o primeiro elemento de Perms_Possiveis com mais do que um elemento.
% Devolve "false" se nao houver nenhum elemento maior que um em Perms_Possiveis.
%===============================================================================
escolhe_menos_alternativas(Perms_Possiveis, Escolha) :-
    findall(L, 
    (
        member(Perm, Perms_Possiveis),
        Perm = [ _ , Perms],
        length(Perms, L)
    ),
    Lengths),
    exclude(=(1), Lengths, Lengths2),
    Lengths2 \== [],
    min_list(Lengths2, L),
    nth1(Index,Lengths, L),
    nth1(Index, Perms_Possiveis, Escolha), !.


%===============================================================================
% experimenta_perm(Escolha, Perms_Possiveis,Novas_Perms_Possiveis)
% Perms_Possiveis eh uma lista de permutacoes possiveis, Escolha eh um dos seus 
% elementos.
% Novas_Perms_Possiveis eh o resultado de substituir em Perms_Possiveis o
% elemento Escolha pelo elemento [Esp, [Perm]].
% (Esp e o espaco de Escolha, Perm e uma das Permutacoes de Escolha)
%===============================================================================
experimenta_perm(Escolha, Perms_Possiveis, Novas_Perms_Possiveis) :-
    Escolha = [Esp, Lst_Perms],
    member(Perm, Lst_Perms),
    Esp = Perm,
    Tentativa = [Esp, [Perm]],
    select(Escolha, Perms_Possiveis, Tentativa, Novas_Perms_Possiveis).
    

%===============================================================================
% resolve_aux(Perms_Possiveis, Novas_Perms_Possiveis)
% Perms_Possiveis eh uma lista de permutacoes possiveis.
% Novas_Perms_Possiveis eh o resultado de aplicar os predicados:
%   -escolhe_menos_alternativas/2
%   -experimenta_perm/2
%   -simplifica/2
% repetidamente ate que a repeticao ja nao altere nada.
%===============================================================================
resolve_aux(Perms_Possiveis, Novas_Perms_Possiveis) :-
    \+ escolhe_menos_alternativas(Perms_Possiveis, _ ),
    Perms_Possiveis = Novas_Perms_Possiveis.

resolve_aux(Perms_Possiveis, Novas_Perms_Possiveis) :-
    escolhe_menos_alternativas(Perms_Possiveis, Escolha),
    experimenta_perm(Escolha, Perms_Possiveis, Temp),
    simplifica(Temp, Temp2),
    resolve_aux(Temp2, Novas_Perms_Possiveis).


%===============================================================================
% resolve(Puz)
% Puz eh um puzzle.
% O predicado resolve Puzz.
%===============================================================================
resolve(Puz) :-
    inicializa(Puz, Perms_Possiveis),
    resolve_aux(Perms_Possiveis, _ ).

