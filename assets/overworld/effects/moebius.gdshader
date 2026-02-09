shader_type spatial;
render_mode unshaded;

// Parameters
uniform float zNear = 0.05;
uniform float zFar = 100.0;
uniform float outlineThickness = 1.5;
uniform vec3 outlineColor : source_color = vec3(0.0);
uniform float wiggleFrequency = 0.08;
uniform float wiggleAmplitude = 2.0;

uniform sampler2D depth_texture : hint_depth_texture, filter_linear_mipmap;
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D normal_texture : hint_normal_roughness_texture, filter_nearest;

const mat3 Sy = mat3(
	vec3(1.0, 0.0, -1.0),
	vec3(2.0, 0.0, -2.0),
	vec3(1.0, 0.0, -1.0)
);

const mat3 Sx = mat3(
	vec3(1.0, 2.0, 1.0),
	vec3(0.0, 0.0, 0.0),
	vec3(-1.0, -2.0, -1.0)
);

// Retrieve and scale depth from the depth buffer
float get_depth(vec2 screen_uv, mat4 inv_projection_matrix){
    float raw_depth = texture(depth_texture, screen_uv).r;
    vec3 ndc = vec3(screen_uv * 2.0 - 1.0, raw_depth);
    vec4 view_space = inv_projection_matrix * vec4(ndc, 1.0);
    view_space.xyz /= view_space.w;
    float linear_depth = view_space.z;
    float scaled_depth = (zFar - zNear) / (zNear + linear_depth * (zNear - zFar));
    return scaled_depth;
}

// Sobel filter for depth-based edge detection
float sobel_depth(in vec2 uv, in vec2 offset, mat4 inv_projection_matrix) {
    float d00 = get_depth(uv + offset * vec2(-1, -1), inv_projection_matrix);
    float d01 = get_depth(uv + offset * vec2(-1,  0), inv_projection_matrix);
    float d02 = get_depth(uv + offset * vec2(-1,  1), inv_projection_matrix);

    float d10 = get_depth(uv + offset * vec2( 0, -1), inv_projection_matrix);
    float d11 = get_depth(uv + offset * vec2( 0,  0), inv_projection_matrix);
    float d12 = get_depth(uv + offset * vec2( 0,  1), inv_projection_matrix);

    float d20 = get_depth(uv + offset * vec2( 1, -1), inv_projection_matrix);
    float d21 = get_depth(uv + offset * vec2( 1,  0), inv_projection_matrix);
    float d22 = get_depth(uv + offset * vec2( 1,  1), inv_projection_matrix);

    float xSobelDepth =
        Sx[0][0] * d00 + Sx[1][0] * d10 + Sx[2][0] * d20 +
        Sx[0][1] * d01 + Sx[1][1] * d11 + Sx[2][1] * d21 +
        Sx[0][2] * d02 + Sx[1][2] * d12 + Sx[2][2] * d22;

    float ySobelDepth =
        Sy[0][0] * d00 + Sy[1][0] * d10 + Sy[2][0] * d20 +
        Sy[0][1] * d01 + Sy[1][1] * d11 + Sy[2][1] * d21 +
        Sy[0][2] * d02 + Sy[1][2] * d12 + Sy[2][2] * d22;

    return sqrt(pow(xSobelDepth, 2.0) + pow(ySobelDepth, 2.0));
}

// Compute luminance for edge detection based on normal buffer
float luminance(vec3 color) {
	const vec3 magic = vec3(0.2125, 0.7154, 0.0721);
	return dot(magic, color);
}

// Sobel filter for normal-based edge detection
float sobel_normal(in vec2 uv, in vec2 offset) {
	float normal00 = luminance(texture(normal_texture, uv + offset * vec2(-1,-1)).rgb);
	float normal01 = luminance(texture(normal_texture, uv + offset * vec2(-1, 0)).rgb);
	float normal02 = luminance(texture(normal_texture, uv + offset * vec2(-1, 1)).rgb);

	float normal10 = luminance(texture(normal_texture, uv + offset * vec2( 0,-1)).rgb);
	float normal11 = luminance(texture(normal_texture, uv + offset * vec2( 0, 0)).rgb);
	float normal12 = luminance(texture(normal_texture, uv + offset * vec2( 0, 1)).rgb);

	float normal20 = luminance(texture(normal_texture, uv + offset * vec2( 1,-1)).rgb);
	float normal21 = luminance(texture(normal_texture, uv + offset * vec2( 1, 0)).rgb);
	float normal22 = luminance(texture(normal_texture, uv + offset * vec2( 1, 1)).rgb);

	float xSobelNormal =
		Sx[0][0] * normal00 + Sx[1][0] * normal10 + Sx[2][0] * normal20 +
		Sx[0][1] * normal01 + Sx[1][1] * normal11 + Sx[2][1] * normal21 +
		Sx[0][2] * normal02 + Sx[1][2] * normal12 + Sx[2][2] * normal22;

	float ySobelNormal =
		Sy[0][0] * normal00 + Sy[1][0] * normal10 + Sy[2][0] * normal20 +
		Sy[0][1] * normal01 + Sy[1][1] * normal11 + Sy[2][1] * normal21 +
		Sy[0][2] * normal02 + Sy[1][2] * normal12 + Sy[2][2] * normal22;

	return sqrt(pow(xSobelNormal, 2.0) + pow(ySobelNormal, 2.0));
}

// Generate random displacement for a hand-drawn wiggly effect
float hash(vec2 p){
	vec3 p3  = fract(vec3(p.xyx) * .1031);
	p3 += dot(p3, p3.yzx + 33.33);
	return fract((p3.x + p3.y) * p3.z);
}

void fragment() {
	vec2 offset = outlineThickness / vec2(textureSize(depth_texture, 0));
	vec2 uv = UV;

	// Displacement to add hand-drawn wiggly effect
	vec2 displ = vec2(
		hash(FRAGCOORD.xy) * sin(FRAGCOORD.y * wiggleFrequency),
		hash(FRAGCOORD.xy) * cos(FRAGCOORD.x * wiggleFrequency)
	) * wiggleAmplitude / vec2(textureSize(depth_texture, 0));

	// Access the depth buffer
	float depth_val = get_depth(uv, INV_PROJECTION_MATRIX);
	if (depth_val < 0.01) {
		discard;
	}

	// Screen texture color
	vec3 pixelColor = texture(screen_texture, uv).rgb;
	float pixelLuma = luminance(pixelColor);
	float modVal = 11.0;

	// Apply hatching based on luminance value (from darker to lighter zones)
	if (pixelLuma <= 0.35) {
		if (mod((uv.y + displ.y) * vec2(textureSize(screen_texture, 0)).y, modVal) < outlineThickness) {
			pixelColor = outlineColor;
		}
	}
	if (pixelLuma <= 0.45) {
		if (mod((uv.x + displ.x) * vec2(textureSize(screen_texture, 0)).x, modVal) < outlineThickness) {
			pixelColor = mix(pixelColor, outlineColor, 0.25);
		}
	}
	if (pixelLuma <= 0.80) {
		if (mod((uv.x + displ.x) * vec2(textureSize(screen_texture, 0)).y +
				(uv.y + displ.y) * vec2(textureSize(screen_texture, 0)).x, modVal) <= outlineThickness) {
			pixelColor = mix(pixelColor, outlineColor, 0.5);
		}
	}

	// Edge detection using depth buffer and normal buffer
	float edgeDepth = sobel_depth(uv + displ, offset, INV_PROJECTION_MATRIX);
	float edgeNormal = sobel_normal(uv + displ, offset);
	float outline = smoothstep(0.0, 1.0, 25.0 * edgeDepth + edgeNormal);
}