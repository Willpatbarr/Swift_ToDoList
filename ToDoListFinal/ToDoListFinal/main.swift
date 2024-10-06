//
//  main.swift
//  ToDoListFinal
//
//  Created by William Barr on 10/5/24.
//

import Foundation

//
//  main.swift
//  ToDoList
//
//  Created by William Barr on 9/26/24.
//

import Foundation

var greeting = "Hello, playground"
print(greeting)

/* program goals:
- have a user interface that shows all the items in the to do list
    and prompts the user to do one of four things
    - create new item to do
    - delete item to do
    - check off item to do
    - quit the program*/

class ItemToDo: Codable {
    var name: String
    var completionIcon: String
    var description: String
    var isCompleted: Bool = false
    
    init(name: String, completionIcon: String = "[ ]") {
        self.name = name
        self.description = ""
        self.completionIcon = completionIcon
    }
    
    func toggleItemCompletion() {
        self.isCompleted.toggle()
        if self.isCompleted {
            self.completionIcon = "[x]"
        } else {
            self.completionIcon = "[ ]"
        }
    }
//    func completeItem() {
//        self.completionIcon = "[x]"
//        self.isCompleted.toggle()
//    }
//    func unCompleteItem() {
//        self.completionIcon = "[ ]"
//        self.isCompleted.toggle()
    func GetDetailsString() -> String {
        var completionStatus: String = ""
        if self.isCompleted {
            completionStatus = "Completed"
        } else {
            completionStatus = "Not Completed"
        }
        var detailString: String = """
        Name: \(self.name)
        Completion Status: \(completionStatus) \(self.completionIcon)
        Description: \(self.description)
        """
        return detailString
    }
}

//let firstItemToDo = ItemToDo(description: "Learn loops syntax")
//let secondItemToDo = ItemToDo(description: "Learn functions syntax")
//let thirdItemToDo = ItemToDo(description: "Learn classes syntax")
//let fourthItemToDo = ItemToDo(description: "Learn how to use inheritance")

var toDoList: [ItemToDo] = []

//toDoList = [firstItemToDo, secondItemToDo, thirdItemToDo, fourthItemToDo]

func saveToDoList(fileName: String) {
    let encoder = JSONEncoder() // makes new jsonencoder object
    encoder.outputFormatting = .prettyPrinted // makes the output file more readable. edits the attribute of output formatting to be .pretty painted
    if let data = try? encoder.encode(toDoList) {
        //creates an error safe way to attempt to encode the toDoList as a JSON file. if fails else is used
        let fileURL = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(fileName)
        do {
            try data.write(to: fileURL)
            print("to-do list saved to \(fileURL.path)")
        } catch {
            print("Error saving file: \(error)")
        }
    } else {
        print("failed to make a new file")
    }
}

func loadToDoListFromFile(fileName: String) {
    let fileURL = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(fileName)
    if let data = try? Data(contentsOf: fileURL) {
        let decoder = JSONDecoder()
        if let decodedList = try? decoder.decode([ItemToDo].self, from: data) {
            toDoList = decodedList
            print("To do list loaded from \(fileURL.path)")
        } else {
            print("failed to load file from \(fileURL.path)")
        }
    } else {
        print("failed to load file")
    }
}

func completeItemToDo(index: Int) {
    toDoList[index - 1].toggleItemCompletion()
}

//func createNewItemToDo(name: String, itemID: String) -> ItemToDo{
//    let name = ItemToDo(name: name)
//    return name
//}
func appendNewItemToDo(item: ItemToDo, toDoList: inout [ItemToDo]) {
    toDoList.append(item)
}

func deleteItemToDo(index: Int) {
    toDoList.remove(at: index - 1)
}

func getDisplayStringOfToDoList(list: [ItemToDo]) -> String {
    var listString: String = ""
    var displayIndex: Int = 1
    for item in list {
        let displayString: String = item.name + ": " + item.completionIcon + "(\(displayIndex))\n"
        listString += displayString
        displayIndex += 1
    }
    return listString
}

func loadFromFileMenu() {
    while true {
        print("would you like to load a file from your computer? (y/n): ")
        if let userChoiceLoadFile: String = readLine() {
            if userChoiceLoadFile == "y" {
                print("Please enter the file name: (e.g. todo.json")
                if let userInputFileName: String = readLine() {
                    loadToDoListFromFile(fileName: userInputFileName)
                    break
                } else {
                    print("input failed")
                }
            } else if userChoiceLoadFile == "n" {
                print("will start program from scratch")
                break
            } else {
                print("please enter 'y' or 'n'")
            }
        } else {
            print("input failed")
        }
    }
}

func main() {
    print("Welcome to the To Do List!")
    loadFromFileMenu()
    print("")
    var itemNumber: Int = 4
    while true {
        if !toDoList.isEmpty {
            print("Here's your to-do list:")
            print(getDisplayStringOfToDoList(list: toDoList))
        } else {
            print("Create a new item to get started!")
        }
        print("""
    What would you like to do?
    - create a new item to do (1)
    - delete item to do (2)
    - complete item (3)
    - view specific item (4)
    - save and quit program (5)
    """)
        var menuChoice: String = ""
        if let userInput: String = readLine() {
            menuChoice = userInput
        } else {
            print("Please enter a valid input")
        }
        if menuChoice == "1" {
            itemNumber += 1
            print("Please enter a name for the task: ", terminator: "")
            if let name: String = readLine() {
                var newItem: ItemToDo
                newItem = ItemToDo(name: name)
                appendNewItemToDo(item: newItem, toDoList: &toDoList)
            } else { print("Invalid Input")}
            
        } else if menuChoice == "2" {
            print("Which item would you like to delete?", terminator: "")
            if let input = readLine(), let index = Int(input) {
                deleteItemToDo(index: index)
                print("Item deleted!")
            } else { print("Invalid Input")}
            
        } else if menuChoice == "3" {
            print("Which item would you like to complete?: ", terminator: "")
            if let input = readLine(), let index = Int(input) {
                completeItemToDo(index: index)
                print("Item completed!")
            } else { print("Invalid Input")}
            
        } else if menuChoice == "4" {
            
            
            while true {
                print("Which item would you like to view the details of?: ", terminator: "")
                if let itemToViewChoice = readLine(), let index = Int(itemToViewChoice) {
                    var printableDetailsString = toDoList[index - 1].GetDetailsString()
                    print(printableDetailsString)
                    print("\n")
                    print("""
                      What would you like to do now?
                      1. Edit name
                      2. Edit description
                      3. Toggle completion status
                      4. return to main menu
                      """)
                    if let detailMenuChoice = readLine() {
                        if detailMenuChoice == "1" {
                            print("\nWhat would you like to change the name to?: ")
                            if let subMenuChoice = readLine() {
                                toDoList[index - 1].name = subMenuChoice
                            } else {
                                print("/nPlease enter a valid input")
                            }
                        } else if detailMenuChoice == "2" {
                            print("\nWhat would you like to change the description to?: ")
                            if let subMenuChoice = readLine() {
                                toDoList[index - 1].description = subMenuChoice
                            } else {
                                print("\nPlease enter a valid input")
                            }
                        } else if detailMenuChoice == "3" {
                            toDoList[index - 1].toggleItemCompletion()
                        } else if detailMenuChoice == "4" {
                            break
                        } else {print("Please enter a valid input")}
                    } else {print("\nInvalid Input")}
                } else { print("\nInvalid Input")}
            }
            
        } else if menuChoice == "5" {
            print("Please enter the filename you want this list saved to: ")
            while true {
                if let inputFileName: String = readLine() {
                    saveToDoList(fileName: inputFileName)
                    break
                } else {
                    print("please enter a valid filename")
                    
                }
            }
            print("Bye!")
            break
        }
        
    }
}

main()


