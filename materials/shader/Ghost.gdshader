shader_type spatial;
render_mode unshaded, cull_disabled, depth_prepass_alpha, depth_test_default;

uniform float threshold = .1;
uniform float fresnel_sharpness = 3.0;
uniform vec3 color:source_color = vec3(1.0, 0.0, 0.0); 

void fragment() {
	float fresnel = pow(1.0 - dot(VIEW, NORMAL), fresnel_sharpness);

    ALBEDO = color.rgb;
    ALPHA = clamp(threshold+fresnel, 0.0, 1.0);
}