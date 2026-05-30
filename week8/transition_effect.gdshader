shader_type canvas_item;

uniform float radius : hint_range(0.0, 1.0) = 1.0;

uniform vec4 overlay_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
    vec2 center_uv = UV * 2.0 - 1.0;
    
    float aspect_ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
    center_uv.x /= aspect_ratio;
    
    float dist = length(center_uv);
    
    float alpha = smoothstep(radius, radius + 0.01, dist);
    
    COLOR = vec4(overlay_color.rgb, alpha);
}