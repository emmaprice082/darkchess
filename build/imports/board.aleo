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
    piece_types as [u8; 32u32].private;

function new_game_state:
    input r0 as u64.private;
    input r1 as u64.private;
    input r2 as address.private;
    input r3 as address.private;
    input r4 as [u8; 32u32].private;
    cast r2 r0 r1 0u64 r2 r3 true r4 into r5 as ChessBoardState.record;
    output r5 as ChessBoardState.record;

function update_board:
    input r0 as ChessBoardState.record;
    input r1 as move.aleo/Move.record;
    sub r1.to_coordinate r1.from_coordinate into r2;
    and r1.from_coordinate r2 into r3;
    assert.eq r3 0u64;
    and r1.to_coordinate r0.white_pieces into r4;
    and r1.to_coordinate r0.black_pieces into r5;
    assert.eq r4 0u64;
    assert.eq r5 0u64;
    not r1.from_coordinate into r6;
    and r0.white_pieces r6 into r7;
    not r1.from_coordinate into r8;
    and r0.black_pieces r8 into r9;
    is.eq r1.piece_type 1u8 into r10;
    or r7 r1.to_coordinate into r11;
    ternary r10 r11 r7 into r12;
    is.eq r1.piece_type 2u8 into r13;
    or r9 r1.to_coordinate into r14;
    ternary r13 r14 r9 into r15;
    or r0.known_enemy_locations r1.from_coordinate into r16;
    or r16 r1.to_coordinate into r17;
    cast r0.owner r12 r15 r17 r0.player_1 r0.player_2 r0.game_started r0.piece_types into r18 as ChessBoardState.record;
    output r18 as ChessBoardState.record;

function reveal_pieces:
    input r0 as ChessBoardState.record;
    input r1 as u64.private;
    or r0.known_enemy_locations r1 into r2;
    cast r0.owner r0.white_pieces r0.black_pieces r2 r0.player_1 r0.player_2 r0.game_started r0.piece_types into r3 as ChessBoardState.record;
    output r3 as ChessBoardState.record;
