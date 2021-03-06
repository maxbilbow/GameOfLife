// ------------------------------------------------------------------------------
//  <autogenerated>
//      This code was generated by a tool.
//      Mono Runtime Version: 4.0.30319.1
// 
//      Changes to this file may cause incorrect behavior and will be lost if 
//      the code is regenerated.
//  </autogenerated>
// ------------------------------------------------------------------------------
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.SocialPlatforms;

namespace RMX {
	
	public static class SavedData {

		static string String(string key) {
			return PlayerPrefs.HasKey(key) ? PlayerPrefs.GetString (key) : "";
		}
		
		static long Long(string key) {
			try {
				return PlayerPrefs.HasKey(key) ? (long) float.Parse(PlayerPrefs.GetString (key)) : (long) -1L;
			} catch (System.Exception e){
				if (Bugger.WillLog(RMXTests.Exceptions,e.Message))
					Debug.Log(Bugger.Last);
				return (long) -1L;
			}
		}

		static double Double(string key) {
			try {
				return PlayerPrefs.HasKey(key) ? (double) float.Parse(PlayerPrefs.GetString (key)) : (double) -1d;
			} catch (System.Exception e){
				if (Bugger.WillLog(RMXTests.Exceptions,e.Message))
					Debug.Log(Bugger.Last);
				return (double) -1d;
			}
		}

		const string TRUE = "True", FALSE = "False";

		public static T Get<T>(string key) 
		where T : System.IEquatable<T>
		{
			if (typeof(T) == typeof(bool))
				return (T)(object) Bool (key);
			if (typeof(T) == typeof(float))
				return (T)(object) Float (key);
			if (typeof(T) == typeof(int))
				return (T)(object) Int (key);
			if (typeof(T) == typeof(long))
				return (T)(object) Long (key);
			if (typeof(T) == typeof(double))
				return (T)(object) Double (key);
			if (typeof(T) == typeof(string))
				return (T)(object) String (key);
			throw new System.Exception (typeof(T).Name + " was not recognised");
		}

		public static T Get<T>(object key)
		where T : System.IEquatable<T> {
			var id = key is string ? (string) key : key.ToString();
			return Get<T> (id);

		}
		static object Bool(string key) {
			return PlayerPrefs.HasKey(key) && PlayerPrefs.GetString (key) == TRUE;
		}

		public static void Set(object key, bool value) {
			PlayerPrefs.SetString(key.ToString(), value ? TRUE : FALSE);
		}

		static int Int(string key) {
			try {
				return PlayerPrefs.HasKey(key) ? int.Parse(PlayerPrefs.GetString (key)) : (int) -1;
			} catch (System.Exception e){
//				Debug.LogWarning(e.Message);
				if (Bugger.WillLog(RMXTests.Exceptions,e.Message))
					Debug.Log(Bugger.Last);
				return (int) -1;
			}
		}

		public static void Set(object key, int value) {
			PlayerPrefs.SetString(key.ToString(), value.ToString());
		}


		public static float Float(string key) {
			try {
				return PlayerPrefs.HasKey(key) ? float.Parse(PlayerPrefs.GetString (key)) : (float) -1f;
			} catch (System.Exception e){
//				Debug.LogWarning(e.Message);
				if (Bugger.WillLog(RMXTests.Exceptions,e.Message))
				    Debug.Log(Bugger.Last);
				return (float) -1f;
			}
		}
		
		public static void Set(object key, float value) {
			PlayerPrefs.SetString(key.ToString(), value.ToString());
		}


	}
}
