import UIKit

class IntroduceISBN: UIViewController, UITextFieldDelegate{

    
    @IBOutlet weak var isbnTextfield: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        isbnTextfield.returnKeyType = UIReturnKeyType.Search
        isbnTextfield.becomeFirstResponder()
        isbnTextfield.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
    * Function to respond to the search keyboard button
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        searchBookByISBN()
        textField.resignFirstResponder()
        return true
    }

    
    /**
     * Function to make a request to openlibrary to search a book by the isbn
     * given in the isbnTextField and render it in the resultTextView
     */
    func searchBookByISBN(){
        errorLabel.hidden = true
        let isbn: String = isbnTextfield.text!
        print ("Searching by \(isbn)")
        let myUrl:String = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(isbn)".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let openLibraryURL:NSURL = NSURL(string: myUrl)!
        
        let request = NSURLRequest(URL: openLibraryURL,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 3)
        var response: NSURLResponse?
        do {
            let booksData = try NSURLConnection.sendSynchronousRequest(request,
                returningResponse: &response)
            
            let json = try NSJSONSerialization.JSONObjectWithData(booksData, options: .MutableLeaves)
            if((json as! NSDictionary)["ISBN:\(isbn)"] != nil){
                let booksMap = (json as! NSDictionary)["ISBN:\(isbn)"]!
                let authorsList = booksMap["authors"] as! NSArray
                var authors: String = ""
                for author in authorsList {
                    let authorName : String = author["name"] as! String
                    authors = "\(authorName)\n"
                }
                let bookName : String = booksMap["title"] as! NSString as String
                let book: Book = Book(isbn: isbn, name: bookName, authors: authors)
                
                if let bookCovers = booksMap["cover"] as! NSDictionary?{
                    if(bookCovers["medium"] != nil){
                        let url = NSURL(string: bookCovers["medium"] as! NSString as String)
                        book.imageURL = url
                        book.image = UIImage(data: NSData(contentsOfURL: url!)!)
                    }
                }
                let masterViewController = self.navigationController!.viewControllers.first as! MasterViewController
                masterViewController.lastBookAdded = book
                self.navigationController?.popViewControllerAnimated(true)
                
            }else{
                errorLabel.hidden = false
                errorLabel.text = "The book doesn't exists"
            }
        } catch{
            errorLabel.hidden = false
            errorLabel.text = "There isn't internet. Check your device config"
        }
        
        
    }
}
