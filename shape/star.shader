
float Star(vec2 uv, float size)
{
    uv.x = abs(uv.x);
    float a = 6.2832/5.;
    float d1 = dot(uv, vec2(sin(a), cos(a)));
    a = 3. * 6.2832/5.;
    float d2 = dot(uv, vec2(sin(a), cos(a)));
    a = 2. * 6.2832/5.;
    float d4 = dot(uv, vec2(sin(a), cos(a)));
    
    float d = min(max(d1, d2), max(uv.y, d4));
    float w = fwidth(d);
    return smoothstep(w, -w, d - size);
}

void main(){
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
       
    vec3 col = vec3(0);
    uv = (gl_FragCoord.xy - 0.5 * iResolution.xy)/iResolution.y;
    
    col += Star( uv + vec2( sin(2.* iTime)/2., cos(2.* iTime)/5.), .1);
    col *= vec3(178.,34.,52.)/255.;
    gl_FragColor = vec4(col,1.0);
}