shader_type spatial;
render_mode unshaded, depth_test_disabled;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;
uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_nearest;
uniform vec4 outline_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform float outline_width : hint_range(1.0, 10.0, 0.5) = 2.0;
uniform float depth_threshold : hint_range(0.0001, 0.02, 0.0001) = 0.01;

void fragment() {
    vec2 pixel_size = outline_width / VIEWPORT_SIZE;

    // sample depth at center and 4 neighbors
    float depth_c  = texture(DEPTH_TEXTURE, SCREEN_UV).r;
    float depth_n  = texture(DEPTH_TEXTURE, SCREEN_UV + vec2( 0.0,  pixel_size.y)).r;
    float depth_s  = texture(DEPTH_TEXTURE, SCREEN_UV + vec2( 0.0, -pixel_size.y)).r;
    float depth_e  = texture(DEPTH_TEXTURE, SCREEN_UV + vec2( pixel_size.x,  0.0)).r;
    float depth_w  = texture(DEPTH_TEXTURE, SCREEN_UV + vec2(-pixel_size.x,  0.0)).r;

    // how much depth changes around this pixel
    float edge = abs(depth_c - depth_n)
               + abs(depth_c - depth_s)
               + abs(depth_c - depth_e)
               + abs(depth_c - depth_w);

    vec4 screen = texture(SCREEN_TEXTURE, SCREEN_UV);

    if (edge > depth_threshold) {
        ALBEDO = outline_color.rgb;
        ALPHA  = outline_color.a;
    } else {
        ALBEDO = screen.rgb;
        ALPHA  = 1.0;
    }
}