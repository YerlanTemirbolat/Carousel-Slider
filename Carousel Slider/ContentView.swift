//
//  ContentView.swift
//  Carousel Slider
//
//  Created by Admin on 9/3/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    
    // 40 = padding horizontal
    // 60 = 2 card to right side
    var width = UIScreen.main.bounds.width - (40 + 60)
    var height = UIScreen.main.bounds.height / 2
    @State var movies = [
        
        Movie(id: 0, image: "p0", title: "Sonic", editor: "Jeff Fauler", rating: 3, offset: 0),
        Movie(id: 1, image: "p1", title: "Black Widow", editor: "Keith Shortland", rating: 4, offset: 0),
        Movie(id: 2, image: "p2", title: "Free Guy", editor: "Sean Levi", rating: 4, offset: 0),
        Movie(id: 3, image: "p3", title: "Aquaman", editor: "James Vann", rating: 3, offset: 0),
        Movie(id: 4, image: "p4", title: "Terminator 2", editor: "James Cameron", rating: 5, offset: 0),
        Movie(id: 5, image: "p5", title: "Identity", editor: "James Mangoldt", rating: 4, offset: 0)

    ]
    
    @State var swipe = 0
    
    var body: some View {
        VStack {
            HStack {
                Text("Custom Carousel")
                    .font(.title)
                    .fontWeight(.heavy)
                
                Spacer()
                
                Button(action: {}, label: {
                    Image(systemName: "circle.grid.2x2.fill")
                        .font(.system(size: 22))
                })
            }
            .foregroundColor(.white)
            .padding()
            
            Spacer()
            
            ZStack {
                ForEach(movies.reversed()) { movie in
                    HStack {
                        ZStack {
                            Image(movie.image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: width, height: getHeight(index: movie.id))
                                .cornerRadius(25)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5)
                            
                            CardView(card: movie)
                                .frame(width: width, height: getHeight(index: movie.id))
                        }
                     
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .padding(.horizontal, 20)
                    .offset(x: movie.id - swipe < 3 ? CGFloat(movie.id - swipe) * 30 : 60)
                    .offset(x: movie.offset)
                    .gesture(DragGesture().onChanged({ (value) in
                        withAnimation {onScroll(value: value.translation.width, index: movie.id)}
                    }).onEnded({ (value) in
                        withAnimation {onEnd(value: value.translation.width, index: movie.id)}
                    }))
                }
            }
            .frame(height: height)
            
            PageViewController(total: movies.count, current: $swipe)
                .padding(.top, 25)
            
            Spacer()
        }
        .padding(.top, 35)
        .background(Color("bg"))
        .edgesIgnoringSafeArea(.all)
    }
    
    func getHeight(index: Int) -> CGFloat {
        return height - (index - swipe < 3 ? CGFloat(index - swipe) * 40 : 80)
    }
    
    func onScroll(value: CGFloat, index: Int) {
        if value < 0 {
            if index != movies.last!.id {
                movies[index].offset = value
            }
        } else {
            if index > 0 {
                movies[index - 1].offset = -(width + 60) + value
            }
        }
    }
        
    func onEnd(value: CGFloat, index: Int) {
        if value < 0 {
            if -value > width / 2 && index != movies.last!.id {
                movies[index].offset = -(width + 60)
                swipe += 1
            } else {
                movies[index].offset = 0
            }
        } else {
            if index > 0 {
                if value > width / 2 {
                    movies[index - 1].offset = 0
                    swipe -= 1
                } else {
                    movies[index - 1].offset = -(width + 60)
                }
            }
        }
    }
}

struct Movie: Identifiable {
    var id: Int
    var image: String
    var title: String
    var editor: String
    var rating: Int
    var offset: CGFloat
}

struct CardView: View {
    
    var card: Movie
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Button(action: {}, label: {
                    Text("Read Now")
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background(Color("purple"))
                        .clipShape(Capsule())
                })
                
                Spacer()
            }
            .padding()
            .padding(.bottom, 10)
        }
    }
}

struct PageViewController: UIViewRepresentable {
    
    var total: Int
    @Binding var current : Int
    
    func makeUIView(context: Context) -> UIPageControl {
        let view = UIPageControl()
        view.numberOfPages = total
        view.currentPage = current
        view.currentPageIndicatorTintColor = .white
        view.preferredIndicatorImage = UIImage(systemName: "book.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22))
        view.backgroundStyle = .prominent
        return view
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = current
    }
}
