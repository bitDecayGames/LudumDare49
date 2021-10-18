import sys.io.File;
import poco.PocobotTemplate;

class Main {
	static var reactorMax = 20;
	static var batteryMax = 10;
	static var loopStart = 1;
	static var loopLimit = reactorMax + 1;

	static function main() {
		var content:String = sys.io.File.getContent('./pocobot.ps');
		// fill out template
		var template = new haxe.Template(content);
		var rendered = template.execute(new PocobotTemplate(28, 10).getDynamic());

		File.saveContent('./pocobot_rendered.ps', rendered);
	}
}