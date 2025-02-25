import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    @State private var showPersonaSelection = true
    @State private var selectedHumanImage = Image(systemName: "person.fill")
    @State private var selectedComputerImage = Image(systemName: "pc")
    
    var body: some View {
        VStack {
            if showPersonaSelection {
                personaSelectionView
            } else {
                gameBoardView
            }
        }
        .navigationTitle("Tic Tac Toe")
    }
    
    private var personaSelectionView: some View {
        VStack {
            Text("Select Your Persona")
                .font(.headline)
                .padding()
            
            HStack {
                Button(action: {
                    selectedHumanImage = Image(systemName: "person.fill")
                }) {
                    Image(systemName: "person.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding()
                }
                
                Button(action: {
                    selectedHumanImage = Image(systemName: "face.smiling.fill")
                }) {
                    Image(systemName: "face.smiling.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding()
                }
            }
            
            Button("Start Game") {
                viewModel.setPlayerImages(human: selectedHumanImage, computer: selectedComputerImage)
                showPersonaSelection = false
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
    
    private var gameBoardView: some View {
        VStack {
            Text(viewModel.turnPrompt)
                .font(.title2)
                .padding()
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                ForEach(0..<9) { i in
                    ZStack {
                        Rectangle()
                            .foregroundColor(.blue)
                            .frame(width: 100, height: 100)
                            .cornerRadius(15)
                        
                        if let move = viewModel.moves[i] {
                            move.image
                                .resizable()
                                .frame(width: 60, height: 60)
                        }
                    }
                    .onTapGesture {
                        viewModel.processPlayerMove(for: i)
                    }
                }
            }
            .padding()
            
            if !viewModel.isGameActive {
                Button("Reset Game") {
                    viewModel.resetGame()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.top, 20)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
