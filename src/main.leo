import board.aleo;
import move.aleo;
import verify.aleo;
import visibility.aleo;

program darkchess.aleo {

    transition initialize_game(
        white_pieces: u64,
        black_pieces: u64,
        player_1: address,
        player_2: address,
    ) -> board.aleo/ChessBoardState {
        let valid_white: bool = verify.aleo/validate_pieces(white_pieces, 16u64);
        assert(valid_white);

        let valid_black: bool = verify.aleo/validate_pieces(black_pieces, 16u64);
        assert(valid_black);

        let state: board.aleo/ChessBoardState = board.aleo/new_game_state(
            white_pieces,
            black_pieces,
            player_1,
            player_2,
        );

        return state;
    }

    transition make_move(
        board: board.aleo/ChessBoardState,
        mv: move.aleo/Move,
    ) -> (board.aleo/ChessBoardState, move.aleo/Move) {
        // Validate the move using the visibility-based `valid_move` function
        assert(verify.aleo/valid_move(board, mv));

        // Update the board state after the move
        let updated_board: board.aleo/ChessBoardState = board.aleo/update_board(board, mv);

        // Apply the fog of war after the move, making sure pieces are only visible according to the rules
        let revealed: u64 = verify.aleo/apply_fog_of_war(updated_board, mv.owner);

        // Reveal pieces based on the visibility layer
        let final_board: board.aleo/ChessBoardState = board.aleo/reveal_pieces(updated_board, revealed);

        return (final_board, mv);
    }

    transition end_game(
        board: board.aleo/ChessBoardState,
    ) -> bool {
        // Check if the game is over (either white or black king is captured)
        return verify.aleo/check_game_over(board);
    }
}
