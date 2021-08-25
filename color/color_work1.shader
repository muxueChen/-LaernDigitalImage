vec3 colorA = vec3(0.149,0.141,0.912);
vec3 colorB = vec3(1.000,0.833,0.224);

float plot (vec2 st, float pct){
  return  smoothstep( pct-0.01, pct, st.y) -
          smoothstep( pct, pct+0.01, st.y);
}
void main() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    vec3 color = vec3(0.0);
    vec3 pct = vec3(uv.x);
    color = mix(colorA, colorB, pct);
    color = mix(color,vec3(1.0,0.0,0.0),plot(uv,pct.r));
    color = mix(color,vec3(0.0,1.0,0.0),plot(uv,pct.g));
    color = mix(color,vec3(0.0,0.0,1.0),plot(uv,pct.b));
    gl_FragColor = vec4(color, 1.0);
}