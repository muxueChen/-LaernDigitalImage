
vec2 brickTile(vec2 _st, float _zoom){
    _st *= _zoom;

    // Here is where the offset is happening
    float ptc = sin(iTime * 2.0);
    if (ptc>0.0) {
        float temp1 = step(1., mod(_st.y,2.0));
        if (temp1 == 1.0 ) {
            _st.x += ptc;
        } else {
            _st.x -= ptc;
        }
    } else {
        float temp1 = step(1., mod(_st.x,2.0));
        if (temp1 == 1.0 ) {
            _st.y += ptc;
        } else {
            _st.y -= ptc;
        }
    }

    // if (_st.x )
    return fract(_st);
}

float box(vec2 _st, vec2 _size){
    _size = vec2(0.5)-_size*0.5;
    vec2 uv = smoothstep(_size,_size+vec2(1e-4),_st);
    uv *= smoothstep(_size,_size+vec2(1e-4),vec2(1.0)-_st);
    return uv.x*uv.y;
}

void main(void){
    vec2 st = gl_FragCoord.xy/iResolution.xy;
    vec3 color = vec3(0.0);

    // Modern metric brick of 215mm x 102.5mm x 65mm
    // http://www.jaharrison.me.uk/Brickwork/Sizes.html
    // st /= vec2(2.15,0.65)/1.5;

    // Apply the brick tiling
    st = brickTile(st,5.0);

    color = vec3(box(st,vec2(0.9)));

    // Uncomment to see the space coordinates
    // color = vec3(st,0.0);

    gl_FragColor = vec4(color,1.0);
}
 