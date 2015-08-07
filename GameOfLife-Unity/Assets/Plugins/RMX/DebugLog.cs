using UnityEngine;


namespace RMX {

	public class Testing {

		public static string Misc = "Misc";
		public static string GameCenter = "GameCenter";
		public static string Achievements = "Achievements";
		public static string Exceptions = "Exceptions";

		public static string Singletons = "Singletons";
		public static string Patches = "Patches";
		public static string Database = "Database";
		public static string EventCenter = "EventCenter";
	}

public class DebugLog {
	private string log = "";
	
	
	public DebugLog(string feature, string message) {
		this.feature = feature;
		this.message = message;
	}
	
	
	public DebugLog(string feature) {
		this.feature = feature;
	}
	
	public DebugLog() {
		this.feature = Testing.Misc;
	}
	
	public string message {
		get {
			return log;
		} set {
			log = Bugger.WillTest(this.feature) ? value : "";
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
			return Bugger.WillTest(this.feature);
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
			if (!Bugger.IsInitialized)
					Bugger.AddLateLog(feature,message);
			else if (Singletons.SettingsInitialized && Singletons.Settings.PrintToScreen) 
				Bugger.current.AddToQueue(log);
		} else {
			log = null;
		}
		Clear ();
		return log;
	}
}
}