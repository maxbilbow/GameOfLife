using UnityEngine;
using System.Collections;

/// Life stores the state of a round of Conway's Game of Life.
/// Adapted from example on Go programming website.
public class GameOfLife  {
	Field a, b;
	int w, h;

	public int width {
		get {
			return this.w;
		}
	}

	public int height {
		get {
			return this.h;
		}
	}

	public Field field {
		get {
			return this.a;
		}
	}
			
	public GameOfLife(Field a, Field b, int w, int h) {
		this.a = a;
		this.b = b;
		this.w = w;
		this.h = h;
	}
	
	/// NewLife returns a new Life game state with a random initial state.
	public static GameOfLife New(int w, int h)  {
		Field a = Field.New(w, h);
		for (int i = 0; i < (w * h / 4); i++){
			int X = Random.Range(0, w);
			int Y = Random.Range(0, h);
			a.Set(X, Y, true);
		}
		return new GameOfLife (a, Field.New (w, h), w, h);
	}
	
	/// Step advances the game by one instant, recomputing and updating all cells.
	public void Step() {
		// Update the state of the next field (b) from the current field (a).
		for (int y = 0; y < this.h; y++) {
			for (int x = 0; x < this.w; x++) {
				this.b.Set(x, y, this.a.Next(x, y));
			}
		}
		// Swap fields a and b.
		var temp = this.a;
		this.a = this.b;
		this.b = temp;
	}
	
	/// String returns the game board as a string.
	public override string ToString() {
		string buf = "";//bytes.Buffer
		for (int y = 0; y < this.h; y++ ){
			for (int x = 0; x < this.w; x++ ){
				string b = " "; //byte(" ")
				if (this.a.Alive(x, y)){
					b = "*";
				}
				buf += b; //.WriteByte(b)
			}
			buf += "\n"; //.WriteByte("\n")
		}
		return buf;//.String()
	}

	public class Field {
		/// Field represents a two-dimensional field of cells.
		bool[,] s;
		int w, h;
		
		public Field(bool[,] s, int w, int h) {
			this.s = s;
			this.w = w;
			this.h = h;
		}
		/// NewField returns an empty field of the specified width and height.
		public static Field New(int w, int h) {
			bool[,] result = new bool[h,w];
			for (int i = 0; i < h; ++i ){
				for (int j = 0; j < w; ++j) {
					result[i,j] = false;
				}
			}
			return new Field(result, w, h);
		}
		
		/// Set sets the state of the specified cell to the given value.
		public void Set(int x, int y, bool b) {
			this.s [y, x] = b;
		}
		
		/// Alive reports whether the specified cell is alive.
		/// If the x or y coordinates are outside the field boundaries they are wrapped
		/// toroidally. For instance, an x value of -1 is treated as width-1.
		public bool Alive(int x, int y) {
			x += this.w;
			x %= this.w;
			y += this.h;
			y %= this.h;
			return this.s[y, x];
		}
		
		/// Next returns the state of the specified cell at the next time step.
		public bool Next(int x, int y) {
			// Count the adjacent cells that are alive.
			int alive = 0;
			for (int i = -1; i <= 1; i++) {
				for (int j = -1; j <= 1; j++) {
					if ((j != 0 || i != 0) && this.Alive(x+i, y+j)) {
						alive++;
					}
				}
			}
			// Return next state according to the game rules:
			//   exactly 3 neighbors: on,
			//   exactly 2 neighbors: maintain current state,
			//   otherwise: off.
			return alive == 3 || alive == 2 && this.Alive(x, y);
		}
		
	}
}