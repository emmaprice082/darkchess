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
        let is_white: bool;
        if player == board.player_1 {
            is_white = true;
        } else {
            is_white = false;
        }

        let visible: u64 = 0u64;
        let mut result: u64 = visible;

        // Loop through all 64 squares and apply visibility based on piece type
        for i in 0u8..64u8 {
            result = apply_visibility(result, board, is_white, i);
        }

        return result;
    }

    function apply_visibility(
        current: u64,
        board: board.aleo/ChessBoardState,
        is_white: bool,
        i: u8
    ) -> u64 {
        let bit: u64 = 1u64 << i;

        let has_piece: bool;
        if is_white {
            has_piece = (board.white_pieces & bit) != 0u64;
        } else {
            has_piece = (board.black_pieces & bit) != 0u64;
        }

        if has_piece {
            let piece: u8 = board.piece_types[i as u32]; // Leo supports u32 indexing

            let vision: u64;
            if piece == 1u8 {
                // Knight visibility
                vision = visibility_lib.aleo::knight_vision(i);
            } else if piece == 2u8 {
                // Bishop (diagonal) visibility
                vision = visibility_lib.aleo::diagonal_vision(i);
            } else if piece == 3u8 {
                // Rook (straight line) visibility
                vision = visibility_lib.aleo::straight_vision(i);
            } else if piece == 4u8 {
                // Queen (combines bishop and rook visibility)
                vision = visibility_lib.aleo::diagonal_vision(i) | visibility_lib.aleo::straight_vision(i);
            } else if piece == 5u8 {
                // King visibility (1-square range in all directions)
                vision = visibility_lib.aleo::king_vision(i);
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
        let visible = apply_fog_of_war(board, mv.owner);
        return (visible & mv.incoming_fire_coordinate) != 0u64;
    }

    function check_game_over(
        board: board.aleo/ChessBoardState,
    ) -> bool {
        let mut white_king_alive: bool = false;
        let mut black_king_alive: bool = false;

        for i in 0u8..64u8 {
            let piece_type = board.piece_types[i as usize];
            let bit = 1u64 << i;

            if piece_type == 5u8 {
                if (board.white_pieces & bit) != 0u64 {
                    white_king_alive = true;
                } else if (board.black_pieces & bit) != 0u64 {
                    black_king_alive = true;
                }
            }
        }

        // Game ends when one of the kings is captured
        return !(white_king_alive && black_king_alive);
    }

}
