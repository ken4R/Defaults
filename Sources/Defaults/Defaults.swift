// MIT License © Sindre Sorhus
import Foundation

public final class Defaults {
	public class Keys {
		public typealias Key = Defaults.Key

		@available(iOS 11.0, macOS 10.13, tvOS 11.0, watchOS 4.0, iOSApplicationExtension 11.0, macOSApplicationExtension 10.13, tvOSApplicationExtension 11.0, watchOSApplicationExtension 4.0, *)
		public typealias NSSecureCodingKey = Defaults.NSSecureCodingKey

		public typealias OptionalKey = Defaults.OptionalKey

		@available(iOS 11.0, macOS 10.13, tvOS 11.0, watchOS 4.0, iOSApplicationExtension 11.0, macOSApplicationExtension 10.13, tvOSApplicationExtension 11.0, watchOSApplicationExtension 4.0, *)
		public typealias NSSecureCodingOptionalKey = Defaults.NSSecureCodingOptionalKey

		fileprivate init() {}
	}

	public final class Key<Value: Codable>: Keys {
		public let name: String
		public let defaultValue: Value
		public let suite: UserDefaults

		/// Create a defaults key.
		public init(_ key: String, default defaultValue: Value, suite: UserDefaults = .standard) {
			self.name = key
			self.defaultValue = defaultValue
			self.suite = suite

			super.init()

			// Sets the default value in the actual UserDefaults, so it can be used in other contexts, like binding.
			if UserDefaults.isNativelySupportedType(Value.self) {
				suite.register(defaults: [key: defaultValue])
			} else if let value = suite._encode(defaultValue) {
				suite.register(defaults: [key: value])
			}
		}
	}

	@available(iOS 11.0, macOS 10.13, tvOS 11.0, watchOS 4.0, iOSApplicationExtension 11.0, macOSApplicationExtension 10.13, tvOSApplicationExtension 11.0, watchOSApplicationExtension 4.0, *)
	public final class NSSecureCodingKey<Value: NSSecureCoding>: Keys {
		public let name: String
		public let defaultValue: Value
		public let suite: UserDefaults

		/// Create a defaults key.
		public init(_ key: String, default defaultValue: Value, suite: UserDefaults = .standard) {
			self.name = key
			self.defaultValue = defaultValue
			self.suite = suite

			super.init()

			// Sets the default value in the actual UserDefaults, so it can be used in other contexts, like binding.
			if UserDefaults.isNativelySupportedType(Value.self) {
				suite.register(defaults: [key: defaultValue])
			} else if let value = try? NSKeyedArchiver.archivedData(withRootObject: defaultValue, requiringSecureCoding: true) {
				suite.register(defaults: [key: value])
			}
		}
	}

	public final class OptionalKey<Value: Codable>: Keys {
		public let name: String
		public let suite: UserDefaults

		/// Create an optional defaults key.
		public init(_ key: String, suite: UserDefaults = .standard) {
			self.name = key
			self.suite = suite
		}
	}

	@available(iOS 11.0, macOS 10.13, tvOS 11.0, watchOS 4.0, iOSApplicationExtension 11.0, macOSApplicationExtension 10.13, tvOSApplicationExtension 11.0, watchOSApplicationExtension 4.0, *)
	public final class NSSecureCodingOptionalKey<Value: NSSecureCoding>: Keys {
		public let name: String
		public let suite: UserDefaults

		/// Create an optional defaults key.
		public init(_ key: String, suite: UserDefaults = .standard) {
			self.name = key
			self.suite = suite
		}
	}

	fileprivate init() {}

	/// Access a defaults value using a `Defaults.Key`.
	public static subscript<Value: Codable>(key: Key<Value>) -> Value {
		get { key.suite[key] }
		set {
			key.suite[key] = newValue
		}
	}

	/// Access a defaults value using a `Defaults.NSSecureCodingKey`.
	@available(iOS 11.0, macOS 10.13, tvOS 11.0, watchOS 4.0, iOSApplicationExtension 11.0, macOSApplicationExtension 10.13, tvOSApplicationExtension 11.0, watchOSApplicationExtension 4.0, *)
	public static subscript<Value: NSSecureCoding>(key: NSSecureCodingKey<Value>) -> Value {
		get { key.suite[key] }
		set {
			key.suite[key] = newValue
		}
	}

	/// Access a defaults value using a `Defaults.OptionalKey`.
	public static subscript<Value: Codable>(key: OptionalKey<Value>) -> Value? {
		get { key.suite[key] }
		set {
			key.suite[key] = newValue
		}
	}

	/// Access a defaults value using a `Defaults.OptionalKey`.
	@available(iOS 11.0, macOS 10.13, tvOS 11.0, watchOS 4.0, iOSApplicationExtension 11.0, macOSApplicationExtension 10.13, tvOSApplicationExtension 11.0, watchOSApplicationExtension 4.0, *)
	public static subscript<Value: NSSecureCoding>(key: NSSecureCodingOptionalKey<Value>) -> Value? {
		get { key.suite[key] }
		set {
			key.suite[key] = newValue
		}
	}
	
	/**
	Reset the given keys back to their default values.

	- Parameter keys: Keys to reset.
	- Parameter suite: `UserDefaults` suite.

	```
	extension Defaults.Keys {
		static let isUnicornMode = Key<Bool>("isUnicornMode", default: false)
	}

	Defaults[.isUnicornMode] = true
	//=> true

	Defaults.reset(.isUnicornMode)

	Defaults[.isUnicornMode]
	//=> false
	```
	*/
	public static func reset<Value: Codable>(_ keys: Key<Value>..., suite: UserDefaults = .standard) {
		reset(keys, suite: suite)
	}

	/**
	Reset the given keys back to their default values.

	- Parameter keys: Keys to reset.
	- Parameter suite: `UserDefaults` suite.
	*/
	@available(iOS 11.0, macOS 10.13, tvOS 11.0, watchOS 4.0, iOSApplicationExtension 11.0, macOSApplicationExtension 10.13, tvOSApplicationExtension 11.0, watchOSApplicationExtension 4.0, *)
	public static func reset<Value: NSSecureCoding>(_ keys: NSSecureCodingKey<Value>..., suite: UserDefaults = .standard) {
		reset(keys, suite: suite)
	}
	
	/**
	Reset the given array of keys back to their default values.

	- Parameter keys: Keys to reset.
	- Parameter suite: `UserDefaults` suite.

	```
	extension Defaults.Keys {
		static let isUnicornMode = Key<Bool>("isUnicornMode", default: false)
	}

	Defaults[.isUnicornMode] = true
	//=> true

	Defaults.reset(.isUnicornMode)

	Defaults[.isUnicornMode]
	//=> false
	```
	*/
	public static func reset<Value: Codable>(_ keys: [Key<Value>], suite: UserDefaults = .standard) {
		for key in keys {
			key.suite[key] = key.defaultValue
		}
	}

	/**
	Reset the given array of keys back to their default values.

	- Parameter keys: Keys to reset.
	- Parameter suite: `UserDefaults` suite.
	*/
	@available(iOS 11.0, macOS 10.13, tvOS 11.0, watchOS 4.0, iOSApplicationExtension 11.0, macOSApplicationExtension 10.13, tvOSApplicationExtension 11.0, watchOSApplicationExtension 4.0, *)
	public static func reset<Value: NSSecureCoding>(_ keys: [NSSecureCodingKey<Value>], suite: UserDefaults = .standard) {
		for key in keys {
			key.suite[key] = key.defaultValue
		}
	}
	
	/**
	Reset the given optional keys back to `nil`.

	- Parameter keys: Keys to reset.
	- Parameter suite: `UserDefaults` suite.

	```
	extension Defaults.Keys {
		static let unicorn = OptionalKey<String>("unicorn")
	}

	Defaults[.unicorn] = "🦄"

	Defaults.reset(.unicorn)

	Defaults[.unicorn]
	//=> nil
	```
	*/
	public static func reset<Value: Codable>(_ keys: OptionalKey<Value>..., suite: UserDefaults = .standard) {
		reset(keys, suite: suite)
	}

	/**
	Reset the given optional keys back to `nil`.

	- Parameter keys: Keys to reset.
	- Parameter suite: `UserDefaults` suite.
	```
	*/
	@available(iOS 11.0, macOS 10.13, tvOS 11.0, watchOS 4.0, iOSApplicationExtension 11.0, macOSApplicationExtension 10.13, tvOSApplicationExtension 11.0, watchOSApplicationExtension 4.0, *)
	public static func reset<Value: NSSecureCoding>(_ keys: NSSecureCodingOptionalKey<Value>..., suite: UserDefaults = .standard) {
		reset(keys, suite: suite)
	}
	
	/**
	Reset the given array of optional keys back to `nil`.

	- Parameter keys: Keys to reset.
	- Parameter suite: `UserDefaults` suite.

	```
	extension Defaults.Keys {
		static let unicorn = OptionalKey<String>("unicorn")
	}

	Defaults[.unicorn] = "🦄"

	Defaults.reset(.unicorn)

	Defaults[.unicorn]
	//=> nil
	```
	*/
	public static func reset<Value: Codable>(_ keys: [OptionalKey<Value>], suite: UserDefaults = .standard) {
		for key in keys {
			key.suite[key] = nil
		}
	}

	/**
	Reset the given array of optional keys back to `nil`.

	- Parameter keys: Keys to reset.
	- Parameter suite: `UserDefaults` suite.
	*/
	@available(iOS 11.0, macOS 10.13, tvOS 11.0, watchOS 4.0, iOSApplicationExtension 11.0, macOSApplicationExtension 10.13, tvOSApplicationExtension 11.0, watchOSApplicationExtension 4.0, *)
	public static func reset<Value: NSSecureCoding>(_ keys: [NSSecureCodingOptionalKey<Value>], suite: UserDefaults = .standard) {
		for key in keys {
			key.suite[key] = nil
		}
	}

	/**
	Remove all entries from the `UserDefaults` suite.
	*/
	public static func removeAll(suite: UserDefaults = .standard) {
		for key in suite.dictionaryRepresentation().keys {
			suite.removeObject(forKey: key)
		}
	}
}

extension UserDefaults {
	private func _get<Value: Codable>(_ key: String) -> Value? {
		if UserDefaults.isNativelySupportedType(Value.self) {
			return object(forKey: key) as? Value
		}

		guard
			let text = string(forKey: key),
			let data = "[\(text)]".data(using: .utf8)
		else {
			return nil
		}

		do {
			return (try JSONDecoder().decode([Value].self, from: data)).first
		} catch {
			print(error)
		}

		return nil
	}

	@available(iOS 11.0, macOS 10.13, tvOS 11.0, watchOS 4.0, iOSApplicationExtension 11.0, macOSApplicationExtension 10.13, tvOSApplicationExtension 11.0, watchOSApplicationExtension 4.0, *)
	private func _get<Value: NSSecureCoding>(_ key: String) -> Value? {
		if UserDefaults.isNativelySupportedType(Value.self) {
			return object(forKey: key) as? Value
		}

		guard
			let data = data(forKey: key)
		else {
			return nil
		}

		do {
			return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Value
		} catch {
			print(error)
		}

		return nil
	}

	fileprivate func _encode<Value: Codable>(_ value: Value) -> String? {
		do {
			// Some codable values like URL and enum are encoded as a top-level
			// string which JSON can't handle, so we need to wrap it in an array
			// We need this: https://forums.swift.org/t/allowing-top-level-fragments-in-jsondecoder/11750
			let data = try JSONEncoder().encode([value])
			return String(String(data: data, encoding: .utf8)!.dropFirst().dropLast())
		} catch {
			print(error)
			return nil
		}
	}

	private func _set<Value: Codable>(_ key: String, to value: Value) {
		if UserDefaults.isNativelySupportedType(Value.self) {
			set(value, forKey: key)
			return
		}

		set(_encode(value), forKey: key)
	}

	@available(iOS 11.0, macOS 10.13, tvOS 11.0, watchOS 4.0, iOSApplicationExtension 11.0, macOSApplicationExtension 10.13, tvOSApplicationExtension 11.0, watchOSApplicationExtension 4.0, *)
	private func _set<Value: NSSecureCoding>(_ key: String, to value: Value) {
		if UserDefaults.isNativelySupportedType(Value.self) {
			set(value, forKey: key)
			return
		}

		set(try? NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: true), forKey: key)
	}

	public subscript<Value: Codable>(key: Defaults.Key<Value>) -> Value {
		get { _get(key.name) ?? key.defaultValue }
		set {
			_set(key.name, to: newValue)
		}
	}

	@available(iOS 11.0, macOS 10.13, tvOS 11.0, watchOS 4.0, iOSApplicationExtension 11.0, macOSApplicationExtension 10.13, tvOSApplicationExtension 11.0, watchOSApplicationExtension 4.0, *)
	public subscript<Value: NSSecureCoding>(key: Defaults.NSSecureCodingKey<Value>) -> Value {
		get { _get(key.name) ?? key.defaultValue }
		set {
			_set(key.name, to: newValue)
		}
	}

	public subscript<Value: Codable>(key: Defaults.OptionalKey<Value>) -> Value? {
		get { _get(key.name) }
		set {
			guard let value = newValue else {
				set(nil, forKey: key.name)
				return
			}

			_set(key.name, to: value)
		}
	}

	@available(iOS 11.0, macOS 10.13, tvOS 11.0, watchOS 4.0, iOSApplicationExtension 11.0, macOSApplicationExtension 10.13, tvOSApplicationExtension 11.0, watchOSApplicationExtension 4.0, *)
	public subscript<Value: NSSecureCoding>(key: Defaults.NSSecureCodingOptionalKey<Value>) -> Value? {
		get { _get(key.name) }
		set {
			guard let value = newValue else {
				set(nil, forKey: key.name)
				return
			}

			_set(key.name, to: value)
		}
	}

	fileprivate static func isNativelySupportedType<Value>(_ type: Value.Type) -> Bool {
		switch type {
		case
			is Bool.Type,
			is String.Type,
			is Int.Type,
			is Double.Type,
			is Float.Type,
			is Date.Type,
			is Data.Type:
			return true
		default:
			return false
		}
	}
}
