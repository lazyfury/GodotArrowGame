shader_type canvas_item;

uniform float dash_length : hint_range(0.01, 5) = 0.15;
uniform float gap_length  : hint_range(0.01, 5) = 0.1;

void fragment() {
    float cycle = dash_length + gap_length;
    float pos = mod(UV.x, cycle);
    
    // 在 gap 区域丢弃像素
    if (pos > dash_length) {
        discard;
    }
    
    COLOR = texture(TEXTURE, UV);
}