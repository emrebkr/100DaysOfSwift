//
//  ViewController.swift
//  Milstone 19-21
//
//  Created by Emre Bakır on 3.02.2023.
//

import UIKit

class ViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
        
    var notes = [Note]()
    
    // When the view will appear on screen, if there is notes saved load them.
    override func viewWillAppear(_ animated: Bool) {
        if let savedNotes = defaults.object(forKey: "notes") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                notes = try jsonDecoder.decode([Note].self , from: savedNotes)
                notes.sort { $0.date > $1.date }
            } catch {
                print("Failed to load notes")
            }
            
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Apple Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Use an instance property of ViewController to create an edit/done button that change based on editing the cell
        navigationItem.rightBarButtonItem = self.editButtonItem
        navigationItem.rightBarButtonItem?.tintColor = .orange
        
        // Set up the toolbar with a button on the right for creating a new note
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let newNote = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(createNewNote))
        toolbarItems = [spacer, newNote]
        navigationController?.isToolbarHidden = false
        
        // If the cell is empty (table view without content) make it a clear view
        tableView.tableFooterView = UIView()
        
        let imageBackground = UIImageView(image: UIImage(named: "background"))
        tableView.backgroundView = imageBackground
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NoteCell
        cell.Title.text = String(notes[indexPath.row].title.prefix(10))
        cell.Date.text = notes[indexPath.row].date
        return cell
    }
    
    // Editing cells https://www.hackingwithswift.com/example-code/uikit/how-to-swipe-to-delete-uitableviewcells
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // If the editing style of the cell is on delete mode, remove it from the array of notes and delete the row with fadeOut
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            save()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            navigationController?.pushViewController(vc, animated: true)
            vc.detailNote = notes[indexPath.row]
            vc.indexOfNote = indexPath.row
            vc.notes = notes
        }
    }
    
    @objc func createNewNote() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            navigationController?.pushViewController(vc, animated: true)
            vc.notes = notes
        }
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedNotes = try? jsonEncoder.encode(notes) {
            defaults.set(savedNotes, forKey: "notes")
        } else {
            print("Failed to save notes.")
        }
    }
}

