program board.aleo;

// Represents the private board state of a player in fog of war chess.
record board_state:
    owner as address.private;                 // Owner of this board
    own_pieces as [u64; 2].private;           // Encoded piece type + position (8 bits × 8 per u64 = 16 pieces)
    known_enemy_locations as u64.private;     // Bitmask (1 bit per square)
    player_1 as address.private;
    player_2 as address.private;
    game_started as boolean.private;

// Initialize a new game board for a player.
function new_board_state:
    input own_pieces_input as [u64; 2].private;
    input opponent_address as address.private;

    cast self.caller own_pieces_input 0u64 self.caller opponent_address false into board as board_state.record;

    output board as board_state.record;

// Update known enemy locations with new revealed tiles (e.g. a piece was seen or captured).
function update_known_enemy_locations:
    input board as board_state.record;
    input newly_revealed_locations as u64.private;

    or board.known_enemy_locations newly_revealed_locations into updated_known;

    cast board.owner board.own_pieces updated_known board.player_1 board.player_2 board.game_started into updated_board as board_state.record;

    output updated_board as board_state.record;

// Start the game by flipping the game_started flag to true (optional helper).
function start_game:
    input board as board_state.record;

    cast board.owner board.own_pieces board.known_enemy_locations board.player_1 board.player_2 true into started_board as board_state.record;

    output started_board as board_state.record;

// TODO:
// make_move: Validate and apply a move based on own_pieces encoding.

// reveal_if_capture: If move results in capture, update known_enemy_locations.

// encode_piece(piece_type: u4, position: u6): u8

// decode_piece(u8): (piece_type, position)

