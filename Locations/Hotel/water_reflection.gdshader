shader_type canvas_item;

uniform float level : hint_range(0.0, 1.0) = 0.5;
uniform vec4 water_albedo = vec4(0.26, 0.23, 0.73, 1.0);
uniform float water_opacity : hint_range(0.0, 1.0) = 0.35;
uniform float water_speed = 0.05;
uniform float wave_distortion = 0.2;
uniform int wave_multiplyer = 7;
uniform bool water_texture_on = true;
uniform sampler2D noise_texture;
uniform sampler2D noise_texture2;
uniform float time; // Uniform para o tempo
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
void fragment() {
	vec2 uv = UV;
	COLOR = vec4(0.0);

	if (uv.y >= level) {
		COLOR.a = 1.0;

		// Distorted reflections
		vec2 water_uv = vec2(uv.x, uv.y * float(wave_multiplyer));
		float noise = texture(noise_texture, vec2(water_uv.x + time * water_speed, water_uv.y)).x * wave_distortion;
		noise -= (0.5 * wave_distortion);

		// Water texture
		if (water_texture_on) {
			float water_texture_limit = 0.35;
			vec4 water_texture = texture(noise_texture2, uv * vec2(0.5, 4.0) + vec2(noise, 0.0));
			float water_texture_value = (water_texture.x < water_texture_limit) ? 1.0 : 0.0;
			COLOR.xyz = vec3(water_texture_value);
		}

		// Reflections
		vec4 current_texture = texture(SCREEN_TEXTURE, vec2(UV.x + noise, 1.0 - UV.y - (level - 0.5) * 2.0));
		COLOR = mix(COLOR, current_texture, 0.5);
		COLOR = mix(COLOR, water_albedo, water_opacity);
	}
}
