import SwiftUI

enum Player {
    case human
    case computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    let image: Image
}

class GameViewModel: ObservableObject {
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameActive = true
    @Published var currentPlayer: Player = .human
    @Published var turnPrompt: String = "Your turn!"
    
    var humanImage: Image = Image(systemName: "person.fill")
    var computerImage: Image = Image(systemName: "pc")
    
    func processPlayerMove(for index: Int) {
        guard isSquareAvailable(at: index) else { return }
        
        moves[index] = Move(player: currentPlayer, boardIndex: index, image: humanImage)
        
        if checkWinCondition(for: currentPlayer) {
            isGameActive = false
            turnPrompt = "Congratulations! You win! 🎉"
            return
        }
        
        if checkForDraw() {
            isGameActive = false
            turnPrompt = "It's a draw! 🤝"
            return
        }
        
        currentPlayer = .computer
        turnPrompt = "Computer's turn..."
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.makeComputerMove()
        }
    }
    
    private func isSquareAvailable(at index: Int) -> Bool {
        return moves[index] == nil
    }
    
    private func makeComputerMove() {
        var availableMoves = [Int]()
        for i in 0..<moves.count {
            if moves[i] == nil {
                availableMoves.append(i)
            }
        }
        
        if let randomIndex = availableMoves.randomElement() {
            moves[randomIndex] = Move(player: .computer, boardIndex: randomIndex, image: computerImage)
            
            if checkWinCondition(for: .computer) {
                isGameActive = false
                turnPrompt = "Oops! Computer wins! 🤖"
                return
            }
            
            if checkForDraw() {
                isGameActive = false
                turnPrompt = "It's a draw! 🤝"
                return
            }
            
            currentPlayer = .human
            turnPrompt = "Your turn!"
        }
    }
    
    private func checkWinCondition(for player: Player) -> Bool {
        let winPatterns: Set<Set<Int>> = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
            [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
            [0, 4, 8], [2, 4, 6]             // Diagonals
        ]
        
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) {
            return true
        }
        
        return false
    }
    
    private func checkForDraw() -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
        isGameActive = true
        currentPlayer = .human
        turnPrompt = "Your turn!"
    }
    
    func setPlayerImages(human: Image, computer: Image) {
        humanImage = human
        computerImage = computer
    }
}
