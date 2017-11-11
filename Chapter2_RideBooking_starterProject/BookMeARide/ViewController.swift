
import UIKit
import Intents

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var from: UITextField?
    @IBOutlet weak var to: UITextField?
    @IBOutlet weak var ridesTableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "RouteCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "RouteCell")
        }
        
        return cell!
    }
    
    // MARK: IBAction
    
    @IBAction func findRouteButtonClicked() {
        
    }
}

