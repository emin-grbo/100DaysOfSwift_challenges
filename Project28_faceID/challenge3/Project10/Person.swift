//
//  Person.swift
//  Project10
//
//  Created by roblack on 18/08/2016.
//  Copyright © 2019 roblack. All rights reserved.
//

import UIKit

class Person: NSObject, Codable {
    
	var name: String
	var image: String

	init(name: String, image: String) {
		self.name = name
		self.image = image
	}
}
