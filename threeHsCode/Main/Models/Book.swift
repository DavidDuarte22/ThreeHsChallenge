//
//  Book.swift
//  threeHsCode
//
//  Created by David Duarte on 21/09/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import Foundation
//id, el autor, el nombre, la disponibilidad, una imagen y la popularidad
struct Book: Codable {
    var id: Int
    var nombre: String
    var autor: String
    var disponibilidad: Bool
    var popularidad: Int
    var imagen: String
    
    init(id: Int, nombre: String, autor: String, disponibilidad: Bool, popularidad: Int, imagen: String) {
        self.id = id
        self.nombre = nombre
        self.autor = autor
        self.disponibilidad = disponibilidad
        self.popularidad = popularidad
        self.imagen = imagen
    }
}

/*
{
    "id": 1,
    "nombre": "The design of every day things",
    "autor": "Don Norman",
    "disponibilidad": true,
    "popularidad": 70,
    "imagen":"https://images-na.ssl-images-amazon.com/images/I/410RTQezHYL._SX326_BO1,204,203,200_.jpg"
},
*/
