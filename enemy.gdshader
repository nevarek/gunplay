shader_type canvas_item;

uniform vec4 hit_color : hint_color;

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV);
    COLOR = vec4(mix(texture_color.rgb, hit_color.rgb, hit_color.a), texture_color.a);
}