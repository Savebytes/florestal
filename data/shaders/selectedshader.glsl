vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords){
    vec4 pixel = Texel(texture, texture_coords);

    return pixel * vec4(0.5f, 0.5f, 0.5f, 1);
}
