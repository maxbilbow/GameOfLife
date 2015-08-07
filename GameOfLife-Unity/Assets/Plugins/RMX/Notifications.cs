using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace RMX {



	public class Notifications : Singletons.ASingleton<Notifications> , EventListener {
		static Dictionary<string,EventListener> earlyListeners = new Dictionary<string,EventListener> ();
		Dictionary<string,EventListener> lateListeners;
		static Dictionary<string,EventListener> Listeners {
			get {
				return IsInitialized ? current.lateListeners : earlyListeners;
			}
		}

		static Dictionary<IEvent,EventStatus> earlyEvents = new Dictionary<IEvent,EventStatus>();
		Dictionary<IEvent,EventStatus> events;

		static Dictionary<IEvent,EventStatus> Events {
			get {
				return IsInitialized ? current.events : earlyEvents;
			}
		}

		bool _setupComplete = false;

		protected override bool SetupComplete {
			get { 
				return _setupComplete;
			}
		}


		void Start() {
//			Debug.LogWarning ("Listeners: " + Listeners.Count);
			lateListeners = earlyListeners;
			earlyListeners = null;
			events = earlyEvents;
			earlyEvents = null;
			_setupComplete = true;
			Debug.Log ("Listeners: " + Listeners.Count);
		}

		public static bool HasListener(EventListener listener) {
			return Listeners.ContainsValue (listener);
		}
		public static void Reset(Event theEvent) {
			Events[theEvent] = EventStatus.Idle;
		}

		public static void AddListener(EventListener listener) {
			Listeners[listener.GetType().Name] = listener;
			if (Bugger.WillLog (Testing.EventCenter, listener.GetType () + " was added to Listeners ("+ Listeners.Count + ")"))
				Debug.Log (Bugger.Last);

		}

		public static EventStatus StatusOf(IEvent theEvent) {
			return Events.ContainsKey(theEvent) ? Events [theEvent] : EventStatus.Idle;
		}

		public static bool IsIdle(IEvent theEvent) {
			return StatusOf (theEvent) == EventStatus.Idle;
		}
	
		public static bool IsActive(IEvent theEvent) {
			return StatusOf (theEvent) == EventStatus.Active;
		}

		public static void EventDidOccur(IEvent e) {
			EventDidOccur (e, null);
		}

		public static void EventDidOccur(IEvent theEvent, object o) {
			var listeners = Listeners;
			Events [theEvent] = o is EventStatus ? (EventStatus) o : EventStatus.Completed;
			foreach (KeyValuePair<string, EventListener> listener in listeners) {
				listener.Value.OnEvent(theEvent,o);
			}
		}


		public static bool WasCompleted(IEvent theEvent) {
			return StatusOf (theEvent) == EventStatus.Completed;
		}

		public static void EventWillStart(IEvent theEvent) {
			EventWillStart (theEvent, null);
		}

		public static void EventWillStart(IEvent theEvent, object o) {
			if (!IsActive (theEvent)) {
				Events [theEvent] = o is EventStatus ? (EventStatus) o : EventStatus.Active;
				foreach (KeyValuePair<string, EventListener> listener in Listeners) {
					listener.Value.OnEventDidStart (theEvent, o);
				}
			}
		}
		public static void EventDidEnd(IEvent theEvent) {
			EventDidEnd (theEvent, null);
		}
		public static void EventDidEnd(IEvent theEvent, object o) {
			var listeners = Listeners;
			Events [theEvent] = Events [theEvent] = o is EventStatus ? (EventStatus) o : EventStatus.Completed;
			foreach (KeyValuePair<string, EventListener> listener in listeners) {
				listener.Value.OnEventDidEnd(theEvent,o);
			}
		}

		public static void NotifyListeners(string message) {
			foreach (KeyValuePair<string, EventListener> listener in Listeners) {
				listener.Value.SendMessage (message, SendMessageOptions.DontRequireReceiver);
			}
		}

	
	
	}






}