

#define RAYMARCH_TIME 128
#define PRECISION .001
#define AA 5
#define PI 3.14159265

vec2 fixUV(in vec2 c) {
    return (2. * c - iResolution.xy) / min(iResolution.x, iResolution.y);
}

float sdfBox(in vec3 p, in vec3 r, float rad) {
    vec3 b = abs(p) - r;
    return length(max(b, 0.)) + min(max(max(b.x, b.y), b.z), 0.) - rad;
}

float sdTorus(vec3 p, vec2 t) {
    vec2 q = vec2(length(p.xz) - t.x, p.y);
    return length(q) - t.y;
}

float sdCapsule(vec3 p, vec3 a, vec3 b, float r) {
    vec3 pa = p - a, ba = b - a;
    float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
    return length(pa - ba * h) - r;
}

float sdCappedTorus(in vec3 p, in vec2 sc, in float ra, in float rb) {
    p.x = abs(p.x);
    float k = (sc.y * p.x > sc.x * p.y) ? dot(p.xy, sc) : length(p.xy);
    return sqrt(dot(p, p) + ra * ra - 2.0 * ra * k) - rb;
}

vec4 opElongate(in vec3 p, in vec3 h) {
    vec3 q = abs(p) - h;
    return vec4(max(q, 0.0), min(max(q.x, max(q.y, q.z)), 0.0));
}

vec2 opU(vec2 a, vec2 b) {
    return a.x < b.x ? a : b;
}

vec2 map(in vec3 p) {
    p.xz *= mat2(0., 1., 1., 0.);
    vec3 q = vec3(abs(p.x), p.yz);
    vec2 d = vec2(sdfBox(p - vec3(0., 1.3, 0.), vec3(1.5, .9, 1.), .3), 2.);

    {
        // frame
        vec4 w = opElongate(p.xzy - vec3(0., 1.3, 1.3), vec3(1.2, 0., 0.55));
        float t = w.w + sdTorus(w.xyz, vec2(.3, .05));
        d = opU(d, vec2(t, 3.));
    }
    {
        // eyes
        d = opU(d, vec2(sdCapsule(q, vec3(.4, 1.6, 1.3), vec3(1., 1.3, 1.3), .1), 3.));
    }
    {
        // mouth
        float an = 70. / 180. * PI;
        d = opU(d, vec2(sdCappedTorus(q * vec3(1., -1., 1.) - vec3(.285, -1., 1.3), vec2(sin(an), cos(an)), .3, .07), 3.));
    }
    {
        // ear
        d = opU(d, vec2(sdCapsule(q, vec3(1.3, 3.0, 1.), vec3(.2, 2.0, 1.), .1), 3.));
    }
    {
        // legs
        d = opU(d, vec2(sdCapsule(vec3(q.x, p.y, abs(p.z)), vec3(1.3, .5, 1.0), vec3(1.5, .1, 1.3), .1), 3.));
    }
    return d;
}

vec2 rayMarch(in vec3 ro, in vec3 rd) {
    float t = 0.1;
    float tmax = 40.;
    vec2 res = vec2(-1.);
    if(rd.y < 0.) {
        float tp = -ro.y / rd.y;
        tmax = min(tmax, tp);
        res = vec2(tp, 1.);
    }
    for(int i = 0; i < RAYMARCH_TIME && t < tmax; i++) {
        vec3 p = ro + t * rd;
        vec2 d = map(p);
        if(d.x < PRECISION) {
            res = vec2(t, d.y);
            break;
        }
        t += d.x;
    }
    return res;
}

// https://iquilezles.org/articles/normalsSDF
vec3 calcNormal(in vec3 p) {
    const float h = 0.0001;
    const vec2 k = vec2(1, -1);
    return normalize(k.xyy * map(p + k.xyy * h).x +
        k.yyx * map(p + k.yyx * h).x +
        k.yxy * map(p + k.yxy * h).x +
        k.xxx * map(p + k.xxx * h).x);
}

mat3 setCamera(vec3 ta, vec3 ro, float cr) {
    vec3 z = normalize(ta - ro);
    vec3 cp = vec3(sin(cr), cos(cr), 0.);
    vec3 x = normalize(cross(z, cp));
    vec3 y = cross(x, z);
    return mat3(x, y, z);
}

// https://iquilezles.org/articles/rmshadows
float softShadow(in vec3 ro, in vec3 rd, float k) {
    float res = 1.0;
    float ph = 1e20;
    float tmin = .1;
    float tmax = 10.;
    for(float t = tmin; t < tmax;) {
        float h = map(ro + rd * t).x;
        if(h < 0.001)
            return 0.0;
        float y = h * h / (2.0 * ph);
        float d = sqrt(h * h - y * y);
        res = min(res, k * d / max(0.0, t - y));
        ph = h;
        t += h;
    }
    return res;
}

// https://iquilezles.org/articles/checkerfiltering
float checkersGrad(in vec2 uv, in vec2 ddx, in vec2 ddy) {
    vec2 w = max(abs(ddx), abs(ddy)) + 0.01;
    vec2 i = (2. * abs(fract(.5 * (uv - 0.5 * w)) - .5) - (2. * abs(fract(.5 * (uv + 0.5 * w)) - .5))) / w;
    return 0.5 - 0.5 * i.x * i.y;
}

vec3 render(in vec2 uv, in vec2 px, in vec2 py) {
    float ro_an = .3 * sin(.3 * iTime);
    vec3 ro = vec3(4. * cos(ro_an), 1. + .5 * sin(.3 * iTime), 4. * sin(ro_an));
    if(iMouse.z > 0.01) {
        float theta = iMouse.x / iResolution.x * 2. * PI;
        ro = vec3(4. * cos(theta), 2. - iMouse.y / iResolution.y * 2., 4. * sin(theta));
    }
    vec3 ta = vec3(0., 1., 0.);
    mat3 cam = setCamera(ta, ro, 0.);
    float fl = 1.;
    vec3 rd = normalize(cam * vec3(uv, fl));
    vec3 bg = vec3(.7, .7, .9);
    vec3 color = bg - rd.y * vec3(.1);
    vec2 t = rayMarch(ro, rd);
    if(t.y > 0.) {
        vec3 p = ro + t.x * rd;
        vec3 n = (t.y < 1.1) ? vec3(0., 1., 0.) : calcNormal(p);
        vec3 light = vec3(6., 4., 5.);
        float dif = clamp(dot(normalize(light - p), n), 0., 1.);
        p += PRECISION * n;
        dif *= softShadow(p, normalize(light - p), 10.);
        float amb = 0.5 + 0.5 * dot(n, vec3(0., 1., 0.));
        vec3 c = vec3(0.);
        if(t.y > 1.9 && t.y < 2.1) {
            // Body
            c = vec3(1.);
        } else if(t.y > 2.9 && t.y < 3.1) {
            // Black
            c = vec3(0.);
        } else if(t.y > 0.9 && t.y < 1.1) {
            // plane
            vec3 rdx = normalize(cam * vec3(px, fl));
            vec3 rdy = normalize(cam * vec3(py, fl));
            vec3 ddx = ro.y * (rd / rd.y - rdx / rdx.y);
            vec3 ddy = ro.y * (rd / rd.y - rdy / rdy.y);
            c = vec3(.1) + vec3(0.1) * checkersGrad(p.xz, ddx.xz, ddy.xz);
        }
        color = amb * c + dif * vec3(.7);
    }
    return sqrt(color);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec3 color = vec3(0.);
    for(int m = 0; m < AA; m++) {
        for(int n = 0; n < AA; n++) {
            vec2 offset = 2. * (vec2(float(m), float(n)) / float(AA) - .5);
            vec2 uv = fixUV(fragCoord + offset);
            vec2 px = fixUV(fragCoord + vec2(1., 0.) + offset);
            vec2 py = fixUV(fragCoord + vec2(0., 1.) + offset);
            color += render(uv, px, py);
        }
    }
    fragColor = vec4(color / float(AA * AA), 1.);
}
