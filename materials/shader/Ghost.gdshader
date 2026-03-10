render_mode unshaded, cull_disabled, depth_prepass_alpha, depth_test_default;

varying vec3 color;

uniform sampler2D depth_texture : source_color, hint_depth_texture;
uniform float threshold = .2;
uniform float fresnel_sharpness = 1.0;

void vertex() {
    color = COLOR.rgb;
}

void fragment() {
	float depth = texture(depth_texture, SCREEN_UV).x;
	vec3 ndc = vec3(SCREEN_UV * 2.0 - 1.0, depth);
	vec4 view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	view.xyz /= view.w;
	float linear_depth = -view.z;

	float object_depth = FRAGCOORD.z;
	vec3 object_ndc = vec3(SCREEN_UV * 2.0 - 1.0, object_depth);
	vec4 object_view = INV_PROJECTION_MATRIX * vec4(object_ndc, 1.0);
	object_view.xyz /= object_view.w;
	float linear_object_depth = -object_view.z;

	float fresnel = pow(1.0 - dot(VIEW, NORMAL), fresnel_sharpness);

	if (linear_depth - linear_object_depth > threshold) {
		ALBEDO = color.rgb;
		ALPHA = clamp(0.1+fresnel, 0.0, 1.0);
	}
	else {
		ALBEDO = color.rgb;
		ALPHA = clamp(0.2+fresnel, 0.0, 1.0);
	}
}