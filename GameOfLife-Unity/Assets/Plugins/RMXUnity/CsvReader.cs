/// <summary>
/// Author: Mario Di Vece <mario@unosquare.com>
/// Date: 3/19/2014
/// Updated: 9/18/2014
/// License: MIT
/// </summary>



namespace RMX
{

	using System;
	using System.Collections.Generic;
	using System.Text;
	using System.Linq;
	using UnityEngine;
	
	/// <summary>
	/// A simple class to read small CSV files
	/// Do not attempt to read very large files with this because
	/// the entire contents of the file are read at once. Also,
	/// The result is produced at once.
	/// </summary>
	public static class CsvReader
	{
		private const char DoubleQuote = '"';
		private const char Comma = ',';
		static public readonly Encoding Windows1252Encoding = Encoding.GetEncoding(1252);
		


		public static string ToString(List<string> record)
		{
			return string.Join(",", record.Select(s => string.Format("\"{0}\"", s.Replace("\"", "\"\""))).ToArray());
		}


		/// <summary>
		/// Defines the 3 different read states
		/// </summary>
		private enum ReadState
		{
			WaitingForNewField,
			PushingNormal,
			PushingQuoted,
		}
		
		/// <summary>
		/// Parses the specified CSV string into a CsvRecordList.
		/// </summary>
		/// <param name="csvString">The CSV string.</param>
		/// <returns></returns>
		static public List<List<string> > Parse(string csvString)
		{
			var records = new List<List<string> >();
			{
				var lines = csvString.Split(new string[] { "\r", "\n" }, StringSplitOptions.RemoveEmptyEntries);
				foreach (var line in lines)
				{
					if (string.IsNullOrEmpty(line))//TODO: account for whitespace
						continue;
					records.Add(CsvReader.ParseLine(line.Trim()));
				}
			}
			
			return records;
		}

		/// <summary>
		/// Reads the CSV records from specified path at once.
		/// </summary>
		/// <param name="path">The path.</param>
		/// <returns></returns>
		static public List<List<string> > Read(TextAsset file)
		{
			if (file == null)
				throw new System.NullReferenceException ("Database file is null");
			var csvLines = file.text.Split ('\n');//System.IO.File.ReadAllLines(path, encoding);
			var csvRecords = new List<List<string> >();
			
			for (var lineIndex = 0; lineIndex < csvLines.Length; lineIndex++)
			{
				var currentLine = csvLines[lineIndex];
				var record = ParseLine(currentLine);
				csvRecords.Add(record);
			}
			
			return csvRecords;
		}

		/// <summary>
		/// Reads the CSV records from specified path at once.
		/// </summary>
		/// <param name="path">The path.</param>
		/// <returns></returns>
		static public List<List<string> > Read(string path)
		{
			throw new System.Exception ("Balls.");
//			return Read(path, Encoding.UTF8);

		}
		
		/// <summary>
		/// Reads a single line from the the currently open reader.
		/// If a reader
		/// </summary>
		/// <param name="reader">The reader.</param>
		/// <returns></returns>
		static public List<string> ReadLine(System.IO.StreamReader reader)
		{
			string line = null;
			if ((line = reader.ReadLine()) != null)
			{
				return ParseLine(line);
			}
			
			return null;
		}
		
		/// <summary>
		/// Reads the specified csv file in the given file path.
		/// </summary>
		/// <param name="path">The path.</param>
		/// <param name="encoding">The encoding.</param>
		/// <returns></returns>
		static public List<List<string> > Read(string path, Encoding encoding)
		{
			throw new System.Exception("Depricated");
//
//			var csvLines = System.IO.File.ReadAllLines(path, encoding);
//			var csvRecords = new List<List<string> >();
//			
//			for (var lineIndex = 0; lineIndex < csvLines.Length; lineIndex++)
//			{
//				var currentLine = csvLines[lineIndex];
//				var record = ParseLine(currentLine);
//				csvRecords.Add(record);
//			}
//			
//			return csvRecords;
		}
		
		/// <summary>
		/// Parses the line into a list of strings.
		/// </summary>
		/// <param name="line">The line.</param>
		/// <returns></returns>
		public static List<string> ParseLine(string line)
		{
			var values = new List<string>();
			var currentValue = new StringBuilder(1024);
			char currentChar;
			Nullable<char> nextChar = null;
			var currentState = ReadState.WaitingForNewField;
			
			for (var charIndex = 0; charIndex < line.Length; charIndex++)
			{
				// Get the current and next character
				currentChar = line[charIndex];
				nextChar = charIndex < line.Length - 1 ? line[charIndex + 1] : new Nullable<char>();
				
				// Perform logic based on state and decide on next state
				switch (currentState)
				{
				case ReadState.WaitingForNewField:
				{
					currentValue.Length = 0;//.Clear();
					if (currentChar == DoubleQuote)
					{
						currentState = ReadState.PushingQuoted;
						continue;
					}
					else if (currentChar == Comma)
					{
						values.Add(currentValue.ToString());
						currentState = ReadState.WaitingForNewField;
						continue;
					}
					else
					{
						currentValue.Append(currentChar);
						currentState = ReadState.PushingNormal;
						continue;
					}
				}
				case ReadState.PushingNormal:
				{
					// Handle field content delimiter by comma
					if (currentChar == Comma)
					{
						currentState = ReadState.WaitingForNewField;
						values.Add(currentValue.ToString().Trim());
						currentValue.Length = 0;//();
						continue;
					}
					
					// Handle double quote escaping
					if (currentChar == DoubleQuote && nextChar == DoubleQuote)
					{
						// advance 1 character now. The loop will advance one more.
						currentValue.Append(currentChar);
						charIndex++;
						continue;
					}
					
					currentValue.Append(currentChar);
					break;
				}
				case ReadState.PushingQuoted:
				{
					// Handle field content delimiter by ending double quotes
					if (currentChar == DoubleQuote && nextChar != DoubleQuote)
					{
						currentState = ReadState.PushingNormal;
						continue;
					}
					
					// Handle double quote escaping
					if (currentChar == DoubleQuote && nextChar == DoubleQuote)
					{
						// advance 1 character now. The loop will advance one more.
						currentValue.Append(currentChar);
						charIndex++;
						continue;
					}
					
					currentValue.Append(currentChar);
					break;
				}
					
				}
				
			}
			
			// push anything that has not been pushed (flush)
			values.Add(currentValue.ToString().Trim());
			return values;
		}
	}

	public class CsvRecord : List<string>
	{
		public override string ToString()
		{
			return string.Join(",", this.Select(s => string.Format("\"{0}\"", s.Replace("\"", "\"\""))).ToArray());
		}
	}
}