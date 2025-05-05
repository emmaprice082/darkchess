import move.aleo;
program board.aleo;

record ChessBoardState:
    owner as address.private;
    white_pieces as u64.private;
    black_pieces as u64.private;
    known_enemy_locations as u64.private;
    player_1 as address.private;
    player_2 as address.private;
    game_started as boolean.private;

function new_game_state:
    input r0 as u64.private;
    input r1 as u64.private;
    input r2 as address.private;
    input r3 as address.private;
    cast r2 r0 r1 0u64 r2 r3 true into r4 as ChessBoardState.record;
    output r4 as ChessBoardState.record;

function update_board:
    input r0 as ChessBoardState.record;
    input r1 as move.aleo/Move.record;
    or r0.known_enemy_locations r1.from_coordinate into r2;
    or r2 r1.to_coordinate into r3;
    cast r0.owner r0.white_pieces r0.black_pieces r3 r0.player_1 r0.player_2 r0.game_started into r4 as ChessBoardState.record;
    output r4 as ChessBoardState.record;

function reveal_pieces:
    input r0 as ChessBoardState.record;
    input r1 as u64.private;
    or r0.known_enemy_locations r1 into r2;
    cast r0.owner r0.white_pieces r0.black_pieces r2 r0.player_1 r0.player_2 r0.game_started into r3 as ChessBoardState.record;
    output r3 as ChessBoardState.record;
