// verify/main.leo
program verify.aleo {
    function get_visible_squares(
        owner: address,
        player: address,
        own_pieces_0: u64,
        i: u8,  // Taking i as a parameter
    ) -> u64 {
        let visibility: u64 = 0u64;  // Initialize visibility without mut
        if (owner != player) {
            return 0u64;
        }

        // Explicitly casting the number 8 to u8
        let byte: u8 = ((own_pieces_0 >> (i * 8u8)) & 0xFFu64) as u8;  // Ensure casting correctly
        if byte == 0u8 {
            return visibility;
        }

        // Explicitly casting 5 as u8 to avoid implicit type issues
        let piece_type: u8 = (byte >> 5u8) & 0x07u8;  // bits 7–5
        let square: u8 = byte & 0x1Fu8;  // bits 4–0

        let square_mask: u64 = 1u64 << square;

        // Always see the square you're on
        visibility = visibility | square_mask;

        // Handle piece types with match statement
        // Assuming piece_type is a variable of type u8
        if piece_type == 1u8 {  // Pawn: sees forward (simplified to +8)
            if square < 56u8 {
                visibility = visibility | (1u64 << (square + 8u8));  // Explicitly using 8u8
            }
        } else if piece_type == 2u8 {  // Knight visibility
            visibility = visibility | knight_vision(square);
        } else if piece_type == 3u8 {  // Bishop
            visibility = visibility | diagonal_vision(square);
        } else if piece_type == 4u8 {  // Rook
            visibility = visibility | straight_vision(square);
        } else if piece_type == 5u8 {  // Queen
            visibility = visibility | straight_vision(square) | diagonal_vision(square);
        } else if piece_type == 6u8 {  // King
            visibility = visibility | king_vision(square);
        } else {  // Default case, should handle all other cases
            // No action is needed, you can leave it empty or put logic here
        }

        // Check if we have processed all 8 pieces, and if not, recurse to the next index
        if i < 7u8 {
            visibility = visibility | get_visible_squares(owner, player, own_pieces_0, i + 1u8);
        }

        return visibility;
    }

    function knight_vision(square: u8) -> u64 {
        let mask: u64 = 0u64;
        let rank: i8 = (square / 8u8) as i8;
        let file: i8 = (square % 8u8) as i8;

        // Manually unrolling deltas
        let dr1: i8 = -2; let df1: i8 = -1;
        let dr2: i8 = -2; let df2: i8 = 1;
        let dr3: i8 = -1; let df3: i8 = -2;
        let dr4: i8 = -1; let df4: i8 = 2;
        let dr5: i8 = 1; let df5: i8 = -2;
        let dr6: i8 = 1; let df6: i8 = 2;
        let dr7: i8 = 2; let df7: i8 = -1;
        let dr8: i8 = 2; let df8: i8 = 1;

        // Checking each of the 8 knight moves
        let r1 = rank + dr1;
        let f1 = file + df1;
        if r1 >= 0 && r1 < 8 && f1 >= 0 && f1 < 8 {
            let target = (r1 * 8 + f1) as u8;
            mask = mask | (1u64 << target);
        }

        let r2 = rank + dr2;
        let f2 = file + df2;
        if r2 >= 0 && r2 < 8 && f2 >= 0 && f2 < 8 {
            let target = (r2 * 8 + f2) as u8;
            mask = mask | (1u64 << target);
        }

        let r3 = rank + dr3;
        let f3 = file + df3;
        if r3 >= 0 && r3 < 8 && f3 >= 0 && f3 < 8 {
            let target = (r3 * 8 + f3) as u8;
            mask = mask | (1u64 << target);
        }

        let r4 = rank + dr4;
        let f4 = file + df4;
        if r4 >= 0 && r4 < 8 && f4 >= 0 && f4 < 8 {
            let target = (r4 * 8 + f4) as u8;
            mask = mask | (1u64 << target);
        }

        let r5 = rank + dr5;
        let f5 = file + df5;
        if r5 >= 0 && r5 < 8 && f5 >= 0 && f5 < 8 {
            let target = (r5 * 8 + f5) as u8;
            mask = mask | (1u64 << target);
        }

        let r6 = rank + dr6;
        let f6 = file + df6;
        if r6 >= 0 && r6 < 8 && f6 >= 0 && f6 < 8 {
            let target = (r6 * 8 + f6) as u8;
            mask = mask | (1u64 << target);
        }

        let r7 = rank + dr7;
        let f7 = file + df7;
        if r7 >= 0 && r7 < 8 && f7 >= 0 && f7 < 8 {
            let target = (r7 * 8 + f7) as u8;
            mask = mask | (1u64 << target);
        }

        let r8 = rank + dr8;
        let f8 = file + df8;
        if r8 >= 0 && r8 < 8 && f8 >= 0 && f8 < 8 {
            let target = (r8 * 8 + f8) as u8;
            mask = mask | (1u64 << target);
        }

        return mask;
    }

    function king_vision(square: u8) -> u64 {
        let mask: u64 = 0u64;
        let rank: i8 = (square / 8u8) as i8;
        let file: i8 = (square % 8u8) as i8;

        // Define possible surrounding squares for the King
        let dr1: i8 = -1; let df1: i8 = -1;
        let dr2: i8 = -1; let df2: i8 = 0;
        let dr3: i8 = -1; let df3: i8 = 1;
        let dr4: i8 = 0;  let df4: i8 = -1;
        let dr5: i8 = 0;  let df5: i8 = 1;
        let dr6: i8 = 1;  let df6: i8 = -1;
        let dr7: i8 = 1;  let df7: i8 = 0;
        let dr8: i8 = 1;  let df8: i8 = 1;

        // Check each of the 8 surrounding squares and update visibility mask
        mask = mask | check_square(rank + dr1, file + df1);
        mask = mask | check_square(rank + dr2, file + df2);
        mask = mask | check_square(rank + dr3, file + df3);
        mask = mask | check_square(rank + dr4, file + df4);
        mask = mask | check_square(rank + dr5, file + df5);
        mask = mask | check_square(rank + dr6, file + df6);
        mask = mask | check_square(rank + dr7, file + df7);
        mask = mask | check_square(rank + dr8, file + df8);

        return mask;
    }

    // Helper function to check whether the square is on the board and return its bitmask
    function check_square(rank: i8, file: i8) -> u64 {
        if rank >= 0 && rank < 8 && file >= 0 && file < 8 {
            let target = (rank * 8 + file) as u8;
            return 1u64 << target;
        }
        return 0u64;
    }

    function diagonal_vision(square: u8) -> u64 {
        let mask: u64 = 0u64;
        let rank: i8 = (square / 8u8) as i8;
        let file: i8 = (square % 8u8) as i8;

        // Define the directions for NE, NW, SE, SW as individual variables
        let dr1: i8 = 1; let df1: i8 = 1;    // NE
        let dr2: i8 = 1; let df2: i8 = -1;   // NW
        let dr3: i8 = -1; let df3: i8 = 1;   // SE
        let dr4: i8 = -1; let df4: i8 = -1;  // SW

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
        let mut r: i8 = rank + dr;
        let mut f: i8 = file + df;

        // Traverse in the direction and accumulate the visibility mask
        while r >= 0 && r < 8 && f >= 0 && f < 8 {
            let target = (r * 8 + f) as u8;
            mask = mask | (1u64 << target);

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

        // N, S, E, W directions
        let directions = [
            (1, 0),  // South
            (-1, 0), // North
            (0, 1),  // East
            (0, -1), // West
        ];

        // Check each direction
        for direction in directions {
            let (dr, df) = direction;
            let mut r = rank + dr;
            let mut f = file + df;
            while r >= 0 && r < 8 && f >= 0 && f < 8 {
                let target = (r * 8 + f) as u8;
                mask = mask | (1u64 << target);
                r = r + dr;
                f = f + df;
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

        let visible: u64 = 0u64;
        let result: u64 = visible;

        // Manually unrolling the loop for all 64 squares (i from 0 to 63)
        result = get_visible_squares(board.owner, player, board.own_pieces_0, 0u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 1u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 2u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 3u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 4u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 5u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 6u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 7u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 8u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 9u8);

        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 10u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 11u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 12u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 13u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 14u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 15u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 16u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 17u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 18u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 19u8);

        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 20u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 21u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 22u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 23u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 24u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 25u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 26u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 27u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 28u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 29u8);

        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 30u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 31u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 32u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 33u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 34u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 35u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 36u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 37u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 38u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 39u8);

        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 40u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 41u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 42u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 43u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 44u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 45u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 46u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 47u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 48u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 49u8);

        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 50u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 51u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 52u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 53u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 54u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 55u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 56u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 57u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 58u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 59u8);

        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 60u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 61u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 62u8);
        result = result | get_visible_squares(board.owner, player, board.own_pieces_0, 63u8);

        return result;
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

