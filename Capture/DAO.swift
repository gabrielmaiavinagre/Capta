//
//  DAO.swift
//  Capta
//
//  Created by Tatiana Magdalena on 5/25/15.
//  Copyright (c) 2015 Tatiana Magdalena. All rights reserved.
//

import Foundation

/*
A plist será uma lista em que cada elemento é uma instância de Book. A chave pode ser um id ou o titulo do livro.

A ideia de adicionar elementos em um plist é a seguinte:
Eu não faço alterações direto na plist. Primeiro, copio todos os dados para uma variável que será um dicionário (pois a plist nada mais é que um dicionário). Faço então as alterações necessárias nesse dicionário, e depois gravo esse dicionário na plist.
Se eu adicionar um elemento no dicionário com uma key que já existe, ele irá SOBRESCREVER aquele elemento. Por isso deve-se ter cuidado para verificar se o elemento já existe ao adicionar.
*/


/*
Os "println" presentes no código são apenas para teste. Ao terminar o desenvolvimento, serão removidos.
*/


class DAO {
    
    private class func getBookInfo(book: Book) -> NSMutableDictionary {
        
        //Crio um dicionário com as informações do livro que serão escritas na pList, já que não posso salvar Book direto.
        
        //[Media]
        var mediaInfo: [NSMutableDictionary] = [NSMutableDictionary]()
        for (var i = 0; i < book.media.count;  i++) {
            var thisMedia: NSMutableDictionary = ["Name": book.media[i].name, "Path": book.media[i].path, "Type": book.media[i].type]
            if(book.media[i].description != nil) {
                thisMedia.setObject(book.media[i].description!, forKey: "Description")
            }
            else {
                thisMedia.setObject("", forKey: "Description")
            }
            mediaInfo.append(thisMedia)
        }
        
        //Cover
        var coverInfo: NSMutableDictionary = ["Name": book.cover.name, "Path": book.cover.path, "Type": book.cover.type]
        if(book.cover.description != nil) {
            coverInfo.setObject(book.cover.description!, forKey: "Description")
        }
        else {
            coverInfo.setObject("", forKey: "Description")
        }
        
        //Book
        var bookInfo: NSMutableDictionary = NSMutableDictionary()
        bookInfo.setObject(coverInfo, forKey: "Cover")
        bookInfo.setObject(mediaInfo, forKey: "Medias")
        
        if (book.author != nil) {
            bookInfo.setObject(book.author!, forKey: "Author")
        }
        else {
            bookInfo.setObject("", forKey: "Author")
        }
        if (book.category != nil) {
            bookInfo.setObject(book.category!, forKey: "Category")
        }
        else {
            bookInfo.setObject("", forKey: "Category")
        }
        if (book.synopsis != nil) {
            bookInfo.setObject(book.synopsis!, forKey: "Synopsis")
        }
        else {
            bookInfo.setObject("", forKey: "Synopsis")
        }
        
        return bookInfo
    }
    
    
    class func booksWithSameName(title: String) -> Int {
        
        var pathAux = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        var path = pathAux.stringByAppendingPathComponent("BooksList.plist")
        
        var fileManager = NSFileManager.defaultManager()
        
        //A plist sempre tera uma copia no bundle. Se nao foi encontrada na pasta de DocumentDirectory por algum erro, essa parte do codigo ira copiar do bundle para la
        if (!(fileManager.fileExistsAtPath(path))) {
            println("***NÃO ENCONTROU O ARQUIVO PLIST***")
            var bundle: NSString! = NSBundle.mainBundle().pathForResource("BooksList", ofType: "plist")
            fileManager.copyItemAtPath(bundle as String, toPath: path as String, error: nil)
        }
        
        //Copia dos dados da plist para a memoria, para poder fazer as alteracoes.
        var contents: NSMutableDictionary! = NSMutableDictionary(contentsOfFile: path)
        var keys = contents.allKeys as! [String]
        sort(&keys)

        //Verificando se este nome de livro ja existe.
        for(var i = 0; i < keys.count; i++) {
            if keys[i].hasPrefix(title) {
                
                println("----------DAO -> addBook -> encontrou livro com mesmo nome -> cria um indice no final do Titulo")
                
                //Se já tem um livro com o mesmo nome, vou criando sufixos do tipo (n)
                var next = i + 1
                var sameTitleCount = 1
                
                if(next < keys.count) {
                    while(keys[next].hasPrefix(title)) {
                        if(keys[next] == title + "_" + String(sameTitleCount+1)) {
                            break
                        }
                        sameTitleCount++
                        next++
                        if(next >= keys.count) {
                            break
                        }
                    }
                }
                
                return sameTitleCount
            }
        }
        
        return 0
    }
    
    
    
    class func mediasWithSameName(name: String, book: Book) -> Int {
        
        var medias = book.media
        var mediasNames = [String]()
    
        for(var i = 0; i < medias.count; i++) {
            mediasNames.append(medias[i].name)
        }
        sort(&mediasNames)
        
        for(var i = 0; i < mediasNames.count; i++) {
            
            if mediasNames[i].hasPrefix(name) {
                
                println("----------DAO -> addMedia -> encontrou Media com mesmo nome -> cria um indice no final do PathPrefix")
                
                //Se já tem uma Media com o mesmo nome, vou criando sufixos do tipo _n
                var next = i + 1
                var sameNameCount = 1
                
                if next < book.media.count {
                    
                    while mediasNames[next].hasPrefix(name) {
                        if mediasNames[next] == name + "_" + String(sameNameCount+1) {
                            break
                        }
                        sameNameCount++
                        next++
                        if(next >= book.media.count) {
                            break
                        }
                    }
                }
                
                return sameNameCount
            }
        }
        
        return 0
    }
    
    
    
    //*************************************************************************************//
    //***********************************ADD BOOK******************************************//
    //*************************************************************************************//
    
    class func addBook(book: Book) -> Bool {
        
        println("----------DAO -> addBook -> inicio")
        
        //A primeira coisa a se fazer é procurar o arquivo da plist:
        var pathAux = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        var path = pathAux.stringByAppendingPathComponent("BooksList.plist")
        
        var fileManager = NSFileManager.defaultManager()
        
        //A plist sempre tera uma copia no bundle. Se nao foi encontrada na pasta de DocumentDirectory por algum erro, essa parte do codigo ira copiar do bundle para la
        if (!(fileManager.fileExistsAtPath(path))) {
            println("***NÃO ENCONTROU O ARQUIVO PLIST***")
            var bundle: NSString! = NSBundle.mainBundle().pathForResource("BooksList", ofType: "plist")
            fileManager.copyItemAtPath(bundle as String, toPath: path as String, error: nil)
        }
        
        //Copia dos dados da plist para a memoria, para poder fazer as alteracoes.
        var contents: NSMutableDictionary! = NSMutableDictionary(contentsOfFile: path)
        var keys = contents.allKeys as! [String]
        sort(&keys)
        
        //Verificando se este nome de livro ja existe.
        for(var i = 0; i < keys.count; i++) {
            if keys[i].hasPrefix(book.title) {
                
                println("----------DAO -> addBook -> encontrou livro com mesmo nome -> cria um indice no final do Titulo")
                
                //Se já tem um livro com o mesmo nome, vou criando sufixos do tipo (n)
                var next = i + 1
                var sameTitleCount = 1
                
                if(next < keys.count) {
                    while(keys[next].hasPrefix(book.title)) {
                        if(keys[next] == book.title + "_" + String(sameTitleCount+1)) {
                            break
                        }
                        sameTitleCount++
                        next++
                        if(next >= keys.count) {
                            break
                        }
                    }
                }
                
                var titleIndex = String(sameTitleCount)
                
                book.title = book.title + "_" + titleIndex
                
                break
            }
        }
        
        //Criando um dicionário com todas as informações de book para ser adicionado na plist, uma vez que a plist só permite armazenar tipo básicos de dados (string, int, etc). Para armazenar um objeto customizado teria que converter pra NSData, usando o protocolo de NSCoding...... Me pareceu uma forma mais confusa, então optei por fazer desse jeito aqui mesmo.
        var bookInfo: NSMutableDictionary = getBookInfo(book)
        
        //Se chegou a este ponto do codigo, o livro nao existe na plist. Procede-se entao com a adicao.
        contents.setObject(bookInfo, forKey: book.title)
        contents.writeToFile(path, atomically: true)
        
        /****Deve-se fazer alguma verificação aqui para saber se os dados foram salvos corretamente na plist****/
        
        //Atualiza Data
        Data.sharedInstance.allBooks.append(book)
        
        //Teste visual (print) pra ver se salvou direito na plist
        pathAux = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        path = pathAux.stringByAppendingPathComponent("BooksList.plist")
        contents = NSMutableDictionary(contentsOfFile: path)
        
        println("~Dados apos adicionar livro: ")
        println(contents)
        keys = contents.allKeys as! [String]
        println("~qtd de elementos = \(keys.count)")
        
        println("----------DAO -> addBook -> fim")
        
        
        return true
    }
    
    
    
    //*************************************************************************************//
    //********************************REMOVE BOOK******************************************//
    //*************************************************************************************//
    
    class func removeBook(book: Book) -> Bool {
        
        println("----------DAO -> removeBook -> inicio")
        
        //Procurar o arquivo da plist:
        var pathAux = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        var path = pathAux.stringByAppendingPathComponent("BooksList.plist")
        
        //Coloca os dados da plist em um dicionário
        var contents: NSMutableDictionary! = NSMutableDictionary(contentsOfFile: path as String)
        var keys = contents.allKeys
        
        //Atualiza Data
        for(var j = 0; j < Data.sharedInstance.allBooks.count; j++) {
            if Data.sharedInstance.allBooks[j].title == book.title {
                Data.sharedInstance.allBooks.removeAtIndex(j)
            }
        }
        
        for(var i = 0; i < keys.count; i++) {
            if keys[i] as! String == book.title {
                contents.removeObjectForKey(book.title)
                contents.writeToFile(path, atomically: true)
                //****Deve-se fazer alguma verificação aqui para saber se os dados foram salvos corretamente na plist****
                
                println("----------DAO -> removeBook -> fim (removeu)")
                
                return true
            }
        }
        
        //Se chegou a esse ponto do código, não encontrou o livro a ser deletado.
        
        println("----------DAO -> removeBook -> fim (nao encontrou)")
        
        return false
    }
    
    
    
    //*************************************************************************************//
    //********************************ADD MEDIA********************************************//
    //*************************************************************************************//
    
    class func addMedia(aMedia: Media, toBook: Book) -> Bool {
        
        println("----------DAO -> addMedia -> inicio")
        
        //A primeira coisa a se fazer é procurar o arquivo da plist:
        var pathAux = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        var path = pathAux.stringByAppendingPathComponent("BooksList.plist")
        
        var fileManager = NSFileManager.defaultManager()
        
        //A plist sempre tera uma copia no bundle. Se nao foi encontrada na pasta de DocumentDirectory por algum erro, essa parte do codigo ira copiar do bundle para la
        if !(fileManager.fileExistsAtPath(path)) {
            var bundle: NSString! = NSBundle.mainBundle().pathForResource("BooksList", ofType: "plist")
            fileManager.copyItemAtPath(bundle as String, toPath: path as String, error: nil)
        }
        
        //Copia dos dados da plist para a memoria, para poder fazer as alteracoes.
        var contents: NSMutableDictionary! = NSMutableDictionary(contentsOfFile: path)
        
        //Verificando se já existe uma Media com o mesmo path para o mesmo livro
        for(var i = 0; i < toBook.media.count; i++) {
            
            var pathExtension = toBook.media[i].path.pathExtension
            var pathPrefix = toBook.media[i].path.stringByDeletingPathExtension
            
            var mediaPathExtension = aMedia.path.pathExtension
            var mediaPathPrefix = aMedia.path.stringByDeletingPathExtension
            
            if (pathExtension == mediaPathExtension) && (pathPrefix.hasPrefix(mediaPathPrefix)) {
                
                println("----------DAO -> addMedia -> encontrou Media com mesmo nome -> cria um indice no final do PathPrefix")
                
                //Se já tem uma Media com o mesmo nome, vou criando sufixos do tipo _n
                var next = i + 1
                var samePathCount = 1
                
                if next < toBook.media.count {
                    
                    while (toBook.media[next].path.stringByDeletingPathExtension).hasPrefix(mediaPathPrefix) {
                        if (toBook.media[next].path.stringByDeletingPathExtension) == mediaPathPrefix + "_" + String(samePathCount+1) {
                            break
                        }
                        samePathCount++
                        next++
                        if(next >= toBook.media.count) {
                            break
                        }
                    }
                }
                
                var pathPrefixIndex = String(samePathCount)
                
                aMedia.path = mediaPathPrefix + "_" + pathPrefixIndex + "." + pathExtension
                
                break
            }
        }
        
        //Colocando a Media já dentro da instância de Book, pois ele que será gravado na plist.
        toBook.media.append(aMedia)
        
        //Crio um dicionário com as novas informações de toBook
        var bookInfo: NSMutableDictionary = getBookInfo(toBook)
        
        //Como o livro já existe, irá sobrescrever seus dados (se tento salvar algo em uma key que já existe em um dicionário, irá sobrescrever).
        contents.setObject(bookInfo, forKey: toBook.title)
        contents.writeToFile(path, atomically: true)
        
        
        
        // APARENTEMENTE, AO ATUALIZAR O toBook, ELE JÁ ATUALIZA EM DATA........ ????????? ENTÃO NÃO PRECISARIA FAZER ESSA ATUALIZAÇÃO EM DATA, SE NÃO FICA DUPLICADO!
        //        //Atualiza Data
        //        println("~Data.sharedInstance.allBooks.count: \(Data.sharedInstance.allBooks.count)")
        //        for(var j = 0; j < Data.sharedInstance.allBooks.count; j++) {
        //            println("\(Data.sharedInstance.allBooks[j].title)")
        //            if Data.sharedInstance.allBooks[j].title == toBook.title {
        //                println(".Quantidade de Media nesse livro antes append de aMedia")
        //                println(Data.sharedInstance.allBooks[j].media.count)
        //                Data.sharedInstance.allBooks[j].media.append(aMedia)
        //                println(".Quantidade de Media nesse livro após append de aMedia")
        //                println(Data.sharedInstance.allBooks[j].media.count)
        ////                println(".Fez append de aMedia, deixando o [Media] deste livro como: ")
        ////                for(var x = 0; x < Data.sharedInstance.allBooks[j].media.count; x++) {
        ////                    println(Data.sharedInstance.allBooks[j].media[x].path)
        ////                }
        //            }
        //        }
        
        
        
        //****Deve-se fazer alguma verificação aqui para saber se os dados foram salvos corretamente na plist****
        
        
        
        //****Recarregando a plist só pra testar se gravou. O teste está com print (teste apenas visal): tentar arranjar algum jeito que dê um retorno pra quem está chamando a função, se gravou direito ou não.****
        pathAux = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        path = pathAux.stringByAppendingPathComponent("BooksList.plist")
        contents = NSMutableDictionary(contentsOfFile: path)
        
        println("~Dados apos adicionar media: ")
        println(contents)
        
        println("----------DAO -> addMedia -> fim")
        
        return true
    }
    
    
    
    //*************************************************************************************//
    //********************************REMOVE MEDIA*****************************************//
    //*************************************************************************************//
    
    class func removeMedia(media: Media, fromBook: Book) -> Bool {
        
        println("----------DAO -> removeMedia -> inicio")
        
        //Remove a Media da instância de fromBook
        for(var i = 0; i < fromBook.media.count; i++) {
            if fromBook.media[i].path == media.path {
                fromBook.media.removeAtIndex(i)
            }
        }
        
        //Procurar o arquivo da plist:
        var pathAux = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        var path = pathAux.stringByAppendingPathComponent("BooksList.plist")
        
        //Coloca os dados da plist em um dicionário
        var contents: NSMutableDictionary! = NSMutableDictionary(contentsOfFile: path as String)
        var keys = contents.allKeys
        
        //Procura o elemento que tem o título de fromBook como key
        for(var i = 0; i < keys.count; i++) {
            if keys[i] as! String == fromBook.title {
                
                //Crio um dicionário com as novas informações de fromBook
                var bookInfo: NSMutableDictionary = getBookInfo(fromBook)
                
                //Adiciona a instância de fromBook, já sem a media, no dicionário. Como essa key já existe, irá sobrescrever.
                contents.setObject(bookInfo, forKey: fromBook.title)
                contents.writeToFile(path, atomically: true)
                
                println("**Dados após remover Media: ")
                println(contents)
                println("----------DAO -> removeMedia -> fim")
                
                //****Deve-se fazer alguma verificação aqui para saber se os dados foram salvos corretamente na plist****
                
                //Atualiza Data
                for(var j = 0; j < Data.sharedInstance.allBooks.count; j++) {
                    if Data.sharedInstance.allBooks[j].title == fromBook.title {
                        for(var i = 0; i < Data.sharedInstance.allBooks[j].media.count; i++) {
                            if Data.sharedInstance.allBooks[j].media[i].path == media.path {
                                Data.sharedInstance.allBooks[j].media.removeAtIndex(i)
                            }
                        }
                    }
                }
                
                
                return true
            }
            
        }
        
        println("----------DAO -> removeMedia -> fim (não encontrou o livro referente a esta Media)")
        
        //Se chegou nesta parte do código, não encontrou este livro na lista, portanto não terá como remover uma Media dele.
        return false
    }
    
    
    
    //*************************************************************************************//
    //********************************UPDATE BOOK******************************************//
    //*************************************************************************************//
    
    class func updateBook(oldBook: Book, newBook: Book) -> Bool {
        
        println("----------DAO -> updateBook -> inicio")
        
        removeBook(oldBook)
        addBook(newBook)
        
        println("----------DAO -> updateBook -> fim")
        
        return true
    }
    
    
    
    //*************************************************************************************//
    //********************************UPDATE MEDIA*****************************************//
    //*************************************************************************************//
    
    class func updateMedia(fromBook: Book, oldMedia: Media, newMedia: Media) {
        
        println("----------DAO -> updateMedia -> inicio")
        
        //Talvez não seja o mais eficiente (pois está acessando a plist duas vezes para ler e duas vezes para escrever)
        removeMedia(oldMedia, fromBook: fromBook)
        addMedia(newMedia, toBook: fromBook)
        
        println("----------DAO -> updateMedia -> fim")
    }
    
    
    
    //*************************************************************************************//
    //********************************GET ALL BOOKS*****************************************//
    //*************************************************************************************//
    
    class func getAllBooks() {
        
        println("----------DAO -> getAllBooks -> inicio")
        
        //Procurar o arquivo da plist:
        var pathAux = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        var path = pathAux.stringByAppendingPathComponent("BooksList.plist")
        
        let contents:NSDictionary! = NSDictionary(contentsOfFile: path)
        
        var allBooks = [Book]()
        
        //Se ainda não tem elementos na plist, não precisa ler e retorna um array vazio.
        if contents == nil {
            println("----------DAO -> getAllBooks -> fim (não tinha nada para ler)")
            Data.sharedInstance.allBooks = allBooks
            return
        }
        
        var keys = contents.allKeys
        
        if keys.count == 0 {
            println("----------DAO -> getAllBooks -> fim (não tinha nada para ler)")
            Data.sharedInstance.allBooks = allBooks
            return
        }
        
        //Percorro todas as keys da plist (todos os livros), e para cada uma dela crio uma instância de Book e adiciono no vetor que será retornado.
        for(var i = 0; i < keys.count; i++) {
            
            var title: String = keys[i] as! String
            var bookInfo: NSDictionary = contents.valueForKey(title) as! NSDictionary
            var currentBook: Book
            
            //Pegando todas as informações que estão na plist e criando uma instância de Book com elas.
            var mediasInfo: [NSDictionary] = bookInfo.valueForKey("Medias") as! [NSDictionary]
            var medias: [Media] = [Media]()
            for (var i = 0; i < mediasInfo.count; i++) {
                var mediaName = mediasInfo[i].objectForKey("Name") as! String
                var mediaPath = mediasInfo[i].objectForKey("Path") as! String
                var mediaType = mediasInfo[i].objectForKey("Type") as! String
                var currentMedia: Media = Media(name: mediaName, path: mediaPath, type: mediaType)
                medias.append(currentMedia)
            }
            
            var coverInfo: NSDictionary = bookInfo.valueForKey("Cover") as! NSDictionary
            var cover: Media = Media(name: coverInfo.valueForKey("Name") as! String, path: coverInfo.valueForKey("Path") as! String, type: coverInfo.valueForKey("Type") as! String)
            
            currentBook = Book(title: title, cover: cover, media: medias)
            currentBook.author = bookInfo.valueForKey("Author") as? String
            currentBook.category = bookInfo.valueForKey("Category") as? String
            currentBook.synopsis = bookInfo.valueForKey("Synopsis") as? String
            
            allBooks.append(currentBook)
        }
        
        println("**Dados recuperados por getAllBooks: ")
        println(contents)
        
        //Cria a instância de Data 
        Data.sharedInstance.allBooks = allBooks
        
        println("----------DAO -> getAllBooks -> fim")
    }
}