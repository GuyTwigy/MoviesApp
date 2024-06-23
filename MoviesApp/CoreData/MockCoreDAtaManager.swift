//
//  MockCoreDAtaManager.swift
//  MoviesApp
//
//  Created by Guy Twig on 23/06/2024.
//

import Foundation
import CoreData

class MockCoreDataManager: CoreDataManagerProtocol {
    
    static let shared = MockCoreDataManager()
    
    private init() {}
        
        lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "MoviesAppCoreData")
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType // Use in-memory store for testing
            container.persistentStoreDescriptions = [description]
            
            container.loadPersistentStores { description, error in
                if let error = error as NSError? {
                    fatalError("Failed to load Core Data stack: \(error), \(error.userInfo)")
                }
            }
            
            return container
        }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchMovies<T: NSManagedObject>(entityType: T.Type) -> [MovieData] {
        let request = NSFetchRequest<T>(entityName: String(describing: entityType))
        do {
            let results = try context.fetch(request)
            var movieDataArray: [MovieData] = []
            
            for result in results {
                guard let id = result.value(forKey: "idString") as? String else { continue }
                guard let title = result.value(forKey: "title") as? String else { continue }
                guard let posterPath = result.value(forKey: "posterPath") as? String else { continue }
                guard let overview = result.value(forKey: "overview") as? String else { continue }
                guard let releaseDate = result.value(forKey: "releaseDate") as? String else { continue }
                guard let originalLanguage = result.value(forKey: "originalLanguage") as? String else { continue }
                guard let voteAverage = result.value(forKey: "voteAverage") as? Double else { continue }
                guard let date = result.value(forKey: "date") as? Date else { continue }
                
                let movieData = MovieData(id: nil, idString: id, title: title, posterPath: posterPath, overview: overview, releaseDate: releaseDate, originalLanguage: originalLanguage, voteAverage: voteAverage, date: date)
                
                movieDataArray.append(movieData)
            }
            
            return movieDataArray
        } catch {
            print("Failed to fetch movies: \(error)")
            return []
        }
    }
    
    func addMovies<T: NSManagedObject>(_ movies: [MovieData], entityType: T.Type) {
        clearMovies(entityType: entityType)
        for movieData in movies {
            let entityName = String(describing: entityType)
            guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
                continue
            }
            
            let movie = NSManagedObject(entity: entity, insertInto: context)
            movie.setValue("\(movieData.id ?? 0)", forKey: "idString")
            movie.setValue(movieData.title, forKey: "title")
            movie.setValue(movieData.posterPath, forKey: "posterPath")
            movie.setValue(movieData.overview, forKey: "overview")
            movie.setValue(movieData.releaseDate, forKey: "releaseDate")
            movie.setValue(movieData.originalLanguage, forKey: "originalLanguage")
            movie.setValue((movieData.voteAverage), forKey: "voteAverage")
            movie.setValue(Date(), forKey: "date")
        }
        saveContext()
    }
    
    func clearMovies<T: NSManagedObject>(entityType: T.Type) {
        let entityName = String(describing: entityType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        do {
            let objects = try context.fetch(fetchRequest) as? [NSManagedObject] ?? []
            for object in objects {
                context.delete(object)
            }
            saveContext()
        } catch {
            print("Failed to clear movies: \(error)")
        }
    }
}
