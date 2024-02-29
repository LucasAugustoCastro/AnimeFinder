//
//  ContentView.swift
//  AnimeFinder
//
//  Created by Lucas Castro on 28/02/24.
//

import SwiftUI
import Alamofire
struct AnimeImageType: Decodable {
    var image_url: String?
    var small_image_url: String?
    var large_image_url: String?
}

struct AnimeImage: Decodable {
    var jpg: AnimeImageType
}


struct AnimeTitle: Decodable {
    var title: String?
}

struct Anime: Identifiable, Decodable {
    var mal_id: Int
    var images: AnimeImage
    var title: String?
    var title_english: String?
    var title_japanese: String?
    var synopsis: String?
    var year: Int?
    var id: Int{
        return mal_id
    }
}

struct PaginationType: Decodable {
    var last_visible_page: Int
}

struct SearchAnime: Decodable {
    var pagination: PaginationType
    var data: [Anime]
}
struct ContentView: View {
    @State var animeList:[Anime] = []
    @State var animeSearch = ""
    
    var body: some View {
        VStack {
            HStack{
                
                TextField("Digite o anime", text: $animeSearch)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 5)
                    .background(.quaternary)
                    .cornerRadius(10)
                    
                    
                Button("Pesquisar", action: {
                    fetchAnimeData(searchAnime: animeSearch)
                })
            }
            .padding()
            Spacer()
            List{
                ForEach(animeList) { anime in
                    HStack{
                        AsyncImage(url: URL(string: anime.images.jpg.image_url ?? "https://st4.depositphotos.com/14953852/22772/v/450/depositphotos_227724992-stock-illustration-image-available-icon-flat-vector.jpg")) { image in
                            // Quando a imagem for carregada com sucesso
                            image
                                .resizable() // Permitir redimensionamento da imagem
                                .aspectRatio(contentMode: .fit) // Manter a proporção da imagem
                        } placeholder: {
                            // Placeholder enquanto a imagem está sendo carregada
                            Image("image")
                                .resizable() // Permitir redimensionamento da imagem
                                .aspectRatio(contentMode: .fit) // Manter a proporção
                        }
                        
                        VStack(alignment: .leading){
                            Text(anime.title ?? "Sem titulo")
                                .padding(.bottom)
                            Text(anime.synopsis ?? "Sem descrição")
                                .lineLimit(5)
                                .font(.system(size:12))
                                
                        }
//                        .padding(.trailing, 6)
                        
                    }
                    .listRowSeparator(.hidden)
                    .frame(maxWidth: .infinity)
                    .padding(5)
//                    .padding(.leading, 5)
                    .background(Color.white)
                    .cornerRadius(6)
                    .shadow(radius: 3)
                    
                }
                .padding(0)
            }
            .listStyle(PlainListStyle())
            .background(Color.white)
            .padding(0)
            
        }

    }
    
    func fetchAnimeData(searchAnime:String) {
        print("PESQUISANDO \(searchAnime)")
        let url = "https://api.jikan.moe/v4/anime?q=\(searchAnime)"
        
        AF.request(url).responseDecodable(of: SearchAnime.self) { response in
            switch response.result {
            case .success(let data):
                animeList = data.data
            case .failure(let error):
                print("Erro ao fazer a solicitação: \(error)")
                animeList = []
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var testeAnime:[Anime] = [
         Anime(
            mal_id: 1,
            images: AnimeImage(
                jpg: AnimeImageType(
                    image_url: "https://st4.depositphotos.com/14953852/22772/v/450/depositphotos_227724992-stock-illustration-image-available-icon-flat-vector.jpg"
                )
            ),
            title: "Naruto",
            synopsis: "Two years have passed since the end of the Fourth Great Ninja War. Konohagakure has remained in a state of peace and harmony—until Sixth Hokage Kakashi Hatake notices the moon is dangerously approaching the Earth, posing the threat of planetary ruin.\n\nAmidst the grave ordeal, the Konoha is invaded by a new evil, Toneri Oosutuski, who suddenly abducts Hinata Hyuuga's little sister Hanabi. Kakashi dispatches a skilled ninja team comprised of Naruto Uzumaki, Sakura Haruno, Shikamaru Nara, Sai, and Hinata in an effort to rescue Hanabi from the diabolical clutches of Toneri. However, during their mission, the team faces several obstacles that challenge them, foiling their efforts.\n\nWith her abduction, the relationships the team share with one another are tested, and with the world reaching the brink of destruction, they must race against time to ensure the safety of their planet. Meanwhile, as the battle ensues, Naruto is driven to fight for something greater than he has ever imagined—love.\n\n[Written by MAL Rewrite]"
        ),
         Anime(
            mal_id: 1,
            images: AnimeImage(
                jpg: AnimeImageType(
                    image_url: "https://st4.depositphotos.com/14953852/22772/v/450/depositphotos_227724992-stock-illustration-image-available-icon-flat-vector.jpg"
                )
            ),
            title: "Naruto",
            synopsis: "Two years have passed since the end of the Fourth Great Ninja War. Konohagakure has remained in a state of peace and harmony—until Sixth Hokage Kakashi Hatake notices the moon is dangerously approaching the Earth, posing the threat of planetary ruin.\n\nAmidst the grave ordeal, the Konoha is invaded by a new evil, Toneri Oosutuski, who suddenly abducts Hinata Hyuuga's little sister Hanabi. Kakashi dispatches a skilled ninja team comprised of Naruto Uzumaki, Sakura Haruno, Shikamaru Nara, Sai, and Hinata in an effort to rescue Hanabi from the diabolical clutches of Toneri. However, during their mission, the team faces several obstacles that challenge them, foiling their efforts.\n\nWith her abduction, the relationships the team share with one another are tested, and with the world reaching the brink of destruction, they must race against time to ensure the safety of their planet. Meanwhile, as the battle ensues, Naruto is driven to fight for something greater than he has ever imagined—love.\n\n[Written by MAL Rewrite]"
        )
     ]
        
    static var previews: some View {
        ContentView(animeList: testeAnime)
    }
}
