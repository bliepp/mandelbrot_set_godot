shader_type canvas_item;

uniform int iterations = 100;

uniform highp float x_range_min = -2.6;
uniform highp float x_range_max = 1.2;

uniform highp float y_range_min = -1.1875;
uniform highp float y_range_max = 1.1875;

vec2 get_coordinate(vec2 uv, float x_min, float x_max, float y_min, float y_max){
	float x = (x_max - x_min)*uv.x + x_min;
	float y = (y_max - y_min)*uv.y + y_min;
	return vec2(x,y);
}

vec3 hsv(float hue, float saturation, float value){
	// loop hue (0° = 360°)
	while(hue > 360.0){hue -= 360.0;}
	while(hue < 0.0){hue += 360.0;}
	
	int h = int(hue)/60;
	float f = hue/60.0 - float(h);
	float p = value*(1.0-saturation),
		q = value*(1.0-saturation*f),
		t = value*(1.0-saturation*(1.0-f));
	
	if(h == 0 || h == 6){ return vec3(value, t, p); }
	else if (h == 1){ return vec3(q, value, p); }
	else if (h == 2){ return vec3(p, value, t); }
	else if (h == 3){ return vec3(p, q, value); }
	else if (h == 4){ return vec3(t, p, value); }
	else if (h == 5){ return vec3(value, p, q); }
}

void fragment(){
	vec2 c = get_coordinate(UV, x_range_min, x_range_max, y_range_min, y_range_max);
	vec2 z = vec2(c.x,c.y);
	
	int i = 0;
	while(i < iterations && z.x*z.x+z.y*z.y < 4.0){
		float temp = z.x;
		z.x = z.x*z.x - z.y*z.y +c.x;
		z.y = 2.0*z.y*temp + c.y;
		i++;
	}
	float m = float(i)/float(iterations);
	COLOR.rgb = hsv(360.0*m * 1.0, 1.0, ceil(1.0-1.1*m));
}