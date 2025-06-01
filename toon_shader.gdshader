shader_type spatial;

/*
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform vec3 albedo : source_color = vec3(.9,0.4,.5);
uniform float metallic = 0.0;
uniform float roughness = 0.0;

void light() {
    float NdotL = max(dot(NORMAL, LIGHT), 0.0);
    vec3 diffuse = NdotL * vec3(1.0, 0.0, 0.0); // red diffuse color
    DIFFUSE_LIGHT = diffuse;
}
*/