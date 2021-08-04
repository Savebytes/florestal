uniform number time;

uniform float speed = 1.0f;
uniform float frequency_y = 0.1f;
uniform float frequency_x = 0.1f;
uniform float amplitude_y = 5.0f;
uniform float amplitude_x = 5.0f;
uniform float inclination = 0.1f;

vec4 position( mat4 transform_projection, vec4 vertex_position )
{
    vertex_position.y += sin((vertex_position.x - time * speed) * frequency_y) * amplitude_y;
    vertex_position.x += cos((vertex_position.y - time * speed) * frequency_x) * amplitude_x;
    vertex_position.x -= vertex_position.y * inclination;
    return transform_projection * vertex_position;
}