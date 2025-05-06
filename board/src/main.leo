import move.aleo;

// chessboard/main.leo
program board.aleo {
    // Modify the ChessBoardState record to include piece_types
    record ChessBoardState {
        owner: address,
        white_pieces: u64,
        black_pieces: u64,
        known_enemy_locations: u64,
        player_1: address,
        player_2: address,
        game_started: bool,
        piece_types: [u8; 32],  // Add piece_types as an array of u8 (for 64 squares)
    }

    // Transition to create a new game state with piece_types
    transition new_game_state(
        white_pieces: u64,
        black_pieces: u64,
        player_1: address,
        player_2: address,
        piece_types: [u8; 32],  // Accept piece_types as a parameter
    ) -> ChessBoardState {
        return ChessBoardState {
            owner: player_1,
            white_pieces,
            black_pieces,
            known_enemy_locations: 0u64,  // Initially no known enemy pieces
            player_1,
            player_2,
            game_started: true,
            piece_types,  // Initialize piece_types
        };
    }

    transition update_board(
        board: ChessBoardState,
        mv: move.aleo/Move,
    ) -> ChessBoardState {
        // Need to make sure the move is valid. Only one bit of the `from_coordinate` and `to_coordinate` should be flipped.
        let flip_bit: u64 = mv.to_coordinate - mv.from_coordinate;
        let check_move: u64 = mv.from_coordinate & flip_bit;
        assert_eq(check_move, 0u64);  // Ensure no overlap between the starting and ending positions.

        // Need to make sure the move does not overlap with existing pieces.
        let check_white: u64 = mv.to_coordinate & board.white_pieces;
        let check_black: u64 = mv.to_coordinate & board.black_pieces;
        assert_eq(check_white, 0u64);  // Ensure no white piece is already at the destination.
        assert_eq(check_black, 0u64);  // Ensure no black piece is already at the destination.

        // Update the pieces on the board after the move.
        let new_white_pieces: u64 = board.white_pieces & !mv.from_coordinate;  // Remove piece from the old location
        let new_black_pieces: u64 = board.black_pieces & !mv.from_coordinate;  // Remove piece from the old location

        // Determine if the move is for a white or black piece and update accordingly.
        let updated_white_pieces: u64 = new_white_pieces;
        let updated_black_pieces: u64 = new_black_pieces;

        // Update white pieces if the piece type is 1u8 (assuming 1u8 for white pieces).
        if mv.piece_type == 1u8 {
            updated_white_pieces = new_white_pieces | mv.to_coordinate;
        }

        // Update black pieces if the piece type is 2u8 (assuming 2u8 for black pieces).
        if mv.piece_type == 2u8 {
            updated_black_pieces = new_black_pieces | mv.to_coordinate;
        }

        // Update the known enemy locations.
        let updated_known: u64 = board.known_enemy_locations | mv.from_coordinate | mv.to_coordinate;

        // Now, return the updated board state.
        return ChessBoardState {
            owner: board.owner,
            white_pieces: updated_white_pieces,
            black_pieces: updated_black_pieces,
            known_enemy_locations: updated_known,
            player_1: board.player_1,
            player_2: board.player_2,
            game_started: board.game_started,
            piece_types: board.piece_types,  // If you're updating piece types, you can do that here
        };
    }

    // Transition to reveal pieces after a move, based on visibility
    transition reveal_pieces(
        board: ChessBoardState,
        revealed: u64,
    ) -> ChessBoardState {
        let updated_known: u64 = board.known_enemy_locations | revealed;

        return ChessBoardState {
            owner: board.owner,
            white_pieces: board.white_pieces,
            black_pieces: board.black_pieces,
            known_enemy_locations: updated_known,
            player_1: board.player_1,
            player_2: board.player_2,
            game_started: board.game_started,
            piece_types: board.piece_types,  // No change to piece_types in this case
        };
    }
}

