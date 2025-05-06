import board.aleo;

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

    // Helper function to check visibility in a given direction
    inline check_direction(rank: i8, file: i8, dr: i8, df: i8) -> u64 {
        let mask: u64 = 0u64;
        let r: i8 = rank + dr;
        let f: i8 = file + df;

        // Traverse in the direction and accumulate the visibility mask
        for i: u8 in 0u8..8u8 {  // Correct loop declaration with 'i: u8'
            if r >= 0i8 && r < 8i8 && f >= 0i8 && f < 8i8 {
                let target: u8 = (r * 8i8 + f) as u8;
                let target_mask: u64 = 1u64 << target;  // Create a mask for the target square
                
                // Instead of using bitwise OR, accumulate the mask using addition
                mask = mask + target_mask;
            }

            // Move to the next square in the direction
            r = r + dr;
            f = f + df;
        }

        return mask;
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
        let direction_mask: u64 = check_direction(rank, file, dr1, df1);

        if direction_mask != 0u64 {
            mask = mask + direction_mask;  // Adding the mask from this direction
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

    function king_vision(square: u8) -> u64 {
        let mask: u64 = 0u64;

        let rank: i8 = (square / 8u8) as i8;
        let file: i8 = (square % 8u8) as i8;

        // Define the directions for N, S, E, W, NE, NW, SE, SW
        let dr: [i8; 8] = [-1i8, 1i8, 0i8, 0i8, -1i8, -1i8, 1i8, 1i8];  // N, S, E, W, NE, NW, SE, SW
        let df: [i8; 8] = [0i8, 0i8, 1i8, -1i8, 1i8, -1i8, 1i8, -1i8];  // N, S, E, W, NE, NW, SE, SW

        // Check each direction for valid king moves
        for i: u8 in 0u8..8u8 {
            let new_rank: i8 = rank + dr[i];
            let new_file: i8 = file + df[i];

            // Ensure the new position is within the board bounds (0 to 7)
            if new_rank >= 0i8 && new_rank < 8i8 && new_file >= 0i8 && new_file < 8i8 {
                let target: u8 = (new_rank * 8i8 + new_file) as u8;
                mask = mask | (1u64 << target);  // Set the bit corresponding to the valid square
            }
        }

        return mask;
    }

    transition apply_visibility(
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

    // function track_king_status(board: board.aleo/ChessBoardState) -> (bool, bool) {
    //     // Track if the white king is alive
    //     let white_king_alive: bool = (board.white_pieces & (1u64 << white_king_position)) != 0u64;

    //     // Track if the black king is alive
    //     let black_king_alive: bool = (board.black_pieces & (1u64 << black_king_position)) != 0u64;

    //     // Return the status of both kings
    //     return (white_king_alive, black_king_alive);
    // }

    // TODO: might need to figure out how to set white_king_position & black_king_position
    // function check_game_over(board: board.aleo/ChessBoardState, move: move.aleo/Move) -> bool {
    //     // Define the piece_type for the king (assuming 1 represents the king)
    //     let king_piece_type: u8 = 1u8;

    //     // Check if the white king is captured by checking if the bit for the white king is not set
    //     // in the white_pieces bitboard. We assume from_coordinate corresponds to a piece that has
    //     // been moved and captured.
    //     let white_king_alive: bool = (board.white_pieces & (1u64 << move.from_coordinate)) != 0u64;
    //     if move.piece_type == king_piece_type && !white_king_alive {
    //         return true;  // White king captured, game over
    //     }

    //     // Check if the black king is captured
    //     let black_king_alive: bool = (board.black_pieces & (1u64 << move.from_coordinate)) != 0u64;
    //     if move.piece_type == king_piece_type && !black_king_alive {
    //         return true;  // Black king captured, game over
    //     }

    //     // If neither king is captured, the game continues
    //     return false;
    // }

}

