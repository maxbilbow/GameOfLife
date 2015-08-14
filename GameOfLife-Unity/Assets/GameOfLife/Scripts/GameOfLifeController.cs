using UnityEngine;
using System.Collections;
using UnityEngine.EventSystems;
using RMX;

public class GameOfLifeController : AGameController<GameOfLifeController> {

	public int diameter = 5;

	public Color color = Color.yellow;
	public Sprite sprite;

	private GameOfLife life;
		
	/// SKNodes that mirror bools in The Game of Life
	private Cell[,] cells;

	private bool cameraWillMove = true;

	protected override void StartDesktop ()
	{

	}

	protected override void StartMobile ()
	{

	}

	protected override void StartSingletons ()
	{

	}


	public override void Patch ()
	{

	}

	public override void PauseGame (bool pause, object args)
	{

	}
	// Use this for initialization
	protected override void PostStart() {
		int w = (int) Screen.width / diameter; 
		int h = (int) Screen.height / diameter;// Camera.current.pixelWidth / diameter; var h = Camera.current.pixelHeight / diameter;
		print ("height: " + h + ", width: " + w);
		this.life = GameOfLife.New (w, h);
		this.cells = new Cell[h, w];
		for (int y = 0; y < this.life.height; ++y ) {
			for (int x = 0; x < this.life.width; ++x ) {
				var cell = new GameObject().AddComponent<Cell>().Init(this.life, x, y, this.diameter, this.sprite);
				cell.gameObject.transform.SetParent(this.transform);
				this.cells[y,x] = cell;
			}
		}

	}

	// Update is called once per frame
	void Update () {

		if (cameraWillMove) {
			try {
				Camera.current.transform.position = new Vector3 (Screen.width / 2, Screen.height / 2, Camera.current.transform.position.z);
				cameraWillMove = false;
			} catch {

			}
		}
		if (this.life != null && this.cells != null) {
			this.life.Step();
			for (int y = 0; y < this.life.height; ++y ) {
				for (int x = 0; x < this.life.width; ++x ) {
					this.cells[y,x].CheckState();
				}
			}
		}
	}


	public class Cell : MonoBehaviour, IPointerDownHandler {
		GameObject node { // = new GameObject();
			get {
				return this.gameObject;
			}
		}
		SpriteRenderer shape;
		int x;
		int y;
		GameOfLife life;

		public Cell Init(GameOfLife life, int x, int y, int diameter, Sprite sprite) {
			this.x = x;
			this.y = y;
			this.life = life;
			this.node.transform.localPosition = new Vector3(x * diameter - diameter, y * diameter - diameter, 0);
			this.node.transform.localScale = new Vector3(diameter,diameter,0);
			this.shape = this.node.AddComponent<SpriteRenderer>();
			this.node.AddComponent<BoxCollider2D> ();
			this.shape.sprite = sprite;
			return this;
		}

		public void OnPointerDown(PointerEventData data) {
			this.ReviveNodeAndNeighbours (2);
			print (data.pressPosition);
		}

		public void CheckState() {
			this.shape.enabled = this.life.field.Alive (x, y);
		}

		
		/// Enables simple interaction with the game
		/// Touching a node will enable it.
		/// For each of it's neighbours there will be a one in 'chance' of it also being activated. Default is 1 in 2.
		public void ReviveNodeAndNeighbours(int chance) {
			for (int i = -1; i <= 1; i++) {
				for (int j = -1; j <= 1; j++) {
					int X = x + i; int Y = y + j;
					if (Random.Range(0, chance) == 1 && j != 0 || i != 0 && X >= 0 && X < this.life.width && Y >= 0 && Y < this.life.height ) {
						this.life.field.Set(X, Y, true);
					}
				}
			}

			this.CheckState ();
		}


	}
}
