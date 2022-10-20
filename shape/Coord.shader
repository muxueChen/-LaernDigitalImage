
float circle(in vec2 _st, in float _radius){
    vec2 l = _st-vec2(0.5);
    return 1.-smoothstep(_radius-(_radius*0.01),
                         _radius+(_radius*0.01),
                         dot(l,l)*4.0);
}

void main() {
	vec2 st = gl_FragCoord.xy/iResolution.xy;
    vec3 color = vec3(0.0);

    st *= 10.0;      // Scale up the space by 3
    st = floor(st); // Wrap around 1.0
    float ptc = st.x + st.y;
    ptc =  mod(ptc, 2.0);
    // Now we have 9 spaces that go from 0-1

    color = vec3(ptc, ptc,ptc);
    // color = vec3(circle(st,0.5));

	gl_FragColor = vec4(color,1.0);
}
