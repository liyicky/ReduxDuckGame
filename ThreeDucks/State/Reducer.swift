/// Copyright (c) 2022 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

typealias Reducer<State, Action> = (State, Action) -> State

let threeDucksReducer: Reducer<ThreeDucksState, ThreeDucksAction> = { state, action in
  var mutatingState = state
  switch action {
  case .startGame:
    mutatingState.gameState = .started
    mutatingState.cards = [
      Card(animal: .bat),
        Card(animal: .bat),
        Card(animal: .ducks),
        Card(animal: .ducks),
        Card(animal: .bear),
        Card(animal: .bear),
        Card(animal: .pelican),
        Card(animal: .pelican),
        Card(animal: .horse),
        Card(animal: .horse),
        Card(animal: .elephant),
        Card(animal: .elephant)
    ].shuffled()
    mutatingState.selectedCards = []
    mutatingState.moves = 0
  case .endGame:
    mutatingState.gameState = .title
  case .flipCard(let id):
    
    // 1 (First check the selectedCards count to make sure no more than two are selected. If two cards are already selectedd, br4eak, which will return the state unchanged.)
    guard mutatingState.selectedCards.count < 2 else {
      break
    }
    
    //2 (Also check that the selected cards aren't already in selectedCards. This is to prevent counting multiple taps on the same card.)
    guard !mutatingState.selectedCards.contains(where: { $0.id == id }) else {
      break
    }
    
    // 3 (Then, make a mutable copy of cards)
    var cards = mutatingState.cards
    
    //4 (Make suer you can finnd the index of the flipping card)
    guard let selectedIndex = cards.firstIndex(where: { $0.id == id }) else {
      break
    }
    
    //5 (Make a new Card, copying the properties from the selected one, making sure isFlipped is true)
    let selectedCard = cards[selectedIndex]
    let flippedCard = Card(id: selectedCard.id, animal: selectedCard.animal, isFlipped: true)
    
    //6 (Insert the now flipped card into cards at the correct index.)
    cards[selectedIndex] = flippedCard
    
    //7 (Append the flipped card to selectedCards and set cards on the new state to the updated array.)
    mutatingState.selectedCards.append(selectedCard)
    mutatingState.cards = cards
    
    //8 (Finally, increament the moves tally.)
    mutatingState.moves += 1
    
  case .unFlipSelectedCards:
    let selectedIDs = mutatingState.selectedCards.map { $0.id }
    let cards: [Card] = mutatingState.cards.map { card in
      guard selectedIDs.contains(card.id) else {
        return card
      }
      return Card(id: card.id, animal: card.animal, isFlipped: false)
    }
    
    mutatingState.selectedCards = []
    mutatingState.cards = cards
    
  case .clearSelectedCards:
    mutatingState.selectedCards = []
    
  case .winGame:
    mutatingState.gameState = .won
  }
  
  return mutatingState
}
