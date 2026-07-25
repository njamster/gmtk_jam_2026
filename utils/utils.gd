class_name Utils
extends Object


static func to_snake_case(input: String) -> String:
	return input.replace(" ", "_").to_lower()
