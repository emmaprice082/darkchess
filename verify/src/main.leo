// verify/main.leo
program verify.aleo {

    function knight_vision(square: u8) -> u64 {
        let mask: u64 = 0u64;

        let rank: i8 = (square / 8u8) as i8;
        let file: i8 = (square % 8u8) as i8;

        // Use subtraction to simulate negative values
        let dr: [i8; 8] = [0i8 - 2i8, 0i8 - 2i8, 0i8 - 1i8, 0i8 - 1i8, 1i8, 1i8, 2i8, 2i8];
        let df: [i8; 8] = [0i8 - 1i8, 1i8, 0i8 - 2i8, 2i8, 0i8 - 2i8, 2i8, 0i8 - 1i8, 1i8];

        for i: u8 in 0u8..8u8 {
            let index: u32 = i as u32;
            let new_rank: i8 = rank + dr[index];
            let new_file: i8 = file + df[index];

            if new_rank >= 0i8 && new_rank < 8i8 && new_file >= 0i8 && new_file < 8i8 {
                let target: u8 = (new_rank * 8i8 + new_file) as u8;
                mask = mask | (1u64 << target);
            }
        }

        return mask;
    }

    // Helper function to check whether the square is on the board and return its bitmask
    function check_square(rank: i8, file: i8) -> u64 {
        if rank >= 0i8 && rank < 8i8 && file >= 0i8 && file < 8i8 {
            let target: u8 = (rank * 8i8 + file) as u8;
            return 1u64 << target;
        }
        return 0u64;
    }

    function diagonal_vision(square: u8) -> u64 {
        let mask: u64 = 0u64;
        let rank: i8 = (square / 8u8) as i8;
        let file: i8 = (square % 8u8) as i8;

        // Define the directions for NE, NW, SE, SW as individual variables
        let dr1: i8 = 1i8;
        let df1: i8 = 1i8;    // NE

        let dr2: i8 = 1i8;
        let df2: i8 = -1i8;   // NW

        let dr3: i8 = -1i8;
        let df3: i8 = 1i8;    // SE

        let dr4: i8 = -1i8;
        let df4: i8 = -1i8;   // SW

        // Check each direction (NE, NW, SE, SW)
        mask = mask | check_direction(rank, file, dr1, df1);
        mask = mask | check_direction(rank, file, dr2, df2);
        mask = mask | check_direction(rank, file, dr3, df3);
        mask = mask | check_direction(rank, file, dr4, df4);

        return mask;
    }

    // Helper function to check visibility in a given direction
    function check_direction(rank: i8, file: i8, dr: i8, df: i8) -> u64 {
        let mask: u64 = 0u64;
        let r: i8 = rank + dr;
        let f: i8 = file + df;

        // Traverse in the direction and accumulate the visibility mask
        for i: u8 in 0u8..8u8 {  // Correct loop declaration with 'i: u8'
            if r >= 0i8 && r < 8i8 && f >= 0i8 && f < 8i8 {
                let target: u8 = (r * 8i8 + f) as u8;
                mask = mask | (1u64 << target);
            }

            // Move to the next square in the direction
            r = r + dr;
            f = f + df;
        }

        return mask;
    }

    function straight_vision(square: u8) -> u64 {
        let mask: u64 = 0u64;
        let rank: i8 = (square / 8u8) as i8;
        let file: i8 = (square % 8u8) as i8;

        let drs: [i8; 4] = [1i8, -1i8, 0i8, 0i8];   // S, N, E, W
        let dfs: [i8; 4] = [0i8, 0i8, 1i8, -1i8];   // S, N, E, W

        for i: u8 in 0u8..4u8 {  // Loop over the 4 directions (S, N, E, W)
            let r: i8 = rank + drs[i];
            let f: i8 = file + dfs[i];

            // Define a range to iterate over the number of steps we can take in the direction
            for j: u8 in 0u8..8u8 {  // Maximum 8 squares in any direction
                if r >= 0i8 && r < 8i8 && f >= 0i8 && f < 8i8 {
                    let target: u8 = (r * 8i8 + f) as u8;
                    mask = mask | (1u64 << target);
                }

                r = r + drs[i];
                f = f + dfs[i];
            }
        }

        return mask;
    }

    function validate_pieces(pieces: u64, max_count: u64) -> bool {
        // Placeholder logic for validation
        return true;
    }

    function apply_fog_of_war(
        board: board.aleo/ChessBoardState,
        player: address,
    ) -> u64 {
        let is_white: bool = player == board.player_1;
        let visibility: u64 = 0u64;

        // Iterate over all 64 squares
        for i: u8 in 0u8..64u8 {
            visibility = apply_visibility(visibility, board, is_white, i);
        }

        return visibility;
    }


    function apply_visibility(
        current: u64,
        board: board.aleo/ChessBoardState,
        is_white: bool,
        i: u8
    ) -> u64 {
        let bit: u64 = 1u64 << i;

        let has_piece: bool = false; // Default value

        // Check if the player has a piece at position i
        if is_white {
            has_piece = (board.white_pieces & bit) != 0u64;
        } else {
            has_piece = (board.black_pieces & bit) != 0u64;
        }

        if has_piece {
            let piece: u8 = board.piece_types[i as u32]; // Leo supports u32 indexing

            let vision: u64 = 0u64; // Default value

            // Set piece visibility based on the piece type
            if piece == 1u8 {
                // Knight visibility
                vision = knight_vision(i);
            } else if piece == 2u8 {
                // Bishop (diagonal) visibility
                vision = diagonal_vision(i);
            } else if piece == 3u8 {
                // Rook (straight line) visibility
                vision = straight_vision(i);
            } else if piece == 4u8 {
                // Queen (combines bishop and rook visibility)
                vision = diagonal_vision(i) | straight_vision(i);
            } else if piece == 5u8 {
                // King visibility (1-square range in all directions)
                vision = king_vision(i);
            } else {
                // No visibility for other pieces (empty or unhandled piece type)
                vision = 0u64;
            }

            // Return updated visibility with the current piece's visibility
            return current | bit | vision;
        }

        return current; // Return unchanged if no piece is present
    }

    transition valid_move(
        board: board.aleo/ChessBoardState,
        mv: move.aleo/Move,
    ) -> bool {
        let visible: u64 = apply_fog_of_war(board, mv.owner);

        // Compute bitmask for the from_coordinate (source square)
        let from_mask: u64 = 1u64 << mv.from_coordinate;

        // The move is valid if the source square is visible
        return (visible & from_mask) != 0u64;
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

