// move/main.leo
program move.aleo {
    record Move {
        owner: address,               // The player making the move
        from_coordinate: u64,         // Starting position of the piece
        to_coordinate: u64,           // Destination of the move
        player_1: address,            // Player 1 address
        player_2: address,            // Player 2 address
        prev_hit_or_miss: u64,        // Track whether the previous move was a hit or miss
        piece_type: u8,               // Type of piece being moved (e.g., king, queen, rook, etc.)
    }

    transition create_move(
        move_record: Move, 
        from_coordinate: u64, 
        to_coordinate: u64,
        prev_hit_or_miss: u64,
        piece_type: u8,
    ) -> Move {
        let opponent: address = move_record.player_1;
        if move_record.owner == move_record.player_1 {
            opponent = move_record.player_2;
        }

        return Move {
            owner: opponent,
            from_coordinate,
            to_coordinate,
            player_1: move_record.player_1,
            player_2: move_record.player_2,
            prev_hit_or_miss,
            piece_type,
        };
    }

    transition start_game(player_2: address) -> Move {
        return Move {
            owner: player_2,
            from_coordinate: 0u64,
            to_coordinate: 0u64,
            player_1: self.caller,
            player_2,
            prev_hit_or_miss: 0u64,
            piece_type: 0u8,  // Initialize with no piece type
        };
    }
}
