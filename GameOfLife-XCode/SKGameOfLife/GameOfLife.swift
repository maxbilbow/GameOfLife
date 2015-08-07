//
//  GameOfLife.swift
//  ShakespeareLogic
//
//  Created by Max Bilbow on 02/07/2015.
//  Copyright © 2015 Rattle Media. All rights reserved.
//

import Foundation

// Field represents a two-dimensional field of cells.
struct Field {
    var s: [[Bool]]
    var w, h: Int
    
    // NewField returns an empty field of the specified width and height.
    static func new(width w: Int, height h: Int) -> Field {
        var result: [[Bool]] = [[Bool]]()
        for var i = 0; i < h; ++i {
            var boolArray = [Bool]()
            for var j = 0; j < w; ++j {
                boolArray.append(false)
            }
            result.append(boolArray)
        }
        return Field(s: result, w: w, h: h)
    }
    
    // Set sets the state of the specified cell to the given value.
    mutating func set(x: Int, y: Int, b: Bool) {
        self.s[y][x] = b
    }
    
    // Alive reports whether the specified cell is alive.
    // If the x or y coordinates are outside the field boundaries they are wrapped
    // toroidally. For instance, an x value of -1 is treated as width-1.
    func alive(var x: Int, var y: Int) -> Bool {
        x += self.w
        x %= self.w
        y += self.h
        y %= self.h
        return self.s[y][x]
    }
    
    // Next returns the state of the specified cell at the next time step.
    func next(x: Int, y: Int) -> Bool {
        // Count the adjacent cells that are alive.
        var alive = 0
        for var i = -1; i <= 1; i++ {
            for var j = -1; j <= 1; j++ {
                if (j != 0 || i != 0) && self.alive(x+i, y: y+j) {
                    alive++
                }
            }
        }
        // Return next state according to the game rules:
        //   exactly 3 neighbors: on,
        //   exactly 2 neighbors: maintain current state,
        //   otherwise: off.
        return alive == 3 || alive == 2 && self.alive(x, y: y)
    }
    
}

// Life stores the state of a round of Conway's Game of Life.
class Life : CustomStringConvertible {
    var a, b: Field
    var w, h: Int
    
    init(fieldA a: Field, fildB b: Field, width w: Int, height h: Int){
        self.a = a
        self.b = b
        self.w = w
        self.h = h
    }
    
    
    // NewLife returns a new Life game state with a random initial state.
    class func new(width: CGFloat, height: CGFloat) -> Life {
        let w = Int(width); let h = Int(height)
        var a: Field = Field.new(width: w, height: h)
        for var i = 0; i < (w * h / 4); i++ {
            a.set(random() % w,y: random() % h, b: true)
        }
        return Life(fieldA: a, fildB: Field.new(width: w, height: h), width: w, height: h)
    }
    
    // NewLife returns a new Life game state with a random initial state.
    class func new(width w: Int, height h: Int) -> Life {
        var a: Field = Field.new(width: w, height: h)
        for var i = 0; i < (w * h / 4); i++ {
            a.set(random() % w,y: random() % h, b: true)
        }
        return Life(fieldA: a, fildB: Field.new(width: w, height: h), width: w, height: h)
    }
    
    // Step advances the game by one instant, recomputing and updating all cells.
    func step() {
        // Update the state of the next field (b) from the current field (a).
        for var y = 0; y < self.h; y++ {
            for var x = 0; x < self.w; x++ {
                self.b.set(x, y: y, b: self.a.next(x, y: y))
            }
        }
        // Swap fields a and b.
        let temp = self.a
        self.a = self.b
        self.b = temp
    }
    
    // String returns the game board as a string.
    var description: String {
        var buf: String = ""//bytes.Buffer
        for var y = 0; y < self.h; y++ {
            for var x = 0; x < self.w; x++ {
                var b: String = " " //byte(" ")
                if self.a.alive(x, y: y) {
                    b = "*"
                }
                buf += b //.WriteByte(b)
            }
            buf += "\n" //.WriteByte("\n")
        }
        return buf//.String()
    }
}


