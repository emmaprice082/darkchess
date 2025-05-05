import visibility.aleo; // Assuming you have the visibility module correctly imported

// verify/main.leo
program verify.aleo {

    function validate_pieces(pieces: u64, max_count: u64) -> bool {
        // Placeholder logic for validation
        return true;
    }

    function apply_fog_of_war(
        board: board.aleo/ChessBoardState,
        player: address,
    ) -> u64 {
        let is_white: bool = player == board.player_1;

        let visible: u64 = 0u64;
        let result: u64 = visible;

        // Manually unrolling the loop for all 64 squares (i from 0 to 63)
        result = apply_visibility(result, board, is_white, 0u8);
        result = apply_visibility(result, board, is_white, 1u8);
        result = apply_visibility(result, board, is_white, 2u8);
        result = apply_visibility(result, board, is_white, 3u8);
        result = apply_visibility(result, board, is_white, 4u8);
        result = apply_visibility(result, board, is_white, 5u8);
        result = apply_visibility(result, board, is_white, 6u8);
        result = apply_visibility(result, board, is_white, 7u8);
        result = apply_visibility(result, board, is_white, 8u8);
        result = apply_visibility(result, board, is_white, 9u8);

        result = apply_visibility(result, board, is_white, 10u8);
        result = apply_visibility(result, board, is_white, 11u8);
        result = apply_visibility(result, board, is_white, 12u8);
        result = apply_visibility(result, board, is_white, 13u8);
        result = apply_visibility(result, board, is_white, 14u8);
        result = apply_visibility(result, board, is_white, 15u8);
        result = apply_visibility(result, board, is_white, 16u8);
        result = apply_visibility(result, board, is_white, 17u8);
        result = apply_visibility(result, board, is_white, 18u8);
        result = apply_visibility(result, board, is_white, 19u8);

        result = apply_visibility(result, board, is_white, 20u8);
        result = apply_visibility(result, board, is_white, 21u8);
        result = apply_visibility(result, board, is_white, 22u8);
        result = apply_visibility(result, board, is_white, 23u8);
        result = apply_visibility(result, board, is_white, 24u8);
        result = apply_visibility(result, board, is_white, 25u8);
        result = apply_visibility(result, board, is_white, 26u8);
        result = apply_visibility(result, board, is_white, 27u8);
        result = apply_visibility(result, board, is_white, 28u8);
        result = apply_visibility(result, board, is_white, 29u8);

        result = apply_visibility(result, board, is_white, 30u8);
        result = apply_visibility(result, board, is_white, 31u8);
        result = apply_visibility(result, board, is_white, 32u8);
        result = apply_visibility(result, board, is_white, 33u8);
        result = apply_visibility(result, board, is_white, 34u8);
        result = apply_visibility(result, board, is_white, 35u8);
        result = apply_visibility(result, board, is_white, 36u8);
        result = apply_visibility(result, board, is_white, 37u8);
        result = apply_visibility(result, board, is_white, 38u8);
        result = apply_visibility(result, board, is_white, 39u8);

        result = apply_visibility(result, board, is_white, 40u8);
        result = apply_visibility(result, board, is_white, 41u8);
        result = apply_visibility(result, board, is_white, 42u8);
        result = apply_visibility(result, board, is_white, 43u8);
        result = apply_visibility(result, board, is_white, 44u8);
        result = apply_visibility(result, board, is_white, 45u8);
        result = apply_visibility(result, board, is_white, 46u8);
        result = apply_visibility(result, board, is_white, 47u8);
        result = apply_visibility(result, board, is_white, 48u8);
        result = apply_visibility(result, board, is_white, 49u8);

        result = apply_visibility(result, board, is_white, 50u8);
        result = apply_visibility(result, board, is_white, 51u8);
        result = apply_visibility(result, board, is_white, 52u8);
        result = apply_visibility(result, board, is_white, 53u8);
        result = apply_visibility(result, board, is_white, 54u8);
        result = apply_visibility(result, board, is_white, 55u8);
        result = apply_visibility(result, board, is_white, 56u8);
        result = apply_visibility(result, board, is_white, 57u8);
        result = apply_visibility(result, board, is_white, 58u8);
        result = apply_visibility(result, board, is_white, 59u8);

        result = apply_visibility(result, board, is_white, 60u8);
        result = apply_visibility(result, board, is_white, 61u8);
        result = apply_visibility(result, board, is_white, 62u8);
        result = apply_visibility(result, board, is_white, 63u8);

        return result;
    }

    function apply_visibility(
        current: u64,
        board: board.aleo/ChessBoardState,
        is_white: bool,
        i: u8
    ) -> u64 {
        let bit: u64 = 1u64 << i;

        let has_piece: bool = false; // Initializing with a default value (e.g., false)

        if is_white {
            has_piece = (board.white_pieces & bit) != 0u64;
        } else {
            has_piece = (board.black_pieces & bit) != 0u64;
        }

        if has_piece {
            let piece: u8 = board.piece_types[i as u32]; // Leo supports u32 indexing

            let vision: u64 = 0u64; // Initialize with a default value

            if piece == 1u8 {
                // Knight visibility
                vision = visibility.aleo/knight_vision(i);
            } else if piece == 2u8 {
                // Bishop (diagonal) visibility
                vision = visibility.aleo/diagonal_vision(i);
            } else if piece == 3u8 {
                // Rook (straight line) visibility
                vision = visibility.aleo/straight_vision(i);
            } else if piece == 4u8 {
                // Queen (combines bishop and rook visibility)
                vision = visibility.aleo/diagonal_vision(i) | visibility.aleo/straight_vision(i);
            } else if piece == 5u8 {
                // King visibility (1-square range in all directions)
                vision = visibility.aleo/king_vision(i);
            } else {
                // No visibility for other pieces (empty or unhandled piece type)
                vision = 0u64;
            }

            // Return updated visibility with the current piece's visibility
            return current | bit | vision;
        }

        return current; // Return unchanged if no piece is present
    }

    function valid_move(
        board: board.aleo/ChessBoardState,
        mv: move.aleo/Move,
    ) -> bool {
        let visible: u64 = apply_fog_of_war(board, mv.owner);

        return (visible & mv.incoming_fire_coordinate) != 0u64;
    }

    // TODO: might need to figure out how to set white_king_position & black_king_position
    function check_game_over(board: board.aleo/ChessBoardState) -> bool {
        // Check if the white king is captured (bit for the white king is not set in the white pieces bitboard)
        let white_king_alive: bool = (board.white_pieces & (1u64 << white_king_position)) != 0u64;

        // Check if the black king is captured (bit for the black king is not set in the black pieces bitboard)
        let black_king_alive: bool = (board.black_pieces & (1u64 << black_king_position)) != 0u64;

        // Game ends when one of the kings is captured
        return !(white_king_alive && black_king_alive);
    }

}

