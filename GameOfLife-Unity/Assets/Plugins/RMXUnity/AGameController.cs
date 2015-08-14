using UnityEngine;
using System.Collections;

namespace RMX {

	public interface IGameController : ISingleton {
		void PauseGame (bool pause, object args = null);
		void Patch();
		
		bool DebugHUD { get; }
		TextAsset Database { get; }
		bool IsDebugging(System.Enum feature);
		float MaxDisplayTime { get;}
		bool BuildForRelease { get;}
	}

	public abstract class AGameController<T> : Singletons.ASingleton<T> , IGameController
	where T : AGameController<T> , IGameController {
		public bool _buildForRelease;
		public bool BuildForRelease {
			get {
				return _buildForRelease;
			}
		}
		public bool _debugHUD;
		public bool safeMode;
		public float _maxDisplayTime = 5f;
		public bool DebugMisc;
		public bool DebugEarlyInits;
		public bool DebugGameCenter;
		public bool DebugAchievements;
		public bool DebugExceptions;
		public bool DebugSingletons;
		public bool DebugGameDataLists;
		public bool DebugDatabase;
		public bool DebugPatches;
		public bool DebugEvents;
		public bool ClearAchievementsOnLoad;


		public Font mainFont;
		public Color backgroundColor = Color.black;
		public Color textColor = Color.white;
		
		public bool DebugHUD {
			get {
				return _debugHUD;
			}
		}
		public TextAsset _database;
		public TextAsset Database { 
			get { 
				return _database;
			} 
		}
		
		public float MaxDisplayTime { 
			get {
				return _maxDisplayTime;
			}
		}


		public Vector2 defaultGravity = new Vector2 (0f, -9.81f);

		protected void Start() {
			PreStart ();
			if (!safeMode) {
				if (DebugHUD) {
					Bugger.Initialize ();
				}
				Physics2D.gravity = defaultGravity;
				WillBeginEvent (Event.SingletonInitialization);
				StartSingletons ();
				#if MOBILE_INPUT
				StartMobile ();
				#else
				StartDesktop();
				#endif
				DidFinishEvent (Event.SingletonInitialization);
			}
			PostStart ();
		}

		/// <summary>
		/// Do at beginnig of Start block
		/// </summary>
		protected virtual void PreStart () {}

		/// <summary>
		/// Do at end of Start block
		/// </summary>
		protected virtual void PostStart () {}

		/// <summary>
		/// Initialise any additional singletons here, especially if they are essential to the workings of your game
		/// NOT called automatically in Safe Mode
		/// </summary>
		protected abstract void StartSingletons ();

		/// <summary>
		/// Initialise any Destop specific settings here
		/// NOT called automatically in Safe Mode
		/// </summary>
		protected abstract void StartDesktop ();

		/// <summary>
		/// Initialise any Mobile specific settings here
		/// NOT called automatically in Safe Mode
		/// </summary>
		protected abstract void StartMobile ();

		/// <summary>
		/// Initiate any pre-load update patches here.
		/// </summary>
		public abstract void Patch ();
		
		
		public abstract void PauseGame (bool pause, object args);
	
		public static bool ShouldDebug(System.Enum feature) {
			if (Singletons.GameControllerInitialized) {
				return _current.IsDebugging(feature);
			}
			throw new UnityException ("Setting should be initialized by now (Testing: " + feature);
			
		}

		/// <summary>
		/// Determines whether this instance is debugging the specified feature by matching it's toString value.
		/// </summary>
		/// <returns><c>true</c> if this instance is debugging the specified feature; otherwise, <c>false</c>.</returns>
		/// <param name="feature">Feature.</param>
		public virtual bool IsDebugging(System.Enum feature){
			if (_buildForRelease)
				return false;
			else if (feature.Equals(RMXTests.Misc))
				return DebugMisc;
			else if (feature.Equals(RMXTests.GameCenter))
				return DebugGameCenter;
			else if (feature.Equals(RMXTests.Achievements))
				return DebugAchievements;
			else if (feature.Equals(RMXTests.Exceptions))
				return DebugExceptions;
			else if (feature.Equals(RMXTests.Singletons))
				return DebugSingletons;
			else if (feature.Equals(RMXTests.Patches))
				return DebugPatches;
			else if (feature.Equals(RMXTests.Database))
				return DebugDatabase;
			else if (feature.Equals(RMXTests.EventCenter))
				return DebugEvents;
			else if (feature.Equals(RMXTests.EarlyInits))
				return DebugEarlyInits;
			else
				Debug.LogWarning (feature.ToString () + " has not been recorded in Settings.IsTesting(feature)");
			return false;
		}
		
	}
}