shader_type canvas_item;
render_mode blend_mix;

uniform float WindStrenght : hint_range(2.0, 60.0);

uniform float skew: hint_range(-500.0, 500.0) = 0;

// vertex method


void vertex() {
	if (skew != 0.0) {
   VERTEX.x += max(0.0, (1.0-UV.y) - heightOffset) * (skew / 12.0);
}
// Input:2
	vec2 n_out2p0 = VERTEX;


// VectorDecompose:3
	float n_out3p0 = n_out2p0.x;
	float n_out3p1 = n_out2p0.y;


// FloatParameter:4
	float n_out4p0 = WindStrenght;


// Input:7
	vec2 n_out7p0 = UV;


// VectorDecompose:8
	float n_out8p0 = vec3(n_out7p0, 0.0).x;
	float n_out8p1 = vec3(n_out7p0, 0.0).y;
	float n_out8p2 = vec3(n_out7p0, 0.0).z;


// FloatFunc:9
	float n_out9p0 = 1.0 - n_out8p1;


// FloatOp:10
	float n_out10p0 = n_out4p0 * n_out9p0;


// Input:15
	vec2 n_out15p0 = VERTEX;


// VectorDecompose:14
	float n_out14p0 = n_out15p0.x;
	float n_out14p1 = n_out15p0.y;


// Input:11
	float n_out11p0 = TIME;


// FloatOp:16
	float n_out16p0 = n_out14p0 + n_out11p0;


// FloatFunc:12
	float n_out12p0 = sin(n_out16p0);


// FloatOp:13
	float n_out13p0 = n_out10p0 * n_out12p0;


// FloatOp:5
	float n_out5p0 = n_out3p0 + n_out13p0;


// VectorCompose:6
	vec2 n_out6p0 = vec2(n_out5p0, n_out3p1);


// Output:0
	VERTEX = n_out6p0;


}
