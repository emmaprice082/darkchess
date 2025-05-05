import move.aleo;

// chessboard/main.leo
program board.aleo {
    record ChessBoardState {
        owner: address,
        white_pieces: u64,
        black_pieces: u64,
        known_enemy_locations: u64,
        player_1: address,
        player_2: address,
        game_started: bool,
    }

    // Ensure `new_game_state` is a valid transition.
    transition new_game_state(
        white_pieces: u64,
        black_pieces: u64,
        player_1: address,
        player_2: address,
    ) -> ChessBoardState {
        return ChessBoardState {
            owner: player_1,
            white_pieces,
            black_pieces,
            known_enemy_locations: 0u64,  // Initially no known enemy pieces.
            player_1,
            player_2,
            game_started: true,
        };
    }

    // Transition to update the board after a move.
    transition update_board(
        board: ChessBoardState,
        mv: move.aleo/Move,
    ) -> ChessBoardState {
        let updated_known: u64 = board.known_enemy_locations
            | mv.from_coordinate
            | mv.to_coordinate;


        return ChessBoardState {
            owner: board.owner,
            white_pieces: board.white_pieces,
            black_pieces: board.black_pieces,
            known_enemy_locations: updated_known,
            player_1: board.player_1,
            player_2: board.player_2,
            game_started: board.game_started,
        };
    }

    // Transition to reveal pieces after a move, based on visibility.
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
        };
    }
}
