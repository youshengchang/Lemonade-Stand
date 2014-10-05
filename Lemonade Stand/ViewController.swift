//
//  ViewController.swift
//  Lemonade Stand
//
//  Created by yousheng chang on 10/3/14.
//  Copyright (c) 2014 InfoTech Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var dollarLabel: UILabel!
    
    @IBOutlet var lemonLabel: UILabel!
    
    @IBOutlet var iceCubeLabel: UILabel!
    
    @IBOutlet var weatherImageView: UIImageView!
    
    @IBOutlet var playerStatusView: UIView!
    
    
    @IBOutlet var purchaseView: UILabel!
    
    @IBOutlet var numberOfLemonPurchasedLabel: UILabel!
    
    
    @IBOutlet var numberOfIceCubePurchaseLabel: UILabel!
    
    
    @IBOutlet var numberOfLemonMixedLabel: UILabel!
    
    
    @IBOutlet var numberOfIceCubeMixedLabel: UILabel!
    
    var numberOfpurchasedLemon:Int = 0
    var numberOfPurchaseIceCube:Int = 0
    var totalAmountOfMoney:Float = 10
    var totalNumberOfLemons = 1
    var totalNumberOfIceCubes = 1
    var numberOfMixedLemon = 0
    var numberOfMixedIceCube = 0
    
    var customers:[Customer] = []
    var lemonDrinks:[LemonadeDrink] = []
    var weathers:[Weather] = []
    var customerPreferences:[Float] = []
    
    var todayCustomers:[Customer] = []
    
    var weatherCondition:Weather?
    
    var todayMixRange: Int = 0
    
    
    
    let customerRange1 = 1
    let customerRange2 = 2
    let customerRange3 = 3
    
    let mixRange1 = 1
    let mixRange2 = 2
    let mixRange3 = 3
    
    let cold = 1
    let mild = 2
    let warm = 3
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.createCustomer()
        self.createWeatherArray()
        self.updateStatus()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func purchaseLemoneButtonPressed(sender: UIButton) {
        
        if totalAmountOfMoney > 1.0 {
            numberOfpurchasedLemon += 1
            totalNumberOfLemons += 1
            totalAmountOfMoney -= 2
            updatePurchaseStatus()
            updateStatus()
        }else{
            showAlertWithText(message: "You don't have enough money")
        }
        
        
        
        
        
    }
    

    @IBAction func unpurchaseLemonButtonPressed(sender: UIButton) {
        if numberOfpurchasedLemon > 0
        {
            numberOfpurchasedLemon -= 1
            totalNumberOfLemons -= 1
            totalAmountOfMoney += 2
            updatePurchaseStatus()
            updateStatus()
        }else{
            showAlertWithText(message: "You don't have Lemon to return")
        }
        
    }
    
    @IBAction func purchaseIceCubeButtonPressed(sender: UIButton) {
        
        if totalAmountOfMoney > 0.0 {
            numberOfPurchaseIceCube += 1
            totalNumberOfIceCubes += 1
            totalAmountOfMoney -= 1
            updatePurchaseStatus()
        }else{
            showAlertWithText(message: "You don't have enough money")
        }
    }
    
    @IBAction func unpurchaseIceCubeButtonPressed(sender: UIButton) {
        if numberOfPurchaseIceCube > 0 {
            numberOfPurchaseIceCube -= 1
            totalNumberOfIceCubes -= 1
            totalAmountOfMoney += 1
            updatePurchaseStatus()
        }else{
            showAlertWithText(message: "You don't have ice cubes to return")
        }
        
        

    }
    
   
    @IBAction func addLemonButtonPressed(sender: UIButton) {
        if totalNumberOfLemons > 0
        {
            numberOfMixedLemon += 1
            totalNumberOfLemons -= 1
            updateMixStatus()
        }else{
            showAlertWithText(message: "You don't have lemons to mix")
        }
        
    }
    
    @IBAction func addIceCubeButtonPressed(sender: UIButton) {
        if totalNumberOfIceCubes > 0 {
            numberOfMixedIceCube += 1
            totalNumberOfIceCubes -= 1
            updateMixStatus()
        }else{
            showAlertWithText(message: "You don't have anu Ice Cubes to mix")
        }
    }
    
    @IBAction func subtractLemonButtonPressed(sender: UIButton) {
        if numberOfMixedLemon > 0{
            numberOfMixedLemon -= 1
            totalNumberOfLemons += 1
            updateMixStatus()
        }else{
            showAlertWithText(message: "You don;t have lemon left in your mix")
        }
    }
    
    @IBAction func subtractIceCubeButtonPressed(sender: UIButton) {
        if numberOfMixedIceCube > 0 {
            numberOfMixedIceCube -= 1
            totalNumberOfIceCubes += 1
            updateMixStatus()
        }else{
            showAlertWithText(message: "You don't have ice cubes in your mix")
        }
        
    }
    
    
    @IBAction func startdayButtonPressed(sender: UIButton) {
        println("\(self.customers)")
        
        todayWeather()
        println("\(self.weatherCondition)")
        self.todayCustomers = self.getTodayCustomers()
        print(self.todayCustomers)
        self.weatherImageView.image = self.weatherCondition?.weatherImage
        self.todayMixCondition()
        
        for var i = 0; i < self.todayCustomers.count; i++ {
            self.sellLemonDrink(self.todayCustomers[i])
        }
        if self.totalAmountOfMoney == 0.0 {
            showAlertWithText(header: "You Lose", message: "You don't have money to buy.")
        }else if self.totalAmountOfMoney < 10.0 {
            showAlertWithText(message: "You didn't make money")
        }else {
            showAlertWithText(header: "You Win", message: "You have made money")
        }
        self.numberOfMixedIceCube = 0
        self.numberOfMixedLemon = 0
        self.numberOfpurchasedLemon = 0
        self.numberOfPurchaseIceCube = 0
        updatePurchaseStatus()
        updateMixStatus()
        self.updateStatus()
        
    }
    
    //Helper functions
    func updateStatus(){
        self.dollarLabel.text = "$\(totalAmountOfMoney)"
        self.lemonLabel.text = "\(totalNumberOfLemons) Lemons"
        self.iceCubeLabel.text = "\(totalNumberOfIceCubes) Ice Cubes"
        self.weatherImageView.image = UIImage(named: "cold.png")
    }
    
    func updatePurchaseStatus(){
        self.numberOfLemonPurchasedLabel.text = "\(numberOfpurchasedLemon)"
        self.numberOfIceCubePurchaseLabel.text = "\(numberOfPurchaseIceCube)"
        updateStatus()
        
    }
    
    func updateMixStatus(){
        self.numberOfLemonMixedLabel.text = "\(numberOfMixedLemon)"
        self.numberOfIceCubeMixedLabel.text = "\(numberOfMixedIceCube)"
        updateStatus()
        
        
    }
    
    func showAlertWithText(header: String = "Warnning", message: String){
        
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
  
    }
    
    func createCustomer(){
        
        
        for var i = 0; i < 10; ++i {
            var customer = Customer()
            var index = Int(arc4random_uniform(UInt32(11)))
            var customerPreference = Float(arc4random_uniform(UInt32(100)))/100.0
            
            customer.preference = customerPreference
            if customer.preference < 0.4 {
                customer.customerRange = self.customerRange1
            }else if customer.preference >= 0.4 && customer.preference < 0.6 {
                customer.customerRange = self.customerRange2
            }else if customer.preference >= 0.6 && customer.preference <= 1.0 {
                customer.customerRange = self.customerRange3
            }
            else{
                customer.preference = 0
            }
            println("Customer Preference: \(customer.preference)")
            self.customers.append(customer)
            
        }
        
    
    }
    
    func createWeatherArray(){
        
        var weather1 = Weather()
        weather1.weatherCondition = weather1.cold
        weather1.weatherImage = UIImage(named: "cold.png")
        var weather2 = Weather()
        weather2.weatherCondition = weather2.mild
        weather2.weatherImage = UIImage(named: "mild.png")
        var weather3 = Weather()
        weather3.weatherCondition = weather3.warm
        weather3.weatherImage = UIImage(named: "warm.png")
        
        weathers = [weather1, weather2, weather3]
        
        
        
    }
    
    func todayWeather(){
        
        var index = Int(arc4random_uniform(UInt32(3)))
        var todayWeather = self.weathers[index]
        self.weatherCondition = todayWeather
        
        println("Today's weather: \(self.weatherCondition)")

    }
    
    func todayMixCondition(){
        var ratio = Float(Float(self.numberOfMixedLemon)/Float(self.numberOfMixedIceCube))
        
        if ratio < 0.3 {
            self.todayMixRange = self.mixRange1
        }else if ratio >= 0.3 && ratio < 0.7 {
            self.todayMixRange = self.mixRange2
        }else if ratio >= 0.7 {
            self.todayMixRange = self.mixRange3
            
        }
        
    }
    
    func getTodayCustomerNumber() -> Int {
        
        println("Today's weather: \(weatherCondition?.weatherCondition)")
        
        if weatherCondition?.weatherCondition == cold {
            return 5
        }
        else if weatherCondition?.weatherCondition == mild {
            return 7
        }
        else if weatherCondition?.weatherCondition == warm {
            return 10
        }
        else{
            return 0
        }
    }
    
    func getTodayCustomers() -> [Customer] {
        var numberOfCustomer = self.getTodayCustomerNumber()
        var customers:[Customer] = []
        
        for var i = 0; i < numberOfCustomer; i++ {
            var index = Int(arc4random_uniform(UInt32(numberOfCustomer)))
            customers.append(self.customers[index])
            println("Customer preference's Rank: \(self.customers[index].customerRange)")
            
            
        }
        
        return customers
        
    }
    
    func sellLemonDrink(customer: Customer) {
        
        println("Today's mixed rank: \(self.todayMixRange)")
        println("Today's customer preference: \(customer.customerRange)")
            
        if customer.customerRange == 1 && self.todayMixRange == 1 {
            self.totalAmountOfMoney += 2
            
        }else if customer.customerRange == 2 && self.todayMixRange == 2 {
            self.totalAmountOfMoney += 3
            
        }else if customer.customerRange == 3 && self.todayMixRange == 3 {
            self.totalAmountOfMoney += 4
        }else {
            println("No Match")
        }
    }
    
      
}

