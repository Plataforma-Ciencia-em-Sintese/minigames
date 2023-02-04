shader_type canvas_item;

uniform bool top_left = false;
uniform bool top_right = false;
uniform bool bottom_left = false;
uniform bool bottom_right = false;
uniform float radius: hint_range(0.0, 1.0) = 1.0;
uniform bool animate = false;
uniform float square_scale: hint_range(0.0, 1.0) = 0.02;

void fragment() {
	float sc = square_scale + square_scale/2.0;
	float r = square_scale + (1.0 - radius) * (square_scale/2.0);
	
	float scax = 1.0 - square_scale;
	
	float dx;
	float dy;
	float d;
	float a;
	
	COLOR = texture(TEXTURE, UV);
	    
	if (bottom_left) {
		if (UV.x < square_scale && UV.y > scax) {
			dx = square_scale - UV.x;
			dy = scax - UV.y;
			d = sqrt(pow(dx, 2.) + pow(dy, 2.));
			a = asin(d);
	
			if (a > r) {
				if (!animate) {
					COLOR.a = 0.;
				} else if (a > sc * sin(3.14 * fract(TIME))) {
					COLOR.a = 0.;
				}
			}
		}
	}
	
	if (top_left) {
		if (UV.x < square_scale && UV.y < square_scale) {
			dx = square_scale - UV.x;
			dy = square_scale - UV.y;
			d = sqrt(pow(dx, 2.) + pow(dy, 2.));
			a = asin(d);

			if (a > r) {
				if (!animate) {
					COLOR.a = 0.;
				} else if (a > sc * sin(3.14 * fract(TIME))) {
					COLOR.a = 0.;
				}
			}
		}
	}
	
	if (top_right) {
		if (UV.x > scax && UV.y < square_scale) {
			dx = scax - UV.x;
			dy = square_scale - UV.y;
			d = sqrt(pow(dx, 2.) + pow(dy, 2.));
			a = asin(d);

			if (a > r) {
				if (!animate) {
					COLOR.a = 0.;
				} else if (a > sc * sin(3.14 * fract(TIME))) {
					COLOR.a = 0.;
				}
			}
		}
	}
	
	if (bottom_right ) {
		if (UV.x > scax && UV.y > scax) {
			dx = scax - UV.x;
			dy = scax - UV.y;
			d = sqrt(pow(dx, 2.) + pow(dy, 2.));
			a = asin(d);
		
			if (a > r) {
				if (!animate) {
					COLOR.a = 0.;
				} else if (a > sc * sin(3.14 * fract(TIME))) {
					COLOR.a = 0.;
				}
			}
		}
	}
	
}