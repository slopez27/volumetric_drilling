// Manipulate fragments to have a picture over picture view.
// Left screen will show the left camera image and right screen will show the right camera image.
// This shader is useful to use with Goovis VR devices.
//
// IMPORTANT parameters:
// * small_window_disparity: defines the top left corner of the left and right small windows.
// * rect_size: size of the small window.
//
//                         (0.5, 1)                  (1,1)
// +-----------------------X-------------------------X 
// |  left_small_window    |  right_small_window     |
// |    +----------+       |       +----------+      |
// |    |          |       |       |          |      |
// |    |          |       |       |          |      |
// |    |          |<--+-->|<----->|          |      |
// |    |          |   |   |       |          |      |
// |    +----------+   |   |       +----------+      |
// |                   |   |                         |
// X-------------------+---+-------------------------+
// (0,0)               |                              
//                     v                              
//                  small_window_disparity                                        

#version 120

// UNIFORMS
uniform sampler2D rosImageTexture;
uniform sampler2D frameBufferTexture;

uniform float small_window_disparity = 0.1;
uniform int window_width = 1920;
uniform int window_height = 1043;

uniform float small_window_y_pos = 0.60;
uniform float small_window_height = 0.38;
uniform int toggle_sim_microscope; // 0 = sim small, microscope big, 1 = sim big, microscope


float offset;
vec2 small_window_pos;

// HELPER FUNCTIONS
float remap(float t, float a, float b, float c, float d)
{
    return c + (t-a)/(b-a) * (d-c);
}

// Remap function 
// https://math.stackexchange.com/questions/914823/shift-numbers-into-a-different-range
vec2 remap_little_window(vec2 output_loc, vec2 rectMin, vec2 rectMax)
{
    float x2 = remap(output_loc.x, rectMin.x, rectMax.x, 0.0, 1.0);
    float y2 = remap(output_loc.y, rectMin.y, rectMax.y, 0.0, 1.0);
    vec2 remapped = vec2(x2, y2);
    return remapped;
}

vec2 clamp_small_window_y(float y, float height)
{
    float clamped_y = clamp(y, 0.0, 1.0 - height);
    return vec2(0.0, clamped_y);
}

vec2 clamp_left_window_x(float x, float width, float disparity) {
    float max_x = 0.5 - width - (disparity / 2.0);
    float clamped_x = clamp(x, 0.0, max_x);
    return vec2(clamped_x, 0.0);
}

vec2 clamp_right_window_x(float x, float width, float disparity) {
    float min_x = 0.5 + (disparity / 2.0);
    float max_x = 1.0 - width;
    float clamped_x = clamp(x, 0.0, max_x - min_x);
    return vec2(min_x + clamped_x, 0.0);
}

void main()
{
    vec2 output_loc = gl_FragCoord.xy / vec2(window_width, window_height);

    float aspect_ratio = float(window_width) / float(window_height);
    float small_window_width = small_window_height / aspect_ratio;
    vec2 rect_size = vec2(small_window_width, small_window_height);

    float min_disparity = small_window_width / 2.0;
    float max_disparity = 0.5 - min_disparity;
    float clamped_disparity = clamp(small_window_disparity, min_disparity, max_disparity);

    vec2 clamped_y = clamp_small_window_y(small_window_y_pos, small_window_height);

    float center_x_left = 0.5 - clamped_disparity;
    float center_x_right = 0.5 + clamped_disparity;
    vec2 left_small_window_pos = vec2(center_x_left - small_window_width / 2.0, clamped_y.y);
    vec2 right_small_window_pos = vec2(center_x_right - small_window_width / 2.0, clamped_y.y);

    // LEFT WINDOW
    vec2 rectMinL = left_small_window_pos;
    vec2 rectMaxL = rectMinL + rect_size;

    // RIGHT WINDOW
    vec2 rectMinR = right_small_window_pos;
    vec2 rectMaxR = rectMinR + rect_size;

    // vec4 baseColor = (toggle_sim_microscope == 1)
    //     ? texture2D(rosImageTexture, output_loc)
    //     : texture2D(frameBufferTexture, output_loc);
    vec4 baseColor;
    vec2 baseCoord = output_loc;

    if (toggle_sim_microscope == 0) {
        // Simulation = big → it's mono, so duplicate across both eyes
        baseCoord.x = (output_loc.x < 0.5)
            ? output_loc.x * 2
            : (output_loc.x - 0.5) * 2;

        baseColor = texture2D(frameBufferTexture, baseCoord);
    } else {
        // Microscope = big → it's stereo, use half for each eye
        baseCoord.x = (output_loc.x < 0.5)
            ? output_loc.x * 0.5              // Left eye → [0.0 → 0.5]
            : 0.5 + (output_loc.x - 0.5) * 0.5; // Right eye → [0.5 → 1.0]

        baseColor = texture2D(rosImageTexture, baseCoord);
    }


    vec4 overlayColor;

    bool inLeftWindow = output_loc.x >= rectMinL.x && output_loc.x <= rectMaxL.x && output_loc.y >= rectMinL.y && output_loc.y <= rectMaxL.y;

    bool inRightWindow = output_loc.x >= rectMinR.x && output_loc.x <= rectMaxR.x && output_loc.y >= rectMinR.y && output_loc.y <= rectMaxR.y;

    if (inLeftWindow || inRightWindow) {
        vec2 output_loc2 = inLeftWindow
            ? remap_little_window(output_loc, rectMinL, rectMaxL)
            : remap_little_window(output_loc, rectMinR, rectMaxR);
        
        // only sending half of the whole texture
        // TODO: need to fix because should only be applying this to microscope
        if (toggle_sim_microscope == 0) {
            output_loc2.x = inLeftWindow
                ? output_loc2.x * 0.5
                : 0.5 + output_loc2.x * 0.5;
        }

        overlayColor = (toggle_sim_microscope == 1)
            ? texture2D(frameBufferTexture, output_loc2)
            : texture2D(rosImageTexture, output_loc2);
        
        gl_FragColor = mix(overlayColor, baseColor, 0.3);
    } else {
        gl_FragColor = baseColor;
    }
}

