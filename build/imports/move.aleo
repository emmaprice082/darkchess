program move.aleo;

record Move:
    owner as address.private;
    from_coordinate as u64.private;
    to_coordinate as u64.private;
    player_1 as address.private;
    player_2 as address.private;
    prev_hit_or_miss as u64.private;
    piece_type as u8.private;

function create_move:
    input r0 as Move.record;
    input r1 as u64.private;
    input r2 as u64.private;
    input r3 as u64.private;
    input r4 as u8.private;
    is.eq r0.owner r0.player_1 into r5;
    ternary r5 r0.player_2 r0.player_1 into r6;
    cast r6 r1 r2 r0.player_1 r0.player_2 r3 r4 into r7 as Move.record;
    output r7 as Move.record;

function start_game:
    input r0 as address.private;
    cast r0 0u64 0u64 self.caller r0 0u64 0u8 into r1 as Move.record;
    output r1 as Move.record;
