package shaders;

import flixel.system.FlxAssets.FlxShader;

class Silhouette extends FlxShader {
	@:glFragmentSource('
		#pragma header

		void main() {
            gl_FragColor = texture2D(bitmap, openfl_TextureCoordv);
            if (gl_FragColor.a > 0.01) {
                gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
            }
		}
		')
	public function new() {
		super();
	}
}
