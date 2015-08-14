//using UnityEngine;

/*
namespace RMX.Deprecated {


	 class DebugLog {
		private string log = "";
		
		
		public DebugLog(string feature, string message) {
//			if (!Singletons.SettingsInitialized || !Bugger.IsInitialized)
				throw new System.Exception ("Settings and DeBugger must be initialized before a DebugLog object is created. Log is: \n" + feature + ": " + message);
			this.feature = feature;
			this.message = message;
		}
		
		
		public DebugLog(string feature) {
//			if (!Singletons.SettingsInitialized || !Bugger.IsInitialized)
				throw new System.Exception ("Settings and DeBugger must be initialized before a DebugLog object is created. Log is for: " + feature);
			this.feature = feature;
		}
		
		public DebugLog() {
//			if (!Singletons.SettingsInitialized || !Bugger.IsInitialized)
				throw new System.Exception ("Settings and DeBugger must be initialized before a DebugLog object is created");
			this.feature = Testing.Misc;
		}
		
		public string message {
			get {
				return log;
			} set {
				log = value;
			}
		}

		public bool Set(string feature, string message) {
			if (Singletons.Settings.IsDebugging(feature)) {
				this.feature = feature;
				this.message = message;
				return true;
			}
			return false;
		}
		
		public string feature = Testing.Misc;
		
		public void Clear() {
			log = "";
		}
		
		public bool isActive {
			get {
				if (Singletons.Settings == null) 
					throw new UnityException("Settings should be initialized before using DebubLog()");
				else
					return Singletons.Settings.IsDebugging(this.feature);
			}
		}

		public void Start(string feature) {
			this.feature = feature;
			this.log = "";
		}
		
		private string color {
			get {
				if (this.feature == Testing.Exceptions)
					return "red";
				else if (this.feature == Testing.GameCenter)
					return "yellow";
				else if (this.feature == Testing.Patches)
					return "green";
				else
					return "blue";
			}	
		}
		
		
		
		private string ProcessLog() {
			string header = "<color=" + color + ">" + this.feature + ": </color>\n";
			
			return header + TextFormatter.Format (this.message);
		}

		public override string ToString() {
			string log;// = this.log;
			if (isActive) {
				log = ProcessLog();
				if (Singletons.Settings.PrintToScreen) 
					Bugger.current.AddToQueue(log);
			} else {
				log = null;
			}
			Clear ();
			return log;
		}
	}
}

*/