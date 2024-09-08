import UIKit

final class TicTacToeViewModel {
    //MARK: Variables
    private(set) var condition: Bool = true {
        didSet {
            updateImageName()
        }
    }
    private(set) var imageName: String = "square.and.arrow.up.on.square"
    private(set) var board: [[String]] = [["", "", ""], ["", "", ""], ["", "", ""]]
    private(set) var currentPlayer: String = "0"
    private(set) var totalGameCounter: Int = 0
    private(set) var xWinCounter: Int = 0
    private(set) var oWinCounter: Int = 0
    
    //MARK: Selectors
    func toggleCondition() {
        condition.toggle()
    }
    
    private func updateImageName() {
        imageName = condition ? "square.and.arrow.up.on.square" : "square.and.arrow.up.on.square.fill"
    }
    
    func checkWhoWin() -> String? {
        let winCombinations = [
            [(0, 0), (0, 1), (0, 2)], // Первая строка
            [(1, 0), (1, 1), (1, 2)], // Вторая строка
            [(2, 0), (2, 1), (2, 2)], // Третья строка
            [(0, 0), (1, 0), (2, 0)], // Первый столбец
            [(0, 1), (1, 1), (2, 1)], // Второй столбец
            [(0, 2), (1, 2), (2, 2)], // Третий столбец
            [(0, 0), (1, 1), (2, 2)], // Диагональ слева направо
            [(0, 2), (1, 1), (2, 0)]  // Диагональ справа налево
        ]
        
        for combinator in winCombinations {
            let first = combinator[0]
            let second = combinator[1]
            let third = combinator[2]
            
            if board[first.0][first.1] != "", board[first.0][first.1] == board[second.0][second.1], board[first.0][first.1] == board[third.0][third.1] {
                return board[first.0][first.1]
            }
        }
        
        return nil
    }
    
    func isDraw() -> Bool {
        for row in board {
            if row.contains("") {
                return false
            }
        }
        return true
    }
    
    func makeMove(at row: Int, col: Int) -> Bool {
        if board[row][col] == "" {
            board[row][col] = currentPlayer
            currentPlayer = (currentPlayer == "O") ? "X" : "O"
            return true
        }
        return false
    }
    
    func handleResult() {
        let winner = checkWhoWin()
        if winner == "X" {
            xWinCounter += 1
        } else if winner == "O" {
            oWinCounter += 1
        } else if isDraw() {
            //nil
        }
        totalGameCounter += 1
    }
    
    func resetGame() {
        board = [["", "", ""], ["", "", ""], ["", "", ""]]
        currentPlayer = "O"
    }
}
