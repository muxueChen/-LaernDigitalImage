// The MIT License
// Copyright © 2018 Inigo Quilez
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


// Computes the exact bounding box to a quadratic Bezier curve. Since the bezier is quadratic,
// the bbox can be compute with a linear equation:
//
//   Yellow: naive bbox of the 3 control points
//   Blue: exact bbox
//
// More info here: https://iquilezles.org/articles/bezierbbox
//    
// Related Shaders:
//     Quadratic Bezier - 3D      : https://www.shadertoy.com/view/ldj3Wh
//     Cubic     Bezier - 2D BBox : https://www.shadertoy.com/view/XdVBWd 
//     Cubic     Bezier - 3D BBox : https://www.shadertoy.com/view/MdKBWt
//     Quadratic Bezier - 2D BBox : https://www.shadertoy.com/view/lsyfWc
//     Quadratic Bezier - 3D BBox : https://www.shadertoy.com/view/tsBfRD

const int LineCount = 2;
const int PointCount = 9;
#iUniform float uLineWidth = 0.01 in {0.0, 1.0}
#iUniform float radius = 0.015 in {0.0, 0.1}
#iUniform float intensity = 1.3 in {0.0, 10.0}
#iUniform float uStart = 0.0 in {0.0, 1.0}
#iUniform float uEnd = 1.0 in {0.0, 1.0}
#iUniform float uFrequency = 1.0 in {0.0, 100.0}
#iUniform float uNoise = 0.0 in {0.0, 1.0}
#iUniform float uPhase = 0.0 in {0.0, 360.0}
#iUniform vec3 uLineColor = vec3(1.0, 1.0, 1.0) in {0.0, 1.0}

float getGlow(float dist, float radius, float intensity) {
    return pow(radius/dist, intensity);
}

// 判断点到线的顺时针方向还是逆时针方向
float pointToLineSign(vec2 N, vec2 M, vec2 p) {
    vec2 NP = p - N;
    vec2 NM = M - N;
    mat2 rotateMat = mat2(0.0, 1.0,
                          -1.0, 0.0);
    NP = rotateMat * NP;
    float flag = sign(dot(NM, NP));
    return flag;
}

float length2( in vec2 v ) { return dot(v,v); }

vec2 sdSegmentSq( in vec2 p, in vec2 a, in vec2 b, float start, float end){
	vec2 pa = p-a, ba = b-a;
	float h = clamp(dot(pa,ba)/dot(ba,ba), start, end);
    float temp = length2( pa - ba*h );
	return vec2(temp, h);
}

vec3 sdSegment( in vec2 p, in vec2 a, in vec2 b, float start, float end) {
    float flag = pointToLineSign(a, b, p);
    if (start >= end) {
        return vec3(1.0, 0.0, flag);
    }
    vec2 temp = sdSegmentSq(p,a,b, start, end);
    
	return vec3(sqrt(temp.x), temp.y, flag);
}

vec3 cubicBezier(vec2 p0, vec2 p1, vec2 p2, in vec2 p3, vec2 pos, float start, float end){   
    const int kNum = 50;
    vec3 res = vec3(1e10, 0.0, 1.0);
    vec2 a = p0;
    for( int i=0; i<kNum; i++ ) {
        float t = float(i)/float(kNum-1);
        t = clamp(t, 0.0, end);
        float s = 1.0-t;
        vec2 b = p0*s*s*s + p1*3.0*s*s*t + p2*3.0*s*t*t + p3*t*t*t;
        float d = sdSegmentSq( pos, a, b, 0.0, 1.0).x;
        if(t>start) {
            if( d<res.x ){
                res = vec3(d, t, 1.0);
            }
        }
        a = b;
    }
    // 求点在贝塞尔曲线的里外
    float t = 0.0;
    float t1 = 0.0;
    float s = 0.0;
    float s1 = 0.0;
    if (res.y < 0.99) {
        t = res.y;
        t1 = res.y + 0.001;
    } else {
        t = res.y;
        t1 = res.y - 0.001;
    }
    s = 1.0 - t;
    s1 = 1.0 - t1;
    vec2 N = p0*s*s*s + p1*3.0*s*s*t + p2*3.0*s*t*t + p3*t*t*t;
    vec2 M = p0*s1*s1*s1 + p1*3.0*s1*s1*t1 + p2*3.0*s1*t1*t1 + p3*t1*t1*t1;
    float flag = pointToLineSign(N, M, pos);
    return vec3(sqrt(res.x), res.y, flag);
}

vec3 quadraticBezier(in vec2 p0, in vec2 p1, in vec2 p2, in vec2 pos, float start, float end) {   
    if (start >= end) {
        return vec3(1.0, 0.0, 1.0);
    }
    vec2 a = p1 - p0;
    vec2 b = p0 - 2.0*p1 + p2;
    vec2 c = p0 - pos;
    float kk = 1.0 / dot(b,b);
    float kx = kk * dot(a,b);
    float ky = kk * (2.0*dot(a,a)+dot(c,b)) / 3.0;
    float kz = kk * dot(c,a);      
    vec2 res;
    float p = ky - kx*kx;
    float p3 = p*p*p;
    float q = kx*(2.0*kx*kx - 3.0*ky) + kz;
    float h = q*q + 4.0*p3;
    if(h >= 0.0) { 
        h = sqrt(h);
        vec2 x = (vec2(h, -h) - q) / 2.0;
        vec2 uv = sign(x)*pow(abs(x), vec2(1.0/3.0));
        float t = uv.x + uv.y - kx;
        t = clamp( t, start, end);
        vec2 qos = c + (2.0*a + b*t)*t;
        
        res = vec2( length(qos),t);
    } else {
        float z = sqrt(-p);
        float v = acos( q/(p*z*2.0) ) / 3.0;
        float m = cos(v);
        float n = sin(v)*1.732050808;
        vec3 t = vec3(m + m, -n - m, n - m) * z - kx;
        t = clamp(t, start, end);

        // 3 roots
        vec2 qos = c + (2.0*a + b*t.x)*t.x;
        float dis = dot(qos,qos);
        res = vec2(dis, t.x);
        qos = c + (2.0*a + b*t.y)*t.y;
        dis = dot(qos,qos);
        if( dis<res.x ) res = vec2(dis,t.y);
        qos = c + (2.0*a + b*t.z)*t.z;
        dis = dot(qos,qos);
        if( dis<res.x ) res = vec2(dis,t.z);
        res.x = sqrt( res.x );
    }
    // 求点在贝塞尔曲线的里外
    float t = 0.0;
    float t1 = 0.0;
    if (res.y < 0.9) {
        t = res.y;
        t1 = res.y + 0.01;
    } else {
        t = res.y;
        t1 = res.y - 0.01;
    }
    vec2 N = b*res.y*t + 2.0 * a * t + p0;
    vec2 M = b*res.y*t1 + 2.0 * a * t1 + p0;
    float flag = pointToLineSign(N, M, pos);
    return vec3(res, flag);
}

vec3 getSDF(vec2 bezier, vec2 points[PointCount], vec2 pos, float start, float end) {
    int i = int(bezier.x);
    if (bezier.y < 0.1) {
        vec2 p0 = points[i];
        vec2 p1 = points[i+1];
        return sdSegment(pos, p0, p1, start, end);
    } else if (bezier.y < 1.1) {
        vec2 p0 = points[i];
        vec2 p1 = points[i+1];
        vec2 p2 = points[i+2];
        return quadraticBezier(p0, p1, p2, pos, start, end);
    } else if (bezier.y < 2.1) {
        vec2 p0 = points[i];
        vec2 p1 = points[i+1];
        vec2 p2 = points[i+2];
        vec2 p3 = points[i+3];
        return cubicBezier(p0, p1, p2, p3, pos, start, end);
    }
    return vec3(1.0);
}

vec2 hash22(vec2 p) {
    p = vec2( dot(p,vec2(127.1,311.7)),
              dot(p,vec2(269.5,183.3)));
    return -1.0 + 2.0 * fract(sin(p)*43758.5453123);
}

float perlinNoise1D(float p) {
    float pi = floor(p);
    float pf = p - pi;
    float w = pf * pf*(3.0-2.0*pf);
    return mix(dot(hash22(vec2(pi, 0.0)), vec2(pf, 0.0)-vec2(0.0, 0.0)),
        dot(hash22(vec2(pi, 0.0)+vec2(1.0, 0.0)), vec2(pf, 0.0)-vec2(1.0, 0.0)), w);
}

float perlinNoise2D(vec2 p) {
    vec2 pi = floor(p);
    vec2 pf = p - pi;
    vec2 w = pf * pf * (3.0 - 2.0 * pf);
    return mix(mix(dot(hash22(pi + vec2(0.0, 0.0)), pf - vec2(0.0, 0.0)), 
                   dot(hash22(pi + vec2(1.0, 0.0)), pf - vec2(1.0, 0.0)), w.x), 
               mix(dot(hash22(pi + vec2(0.0, 1.0)), pf - vec2(0.0, 1.0)), 
                   dot(hash22(pi + vec2(1.0, 1.0)), pf - vec2(1.0, 1.0)), w.x),
               w.y);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
    vec2 p = (fragCoord.xy*2.0 - iResolution.xy)/iResolution.y;
    float px = 2.0/iResolution.y;
    vec3 col = vec3(0.15);

    vec2 p0 = vec2(-1.0, -1.0);
    vec2 p1 = vec2(-1.0, -0.8);
    vec2 p2 = vec2(-0.5, -0.5);

    vec2 p3 = vec2(-0.2, 0.0);
    vec2 p4 = vec2(0.0, 0.0);
    vec2 p5 = vec2(0.0, 0.0);
    vec2 p6 = vec2(0.5, 0.5);
    vec2 p7 = vec2(0.5, -0.5);
    vec2 p8 = vec2(-0.2, -0.2);
    float w = 1.0/float(LineCount);

    vec3 uBezierLins[LineCount];
    vec2 uPoints[PointCount];
    uBezierLins[0] = vec3(0.0, 1.0, w);
    uBezierLins[1] = vec3(2.0, 1.0, w);
    // uBezierLins[2] = vec3(4.0, 1.0, w);

    uPoints[0] = p0;
    uPoints[1] = p1;
    uPoints[2] = p2;
    uPoints[3] = p3;
    uPoints[4] = p4;
    uPoints[5] = p5;
    uPoints[6] = p6;
    uPoints[7] = p7;
    uPoints[8] = p8;
    
    float s_t = 0.0;
    vec3 sd = vec3(1.0, 0.0, 1.0);
    float t = 0.0;
    float baseNoiseOffset = 0.0;
    float noiseOffset = 0.0;
    for (int i = 0; i < LineCount; i++) {
        float start = clamp((uStart - s_t) / uBezierLins[i].z, 0.0, 1.0);
        float end = clamp((uEnd - s_t) / uBezierLins[i].z, 0.0, 1.0);
        vec3 be = getSDF(uBezierLins[i].xy, uPoints, p, start, end);
        if (be.x <= sd.x) {
            sd = be;
            noiseOffset = baseNoiseOffset + floor(uBezierLins[i].z * uFrequency) * be.y;
        }
        s_t += uBezierLins[i].z;
        baseNoiseOffset += floor(uBezierLins[i].z * uFrequency);
    }
   
    float noise_t = perlinNoise1D(noiseOffset+uPhase + iTime)*0.5*uNoise;
    sd.x += noise_t*sd.z;
    sd.x = abs(sd.x);
    float glow = getGlow(sd.x, radius, intensity);
    float s_w = uLineWidth * 0.05;
    float line = 1.0 - smoothstep(s_w, s_w+px*1.5, sd.x);
    col = mix(vec3(0.0), uLineColor, line);
    col += glow * vec3(1.0,0.05,0.3);
    float a = clamp(line + glow, 0.0, 1.0);
    fragColor = vec4(col, a);
}