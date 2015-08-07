// ------------------------------------------------------------------------------
//  <autogenerated>
//      This code was generated by a tool.
//      Mono Runtime Version: 4.0.30319.1
// 
//      Changes to this file may cause incorrect behavior and will be lost if 
//      the code is regenerated.
//  </autogenerated>
// ------------------------------------------------------------------------------
using System;
using UnityEngine;
namespace RMX
{
	public interface EventListener {
		void OnEvent(IEvent theEvent, object args);
		void OnEventDidStart(IEvent theEvent, object args);
		void OnEventDidEnd(IEvent theEvent, object args);
		void SendMessage(string message, SendMessageOptions sendMessageOptions);
		string name { get; }
	}
	
	public enum EventStatus {
		Active, Completed, Idle, Success, Failure, ForceNewEvent
	}

	public interface IEvent {
		string Type {get;}
		EventStatus Status {get;}
		bool IsType (IEvent theEvent);
		bool HasStatus (EventStatus status) ;
	}

	public class Events {

		public static Event SingletonInitialization	 = new Event("SingletonInitialization");

		public static Event ScreenBecameEmpty		 = new Event("ScreenBecameEmpty");
		public static Event PauseSession			 = new Event("PauseSession");
		public static Event ResumeSession			 = new Event("ResumeSession");
		public static Event GC_AchievementGained	 = new Event("GC_AchievementGained");
		public static Event GC_UserAuthentication	 = new Event("GC_UserAuthentication");

	}

	public class Event : IEvent {
		string _type;
		public string Type {
			get {
				return _type;
			}
		}
		EventStatus _status;
		public EventStatus Status {
			get {
				return _status;
			}
		}

		public Event(string type) {
			this._type = type;
			this._status = EventStatus.Idle;
		}

		public bool IsType(IEvent theEvent) {
			return theEvent.Type == this.Type;
		}

		public bool HasStatus(EventStatus status) {
			return this.Status == status;
		}


	}
//	public enum EventType {
//		SingletonInitialization,
//		ClockIsAboutToBurst,
//		ScreenBecameEmpty,
//		SomethingBurst,
//		PauseSession, ResumeSession,
//		GC_AchievementGained,
//		GC_UserAuthentication,
//		SpawnMultipleClocks,
//		SpawnInflatableClock
//		
//	}
}

