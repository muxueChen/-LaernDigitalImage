const float tau = radians(360.);
#iUniform vec3 inputColor = vec3(2, 3, 2) in {0, 255}
vec3 linearToSRGB(vec3 linear){
    return mix(
        linear * 12.92,
        pow(linear, vec3(1./2.4) ) * 1.055 - .055,
        step( .0031308, linear )
    );
}

void main() {
	vec2 uv = gl_FragCoord.xy / iResolution.xy;
    
    vec3 rainbow = linearToSRGB(
		sin( (uv.x+inputColor/3.)*tau + iTime) * .5 + .5
    );
	
    gl_FragColor.rgb = rainbow;
    gl_FragColor.a = 1.0;
}