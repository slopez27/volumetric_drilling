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

// in vec2 gl_TexCoord;

// UNIFORMS
// A texture containing the left and right images from the microscope.
uniform sampler2D rosImageTexture;
// Texture containing the simulation assisted navigation view.
uniform sampler2D frameBufferTexture;
// distance of small window from the center. Value between [0.0, 0.2]
uniform float small_window_disparity = 0.1;
uniform int window_width = 1920;
uniform int window_height = 1043;


// CONFIG PARAMETERS
// TODO: I got the ok to change this so can control x and y!!!
// NOTE: changing this to uniform
uniform float small_window_y_pos = 0.60;
uniform float small_window_height = 0.38;
uniform float small_window_x_pos = 0.1;

// NOTE: Commenting this section out just for now
// // Adjust the small window's width to ensure it is always square
// float aspect_ratio = float(window_width) / float(window_height);
// float small_window_width = small_window_height / aspect_ratio;

// // adding clamped position
// vec2 clamped_pos = clamp_small_window_y(small_window_y_pos, small_window_height);

// vec2 rect_size = vec2(small_window_width, small_window_height);
// vec2 left_small_window_pos = vec2(0.5 - rect_size.x - small_window_disparity, clamped_pos.y);
// vec2 right_small_window_pos = vec2(small_window_disparity, clamped_pos.y);

// OTHER PARAMETERS
float offset;
vec2 small_window_pos;

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

vec2 clamp_small_window_x(float x, float width, float disparity)
{
    float max_x = 1.0 - (2.0 * width + disparity);
    float clamped_x = clamp(x, 0.0, max_x);
    return vec2(clamped_x, 0.0);
}



void main()
{
    // output_loc is the fragment location on screen from [0,1]x[0,1]
    vec2 output_loc = gl_TexCoord[0].xy;

    // NOTE: seeing if better if I have it in main
    float aspect_ratio = float(window_width) / float(window_height);
    float small_window_width = small_window_height / aspect_ratio;
    vec2 rect_size = vec2(small_window_width, small_window_height);

    float clamped_disparity = clamp(small_window_disparity, 0.0, 0.5 - small_window_width);

    vec2 clamped_pos = clamp_small_window_y(small_window_y_pos, small_window_height);
    // vec2 left_small_window_pos = vec2(small_window_x_pos, clamped_pos.y);
    // vec2 right_small_window_pos = vec2(small_window_x_pos + rect_size.x + clamped_disparity, clamped_pos.y);

    vec2 clamped_x_pos = clamp_small_window_x(small_window_x_pos, small_window_width, clamped_disparity);
    vec2 left_small_window_pos = vec2(clamped_x_pos.x, clamped_pos.y);
    vec2 right_small_window_pos = vec2(clamped_x_pos.x + rect_size.x + clamped_disparity, clamped_pos.y);


    // if (output_loc[0] <= 0.5)
    // {
    //     offset = 0.0;
    //     small_window_pos = left_small_window_pos;
    // }
    // else
    // {
    //     offset = 0.5;
    //     small_window_pos = right_small_window_pos;
    // }

    // // Rectangle boundaries in normalized device coordinates
    // vec2 rectMin = small_window_pos;
    // vec2 rectMax = small_window_pos + rect_size;
    // rectMin.x += offset;
    // rectMax.x += offset;

    // if (output_loc.x >= rectMin.x && output_loc.x <= rectMax.x &&
    //     output_loc.y >= rectMin.y && output_loc.y <= rectMax.y)
    // {
    //     // gl_FragColor = vec4(0.0, 1.0, 0.0, 1.0); // Green color
    //     vec2 output_loc2 = remap_little_window(output_loc, rectMin, rectMax);
    //     // gl_FragColor = texture2D(frameBufferTexture, output_loc2); 
    //     gl_FragColor = mix(texture2D(frameBufferTexture, output_loc2), texture2D(rosImageTexture, output_loc), 0.3);
    // }
    // else
    // {
    //     gl_FragColor = texture2D(rosImageTexture, output_loc); 
    // }

    // LEFT WINDOW
    vec2 rectMinL = left_small_window_pos;
    vec2 rectMaxL = rectMinL + rect_size;

    // RIGHT WINDOW
    vec2 rectMinR = right_small_window_pos;
    vec2 rectMaxR = rectMinR + rect_size;

    vec4 baseColor = texture2D(rosImageTexture, output_loc);

    // Check left window
    if (output_loc.x >= rectMinL.x && output_loc.x <= rectMaxL.x &&
        output_loc.y >= rectMinL.y && output_loc.y <= rectMaxL.y)
    {
        vec2 output_loc2 = remap_little_window(output_loc, rectMinL, rectMaxL);
        gl_FragColor = mix(texture2D(frameBufferTexture, output_loc2), baseColor, 0.3);
    }
    // Check right window
    else if (output_loc.x >= rectMinR.x && output_loc.x <= rectMaxR.x &&
            output_loc.y >= rectMinR.y && output_loc.y <= rectMaxR.y)
    {
        vec2 output_loc2 = remap_little_window(output_loc, rectMinR, rectMaxR);
        gl_FragColor = mix(texture2D(frameBufferTexture, output_loc2), baseColor, 0.3);
    }
    else
    {
        gl_FragColor = baseColor;
    }


   
}
