Shader "Custom/RampDiffuse" {
	Properties {
		_EmissiveColor ("Emissive Color", Color) = (1,1,1,1)
		_AmbientColor  ("Ambient Color", Color) = (1,1,1,1)
		_MySliderValue ("This is a Slider", Range(0,10)) = 2.5
		_RampTex ("Ramp Texture", 2D) = "white"{}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
        LOD 200
        
        	
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }
Program "vp" {
// Vertex combos: 9
//   opengl - ALU: 5 to 65
//   d3d9 - ALU: 5 to 65
//   d3d11 - ALU: 5 to 47, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 5 to 47, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Matrix 5 [_Object2World]
Vector 17 [unity_Scale]
"!!ARBvp1.0
# 30 ALU
PARAM c[18] = { { 1 },
		state.matrix.mvp,
		program.local[5..17] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[17].w;
DP3 R3.w, R1, c[6];
DP3 R2.w, R1, c[7];
DP3 R0.x, R1, c[5];
MOV R0.y, R3.w;
MOV R0.z, R2.w;
MUL R1, R0.xyzz, R0.yzzx;
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[12];
DP4 R2.y, R0, c[11];
DP4 R2.x, R0, c[10];
MUL R0.y, R3.w, R3.w;
MAD R0.y, R0.x, R0.x, -R0;
MOV result.texcoord[0].x, R0;
DP4 R3.z, R1, c[15];
DP4 R3.y, R1, c[14];
DP4 R3.x, R1, c[13];
MUL R1.xyz, R0.y, c[16];
ADD R2.xyz, R2, R3;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
ADD result.texcoord[1].xyz, R2, R1;
MOV result.texcoord[0].z, R2.w;
MOV result.texcoord[0].y, R3.w;
ADD result.texcoord[2].xyz, -R0, c[9];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 30 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceCameraPos]
Vector 9 [unity_SHAr]
Vector 10 [unity_SHAg]
Vector 11 [unity_SHAb]
Vector 12 [unity_SHBr]
Vector 13 [unity_SHBg]
Vector 14 [unity_SHBb]
Vector 15 [unity_SHC]
Matrix 4 [_Object2World]
Vector 16 [unity_Scale]
"vs_2_0
; 30 ALU
def c17, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
mul r1.xyz, v1, c16.w
dp3 r3.w, r1, c5
dp3 r2.w, r1, c6
dp3 r0.x, r1, c4
mov r0.y, r3.w
mov r0.z, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c17.x
dp4 r2.z, r0, c11
dp4 r2.y, r0, c10
dp4 r2.x, r0, c9
mul r0.y, r3.w, r3.w
mad r0.y, r0.x, r0.x, -r0
mov oT0.x, r0
dp4 r3.z, r1, c14
dp4 r3.y, r1, c13
dp4 r3.x, r1, c12
mul r1.xyz, r0.y, c15
add r2.xyz, r2, r3
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add oT1.xyz, r2, r1
mov oT0.z, r2.w
mov oT0.y, r3.w
add oT2.xyz, -r0, c8
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "UnityPerCamera" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 27 instructions, 4 temp regs, 0 temp arrays:
// ALU 24 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedoleoejjmglcfabcfaeihjhpjicoeieaaabaaaaaaieafaaaaadaaaaaa
cmaaaaaapeaaaaaahmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoiaaaaaaaaeaaaaaa
aiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaaheaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
aaaeaaaaeaaaabaaaaabaaaafjaaaaaeegiocaaaaaaaaaaaafaaaaaafjaaaaae
egiocaaaabaaaaaacnaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaad
hccabaaaadaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaa
acaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaacaaaaaaamaaaaaa
agaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
acaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaafhccabaaa
abaaaaaaegacbaaaaaaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadp
bbaaaaaibcaabaaaabaaaaaaegiocaaaabaaaaaacgaaaaaaegaobaaaaaaaaaaa
bbaaaaaiccaabaaaabaaaaaaegiocaaaabaaaaaachaaaaaaegaobaaaaaaaaaaa
bbaaaaaiecaabaaaabaaaaaaegiocaaaabaaaaaaciaaaaaaegaobaaaaaaaaaaa
diaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaai
bcaabaaaadaaaaaaegiocaaaabaaaaaacjaaaaaaegaobaaaacaaaaaabbaaaaai
ccaabaaaadaaaaaaegiocaaaabaaaaaackaaaaaaegaobaaaacaaaaaabbaaaaai
ecaabaaaadaaaaaaegiocaaaabaaaaaaclaaaaaaegaobaaaacaaaaaaaaaaaaah
hcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaahccaabaaa
aaaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaiaebaaaaaaaaaaaaaadcaaaaak
hccabaaaacaaaaaaegiccaaaabaaaaaacmaaaaaaagaabaaaaaaaaaaaegacbaaa
abaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaa
anaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaaj
hccabaaaadaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaaaaaaaaaaaeaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_2 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal_8;
  normal_8 = tmpvar_6;
  highp float vC_9;
  mediump vec3 x3_10;
  mediump vec3 x2_11;
  mediump vec3 x1_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAr, normal_8);
  x1_12.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAg, normal_8);
  x1_12.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAb, normal_8);
  x1_12.z = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = (normal_8.xyzz * normal_8.yzzx);
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBr, tmpvar_16);
  x2_11.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBg, tmpvar_16);
  x2_11.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBb, tmpvar_16);
  x2_11.z = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = ((normal_8.x * normal_8.x) - (normal_8.y * normal_8.y));
  vC_9 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (unity_SHC.xyz * vC_9);
  x3_10 = tmpvar_21;
  tmpvar_7 = ((x1_12 + x2_11) + x3_10);
  shlight_1 = tmpvar_7;
  tmpvar_3 = shlight_1;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform sampler2D _RampTex;
uniform highp float _MySliderValue;
uniform highp vec4 _AmbientColor;
uniform highp vec4 _EmissiveColor;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = pow ((_EmissiveColor + _AmbientColor), vec4(_MySliderValue));
  highp vec3 tmpvar_5;
  tmpvar_5 = tmpvar_4.xyz;
  tmpvar_2 = tmpvar_5;
  highp float tmpvar_6;
  tmpvar_6 = tmpvar_4.w;
  tmpvar_3 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize(xlv_TEXCOORD2);
  mediump vec3 viewDir_8;
  viewDir_8 = tmpvar_7;
  highp vec4 col_9;
  highp vec3 ramp_10;
  highp float rimLight_11;
  highp float difLight_12;
  lowp float tmpvar_13;
  tmpvar_13 = max (0.0, dot (xlv_TEXCOORD0, _WorldSpaceLightPos0.xyz));
  difLight_12 = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = max (0.0, dot (xlv_TEXCOORD0, viewDir_8));
  rimLight_11 = tmpvar_14;
  highp vec2 tmpvar_15;
  tmpvar_15.x = ((difLight_12 * 0.5) + 0.5);
  tmpvar_15.y = ((rimLight_11 * 0.5) + 0.5);
  lowp vec3 tmpvar_16;
  tmpvar_16 = texture2D (_RampTex, tmpvar_15).xyz;
  ramp_10 = tmpvar_16;
  col_9.xyz = ((tmpvar_2 * _LightColor0.xyz) * ramp_10);
  col_9.w = tmpvar_3;
  c_1 = col_9;
  c_1.xyz = (c_1.xyz + (tmpvar_2 * xlv_TEXCOORD1));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_2 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal_8;
  normal_8 = tmpvar_6;
  highp float vC_9;
  mediump vec3 x3_10;
  mediump vec3 x2_11;
  mediump vec3 x1_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAr, normal_8);
  x1_12.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAg, normal_8);
  x1_12.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAb, normal_8);
  x1_12.z = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = (normal_8.xyzz * normal_8.yzzx);
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBr, tmpvar_16);
  x2_11.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBg, tmpvar_16);
  x2_11.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBb, tmpvar_16);
  x2_11.z = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = ((normal_8.x * normal_8.x) - (normal_8.y * normal_8.y));
  vC_9 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (unity_SHC.xyz * vC_9);
  x3_10 = tmpvar_21;
  tmpvar_7 = ((x1_12 + x2_11) + x3_10);
  shlight_1 = tmpvar_7;
  tmpvar_3 = shlight_1;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform sampler2D _RampTex;
uniform highp float _MySliderValue;
uniform highp vec4 _AmbientColor;
uniform highp vec4 _EmissiveColor;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = pow ((_EmissiveColor + _AmbientColor), vec4(_MySliderValue));
  highp vec3 tmpvar_5;
  tmpvar_5 = tmpvar_4.xyz;
  tmpvar_2 = tmpvar_5;
  highp float tmpvar_6;
  tmpvar_6 = tmpvar_4.w;
  tmpvar_3 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize(xlv_TEXCOORD2);
  mediump vec3 viewDir_8;
  viewDir_8 = tmpvar_7;
  highp vec4 col_9;
  highp vec3 ramp_10;
  highp float rimLight_11;
  highp float difLight_12;
  lowp float tmpvar_13;
  tmpvar_13 = max (0.0, dot (xlv_TEXCOORD0, _WorldSpaceLightPos0.xyz));
  difLight_12 = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = max (0.0, dot (xlv_TEXCOORD0, viewDir_8));
  rimLight_11 = tmpvar_14;
  highp vec2 tmpvar_15;
  tmpvar_15.x = ((difLight_12 * 0.5) + 0.5);
  tmpvar_15.y = ((rimLight_11 * 0.5) + 0.5);
  lowp vec3 tmpvar_16;
  tmpvar_16 = texture2D (_RampTex, tmpvar_15).xyz;
  ramp_10 = tmpvar_16;
  col_9.xyz = ((tmpvar_2 * _LightColor0.xyz) * ramp_10);
  col_9.w = tmpvar_3;
  c_1 = col_9;
  c_1.xyz = (c_1.xyz + (tmpvar_2 * xlv_TEXCOORD1));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceCameraPos]
Vector 9 [unity_SHAr]
Vector 10 [unity_SHAg]
Vector 11 [unity_SHAb]
Vector 12 [unity_SHBr]
Vector 13 [unity_SHBg]
Vector 14 [unity_SHBb]
Vector 15 [unity_SHC]
Matrix 4 [_Object2World]
Vector 16 [unity_Scale]
"agal_vs
c17 1.0 0.0 0.0 0.0
[bc]
adaaaaaaabaaahacabaaaaoeaaaaaaaabaaaaappabaaaaaa mul r1.xyz, a1, c16.w
bcaaaaaaadaaaiacabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r3.w, r1.xyzz, c5
bcaaaaaaacaaaiacabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r2.w, r1.xyzz, c6
bcaaaaaaaaaaabacabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r0.x, r1.xyzz, c4
aaaaaaaaaaaaacacadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.y, r3.w
aaaaaaaaaaaaaeacacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.z, r2.w
adaaaaaaabaaapacaaaaaakeacaaaaaaaaaaaacjacaaaaaa mul r1, r0.xyzz, r0.yzzx
aaaaaaaaaaaaaiacbbaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c17.x
bdaaaaaaacaaaeacaaaaaaoeacaaaaaaalaaaaoeabaaaaaa dp4 r2.z, r0, c11
bdaaaaaaacaaacacaaaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r2.y, r0, c10
bdaaaaaaacaaabacaaaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r2.x, r0, c9
adaaaaaaaaaaacacadaaaappacaaaaaaadaaaappacaaaaaa mul r0.y, r3.w, r3.w
adaaaaaaaeaaacacaaaaaaaaacaaaaaaaaaaaaaaacaaaaaa mul r4.y, r0.x, r0.x
acaaaaaaaaaaacacaeaaaaffacaaaaaaaaaaaaffacaaaaaa sub r0.y, r4.y, r0.y
aaaaaaaaaaaaabaeaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov v0.x, r0.x
bdaaaaaaadaaaeacabaaaaoeacaaaaaaaoaaaaoeabaaaaaa dp4 r3.z, r1, c14
bdaaaaaaadaaacacabaaaaoeacaaaaaaanaaaaoeabaaaaaa dp4 r3.y, r1, c13
bdaaaaaaadaaabacabaaaaoeacaaaaaaamaaaaoeabaaaaaa dp4 r3.x, r1, c12
adaaaaaaabaaahacaaaaaaffacaaaaaaapaaaaoeabaaaaaa mul r1.xyz, r0.y, c15
abaaaaaaacaaahacacaaaakeacaaaaaaadaaaakeacaaaaaa add r2.xyz, r2.xyzz, r3.xyzz
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
abaaaaaaabaaahaeacaaaakeacaaaaaaabaaaakeacaaaaaa add v1.xyz, r2.xyzz, r1.xyzz
aaaaaaaaaaaaaeaeacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v0.z, r2.w
aaaaaaaaaaaaacaeadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v0.y, r3.w
bfaaaaaaaeaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r4.xyz, r0.xyzz
abaaaaaaacaaahaeaeaaaakeacaaaaaaaiaaaaoeabaaaaaa add v2.xyz, r4.xyzz, c8
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "UnityPerCamera" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 27 instructions, 4 temp regs, 0 temp arrays:
// ALU 24 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedbfpnliikjpcfknabomhhdpomfbeejkfmabaaaaaaamaiaaaaaeaaaaaa
daaaaaaaleacaaaalmagaaaaieahaaaaebgpgodjhmacaaaahmacaaaaaaacpopp
biacaaaageaaaaaaafaaceaaaaaagaaaaaaagaaaaaaaceaaabaagaaaaaaaaeaa
abaaabaaaaaaaaaaabaacgaaahaaacaaaaaaaaaaacaaaaaaaeaaajaaaaaaaaaa
acaaamaaaeaaanaaaaaaaaaaacaabeaaabaabbaaaaaaaaaaaaaaaaaaaaacpopp
fbaaaaafbcaaapkaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaabpaaaaacafaaaaia
aaaaapjabpaaaaacafaaaciaacaaapjaafaaaaadaaaaahiaaaaaffjaaoaaoeka
aeaaaaaeaaaaahiaanaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaahiaapaaoeka
aaaakkjaaaaaoeiaaeaaaaaeaaaaahiabaaaoekaaaaappjaaaaaoeiaacaaaaad
acaaahoaaaaaoeibabaaoekaafaaaaadaaaaahiaacaaoejabbaappkaafaaaaad
abaaahiaaaaaffiaaoaaoekaaeaaaaaeaaaaaliaanaakekaaaaaaaiaabaakeia
aeaaaaaeaaaaahiaapaaoekaaaaakkiaaaaapeiaabaaaaacaaaaaiiabcaaaaka
ajaaaaadabaaabiaacaaoekaaaaaoeiaajaaaaadabaaaciaadaaoekaaaaaoeia
ajaaaaadabaaaeiaaeaaoekaaaaaoeiaafaaaaadacaaapiaaaaacjiaaaaakeia
ajaaaaadadaaabiaafaaoekaacaaoeiaajaaaaadadaaaciaagaaoekaacaaoeia
ajaaaaadadaaaeiaahaaoekaacaaoeiaacaaaaadabaaahiaabaaoeiaadaaoeia
afaaaaadaaaaaiiaaaaaffiaaaaaffiaaeaaaaaeaaaaaiiaaaaaaaiaaaaaaaia
aaaappibabaaaaacaaaaahoaaaaaoeiaaeaaaaaeabaaahoaaiaaoekaaaaappia
abaaoeiaafaaaaadaaaaapiaaaaaffjaakaaoekaaeaaaaaeaaaaapiaajaaoeka
aaaaaajaaaaaoeiaaeaaaaaeaaaaapiaalaaoekaaaaakkjaaaaaoeiaaeaaaaae
aaaaapiaamaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoeka
aaaaoeiaabaaaaacaaaaammaaaaaoeiappppaaaafdeieefcaaaeaaaaeaaaabaa
aaabaaaafjaaaaaeegiocaaaaaaaaaaaafaaaaaafjaaaaaeegiocaaaabaaaaaa
cnaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaad
hccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaa
giaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaacaaaaaabeaaaaaa
diaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaa
dcaaaaaklcaabaaaaaaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaaaaaaaaaaa
egaibaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaaoaaaaaa
kgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaafhccabaaaabaaaaaaegacbaaa
aaaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaa
abaaaaaaegiocaaaabaaaaaacgaaaaaaegaobaaaaaaaaaaabbaaaaaiccaabaaa
abaaaaaaegiocaaaabaaaaaachaaaaaaegaobaaaaaaaaaaabbaaaaaiecaabaaa
abaaaaaaegiocaaaabaaaaaaciaaaaaaegaobaaaaaaaaaaadiaaaaahpcaabaaa
acaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaaibcaabaaaadaaaaaa
egiocaaaabaaaaaacjaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaa
egiocaaaabaaaaaackaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaa
egiocaaaabaaaaaaclaaaaaaegaobaaaacaaaaaaaaaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaahccaabaaaaaaaaaaabkaabaaa
aaaaaaaabkaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
akaabaaaaaaaaaaabkaabaiaebaaaaaaaaaaaaaadcaaaaakhccabaaaacaaaaaa
egiccaaaabaaaaaacmaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadiaaaaai
hcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
aaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaajhccabaaaadaaaaaa
egacbaiaebaaaaaaaaaaaaaaegiccaaaaaaaaaaaaeaaaaaadoaaaaabejfdeheo
maaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakjaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaadaaaaaaapaaaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaaaeaaaaaa
apaaaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
ahaiaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaaheaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 395
struct Input {
    highp vec2 uv_MainTex;
};
#line 418
struct v2f_surf {
    highp vec4 pos;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec3 viewDir;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _EmissiveColor;
uniform highp vec4 _AmbientColor;
#line 393
uniform highp float _MySliderValue;
uniform sampler2D _RampTex;
#line 400
#line 426
#line 439
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 87
highp vec3 WorldSpaceViewDir( in highp vec4 v ) {
    return (_WorldSpaceCameraPos.xyz - (_Object2World * v).xyz);
}
#line 426
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 430
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.normal = worldN;
    highp vec3 viewDirForLight = WorldSpaceViewDir( v.vertex);
    o.viewDir = viewDirForLight;
    #line 434
    highp vec3 shlight = ShadeSH9( vec4( worldN, 1.0));
    o.vlight = shlight;
    return o;
}

out lowp vec3 xlv_TEXCOORD0;
out lowp vec3 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.normal);
    xlv_TEXCOORD1 = vec3(xl_retval.vlight);
    xlv_TEXCOORD2 = vec3(xl_retval.viewDir);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 395
struct Input {
    highp vec2 uv_MainTex;
};
#line 418
struct v2f_surf {
    highp vec4 pos;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec3 viewDir;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _EmissiveColor;
uniform highp vec4 _AmbientColor;
#line 393
uniform highp float _MySliderValue;
uniform sampler2D _RampTex;
#line 400
#line 426
#line 439
#line 406
highp vec4 LightingBasicDiffuse( in SurfaceOutput s, in lowp vec3 lightDir, in mediump vec3 viewDir, in lowp float atten ) {
    #line 408
    highp float difLight = max( 0.0, dot( s.Normal, lightDir));
    highp float rimLight = max( 0.0, dot( s.Normal, viewDir));
    highp float dif_hLambert = ((difLight * 0.5) + 0.5);
    highp float rim_hLambert = ((rimLight * 0.5) + 0.5);
    #line 412
    highp vec3 ramp = texture( _RampTex, vec2( dif_hLambert, rim_hLambert)).xyz;
    highp vec4 col;
    col.xyz = ((s.Albedo * _LightColor0.xyz) * ramp);
    col.w = s.Alpha;
    #line 416
    return col;
}
#line 400
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec4 c = pow( (_EmissiveColor + _AmbientColor), vec4( _MySliderValue));
    o.Albedo = c.xyz;
    #line 404
    o.Alpha = c.w;
}
#line 439
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    #line 443
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    #line 447
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    surf( surfIN, o);
    lowp float atten = 1.0;
    #line 451
    lowp vec4 c = vec4( 0.0);
    c = LightingBasicDiffuse( o, _WorldSpaceLightPos0.xyz, normalize(IN.viewDir), atten);
    c.xyz += (o.Albedo * IN.vlight);
    return c;
}
in lowp vec3 xlv_TEXCOORD0;
in lowp vec3 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.normal = vec3(xlv_TEXCOORD0);
    xlt_IN.vlight = vec3(xlv_TEXCOORD1);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD2);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Vector 9 [unity_LightmapST]
"!!ARBvp1.0
# 5 ALU
PARAM c[10] = { program.local[0],
		state.matrix.mvp,
		program.local[5..9] };
MAD result.texcoord[0].xy, vertex.texcoord[1], c[9], c[9].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 5 instructions, 0 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_LightmapST]
"vs_2_0
; 5 ALU
dcl_position0 v0
dcl_texcoord1 v2
mad oT0.xy, v2, c8, c8.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 112 // 112 used size, 7 vars
Vector 96 [unity_LightmapST] 4
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "$Globals" 0
BindCB "UnityPerDraw" 1
// 6 instructions, 1 temp regs, 0 temp arrays:
// ALU 5 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedcohokmjkjhdmffelmafcagkbgfcpilheabaaaaaaiaacaaaaadaaaaaa
cmaaaaaapeaaaaaaemabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheofaaaaaaaacaaaaaa
aiaaaaaadiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefccmabaaaaeaaaabaaelaaaaaafjaaaaae
egiocaaaaaaaaaaaahaaaaaafjaaaaaeegiocaaaabaaaaaaaeaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaaddccabaaaabaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
aeaaaaaaegiacaaaaaaaaaaaagaaaaaaogikcaaaaaaaaaaaagaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 glstate_matrix_mvp;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp float _MySliderValue;
uniform highp vec4 _AmbientColor;
uniform highp vec4 _EmissiveColor;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = pow ((_EmissiveColor + _AmbientColor), vec4(_MySliderValue));
  highp vec3 tmpvar_5;
  tmpvar_5 = tmpvar_4.xyz;
  tmpvar_2 = tmpvar_5;
  highp float tmpvar_6;
  tmpvar_6 = tmpvar_4.w;
  tmpvar_3 = tmpvar_6;
  c_1.xyz = (tmpvar_2 * (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD0).xyz));
  c_1.w = tmpvar_3;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 glstate_matrix_mvp;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp float _MySliderValue;
uniform highp vec4 _AmbientColor;
uniform highp vec4 _EmissiveColor;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = pow ((_EmissiveColor + _AmbientColor), vec4(_MySliderValue));
  highp vec3 tmpvar_5;
  tmpvar_5 = tmpvar_4.xyz;
  tmpvar_2 = tmpvar_5;
  highp float tmpvar_6;
  tmpvar_6 = tmpvar_4.w;
  tmpvar_3 = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (unity_Lightmap, xlv_TEXCOORD0);
  c_1.xyz = (tmpvar_2 * ((8.0 * tmpvar_7.w) * tmpvar_7.xyz));
  c_1.w = tmpvar_3;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_LightmapST]
"agal_vs
[bc]
adaaaaaaaaaaadacaeaaaaoeaaaaaaaaaiaaaaoeabaaaaaa mul r0.xy, a4, c8
abaaaaaaaaaaadaeaaaaaafeacaaaaaaaiaaaaooabaaaaaa add v0.xy, r0.xyyy, c8.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 112 // 112 used size, 7 vars
Vector 96 [unity_LightmapST] 4
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "$Globals" 0
BindCB "UnityPerDraw" 1
// 6 instructions, 1 temp regs, 0 temp arrays:
// ALU 5 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedfgkllgdmmokoagfcoehcebobomcoogmmabaaaaaagmadaaaaaeaaaaaa
daaaaaaabiabaaaaemacaaaabeadaaaaebgpgodjoaaaaaaaoaaaaaaaaaacpopp
kaaaaaaaeaaaaaaaacaaceaaaaaadmaaaaaadmaaaaaaceaaabaadmaaaaaaagaa
abaaabaaaaaaaaaaabaaaaaaaeaaacaaaaaaaaaaaaaaaaaaaaacpoppbpaaaaac
afaaaaiaaaaaapjabpaaaaacafaaaeiaaeaaapjaaeaaaaaeaaaaadoaaeaaoeja
abaaoekaabaaookaafaaaaadaaaaapiaaaaaffjaadaaoekaaeaaaaaeaaaaapia
acaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaaeaaoekaaaaakkjaaaaaoeia
aeaaaaaeaaaaapiaafaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappia
aaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiappppaaaafdeieefccmabaaaa
eaaaabaaelaaaaaafjaaaaaeegiocaaaaaaaaaaaahaaaaaafjaaaaaeegiocaaa
abaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaaeaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagiaaaaac
abaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaaeaaaaaaegiacaaaaaaaaaaaagaaaaaaogikcaaa
aaaaaaaaagaaaaaadoaaaaabejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheofaaaaaaaacaaaaaa
aiaaaaaadiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 395
struct Input {
    highp vec2 uv_MainTex;
};
#line 418
struct v2f_surf {
    highp vec4 pos;
    highp vec2 lmap;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _EmissiveColor;
uniform highp vec4 _AmbientColor;
#line 393
uniform highp float _MySliderValue;
uniform sampler2D _RampTex;
#line 400
#line 424
uniform highp vec4 unity_LightmapST;
uniform sampler2D unity_Lightmap;
#line 425
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 428
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    #line 432
    return o;
}

out highp vec2 xlv_TEXCOORD0;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.lmap);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 395
struct Input {
    highp vec2 uv_MainTex;
};
#line 418
struct v2f_surf {
    highp vec4 pos;
    highp vec2 lmap;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _EmissiveColor;
uniform highp vec4 _AmbientColor;
#line 393
uniform highp float _MySliderValue;
uniform sampler2D _RampTex;
#line 400
#line 424
uniform highp vec4 unity_LightmapST;
uniform sampler2D unity_Lightmap;
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 400
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec4 c = pow( (_EmissiveColor + _AmbientColor), vec4( _MySliderValue));
    o.Albedo = c.xyz;
    #line 404
    o.Alpha = c.w;
}
#line 435
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 437
    Input surfIN;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 441
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    surf( surfIN, o);
    #line 445
    lowp float atten = 1.0;
    lowp vec4 c = vec4( 0.0);
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    lowp vec3 lm = DecodeLightmap( lmtex);
    #line 449
    c.xyz += (o.Albedo * lm);
    c.w = o.Alpha;
    return c;
}
in highp vec2 xlv_TEXCOORD0;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.lmap = vec2(xlv_TEXCOORD0);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [unity_SHAr]
Vector 12 [unity_SHAg]
Vector 13 [unity_SHAb]
Vector 14 [unity_SHBr]
Vector 15 [unity_SHBg]
Vector 16 [unity_SHBb]
Vector 17 [unity_SHC]
Matrix 5 [_Object2World]
Vector 18 [unity_Scale]
"!!ARBvp1.0
# 35 ALU
PARAM c[19] = { { 1, 0.5 },
		state.matrix.mvp,
		program.local[5..18] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R0.xyz, vertex.normal, c[18].w;
DP3 R3.w, R0, c[6];
DP3 R2.w, R0, c[7];
DP3 R1.w, R0, c[5];
MOV R1.x, R3.w;
MOV R1.y, R2.w;
MOV R1.z, c[0].x;
MUL R0, R1.wxyy, R1.xyyw;
DP4 R2.z, R1.wxyz, c[13];
DP4 R2.y, R1.wxyz, c[12];
DP4 R2.x, R1.wxyz, c[11];
DP4 R1.z, R0, c[16];
DP4 R1.y, R0, c[15];
DP4 R1.x, R0, c[14];
MUL R3.x, R3.w, R3.w;
MAD R0.x, R1.w, R1.w, -R3;
ADD R3.xyz, R2, R1;
MUL R2.xyz, R0.x, c[17];
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].y;
MOV result.position, R0;
MUL R1.y, R1, c[10].x;
MOV result.texcoord[3].zw, R0;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
ADD result.texcoord[1].xyz, R3, R2;
ADD result.texcoord[3].xy, R1, R1.z;
MOV result.texcoord[0].z, R2.w;
MOV result.texcoord[0].y, R3.w;
MOV result.texcoord[0].x, R1.w;
ADD result.texcoord[2].xyz, -R0, c[9];
END
# 35 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceCameraPos]
Vector 9 [_ProjectionParams]
Vector 10 [_ScreenParams]
Vector 11 [unity_SHAr]
Vector 12 [unity_SHAg]
Vector 13 [unity_SHAb]
Vector 14 [unity_SHBr]
Vector 15 [unity_SHBg]
Vector 16 [unity_SHBb]
Vector 17 [unity_SHC]
Matrix 4 [_Object2World]
Vector 18 [unity_Scale]
"vs_2_0
; 35 ALU
def c19, 1.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
mul r0.xyz, v1, c18.w
dp3 r3.w, r0, c5
dp3 r2.w, r0, c6
dp3 r1.w, r0, c4
mov r1.x, r3.w
mov r1.y, r2.w
mov r1.z, c19.x
mul r0, r1.wxyy, r1.xyyw
dp4 r2.z, r1.wxyz, c13
dp4 r2.y, r1.wxyz, c12
dp4 r2.x, r1.wxyz, c11
dp4 r1.z, r0, c16
dp4 r1.y, r0, c15
dp4 r1.x, r0, c14
mul r3.x, r3.w, r3.w
mad r0.x, r1.w, r1.w, -r3
add r3.xyz, r2, r1
mul r2.xyz, r0.x, c17
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c19.y
mov oPos, r0
mul r1.y, r1, c9.x
mov oT3.zw, r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add oT1.xyz, r3, r2
mad oT3.xy, r1.z, c10.zwzw, r1
mov oT0.z, r2.w
mov oT0.y, r3.w
mov oT0.x, r1.w
add oT2.xyz, -r0, c8
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "UnityPerCamera" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 32 instructions, 5 temp regs, 0 temp arrays:
// ALU 27 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedofnchbmjcbnlblmmefknnnpdiocjkamdabaaaaaadeagaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcjiaeaaaaeaaaabaa
cgabaaaafjaaaaaeegiocaaaaaaaaaaaagaaaaaafjaaaaaeegiocaaaabaaaaaa
cnaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaad
hccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaa
gfaaaaadpccabaaaaeaaaaaagiaaaaacafaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaihcaabaaaabaaaaaaegbcbaaaacaaaaaapgipcaaaacaaaaaabeaaaaaa
diaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaaacaaaaaaanaaaaaa
dcaaaaaklcaabaaaabaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaaaabaaaaaa
egaibaaaacaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaa
kgakbaaaabaaaaaaegadbaaaabaaaaaadgaaaaafhccabaaaabaaaaaaegacbaaa
abaaaaaadgaaaaaficaabaaaabaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaa
acaaaaaaegiocaaaabaaaaaacgaaaaaaegaobaaaabaaaaaabbaaaaaiccaabaaa
acaaaaaaegiocaaaabaaaaaachaaaaaaegaobaaaabaaaaaabbaaaaaiecaabaaa
acaaaaaaegiocaaaabaaaaaaciaaaaaaegaobaaaabaaaaaadiaaaaahpcaabaaa
adaaaaaajgacbaaaabaaaaaaegakbaaaabaaaaaabbaaaaaibcaabaaaaeaaaaaa
egiocaaaabaaaaaacjaaaaaaegaobaaaadaaaaaabbaaaaaiccaabaaaaeaaaaaa
egiocaaaabaaaaaackaaaaaaegaobaaaadaaaaaabbaaaaaiecaabaaaaeaaaaaa
egiocaaaabaaaaaaclaaaaaaegaobaaaadaaaaaaaaaaaaahhcaabaaaacaaaaaa
egacbaaaacaaaaaaegacbaaaaeaaaaaadiaaaaahccaabaaaabaaaaaabkaabaaa
abaaaaaabkaabaaaabaaaaaadcaaaaakbcaabaaaabaaaaaaakaabaaaabaaaaaa
akaabaaaabaaaaaabkaabaiaebaaaaaaabaaaaaadcaaaaakhccabaaaacaaaaaa
egiccaaaabaaaaaacmaaaaaaagaabaaaabaaaaaaegacbaaaacaaaaaadiaaaaai
hcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaajhccabaaaadaaaaaa
egacbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaaaeaaaaaadiaaaaaiccaabaaa
aaaaaaaabkaabaaaaaaaaaaaakiacaaaaaaaaaaaafaaaaaadiaaaaakncaabaaa
abaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadp
dgaaaaafmccabaaaaeaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaaeaaaaaa
kgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_2 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal_8;
  normal_8 = tmpvar_6;
  highp float vC_9;
  mediump vec3 x3_10;
  mediump vec3 x2_11;
  mediump vec3 x1_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAr, normal_8);
  x1_12.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAg, normal_8);
  x1_12.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAb, normal_8);
  x1_12.z = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = (normal_8.xyzz * normal_8.yzzx);
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBr, tmpvar_16);
  x2_11.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBg, tmpvar_16);
  x2_11.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBb, tmpvar_16);
  x2_11.z = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = ((normal_8.x * normal_8.x) - (normal_8.y * normal_8.y));
  vC_9 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (unity_SHC.xyz * vC_9);
  x3_10 = tmpvar_21;
  tmpvar_7 = ((x1_12 + x2_11) + x3_10);
  shlight_1 = tmpvar_7;
  tmpvar_3 = shlight_1;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform sampler2D _RampTex;
uniform highp float _MySliderValue;
uniform highp vec4 _AmbientColor;
uniform highp vec4 _EmissiveColor;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = pow ((_EmissiveColor + _AmbientColor), vec4(_MySliderValue));
  highp vec3 tmpvar_5;
  tmpvar_5 = tmpvar_4.xyz;
  tmpvar_2 = tmpvar_5;
  highp float tmpvar_6;
  tmpvar_6 = tmpvar_4.w;
  tmpvar_3 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize(xlv_TEXCOORD2);
  mediump vec3 viewDir_8;
  viewDir_8 = tmpvar_7;
  highp vec4 col_9;
  highp vec3 ramp_10;
  highp float rimLight_11;
  highp float difLight_12;
  lowp float tmpvar_13;
  tmpvar_13 = max (0.0, dot (xlv_TEXCOORD0, _WorldSpaceLightPos0.xyz));
  difLight_12 = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = max (0.0, dot (xlv_TEXCOORD0, viewDir_8));
  rimLight_11 = tmpvar_14;
  highp vec2 tmpvar_15;
  tmpvar_15.x = ((difLight_12 * 0.5) + 0.5);
  tmpvar_15.y = ((rimLight_11 * 0.5) + 0.5);
  lowp vec3 tmpvar_16;
  tmpvar_16 = texture2D (_RampTex, tmpvar_15).xyz;
  ramp_10 = tmpvar_16;
  col_9.xyz = ((tmpvar_2 * _LightColor0.xyz) * ramp_10);
  col_9.w = tmpvar_3;
  c_1 = col_9;
  c_1.xyz = (c_1.xyz + (tmpvar_2 * xlv_TEXCOORD1));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_mvp * _glesVertex);
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_2 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = tmpvar_6;
  mediump vec3 tmpvar_8;
  mediump vec4 normal_9;
  normal_9 = tmpvar_7;
  highp float vC_10;
  mediump vec3 x3_11;
  mediump vec3 x2_12;
  mediump vec3 x1_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal_9);
  x1_13.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal_9);
  x1_13.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal_9);
  x1_13.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal_9.xyzz * normal_9.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2_12.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2_12.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2_12.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal_9.x * normal_9.x) - (normal_9.y * normal_9.y));
  vC_10 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC_10);
  x3_11 = tmpvar_22;
  tmpvar_8 = ((x1_13 + x2_12) + x3_11);
  shlight_1 = tmpvar_8;
  tmpvar_3 = shlight_1;
  highp vec4 o_23;
  highp vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_4 * 0.5);
  highp vec2 tmpvar_25;
  tmpvar_25.x = tmpvar_24.x;
  tmpvar_25.y = (tmpvar_24.y * _ProjectionParams.x);
  o_23.xy = (tmpvar_25 + tmpvar_24.w);
  o_23.zw = tmpvar_4.zw;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = o_23;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform sampler2D _RampTex;
uniform highp float _MySliderValue;
uniform highp vec4 _AmbientColor;
uniform highp vec4 _EmissiveColor;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = pow ((_EmissiveColor + _AmbientColor), vec4(_MySliderValue));
  highp vec3 tmpvar_5;
  tmpvar_5 = tmpvar_4.xyz;
  tmpvar_2 = tmpvar_5;
  highp float tmpvar_6;
  tmpvar_6 = tmpvar_4.w;
  tmpvar_3 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize(xlv_TEXCOORD2);
  mediump vec3 viewDir_8;
  viewDir_8 = tmpvar_7;
  highp vec4 col_9;
  highp vec3 ramp_10;
  highp float rimLight_11;
  highp float difLight_12;
  lowp float tmpvar_13;
  tmpvar_13 = max (0.0, dot (xlv_TEXCOORD0, _WorldSpaceLightPos0.xyz));
  difLight_12 = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = max (0.0, dot (xlv_TEXCOORD0, viewDir_8));
  rimLight_11 = tmpvar_14;
  highp vec2 tmpvar_15;
  tmpvar_15.x = ((difLight_12 * 0.5) + 0.5);
  tmpvar_15.y = ((rimLight_11 * 0.5) + 0.5);
  lowp vec3 tmpvar_16;
  tmpvar_16 = texture2D (_RampTex, tmpvar_15).xyz;
  ramp_10 = tmpvar_16;
  col_9.xyz = ((tmpvar_2 * _LightColor0.xyz) * ramp_10);
  col_9.w = tmpvar_3;
  c_1 = col_9;
  c_1.xyz = (c_1.xyz + (tmpvar_2 * xlv_TEXCOORD1));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceCameraPos]
Vector 9 [_ProjectionParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Matrix 4 [_Object2World]
Vector 17 [unity_Scale]
Vector 18 [unity_NPOTScale]
"agal_vs
c19 1.0 0.5 0.0 0.0
[bc]
adaaaaaaaaaaahacabaaaaoeaaaaaaaabbaaaappabaaaaaa mul r0.xyz, a1, c17.w
bcaaaaaaadaaaiacaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r3.w, r0.xyzz, c5
bcaaaaaaacaaaiacaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r2.w, r0.xyzz, c6
bcaaaaaaabaaaiacaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r1.w, r0.xyzz, c4
aaaaaaaaabaaabacadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r3.w
aaaaaaaaabaaacacacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r1.y, r2.w
aaaaaaaaabaaaeacbdaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.z, c19.x
adaaaaaaaaaaapacabaaaafdacaaaaaaabaaaaneacaaaaaa mul r0, r1.wxyy, r1.xyyw
bdaaaaaaacaaaeacabaaaajdacaaaaaaamaaaaoeabaaaaaa dp4 r2.z, r1.wxyz, c12
bdaaaaaaacaaacacabaaaajdacaaaaaaalaaaaoeabaaaaaa dp4 r2.y, r1.wxyz, c11
bdaaaaaaacaaabacabaaaajdacaaaaaaakaaaaoeabaaaaaa dp4 r2.x, r1.wxyz, c10
bdaaaaaaabaaaeacaaaaaaoeacaaaaaaapaaaaoeabaaaaaa dp4 r1.z, r0, c15
bdaaaaaaabaaacacaaaaaaoeacaaaaaaaoaaaaoeabaaaaaa dp4 r1.y, r0, c14
bdaaaaaaabaaabacaaaaaaoeacaaaaaaanaaaaoeabaaaaaa dp4 r1.x, r0, c13
adaaaaaaadaaabacadaaaappacaaaaaaadaaaappacaaaaaa mul r3.x, r3.w, r3.w
adaaaaaaaeaaabacabaaaappacaaaaaaabaaaappacaaaaaa mul r4.x, r1.w, r1.w
acaaaaaaaaaaabacaeaaaaaaacaaaaaaadaaaaaaacaaaaaa sub r0.x, r4.x, r3.x
abaaaaaaacaaahacacaaaakeacaaaaaaabaaaakeacaaaaaa add r2.xyz, r2.xyzz, r1.xyzz
adaaaaaaabaaahacaaaaaaaaacaaaaaabaaaaaoeabaaaaaa mul r1.xyz, r0.x, c16
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 r0.w, a0, c3
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 r0.z, a0, c2
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 r0.x, a0, c0
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 r0.y, a0, c1
adaaaaaaadaaahacaaaaaapeacaaaaaabdaaaaffabaaaaaa mul r3.xyz, r0.xyww, c19.y
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
abaaaaaaabaaahaeacaaaakeacaaaaaaabaaaakeacaaaaaa add v1.xyz, r2.xyzz, r1.xyzz
aaaaaaaaadaaamaeaaaaaaopacaaaaaaaaaaaaaaaaaaaaaa mov v3.zw, r0.wwzw
adaaaaaaabaaacacadaaaaffacaaaaaaajaaaaaaabaaaaaa mul r1.y, r3.y, c9.x
aaaaaaaaabaaabacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r3.x
abaaaaaaabaaadacabaaaafeacaaaaaaadaaaakkacaaaaaa add r1.xy, r1.xyyy, r3.z
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
adaaaaaaadaaadaeabaaaafeacaaaaaabcaaaaoeabaaaaaa mul v3.xy, r1.xyyy, c18
aaaaaaaaaaaaaeaeacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v0.z, r2.w
aaaaaaaaaaaaacaeadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v0.y, r3.w
aaaaaaaaaaaaabaeabaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v0.x, r1.w
bfaaaaaaaeaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r4.xyz, r0.xyzz
abaaaaaaacaaahaeaeaaaakeacaaaaaaaiaaaaoeabaaaaaa add v2.xyz, r4.xyzz, c8
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "UnityPerCamera" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 32 instructions, 5 temp regs, 0 temp arrays:
// ALU 27 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedangcndemkelnlkgkljlnmpifekiecffhabaaaaaaaiajaaaaaeaaaaaa
daaaaaaaaaadaaaakaahaaaagiaiaaaaebgpgodjmiacaaaamiacaaaaaaacpopp
geacaaaageaaaaaaafaaceaaaaaagaaaaaaagaaaaaaaceaaabaagaaaaaaaaeaa
acaaabaaaaaaaaaaabaacgaaahaaadaaaaaaaaaaacaaaaaaaeaaakaaaaaaaaaa
acaaamaaaeaaaoaaaaaaaaaaacaabeaaabaabcaaaaaaaaaaaaaaaaaaaaacpopp
fbaaaaafbdaaapkaaaaaiadpaaaaaadpaaaaaaaaaaaaaaaabpaaaaacafaaaaia
aaaaapjabpaaaaacafaaaciaacaaapjaafaaaaadaaaaahiaaaaaffjaapaaoeka
aeaaaaaeaaaaahiaaoaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaahiabaaaoeka
aaaakkjaaaaaoeiaaeaaaaaeaaaaahiabbaaoekaaaaappjaaaaaoeiaacaaaaad
acaaahoaaaaaoeibabaaoekaafaaaaadaaaaahiaacaaoejabcaappkaafaaaaad
abaaahiaaaaaffiaapaaoekaaeaaaaaeaaaaaliaaoaakekaaaaaaaiaabaakeia
aeaaaaaeaaaaahiabaaaoekaaaaakkiaaaaapeiaabaaaaacaaaaaiiabdaaaaka
ajaaaaadabaaabiaadaaoekaaaaaoeiaajaaaaadabaaaciaaeaaoekaaaaaoeia
ajaaaaadabaaaeiaafaaoekaaaaaoeiaafaaaaadacaaapiaaaaacjiaaaaakeia
ajaaaaadadaaabiaagaaoekaacaaoeiaajaaaaadadaaaciaahaaoekaacaaoeia
ajaaaaadadaaaeiaaiaaoekaacaaoeiaacaaaaadabaaahiaabaaoeiaadaaoeia
afaaaaadaaaaaiiaaaaaffiaaaaaffiaaeaaaaaeaaaaaiiaaaaaaaiaaaaaaaia
aaaappibabaaaaacaaaaahoaaaaaoeiaaeaaaaaeabaaahoaajaaoekaaaaappia
abaaoeiaafaaaaadaaaaapiaaaaaffjaalaaoekaaeaaaaaeaaaaapiaakaaoeka
aaaaaajaaaaaoeiaaeaaaaaeaaaaapiaamaaoekaaaaakkjaaaaaoeiaaeaaaaae
aaaaapiaanaaoekaaaaappjaaaaaoeiaafaaaaadabaaabiaaaaaffiaacaaaaka
afaaaaadabaaaiiaabaaaaiabdaaffkaafaaaaadabaaafiaaaaapeiabdaaffka
acaaaaadadaaadoaabaakkiaabaaomiaaeaaaaaeaaaaadmaaaaappiaaaaaoeka
aaaaoeiaabaaaaacaaaaammaaaaaoeiaabaaaaacadaaamoaaaaaoeiappppaaaa
fdeieefcjiaeaaaaeaaaabaacgabaaaafjaaaaaeegiocaaaaaaaaaaaagaaaaaa
fjaaaaaeegiocaaaabaaaaaacnaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagiaaaaacafaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaa
aaaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaaegbcbaaaacaaaaaa
pgipcaaaacaaaaaabeaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaaabaaaaaaegiicaaaacaaaaaa
amaaaaaaagaabaaaabaaaaaaegaibaaaacaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaacaaaaaaaoaaaaaakgakbaaaabaaaaaaegadbaaaabaaaaaadgaaaaaf
hccabaaaabaaaaaaegacbaaaabaaaaaadgaaaaaficaabaaaabaaaaaaabeaaaaa
aaaaiadpbbaaaaaibcaabaaaacaaaaaaegiocaaaabaaaaaacgaaaaaaegaobaaa
abaaaaaabbaaaaaiccaabaaaacaaaaaaegiocaaaabaaaaaachaaaaaaegaobaaa
abaaaaaabbaaaaaiecaabaaaacaaaaaaegiocaaaabaaaaaaciaaaaaaegaobaaa
abaaaaaadiaaaaahpcaabaaaadaaaaaajgacbaaaabaaaaaaegakbaaaabaaaaaa
bbaaaaaibcaabaaaaeaaaaaaegiocaaaabaaaaaacjaaaaaaegaobaaaadaaaaaa
bbaaaaaiccaabaaaaeaaaaaaegiocaaaabaaaaaackaaaaaaegaobaaaadaaaaaa
bbaaaaaiecaabaaaaeaaaaaaegiocaaaabaaaaaaclaaaaaaegaobaaaadaaaaaa
aaaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaaaeaaaaaadiaaaaah
ccaabaaaabaaaaaabkaabaaaabaaaaaabkaabaaaabaaaaaadcaaaaakbcaabaaa
abaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaabkaabaiaebaaaaaaabaaaaaa
dcaaaaakhccabaaaacaaaaaaegiccaaaabaaaaaacmaaaaaaagaabaaaabaaaaaa
egacbaaaacaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaamaaaaaa
agbabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
acaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaa
aaaaaaajhccabaaaadaaaaaaegacbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaa
aeaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaaaaaaaaa
afaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadp
aaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaaeaaaaaakgaobaaaaaaaaaaa
aaaaaaahdccabaaaaeaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab
ejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaa
kjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaa
faepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfcee
aaedepemepfcaaklepfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaahaiaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaa
imaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaaimaaaaaaadaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 403
struct Input {
    highp vec2 uv_MainTex;
};
#line 426
struct v2f_surf {
    highp vec4 pos;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec3 viewDir;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform highp vec4 _EmissiveColor;
uniform highp vec4 _AmbientColor;
#line 401
uniform highp float _MySliderValue;
uniform sampler2D _RampTex;
#line 408
#line 435
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 87
highp vec3 WorldSpaceViewDir( in highp vec4 v ) {
    return (_WorldSpaceCameraPos.xyz - (_Object2World * v).xyz);
}
#line 435
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 439
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.normal = worldN;
    highp vec3 viewDirForLight = WorldSpaceViewDir( v.vertex);
    o.viewDir = viewDirForLight;
    #line 443
    highp vec3 shlight = ShadeSH9( vec4( worldN, 1.0));
    o.vlight = shlight;
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    #line 447
    return o;
}

out lowp vec3 xlv_TEXCOORD0;
out lowp vec3 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.normal);
    xlv_TEXCOORD1 = vec3(xl_retval.vlight);
    xlv_TEXCOORD2 = vec3(xl_retval.viewDir);
    xlv_TEXCOORD3 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 403
struct Input {
    highp vec2 uv_MainTex;
};
#line 426
struct v2f_surf {
    highp vec4 pos;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec3 viewDir;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform highp vec4 _EmissiveColor;
uniform highp vec4 _AmbientColor;
#line 401
uniform highp float _MySliderValue;
uniform sampler2D _RampTex;
#line 408
#line 435
#line 414
highp vec4 LightingBasicDiffuse( in SurfaceOutput s, in lowp vec3 lightDir, in mediump vec3 viewDir, in lowp float atten ) {
    #line 416
    highp float difLight = max( 0.0, dot( s.Normal, lightDir));
    highp float rimLight = max( 0.0, dot( s.Normal, viewDir));
    highp float dif_hLambert = ((difLight * 0.5) + 0.5);
    highp float rim_hLambert = ((rimLight * 0.5) + 0.5);
    #line 420
    highp vec3 ramp = texture( _RampTex, vec2( dif_hLambert, rim_hLambert)).xyz;
    highp vec4 col;
    col.xyz = ((s.Albedo * _LightColor0.xyz) * ramp);
    col.w = s.Alpha;
    #line 424
    return col;
}
#line 408
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec4 c = pow( (_EmissiveColor + _AmbientColor), vec4( _MySliderValue));
    o.Albedo = c.xyz;
    #line 412
    o.Alpha = c.w;
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    highp float dist = textureProj( _ShadowMapTexture, shadowCoord).x;
    mediump float lightShadowDataX = _LightShadowData.x;
    #line 397
    return max( float((dist > (shadowCoord.z / shadowCoord.w))), lightShadowDataX);
}
#line 449
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 451
    Input surfIN;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 455
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    #line 459
    surf( surfIN, o);
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    lowp vec4 c = vec4( 0.0);
    c = LightingBasicDiffuse( o, _WorldSpaceLightPos0.xyz, normalize(IN.viewDir), atten);
    #line 463
    c.xyz += (o.Albedo * IN.vlight);
    return c;
}
in lowp vec3 xlv_TEXCOORD0;
in lowp vec3 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.normal = vec3(xlv_TEXCOORD0);
    xlt_IN.vlight = vec3(xlv_TEXCOORD1);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD2);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Vector 9 [_ProjectionParams]
Vector 10 [unity_LightmapST]
"!!ARBvp1.0
# 10 ALU
PARAM c[11] = { { 0.5 },
		state.matrix.mvp,
		program.local[5..10] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[9].x;
ADD result.texcoord[1].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[1].zw, R0;
MAD result.texcoord[0].xy, vertex.texcoord[1], c[10], c[10].zwzw;
END
# 10 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_LightmapST]
"vs_2_0
; 10 ALU
def c11, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord1 v2
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c11.x
mul r1.y, r1, c8.x
mad oT1.xy, r1.z, c9.zwzw, r1
mov oPos, r0
mov oT1.zw, r0
mad oT0.xy, v2, c10, c10.zwzw
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 176 // 176 used size, 8 vars
Vector 160 [unity_LightmapST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 11 instructions, 2 temp regs, 0 temp arrays:
// ALU 8 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedcbbblengjeljhcopbdcfjhnhmjjdembcabaaaaaaeaadaaaaadaaaaaa
cmaaaaaapeaaaaaageabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheogiaaaaaaadaaaaaa
aiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaafmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcneabaaaaeaaaabaahfaaaaaafjaaaaaeegiocaaaaaaaaaaa
alaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaa
aeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadpccabaaa
acaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaaeaaaaaaegiacaaaaaaaaaaaakaaaaaaogikcaaaaaaaaaaa
akaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaa
afaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadp
aaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaacaaaaaakgaobaaaaaaaaaaa
aaaaaaahdccabaaaacaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD1 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp float _MySliderValue;
uniform highp vec4 _AmbientColor;
uniform highp vec4 _EmissiveColor;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _LightShadowData;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = pow ((_EmissiveColor + _AmbientColor), vec4(_MySliderValue));
  highp vec3 tmpvar_5;
  tmpvar_5 = tmpvar_4.xyz;
  tmpvar_2 = tmpvar_5;
  highp float tmpvar_6;
  tmpvar_6 = tmpvar_4.w;
  tmpvar_3 = tmpvar_6;
  lowp float tmpvar_7;
  mediump float lightShadowDataX_8;
  highp float dist_9;
  lowp float tmpvar_10;
  tmpvar_10 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD1).x;
  dist_9 = tmpvar_10;
  highp float tmpvar_11;
  tmpvar_11 = _LightShadowData.x;
  lightShadowDataX_8 = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = max (float((dist_9 > (xlv_TEXCOORD1.z / xlv_TEXCOORD1.w))), lightShadowDataX_8);
  tmpvar_7 = tmpvar_12;
  c_1.xyz = (tmpvar_2 * min ((2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD0).xyz), vec3((tmpvar_7 * 2.0))));
  c_1.w = tmpvar_3;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD1 = o_2;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp float _MySliderValue;
uniform highp vec4 _AmbientColor;
uniform highp vec4 _EmissiveColor;
uniform sampler2D _ShadowMapTexture;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = pow ((_EmissiveColor + _AmbientColor), vec4(_MySliderValue));
  highp vec3 tmpvar_5;
  tmpvar_5 = tmpvar_4.xyz;
  tmpvar_2 = tmpvar_5;
  highp float tmpvar_6;
  tmpvar_6 = tmpvar_4.w;
  tmpvar_3 = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD1);
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (unity_Lightmap, xlv_TEXCOORD0);
  lowp vec3 tmpvar_9;
  tmpvar_9 = ((8.0 * tmpvar_8.w) * tmpvar_8.xyz);
  c_1.xyz = (tmpvar_2 * max (min (tmpvar_9, ((tmpvar_7.x * 2.0) * tmpvar_8.xyz)), (tmpvar_9 * tmpvar_7.x)));
  c_1.w = tmpvar_3;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [unity_NPOTScale]
Vector 10 [unity_LightmapST]
"agal_vs
c11 0.5 0.0 0.0 0.0
[bc]
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 r0.w, a0, c3
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 r0.z, a0, c2
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 r0.x, a0, c0
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 r0.y, a0, c1
adaaaaaaabaaahacaaaaaapeacaaaaaaalaaaaaaabaaaaaa mul r1.xyz, r0.xyww, c11.x
adaaaaaaabaaacacabaaaaffacaaaaaaaiaaaaaaabaaaaaa mul r1.y, r1.y, c8.x
abaaaaaaabaaadacabaaaafeacaaaaaaabaaaakkacaaaaaa add r1.xy, r1.xyyy, r1.z
adaaaaaaabaaadaeabaaaafeacaaaaaaajaaaaoeabaaaaaa mul v1.xy, r1.xyyy, c9
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
aaaaaaaaabaaamaeaaaaaaopacaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, r0.wwzw
adaaaaaaaaaaadacaeaaaaoeaaaaaaaaakaaaaoeabaaaaaa mul r0.xy, a4, c10
abaaaaaaaaaaadaeaaaaaafeacaaaaaaakaaaaooabaaaaaa add v0.xy, r0.xyyy, c10.zwzw
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 176 // 176 used size, 8 vars
Vector 160 [unity_LightmapST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 11 instructions, 2 temp regs, 0 temp arrays:
// ALU 8 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedahbnkfohpkepegckbbidjciajmncepcpabaaaaaajmaeaaaaaeaaaaaa
daaaaaaaiiabaaaageadaaaacmaeaaaaebgpgodjfaabaaaafaabaaaaaaacpopp
aeabaaaaemaaaaaaadaaceaaaaaaeiaaaaaaeiaaaaaaceaaabaaeiaaaaaaakaa
abaaabaaaaaaaaaaabaaafaaabaaacaaaaaaaaaaacaaaaaaaeaaadaaaaaaaaaa
aaaaaaaaaaacpoppfbaaaaafahaaapkaaaaaaadpaaaaaaaaaaaaaaaaaaaaaaaa
bpaaaaacafaaaaiaaaaaapjabpaaaaacafaaaeiaaeaaapjaaeaaaaaeaaaaadoa
aeaaoejaabaaoekaabaaookaafaaaaadaaaaapiaaaaaffjaaeaaoekaaeaaaaae
aaaaapiaadaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaafaaoekaaaaakkja
aaaaoeiaaeaaaaaeaaaaapiaagaaoekaaaaappjaaaaaoeiaafaaaaadabaaabia
aaaaffiaacaaaakaafaaaaadabaaaiiaabaaaaiaahaaaakaafaaaaadabaaafia
aaaapeiaahaaaakaacaaaaadabaaadoaabaakkiaabaaomiaaeaaaaaeaaaaadma
aaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiaabaaaaacabaaamoa
aaaaoeiappppaaaafdeieefcneabaaaaeaaaabaahfaaaaaafjaaaaaeegiocaaa
aaaaaaaaalaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaa
acaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaaeaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
pccabaaaacaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaaeaaaaaaegiacaaaaaaaaaaaakaaaaaaogikcaaa
aaaaaaaaakaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaa
abaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaa
aaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaacaaaaaakgaobaaa
aaaaaaaaaaaaaaahdccabaaaacaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaa
doaaaaabejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
apaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaaaaaalaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaaabaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffied
epepfceeaaedepemepfcaaklepfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadamaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 403
struct Input {
    highp vec2 uv_MainTex;
};
#line 426
struct v2f_surf {
    highp vec4 pos;
    highp vec2 lmap;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform highp vec4 _EmissiveColor;
uniform highp vec4 _AmbientColor;
#line 401
uniform highp float _MySliderValue;
uniform sampler2D _RampTex;
#line 408
#line 433
uniform highp vec4 unity_LightmapST;
uniform sampler2D unity_Lightmap;
#line 434
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 437
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    #line 442
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.lmap);
    xlv_TEXCOORD1 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 403
struct Input {
    highp vec2 uv_MainTex;
};
#line 426
struct v2f_surf {
    highp vec4 pos;
    highp vec2 lmap;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform highp vec4 _EmissiveColor;
uniform highp vec4 _AmbientColor;
#line 401
uniform highp float _MySliderValue;
uniform sampler2D _RampTex;
#line 408
#line 433
uniform highp vec4 unity_LightmapST;
uniform sampler2D unity_Lightmap;
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 408
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec4 c = pow( (_EmissiveColor + _AmbientColor), vec4( _MySliderValue));
    o.Albedo = c.xyz;
    #line 412
    o.Alpha = c.w;
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    highp float dist = textureProj( _ShadowMapTexture, shadowCoord).x;
    mediump float lightShadowDataX = _LightShadowData.x;
    #line 397
    return max( float((dist > (shadowCoord.z / shadowCoord.w))), lightShadowDataX);
}
#line 445
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 447
    Input surfIN;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 451
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    surf( surfIN, o);
    #line 455
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    lowp vec4 c = vec4( 0.0);
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    lowp vec3 lm = DecodeLightmap( lmtex);
    #line 459
    c.xyz += (o.Albedo * min( lm, vec3( (atten * 2.0))));
    c.w = o.Alpha;
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.lmap = vec2(xlv_TEXCOORD0);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD1);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [unity_4LightPosX0]
Vector 11 [unity_4LightPosY0]
Vector 12 [unity_4LightPosZ0]
Vector 13 [unity_4LightAtten0]
Vector 14 [unity_LightColor0]
Vector 15 [unity_LightColor1]
Vector 16 [unity_LightColor2]
Vector 17 [unity_LightColor3]
Vector 18 [unity_SHAr]
Vector 19 [unity_SHAg]
Vector 20 [unity_SHAb]
Vector 21 [unity_SHBr]
Vector 22 [unity_SHBg]
Vector 23 [unity_SHBb]
Vector 24 [unity_SHC]
Matrix 5 [_Object2World]
Vector 25 [unity_Scale]
"!!ARBvp1.0
# 59 ALU
PARAM c[26] = { { 1, 0 },
		state.matrix.mvp,
		program.local[5..25] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R3.xyz, vertex.normal, c[25].w;
DP3 R5.x, R3, c[5];
DP4 R4.zw, vertex.position, c[6];
ADD R2, -R4.z, c[11];
DP3 R4.z, R3, c[6];
DP3 R3.x, R3, c[7];
DP4 R3.w, vertex.position, c[5];
MUL R0, R4.z, R2;
ADD R1, -R3.w, c[10];
DP4 R4.xy, vertex.position, c[7];
MUL R2, R2, R2;
MOV R5.z, R3.x;
MOV R5.y, R4.z;
MOV R5.w, c[0].x;
MAD R0, R5.x, R1, R0;
MAD R2, R1, R1, R2;
ADD R1, -R4.x, c[12];
MAD R2, R1, R1, R2;
MAD R0, R3.x, R1, R0;
MUL R1, R2, c[13];
ADD R1, R1, c[0].x;
MOV result.texcoord[0].z, R3.x;
RSQ R2.x, R2.x;
RSQ R2.y, R2.y;
RSQ R2.z, R2.z;
RSQ R2.w, R2.w;
MUL R0, R0, R2;
DP4 R2.z, R5, c[20];
DP4 R2.y, R5, c[19];
DP4 R2.x, R5, c[18];
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].y;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[15];
MAD R1.xyz, R0.x, c[14], R1;
MAD R0.xyz, R0.z, c[16], R1;
MAD R1.xyz, R0.w, c[17], R0;
MUL R0, R5.xyzz, R5.yzzx;
MUL R1.w, R4.z, R4.z;
DP4 R5.w, R0, c[23];
DP4 R5.z, R0, c[22];
DP4 R5.y, R0, c[21];
MAD R1.w, R5.x, R5.x, -R1;
MUL R0.xyz, R1.w, c[24];
ADD R2.xyz, R2, R5.yzww;
ADD R0.xyz, R2, R0;
MOV R3.x, R4.w;
MOV R3.y, R4;
ADD result.texcoord[1].xyz, R0, R1;
MOV result.texcoord[0].y, R4.z;
MOV result.texcoord[0].x, R5;
ADD result.texcoord[2].xyz, -R3.wxyw, c[9];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 59 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceCameraPos]
Vector 9 [unity_4LightPosX0]
Vector 10 [unity_4LightPosY0]
Vector 11 [unity_4LightPosZ0]
Vector 12 [unity_4LightAtten0]
Vector 13 [unity_LightColor0]
Vector 14 [unity_LightColor1]
Vector 15 [unity_LightColor2]
Vector 16 [unity_LightColor3]
Vector 17 [unity_SHAr]
Vector 18 [unity_SHAg]
Vector 19 [unity_SHAb]
Vector 20 [unity_SHBr]
Vector 21 [unity_SHBg]
Vector 22 [unity_SHBb]
Vector 23 [unity_SHC]
Matrix 4 [_Object2World]
Vector 24 [unity_Scale]
"vs_2_0
; 59 ALU
def c25, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
mul r3.xyz, v1, c24.w
dp3 r5.x, r3, c4
dp4 r4.zw, v0, c5
add r2, -r4.z, c10
dp3 r4.z, r3, c5
dp3 r3.x, r3, c6
dp4 r3.w, v0, c4
mul r0, r4.z, r2
add r1, -r3.w, c9
dp4 r4.xy, v0, c6
mul r2, r2, r2
mov r5.z, r3.x
mov r5.y, r4.z
mov r5.w, c25.x
mad r0, r5.x, r1, r0
mad r2, r1, r1, r2
add r1, -r4.x, c11
mad r2, r1, r1, r2
mad r0, r3.x, r1, r0
mul r1, r2, c12
add r1, r1, c25.x
mov oT0.z, r3.x
rsq r2.x, r2.x
rsq r2.y, r2.y
rsq r2.z, r2.z
rsq r2.w, r2.w
mul r0, r0, r2
dp4 r2.z, r5, c19
dp4 r2.y, r5, c18
dp4 r2.x, r5, c17
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c25.y
mul r0, r0, r1
mul r1.xyz, r0.y, c14
mad r1.xyz, r0.x, c13, r1
mad r0.xyz, r0.z, c15, r1
mad r1.xyz, r0.w, c16, r0
mul r0, r5.xyzz, r5.yzzx
mul r1.w, r4.z, r4.z
dp4 r5.w, r0, c22
dp4 r5.z, r0, c21
dp4 r5.y, r0, c20
mad r1.w, r5.x, r5.x, -r1
mul r0.xyz, r1.w, c23
add r2.xyz, r2, r5.yzww
add r0.xyz, r2, r0
mov r3.x, r4.w
mov r3.y, r4
add oT1.xyz, r0, r1
mov oT0.y, r4.z
mov oT0.x, r5
add oT2.xyz, -r3.wxyw, c8
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 32 [unity_4LightPosX0] 4
Vector 48 [unity_4LightPosY0] 4
Vector 64 [unity_4LightPosZ0] 4
Vector 80 [unity_4LightAtten0] 4
Vector 96 [unity_LightColor0] 4
Vector 112 [unity_LightColor1] 4
Vector 128 [unity_LightColor2] 4
Vector 144 [unity_LightColor3] 4
Vector 160 [unity_LightColor4] 4
Vector 176 [unity_LightColor5] 4
Vector 192 [unity_LightColor6] 4
Vector 208 [unity_LightColor7] 4
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "UnityPerCamera" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 47 instructions, 6 temp regs, 0 temp arrays:
// ALU 44 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedghbholohggklicngbiineclgpcoojjhbabaaaaaadmaiaaaaadaaaaaa
cmaaaaaapeaaaaaahmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoiaaaaaaaaeaaaaaa
aiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaaheaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
liagaaaaeaaaabaakoabaaaafjaaaaaeegiocaaaaaaaaaaaafaaaaaafjaaaaae
egiocaaaabaaaaaacnaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaad
hccabaaaadaaaaaagiaaaaacagaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaa
acaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaacaaaaaaamaaaaaa
agaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
acaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaafhccabaaa
abaaaaaaegacbaaaaaaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadp
bbaaaaaibcaabaaaabaaaaaaegiocaaaabaaaaaacgaaaaaaegaobaaaaaaaaaaa
bbaaaaaiccaabaaaabaaaaaaegiocaaaabaaaaaachaaaaaaegaobaaaaaaaaaaa
bbaaaaaiecaabaaaabaaaaaaegiocaaaabaaaaaaciaaaaaaegaobaaaaaaaaaaa
diaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaai
bcaabaaaadaaaaaaegiocaaaabaaaaaacjaaaaaaegaobaaaacaaaaaabbaaaaai
ccaabaaaadaaaaaaegiocaaaabaaaaaackaaaaaaegaobaaaacaaaaaabbaaaaai
ecaabaaaadaaaaaaegiocaaaabaaaaaaclaaaaaaegaobaaaacaaaaaaaaaaaaah
hcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaahicaabaaa
aaaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaakicaabaaaaaaaaaaa
akaabaaaaaaaaaaaakaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaabaaaaaacmaaaaaapgapbaaaaaaaaaaaegacbaaa
abaaaaaadiaaaaaihcaabaaaacaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaa
anaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaa
aaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaa
egiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaacaaaaaaaaaaaaaj
pcaabaaaadaaaaaafgafbaiaebaaaaaaacaaaaaaegiocaaaabaaaaaaadaaaaaa
diaaaaahpcaabaaaaeaaaaaafgafbaaaaaaaaaaaegaobaaaadaaaaaadiaaaaah
pcaabaaaadaaaaaaegaobaaaadaaaaaaegaobaaaadaaaaaaaaaaaaajpcaabaaa
afaaaaaaagaabaiaebaaaaaaacaaaaaaegiocaaaabaaaaaaacaaaaaadcaaaaaj
pcaabaaaaeaaaaaaegaobaaaafaaaaaaagaabaaaaaaaaaaaegaobaaaaeaaaaaa
dcaaaaajpcaabaaaadaaaaaaegaobaaaafaaaaaaegaobaaaafaaaaaaegaobaaa
adaaaaaaaaaaaaajpcaabaaaafaaaaaakgakbaiaebaaaaaaacaaaaaaegiocaaa
abaaaaaaaeaaaaaaaaaaaaajhccabaaaadaaaaaaegacbaiaebaaaaaaacaaaaaa
egiccaaaaaaaaaaaaeaaaaaadcaaaaajpcaabaaaaaaaaaaaegaobaaaafaaaaaa
kgakbaaaaaaaaaaaegaobaaaaeaaaaaadcaaaaajpcaabaaaacaaaaaaegaobaaa
afaaaaaaegaobaaaafaaaaaaegaobaaaadaaaaaaeeaaaaafpcaabaaaadaaaaaa
egaobaaaacaaaaaadcaaaaanpcaabaaaacaaaaaaegaobaaaacaaaaaaegiocaaa
abaaaaaaafaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpaoaaaaak
pcaabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpegaobaaa
acaaaaaadiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaadaaaaaa
deaaaaakpcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaadiaaaaahpcaabaaaaaaaaaaaegaobaaaacaaaaaaegaobaaa
aaaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaaaaaaaaaegiccaaaabaaaaaa
ahaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaabaaaaaaagaaaaaaagaabaaa
aaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaa
aiaaaaaakgakbaaaaaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaabaaaaaaajaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaah
hccabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_2 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal_8;
  normal_8 = tmpvar_6;
  highp float vC_9;
  mediump vec3 x3_10;
  mediump vec3 x2_11;
  mediump vec3 x1_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAr, normal_8);
  x1_12.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAg, normal_8);
  x1_12.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAb, normal_8);
  x1_12.z = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = (normal_8.xyzz * normal_8.yzzx);
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBr, tmpvar_16);
  x2_11.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBg, tmpvar_16);
  x2_11.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBb, tmpvar_16);
  x2_11.z = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = ((normal_8.x * normal_8.x) - (normal_8.y * normal_8.y));
  vC_9 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (unity_SHC.xyz * vC_9);
  x3_10 = tmpvar_21;
  tmpvar_7 = ((x1_12 + x2_11) + x3_10);
  shlight_1 = tmpvar_7;
  tmpvar_3 = shlight_1;
  highp vec3 tmpvar_22;
  tmpvar_22 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_4LightPosX0 - tmpvar_22.x);
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosY0 - tmpvar_22.y);
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_4LightPosZ0 - tmpvar_22.z);
  highp vec4 tmpvar_26;
  tmpvar_26 = (((tmpvar_23 * tmpvar_23) + (tmpvar_24 * tmpvar_24)) + (tmpvar_25 * tmpvar_25));
  highp vec4 tmpvar_27;
  tmpvar_27 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_23 * tmpvar_5.x) + (tmpvar_24 * tmpvar_5.y)) + (tmpvar_25 * tmpvar_5.z)) * inversesqrt(tmpvar_26))) * (1.0/((1.0 + (tmpvar_26 * unity_4LightAtten0)))));
  highp vec3 tmpvar_28;
  tmpvar_28 = (tmpvar_3 + ((((unity_LightColor[0].xyz * tmpvar_27.x) + (unity_LightColor[1].xyz * tmpvar_27.y)) + (unity_LightColor[2].xyz * tmpvar_27.z)) + (unity_LightColor[3].xyz * tmpvar_27.w)));
  tmpvar_3 = tmpvar_28;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform sampler2D _RampTex;
uniform highp float _MySliderValue;
uniform highp vec4 _AmbientColor;
uniform highp vec4 _EmissiveColor;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = pow ((_EmissiveColor + _AmbientColor), vec4(_MySliderValue));
  highp vec3 tmpvar_5;
  tmpvar_5 = tmpvar_4.xyz;
  tmpvar_2 = tmpvar_5;
  highp float tmpvar_6;
  tmpvar_6 = tmpvar_4.w;
  tmpvar_3 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize(xlv_TEXCOORD2);
  mediump vec3 viewDir_8;
  viewDir_8 = tmpvar_7;
  highp vec4 col_9;
  highp vec3 ramp_10;
  highp float rimLight_11;
  highp float difLight_12;
  lowp float tmpvar_13;
  tmpvar_13 = max (0.0, dot (xlv_TEXCOORD0, _WorldSpaceLightPos0.xyz));
  difLight_12 = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = max (0.0, dot (xlv_TEXCOORD0, viewDir_8));
  rimLight_11 = tmpvar_14;
  highp vec2 tmpvar_15;
  tmpvar_15.x = ((difLight_12 * 0.5) + 0.5);
  tmpvar_15.y = ((rimLight_11 * 0.5) + 0.5);
  lowp vec3 tmpvar_16;
  tmpvar_16 = texture2D (_RampTex, tmpvar_15).xyz;
  ramp_10 = tmpvar_16;
  col_9.xyz = ((tmpvar_2 * _LightColor0.xyz) * ramp_10);
  col_9.w = tmpvar_3;
  c_1 = col_9;
  c_1.xyz = (c_1.xyz + (tmpvar_2 * xlv_TEXCOORD1));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_2 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal_8;
  normal_8 = tmpvar_6;
  highp float vC_9;
  mediump vec3 x3_10;
  mediump vec3 x2_11;
  mediump vec3 x1_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAr, normal_8);
  x1_12.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAg, normal_8);
  x1_12.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAb, normal_8);
  x1_12.z = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = (normal_8.xyzz * normal_8.yzzx);
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBr, tmpvar_16);
  x2_11.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBg, tmpvar_16);
  x2_11.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBb, tmpvar_16);
  x2_11.z = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = ((normal_8.x * normal_8.x) - (normal_8.y * normal_8.y));
  vC_9 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (unity_SHC.xyz * vC_9);
  x3_10 = tmpvar_21;
  tmpvar_7 = ((x1_12 + x2_11) + x3_10);
  shlight_1 = tmpvar_7;
  tmpvar_3 = shlight_1;
  highp vec3 tmpvar_22;
  tmpvar_22 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_4LightPosX0 - tmpvar_22.x);
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosY0 - tmpvar_22.y);
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_4LightPosZ0 - tmpvar_22.z);
  highp vec4 tmpvar_26;
  tmpvar_26 = (((tmpvar_23 * tmpvar_23) + (tmpvar_24 * tmpvar_24)) + (tmpvar_25 * tmpvar_25));
  highp vec4 tmpvar_27;
  tmpvar_27 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_23 * tmpvar_5.x) + (tmpvar_24 * tmpvar_5.y)) + (tmpvar_25 * tmpvar_5.z)) * inversesqrt(tmpvar_26))) * (1.0/((1.0 + (tmpvar_26 * unity_4LightAtten0)))));
  highp vec3 tmpvar_28;
  tmpvar_28 = (tmpvar_3 + ((((unity_LightColor[0].xyz * tmpvar_27.x) + (unity_LightColor[1].xyz * tmpvar_27.y)) + (unity_LightColor[2].xyz * tmpvar_27.z)) + (unity_LightColor[3].xyz * tmpvar_27.w)));
  tmpvar_3 = tmpvar_28;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform sampler2D _RampTex;
uniform highp float _MySliderValue;
uniform highp vec4 _AmbientColor;
uniform highp vec4 _EmissiveColor;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = pow ((_EmissiveColor + _AmbientColor), vec4(_MySliderValue));
  highp vec3 tmpvar_5;
  tmpvar_5 = tmpvar_4.xyz;
  tmpvar_2 = tmpvar_5;
  highp float tmpvar_6;
  tmpvar_6 = tmpvar_4.w;
  tmpvar_3 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize(xlv_TEXCOORD2);
  mediump vec3 viewDir_8;
  viewDir_8 = tmpvar_7;
  highp vec4 col_9;
  highp vec3 ramp_10;
  highp float rimLight_11;
  highp float difLight_12;
  lowp float tmpvar_13;
  tmpvar_13 = max (0.0, dot (xlv_TEXCOORD0, _WorldSpaceLightPos0.xyz));
  difLight_12 = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = max (0.0, dot (xlv_TEXCOORD0, viewDir_8));
  rimLight_11 = tmpvar_14;
  highp vec2 tmpvar_15;
  tmpvar_15.x = ((difLight_12 * 0.5) + 0.5);
  tmpvar_15.y = ((rimLight_11 * 0.5) + 0.5);
  lowp vec3 tmpvar_16;
  tmpvar_16 = texture2D (_RampTex, tmpvar_15).xyz;
  ramp_10 = tmpvar_16;
  col_9.xyz = ((tmpvar_2 * _LightColor0.xyz) * ramp_10);
  col_9.w = tmpvar_3;
  c_1 = col_9;
  c_1.xyz = (c_1.xyz + (tmpvar_2 * xlv_TEXCOORD1));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceCameraPos]
Vector 9 [unity_4LightPosX0]
Vector 10 [unity_4LightPosY0]
Vector 11 [unity_4LightPosZ0]
Vector 12 [unity_4LightAtten0]
Vector 13 [unity_LightColor0]
Vector 14 [unity_LightColor1]
Vector 15 [unity_LightColor2]
Vector 16 [unity_LightColor3]
Vector 17 [unity_SHAr]
Vector 18 [unity_SHAg]
Vector 19 [unity_SHAb]
Vector 20 [unity_SHBr]
Vector 21 [unity_SHBg]
Vector 22 [unity_SHBb]
Vector 23 [unity_SHC]
Matrix 4 [_Object2World]
Vector 24 [unity_Scale]
"agal_vs
c25 1.0 0.0 0.0 0.0
[bc]
adaaaaaaadaaahacabaaaaoeaaaaaaaabiaaaappabaaaaaa mul r3.xyz, a1, c24.w
bcaaaaaaafaaabacadaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r5.x, r3.xyzz, c4
bdaaaaaaaeaaamacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r4.zw, a0, c5
bfaaaaaaacaaaeacaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa neg r2.z, r4.z
abaaaaaaacaaapacacaaaakkacaaaaaaakaaaaoeabaaaaaa add r2, r2.z, c10
bcaaaaaaaeaaaeacadaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r4.z, r3.xyzz, c5
bcaaaaaaadaaabacadaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r3.x, r3.xyzz, c6
bdaaaaaaadaaaiacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r3.w, a0, c4
adaaaaaaaaaaapacaeaaaakkacaaaaaaacaaaaoeacaaaaaa mul r0, r4.z, r2
bfaaaaaaabaaaiacadaaaappacaaaaaaaaaaaaaaaaaaaaaa neg r1.w, r3.w
abaaaaaaabaaapacabaaaappacaaaaaaajaaaaoeabaaaaaa add r1, r1.w, c9
bdaaaaaaaeaaadacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r4.xy, a0, c6
adaaaaaaacaaapacacaaaaoeacaaaaaaacaaaaoeacaaaaaa mul r2, r2, r2
aaaaaaaaafaaaeacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r5.z, r3.x
aaaaaaaaafaaacacaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r5.y, r4.z
aaaaaaaaafaaaiacbjaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r5.w, c25.x
adaaaaaaagaaapacafaaaaaaacaaaaaaabaaaaoeacaaaaaa mul r6, r5.x, r1
abaaaaaaaaaaapacagaaaaoeacaaaaaaaaaaaaoeacaaaaaa add r0, r6, r0
adaaaaaaagaaapacabaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r6, r1, r1
abaaaaaaacaaapacagaaaaoeacaaaaaaacaaaaoeacaaaaaa add r2, r6, r2
bfaaaaaaabaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r1.x, r4.x
abaaaaaaabaaapacabaaaaaaacaaaaaaalaaaaoeabaaaaaa add r1, r1.x, c11
adaaaaaaagaaapacabaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r6, r1, r1
abaaaaaaacaaapacagaaaaoeacaaaaaaacaaaaoeacaaaaaa add r2, r6, r2
adaaaaaaagaaapacadaaaaaaacaaaaaaabaaaaoeacaaaaaa mul r6, r3.x, r1
abaaaaaaaaaaapacagaaaaoeacaaaaaaaaaaaaoeacaaaaaa add r0, r6, r0
adaaaaaaabaaapacacaaaaoeacaaaaaaamaaaaoeabaaaaaa mul r1, r2, c12
abaaaaaaabaaapacabaaaaoeacaaaaaabjaaaaaaabaaaaaa add r1, r1, c25.x
aaaaaaaaaaaaaeaeadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov v0.z, r3.x
akaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r2.x, r2.x
akaaaaaaacaaacacacaaaaffacaaaaaaaaaaaaaaaaaaaaaa rsq r2.y, r2.y
akaaaaaaacaaaeacacaaaakkacaaaaaaaaaaaaaaaaaaaaaa rsq r2.z, r2.z
akaaaaaaacaaaiacacaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r2.w, r2.w
adaaaaaaaaaaapacaaaaaaoeacaaaaaaacaaaaoeacaaaaaa mul r0, r0, r2
bdaaaaaaacaaaeacafaaaaoeacaaaaaabdaaaaoeabaaaaaa dp4 r2.z, r5, c19
bdaaaaaaacaaacacafaaaaoeacaaaaaabcaaaaoeabaaaaaa dp4 r2.y, r5, c18
bdaaaaaaacaaabacafaaaaoeacaaaaaabbaaaaoeabaaaaaa dp4 r2.x, r5, c17
afaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r1.x, r1.x
afaaaaaaabaaacacabaaaaffacaaaaaaaaaaaaaaaaaaaaaa rcp r1.y, r1.y
afaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r1.w, r1.w
afaaaaaaabaaaeacabaaaakkacaaaaaaaaaaaaaaaaaaaaaa rcp r1.z, r1.z
ahaaaaaaaaaaapacaaaaaaoeacaaaaaabjaaaaffabaaaaaa max r0, r0, c25.y
adaaaaaaaaaaapacaaaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r0, r0, r1
adaaaaaaabaaahacaaaaaaffacaaaaaaaoaaaaoeabaaaaaa mul r1.xyz, r0.y, c14
adaaaaaaagaaahacaaaaaaaaacaaaaaaanaaaaoeabaaaaaa mul r6.xyz, r0.x, c13
abaaaaaaabaaahacagaaaakeacaaaaaaabaaaakeacaaaaaa add r1.xyz, r6.xyzz, r1.xyzz
adaaaaaaaaaaahacaaaaaakkacaaaaaaapaaaaoeabaaaaaa mul r0.xyz, r0.z, c15
abaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa add r0.xyz, r0.xyzz, r1.xyzz
adaaaaaaabaaahacaaaaaappacaaaaaabaaaaaoeabaaaaaa mul r1.xyz, r0.w, c16
abaaaaaaabaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r1.xyz, r1.xyzz, r0.xyzz
adaaaaaaaaaaapacafaaaakeacaaaaaaafaaaacjacaaaaaa mul r0, r5.xyzz, r5.yzzx
adaaaaaaabaaaiacaeaaaakkacaaaaaaaeaaaakkacaaaaaa mul r1.w, r4.z, r4.z
bdaaaaaaafaaaiacaaaaaaoeacaaaaaabgaaaaoeabaaaaaa dp4 r5.w, r0, c22
bdaaaaaaafaaaeacaaaaaaoeacaaaaaabfaaaaoeabaaaaaa dp4 r5.z, r0, c21
bdaaaaaaafaaacacaaaaaaoeacaaaaaabeaaaaoeabaaaaaa dp4 r5.y, r0, c20
adaaaaaaagaaaiacafaaaaaaacaaaaaaafaaaaaaacaaaaaa mul r6.w, r5.x, r5.x
acaaaaaaabaaaiacagaaaappacaaaaaaabaaaappacaaaaaa sub r1.w, r6.w, r1.w
adaaaaaaaaaaahacabaaaappacaaaaaabhaaaaoeabaaaaaa mul r0.xyz, r1.w, c23
abaaaaaaacaaahacacaaaakeacaaaaaaafaaaapjacaaaaaa add r2.xyz, r2.xyzz, r5.yzww
abaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r2.xyzz, r0.xyzz
aaaaaaaaadaaabacaeaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r3.x, r4.w
aaaaaaaaadaaacacaeaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r3.y, r4.y
abaaaaaaabaaahaeaaaaaakeacaaaaaaabaaaakeacaaaaaa add v1.xyz, r0.xyzz, r1.xyzz
aaaaaaaaaaaaacaeaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov v0.y, r4.z
aaaaaaaaaaaaabaeafaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov v0.x, r5.x
bfaaaaaaagaaalacadaaaapdacaaaaaaaaaaaaaaaaaaaaaa neg r6.xyw, r3.wxww
abaaaaaaacaaahaeagaaaafdacaaaaaaaiaaaaoeabaaaaaa add v2.xyz, r6.wxyy, c8
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 32 [unity_4LightPosX0] 4
Vector 48 [unity_4LightPosY0] 4
Vector 64 [unity_4LightPosZ0] 4
Vector 80 [unity_4LightAtten0] 4
Vector 96 [unity_LightColor0] 4
Vector 112 [unity_LightColor1] 4
Vector 128 [unity_LightColor2] 4
Vector 144 [unity_LightColor3] 4
Vector 160 [unity_LightColor4] 4
Vector 176 [unity_LightColor5] 4
Vector 192 [unity_LightColor6] 4
Vector 208 [unity_LightColor7] 4
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "UnityPerCamera" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 47 instructions, 6 temp regs, 0 temp arrays:
// ALU 44 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedbfhccbjlacndfadkfbclegomidaekkgoabaaaaaahmamaaaaaeaaaaaa
daaaaaaagmaeaaaacmalaaaapealaaaaebgpgodjdeaeaaaadeaeaaaaaaacpopp
meadaaaahaaaaaaaagaaceaaaaaagmaaaaaagmaaaaaaceaaabaagmaaaaaaaeaa
abaaabaaaaaaaaaaabaaacaaaiaaacaaaaaaaaaaabaacgaaahaaakaaaaaaaaaa
acaaaaaaaeaabbaaaaaaaaaaacaaamaaaeaabfaaaaaaaaaaacaabeaaabaabjaa
aaaaaaaaaaaaaaaaaaacpoppfbaaaaafbkaaapkaaaaaiadpaaaaaaaaaaaaaaaa
aaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaaciaacaaapjaafaaaaad
aaaaahiaaaaaffjabgaaoekaaeaaaaaeaaaaahiabfaaoekaaaaaaajaaaaaoeia
aeaaaaaeaaaaahiabhaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaahiabiaaoeka
aaaappjaaaaaoeiaacaaaaadacaaahoaaaaaoeibabaaoekaacaaaaadabaaapia
aaaaffibadaaoekaafaaaaadacaaapiaabaaoeiaabaaoeiaacaaaaadadaaapia
aaaaaaibacaaoekaacaaaaadaaaaapiaaaaakkibaeaaoekaaeaaaaaeacaaapia
adaaoeiaadaaoeiaacaaoeiaaeaaaaaeacaaapiaaaaaoeiaaaaaoeiaacaaoeia
ahaaaaacaeaaabiaacaaaaiaahaaaaacaeaaaciaacaaffiaahaaaaacaeaaaeia
acaakkiaahaaaaacaeaaaiiaacaappiaabaaaaacafaaabiabkaaaakaaeaaaaae
acaaapiaacaaoeiaafaaoekaafaaaaiaafaaaaadafaaahiaacaaoejabjaappka
afaaaaadagaaahiaafaaffiabgaaoekaaeaaaaaeafaaaliabfaakekaafaaaaia
agaakeiaaeaaaaaeafaaahiabhaaoekaafaakkiaafaapeiaafaaaaadabaaapia
abaaoeiaafaaffiaaeaaaaaeabaaapiaadaaoeiaafaaaaiaabaaoeiaaeaaaaae
aaaaapiaaaaaoeiaafaakkiaabaaoeiaafaaaaadaaaaapiaaeaaoeiaaaaaoeia
alaaaaadaaaaapiaaaaaoeiabkaaffkaagaaaaacabaaabiaacaaaaiaagaaaaac
abaaaciaacaaffiaagaaaaacabaaaeiaacaakkiaagaaaaacabaaaiiaacaappia
afaaaaadaaaaapiaaaaaoeiaabaaoeiaafaaaaadabaaahiaaaaaffiaahaaoeka
aeaaaaaeabaaahiaagaaoekaaaaaaaiaabaaoeiaaeaaaaaeaaaaahiaaiaaoeka
aaaakkiaabaaoeiaaeaaaaaeaaaaahiaajaaoekaaaaappiaaaaaoeiaabaaaaac
afaaaiiabkaaaakaajaaaaadabaaabiaakaaoekaafaaoeiaajaaaaadabaaacia
alaaoekaafaaoeiaajaaaaadabaaaeiaamaaoekaafaaoeiaafaaaaadacaaapia
afaacjiaafaakeiaajaaaaadadaaabiaanaaoekaacaaoeiaajaaaaadadaaacia
aoaaoekaacaaoeiaajaaaaadadaaaeiaapaaoekaacaaoeiaacaaaaadabaaahia
abaaoeiaadaaoeiaafaaaaadaaaaaiiaafaaffiaafaaffiaaeaaaaaeaaaaaiia
afaaaaiaafaaaaiaaaaappibabaaaaacaaaaahoaafaaoeiaaeaaaaaeabaaahia
baaaoekaaaaappiaabaaoeiaacaaaaadabaaahoaaaaaoeiaabaaoeiaafaaaaad
aaaaapiaaaaaffjabcaaoekaaeaaaaaeaaaaapiabbaaoekaaaaaaajaaaaaoeia
aeaaaaaeaaaaapiabdaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiabeaaoeka
aaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaac
aaaaammaaaaaoeiappppaaaafdeieefcliagaaaaeaaaabaakoabaaaafjaaaaae
egiocaaaaaaaaaaaafaaaaaafjaaaaaeegiocaaaabaaaaaacnaaaaaafjaaaaae
egiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaa
gfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagiaaaaacagaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
acaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaa
aaaaaaaaegbcbaaaacaaaaaapgipcaaaacaaaaaabeaaaaaadiaaaaaihcaabaaa
abaaaaaafgafbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaa
aaaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaaaaaaaaaa
egadbaaaaaaaaaaadgaaaaafhccabaaaabaaaaaaegacbaaaaaaaaaaadgaaaaaf
icaabaaaaaaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaabaaaaaaegiocaaa
abaaaaaacgaaaaaaegaobaaaaaaaaaaabbaaaaaiccaabaaaabaaaaaaegiocaaa
abaaaaaachaaaaaaegaobaaaaaaaaaaabbaaaaaiecaabaaaabaaaaaaegiocaaa
abaaaaaaciaaaaaaegaobaaaaaaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaa
aaaaaaaaegakbaaaaaaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaaabaaaaaa
cjaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaaabaaaaaa
ckaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaaabaaaaaa
claaaaaaegaobaaaacaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaa
egacbaaaadaaaaaadiaaaaahicaabaaaaaaaaaaabkaabaaaaaaaaaaabkaabaaa
aaaaaaaadcaaaaakicaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaa
dkaabaiaebaaaaaaaaaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaabaaaaaa
cmaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaacaaaaaa
fgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaacaaaaaa
egiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaacaaaaaadcaaaaak
hcaabaaaacaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaa
acaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaa
aaaaaaaaegacbaaaacaaaaaaaaaaaaajpcaabaaaadaaaaaafgafbaiaebaaaaaa
acaaaaaaegiocaaaabaaaaaaadaaaaaadiaaaaahpcaabaaaaeaaaaaafgafbaaa
aaaaaaaaegaobaaaadaaaaaadiaaaaahpcaabaaaadaaaaaaegaobaaaadaaaaaa
egaobaaaadaaaaaaaaaaaaajpcaabaaaafaaaaaaagaabaiaebaaaaaaacaaaaaa
egiocaaaabaaaaaaacaaaaaadcaaaaajpcaabaaaaeaaaaaaegaobaaaafaaaaaa
agaabaaaaaaaaaaaegaobaaaaeaaaaaadcaaaaajpcaabaaaadaaaaaaegaobaaa
afaaaaaaegaobaaaafaaaaaaegaobaaaadaaaaaaaaaaaaajpcaabaaaafaaaaaa
kgakbaiaebaaaaaaacaaaaaaegiocaaaabaaaaaaaeaaaaaaaaaaaaajhccabaaa
adaaaaaaegacbaiaebaaaaaaacaaaaaaegiccaaaaaaaaaaaaeaaaaaadcaaaaaj
pcaabaaaaaaaaaaaegaobaaaafaaaaaakgakbaaaaaaaaaaaegaobaaaaeaaaaaa
dcaaaaajpcaabaaaacaaaaaaegaobaaaafaaaaaaegaobaaaafaaaaaaegaobaaa
adaaaaaaeeaaaaafpcaabaaaadaaaaaaegaobaaaacaaaaaadcaaaaanpcaabaaa
acaaaaaaegaobaaaacaaaaaaegiocaaaabaaaaaaafaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpaoaaaaakpcaabaaaacaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpegaobaaaacaaaaaadiaaaaahpcaabaaaaaaaaaaa
egaobaaaaaaaaaaaegaobaaaadaaaaaadeaaaaakpcaabaaaaaaaaaaaegaobaaa
aaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadiaaaaahpcaabaaa
aaaaaaaaegaobaaaacaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaaacaaaaaa
fgafbaaaaaaaaaaaegiccaaaabaaaaaaahaaaaaadcaaaaakhcaabaaaacaaaaaa
egiccaaaabaaaaaaagaaaaaaagaabaaaaaaaaaaaegacbaaaacaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaabaaaaaaaiaaaaaakgakbaaaaaaaaaaaegacbaaa
acaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaajaaaaaapgapbaaa
aaaaaaaaegacbaaaaaaaaaaaaaaaaaahhccabaaaacaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadoaaaaabejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoiaaaaaaaaeaaaaaa
aiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaaheaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 395
struct Input {
    highp vec2 uv_MainTex;
};
#line 418
struct v2f_surf {
    highp vec4 pos;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec3 viewDir;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _EmissiveColor;
uniform highp vec4 _AmbientColor;
#line 393
uniform highp float _MySliderValue;
uniform sampler2D _RampTex;
#line 400
#line 426
#line 96
highp vec3 Shade4PointLights( in highp vec4 lightPosX, in highp vec4 lightPosY, in highp vec4 lightPosZ, in highp vec3 lightColor0, in highp vec3 lightColor1, in highp vec3 lightColor2, in highp vec3 lightColor3, in highp vec4 lightAttenSq, in highp vec3 pos, in highp vec3 normal ) {
    highp vec4 toLightX = (lightPosX - pos.x);
    highp vec4 toLightY = (lightPosY - pos.y);
    #line 100
    highp vec4 toLightZ = (lightPosZ - pos.z);
    highp vec4 lengthSq = vec4( 0.0);
    lengthSq += (toLightX * toLightX);
    lengthSq += (toLightY * toLightY);
    #line 104
    lengthSq += (toLightZ * toLightZ);
    highp vec4 ndotl = vec4( 0.0);
    ndotl += (toLightX * normal.x);
    ndotl += (toLightY * normal.y);
    #line 108
    ndotl += (toLightZ * normal.z);
    highp vec4 corr = inversesqrt(lengthSq);
    ndotl = max( vec4( 0.0, 0.0, 0.0, 0.0), (ndotl * corr));
    highp vec4 atten = (1.0 / (1.0 + (lengthSq * lightAttenSq)));
    #line 112
    highp vec4 diff = (ndotl * atten);
    highp vec3 col = vec3( 0.0);
    col += (lightColor0 * diff.x);
    col += (lightColor1 * diff.y);
    #line 116
    col += (lightColor2 * diff.z);
    col += (lightColor3 * diff.w);
    return col;
}
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 87
highp vec3 WorldSpaceViewDir( in highp vec4 v ) {
    return (_WorldSpaceCameraPos.xyz - (_Object2World * v).xyz);
}
#line 426
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 430
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.normal = worldN;
    highp vec3 viewDirForLight = WorldSpaceViewDir( v.vertex);
    o.viewDir = viewDirForLight;
    #line 434
    highp vec3 shlight = ShadeSH9( vec4( worldN, 1.0));
    o.vlight = shlight;
    highp vec3 worldPos = (_Object2World * v.vertex).xyz;
    o.vlight += Shade4PointLights( unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0, unity_LightColor[0].xyz, unity_LightColor[1].xyz, unity_LightColor[2].xyz, unity_LightColor[3].xyz, unity_4LightAtten0, worldPos, worldN);
    #line 439
    return o;
}

out lowp vec3 xlv_TEXCOORD0;
out lowp vec3 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.normal);
    xlv_TEXCOORD1 = vec3(xl_retval.vlight);
    xlv_TEXCOORD2 = vec3(xl_retval.viewDir);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 395
struct Input {
    highp vec2 uv_MainTex;
};
#line 418
struct v2f_surf {
    highp vec4 pos;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec3 viewDir;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _EmissiveColor;
uniform highp vec4 _AmbientColor;
#line 393
uniform highp float _MySliderValue;
uniform sampler2D _RampTex;
#line 400
#line 426
#line 406
highp vec4 LightingBasicDiffuse( in SurfaceOutput s, in lowp vec3 lightDir, in mediump vec3 viewDir, in lowp float atten ) {
    #line 408
    highp float difLight = max( 0.0, dot( s.Normal, lightDir));
    highp float rimLight = max( 0.0, dot( s.Normal, viewDir));
    highp float dif_hLambert = ((difLight * 0.5) + 0.5);
    highp float rim_hLambert = ((rimLight * 0.5) + 0.5);
    #line 412
    highp vec3 ramp = texture( _RampTex, vec2( dif_hLambert, rim_hLambert)).xyz;
    highp vec4 col;
    col.xyz = ((s.Albedo * _LightColor0.xyz) * ramp);
    col.w = s.Alpha;
    #line 416
    return col;
}
#line 400
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec4 c = pow( (_EmissiveColor + _AmbientColor), vec4( _MySliderValue));
    o.Albedo = c.xyz;
    #line 404
    o.Alpha = c.w;
}
#line 441
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 443
    Input surfIN;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 447
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    #line 451
    surf( surfIN, o);
    lowp float atten = 1.0;
    lowp vec4 c = vec4( 0.0);
    c = LightingBasicDiffuse( o, _WorldSpaceLightPos0.xyz, normalize(IN.viewDir), atten);
    #line 455
    c.xyz += (o.Albedo * IN.vlight);
    return c;
}
in lowp vec3 xlv_TEXCOORD0;
in lowp vec3 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.normal = vec3(xlv_TEXCOORD0);
    xlt_IN.vlight = vec3(xlv_TEXCOORD1);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD2);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [unity_4LightPosX0]
Vector 12 [unity_4LightPosY0]
Vector 13 [unity_4LightPosZ0]
Vector 14 [unity_4LightAtten0]
Vector 15 [unity_LightColor0]
Vector 16 [unity_LightColor1]
Vector 17 [unity_LightColor2]
Vector 18 [unity_LightColor3]
Vector 19 [unity_SHAr]
Vector 20 [unity_SHAg]
Vector 21 [unity_SHAb]
Vector 22 [unity_SHBr]
Vector 23 [unity_SHBg]
Vector 24 [unity_SHBb]
Vector 25 [unity_SHC]
Matrix 5 [_Object2World]
Vector 26 [unity_Scale]
"!!ARBvp1.0
# 65 ALU
PARAM c[27] = { { 1, 0, 0.5 },
		state.matrix.mvp,
		program.local[5..26] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R3.xyz, vertex.normal, c[26].w;
DP3 R5.x, R3, c[5];
DP4 R4.zw, vertex.position, c[6];
ADD R2, -R4.z, c[12];
DP3 R4.z, R3, c[6];
DP3 R3.x, R3, c[7];
DP4 R3.w, vertex.position, c[5];
MUL R0, R4.z, R2;
ADD R1, -R3.w, c[11];
DP4 R4.xy, vertex.position, c[7];
MUL R2, R2, R2;
MOV R5.z, R3.x;
MOV R5.y, R4.z;
MOV R5.w, c[0].x;
MAD R0, R5.x, R1, R0;
MAD R2, R1, R1, R2;
ADD R1, -R4.x, c[13];
MAD R2, R1, R1, R2;
MAD R0, R3.x, R1, R0;
MUL R1, R2, c[14];
ADD R1, R1, c[0].x;
MOV result.texcoord[0].z, R3.x;
RSQ R2.x, R2.x;
RSQ R2.y, R2.y;
RSQ R2.z, R2.z;
RSQ R2.w, R2.w;
MUL R0, R0, R2;
DP4 R2.z, R5, c[21];
DP4 R2.y, R5, c[20];
DP4 R2.x, R5, c[19];
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].y;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[16];
MAD R1.xyz, R0.x, c[15], R1;
MAD R0.xyz, R0.z, c[17], R1;
MAD R1.xyz, R0.w, c[18], R0;
MUL R0, R5.xyzz, R5.yzzx;
MUL R1.w, R4.z, R4.z;
DP4 R5.w, R0, c[24];
DP4 R5.z, R0, c[23];
DP4 R5.y, R0, c[22];
MAD R1.w, R5.x, R5.x, -R1;
MUL R0.xyz, R1.w, c[25];
ADD R2.xyz, R2, R5.yzww;
ADD R5.yzw, R2.xxyz, R0.xxyz;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R2.xyz, R0.xyww, c[0].z;
ADD result.texcoord[1].xyz, R5.yzww, R1;
MOV R1.x, R2;
MUL R1.y, R2, c[10].x;
MOV R3.x, R4.w;
MOV R3.y, R4;
ADD result.texcoord[3].xy, R1, R2.z;
MOV result.position, R0;
MOV result.texcoord[3].zw, R0;
MOV result.texcoord[0].y, R4.z;
MOV result.texcoord[0].x, R5;
ADD result.texcoord[2].xyz, -R3.wxyw, c[9];
END
# 65 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceCameraPos]
Vector 9 [_ProjectionParams]
Vector 10 [_ScreenParams]
Vector 11 [unity_4LightPosX0]
Vector 12 [unity_4LightPosY0]
Vector 13 [unity_4LightPosZ0]
Vector 14 [unity_4LightAtten0]
Vector 15 [unity_LightColor0]
Vector 16 [unity_LightColor1]
Vector 17 [unity_LightColor2]
Vector 18 [unity_LightColor3]
Vector 19 [unity_SHAr]
Vector 20 [unity_SHAg]
Vector 21 [unity_SHAb]
Vector 22 [unity_SHBr]
Vector 23 [unity_SHBg]
Vector 24 [unity_SHBb]
Vector 25 [unity_SHC]
Matrix 4 [_Object2World]
Vector 26 [unity_Scale]
"vs_2_0
; 65 ALU
def c27, 1.00000000, 0.00000000, 0.50000000, 0
dcl_position0 v0
dcl_normal0 v1
mul r3.xyz, v1, c26.w
dp3 r5.x, r3, c4
dp4 r4.zw, v0, c5
add r2, -r4.z, c12
dp3 r4.z, r3, c5
dp3 r3.x, r3, c6
dp4 r3.w, v0, c4
mul r0, r4.z, r2
add r1, -r3.w, c11
dp4 r4.xy, v0, c6
mul r2, r2, r2
mov r5.z, r3.x
mov r5.y, r4.z
mov r5.w, c27.x
mad r0, r5.x, r1, r0
mad r2, r1, r1, r2
add r1, -r4.x, c13
mad r2, r1, r1, r2
mad r0, r3.x, r1, r0
mul r1, r2, c14
add r1, r1, c27.x
mov oT0.z, r3.x
rsq r2.x, r2.x
rsq r2.y, r2.y
rsq r2.z, r2.z
rsq r2.w, r2.w
mul r0, r0, r2
dp4 r2.z, r5, c21
dp4 r2.y, r5, c20
dp4 r2.x, r5, c19
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c27.y
mul r0, r0, r1
mul r1.xyz, r0.y, c16
mad r1.xyz, r0.x, c15, r1
mad r0.xyz, r0.z, c17, r1
mad r1.xyz, r0.w, c18, r0
mul r0, r5.xyzz, r5.yzzx
mul r1.w, r4.z, r4.z
dp4 r5.w, r0, c24
dp4 r5.z, r0, c23
dp4 r5.y, r0, c22
mad r1.w, r5.x, r5.x, -r1
mul r0.xyz, r1.w, c25
add r2.xyz, r2, r5.yzww
add r5.yzw, r2.xxyz, r0.xxyz
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c27.z
add oT1.xyz, r5.yzww, r1
mov r1.x, r2
mul r1.y, r2, c9.x
mov r3.x, r4.w
mov r3.y, r4
mad oT3.xy, r2.z, c10.zwzw, r1
mov oPos, r0
mov oT3.zw, r0
mov oT0.y, r4.z
mov oT0.x, r5
add oT2.xyz, -r3.wxyw, c8
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 32 [unity_4LightPosX0] 4
Vector 48 [unity_4LightPosY0] 4
Vector 64 [unity_4LightPosZ0] 4
Vector 80 [unity_4LightAtten0] 4
Vector 96 [unity_LightColor0] 4
Vector 112 [unity_LightColor1] 4
Vector 128 [unity_LightColor2] 4
Vector 144 [unity_LightColor3] 4
Vector 160 [unity_LightColor4] 4
Vector 176 [unity_LightColor5] 4
Vector 192 [unity_LightColor6] 4
Vector 208 [unity_LightColor7] 4
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "UnityPerCamera" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 52 instructions, 7 temp regs, 0 temp arrays:
// ALU 47 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedjceblnbmdpnddoigjheihbkjahklgolbabaaaaaaomaiaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcfaahaaaaeaaaabaa
neabaaaafjaaaaaeegiocaaaaaaaaaaaagaaaaaafjaaaaaeegiocaaaabaaaaaa
cnaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaad
hccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaa
gfaaaaadpccabaaaaeaaaaaagiaaaaacahaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaihcaabaaaabaaaaaaegbcbaaaacaaaaaapgipcaaaacaaaaaabeaaaaaa
diaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaaacaaaaaaanaaaaaa
dcaaaaaklcaabaaaabaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaaaabaaaaaa
egaibaaaacaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaa
kgakbaaaabaaaaaaegadbaaaabaaaaaadgaaaaafhccabaaaabaaaaaaegacbaaa
abaaaaaadgaaaaaficaabaaaabaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaa
acaaaaaaegiocaaaabaaaaaacgaaaaaaegaobaaaabaaaaaabbaaaaaiccaabaaa
acaaaaaaegiocaaaabaaaaaachaaaaaaegaobaaaabaaaaaabbaaaaaiecaabaaa
acaaaaaaegiocaaaabaaaaaaciaaaaaaegaobaaaabaaaaaadiaaaaahpcaabaaa
adaaaaaajgacbaaaabaaaaaaegakbaaaabaaaaaabbaaaaaibcaabaaaaeaaaaaa
egiocaaaabaaaaaacjaaaaaaegaobaaaadaaaaaabbaaaaaiccaabaaaaeaaaaaa
egiocaaaabaaaaaackaaaaaaegaobaaaadaaaaaabbaaaaaiecaabaaaaeaaaaaa
egiocaaaabaaaaaaclaaaaaaegaobaaaadaaaaaaaaaaaaahhcaabaaaacaaaaaa
egacbaaaacaaaaaaegacbaaaaeaaaaaadiaaaaahicaabaaaabaaaaaabkaabaaa
abaaaaaabkaabaaaabaaaaaadcaaaaakicaabaaaabaaaaaaakaabaaaabaaaaaa
akaabaaaabaaaaaadkaabaiaebaaaaaaabaaaaaadcaaaaakhcaabaaaacaaaaaa
egiccaaaabaaaaaacmaaaaaapgapbaaaabaaaaaaegacbaaaacaaaaaadiaaaaai
hcaabaaaadaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
hcaabaaaadaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
adaaaaaadcaaaaakhcaabaaaadaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaadaaaaaadcaaaaakhcaabaaaadaaaaaaegiccaaaacaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaadaaaaaaaaaaaaajpcaabaaaaeaaaaaa
fgafbaiaebaaaaaaadaaaaaaegiocaaaabaaaaaaadaaaaaadiaaaaahpcaabaaa
afaaaaaafgafbaaaabaaaaaaegaobaaaaeaaaaaadiaaaaahpcaabaaaaeaaaaaa
egaobaaaaeaaaaaaegaobaaaaeaaaaaaaaaaaaajpcaabaaaagaaaaaaagaabaia
ebaaaaaaadaaaaaaegiocaaaabaaaaaaacaaaaaadcaaaaajpcaabaaaafaaaaaa
egaobaaaagaaaaaaagaabaaaabaaaaaaegaobaaaafaaaaaadcaaaaajpcaabaaa
aeaaaaaaegaobaaaagaaaaaaegaobaaaagaaaaaaegaobaaaaeaaaaaaaaaaaaaj
pcaabaaaagaaaaaakgakbaiaebaaaaaaadaaaaaaegiocaaaabaaaaaaaeaaaaaa
aaaaaaajhccabaaaadaaaaaaegacbaiaebaaaaaaadaaaaaaegiccaaaaaaaaaaa
aeaaaaaadcaaaaajpcaabaaaabaaaaaaegaobaaaagaaaaaakgakbaaaabaaaaaa
egaobaaaafaaaaaadcaaaaajpcaabaaaadaaaaaaegaobaaaagaaaaaaegaobaaa
agaaaaaaegaobaaaaeaaaaaaeeaaaaafpcaabaaaaeaaaaaaegaobaaaadaaaaaa
dcaaaaanpcaabaaaadaaaaaaegaobaaaadaaaaaaegiocaaaabaaaaaaafaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpaoaaaaakpcaabaaaadaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpegaobaaaadaaaaaadiaaaaah
pcaabaaaabaaaaaaegaobaaaabaaaaaaegaobaaaaeaaaaaadeaaaaakpcaabaaa
abaaaaaaegaobaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
diaaaaahpcaabaaaabaaaaaaegaobaaaadaaaaaaegaobaaaabaaaaaadiaaaaai
hcaabaaaadaaaaaafgafbaaaabaaaaaaegiccaaaabaaaaaaahaaaaaadcaaaaak
hcaabaaaadaaaaaaegiccaaaabaaaaaaagaaaaaaagaabaaaabaaaaaaegacbaaa
adaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaabaaaaaaaiaaaaaakgakbaaa
abaaaaaaegacbaaaadaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaabaaaaaa
ajaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaaaaaaaaahhccabaaaacaaaaaa
egacbaaaabaaaaaaegacbaaaacaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaa
aaaaaaaaakiacaaaaaaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaa
aeaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaaeaaaaaakgakbaaaabaaaaaa
mgaabaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_2 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal_8;
  normal_8 = tmpvar_6;
  highp float vC_9;
  mediump vec3 x3_10;
  mediump vec3 x2_11;
  mediump vec3 x1_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAr, normal_8);
  x1_12.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAg, normal_8);
  x1_12.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAb, normal_8);
  x1_12.z = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = (normal_8.xyzz * normal_8.yzzx);
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBr, tmpvar_16);
  x2_11.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBg, tmpvar_16);
  x2_11.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBb, tmpvar_16);
  x2_11.z = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = ((normal_8.x * normal_8.x) - (normal_8.y * normal_8.y));
  vC_9 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (unity_SHC.xyz * vC_9);
  x3_10 = tmpvar_21;
  tmpvar_7 = ((x1_12 + x2_11) + x3_10);
  shlight_1 = tmpvar_7;
  tmpvar_3 = shlight_1;
  highp vec3 tmpvar_22;
  tmpvar_22 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_4LightPosX0 - tmpvar_22.x);
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosY0 - tmpvar_22.y);
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_4LightPosZ0 - tmpvar_22.z);
  highp vec4 tmpvar_26;
  tmpvar_26 = (((tmpvar_23 * tmpvar_23) + (tmpvar_24 * tmpvar_24)) + (tmpvar_25 * tmpvar_25));
  highp vec4 tmpvar_27;
  tmpvar_27 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_23 * tmpvar_5.x) + (tmpvar_24 * tmpvar_5.y)) + (tmpvar_25 * tmpvar_5.z)) * inversesqrt(tmpvar_26))) * (1.0/((1.0 + (tmpvar_26 * unity_4LightAtten0)))));
  highp vec3 tmpvar_28;
  tmpvar_28 = (tmpvar_3 + ((((unity_LightColor[0].xyz * tmpvar_27.x) + (unity_LightColor[1].xyz * tmpvar_27.y)) + (unity_LightColor[2].xyz * tmpvar_27.z)) + (unity_LightColor[3].xyz * tmpvar_27.w)));
  tmpvar_3 = tmpvar_28;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform sampler2D _RampTex;
uniform highp float _MySliderValue;
uniform highp vec4 _AmbientColor;
uniform highp vec4 _EmissiveColor;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = pow ((_EmissiveColor + _AmbientColor), vec4(_MySliderValue));
  highp vec3 tmpvar_5;
  tmpvar_5 = tmpvar_4.xyz;
  tmpvar_2 = tmpvar_5;
  highp float tmpvar_6;
  tmpvar_6 = tmpvar_4.w;
  tmpvar_3 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize(xlv_TEXCOORD2);
  mediump vec3 viewDir_8;
  viewDir_8 = tmpvar_7;
  highp vec4 col_9;
  highp vec3 ramp_10;
  highp float rimLight_11;
  highp float difLight_12;
  lowp float tmpvar_13;
  tmpvar_13 = max (0.0, dot (xlv_TEXCOORD0, _WorldSpaceLightPos0.xyz));
  difLight_12 = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = max (0.0, dot (xlv_TEXCOORD0, viewDir_8));
  rimLight_11 = tmpvar_14;
  highp vec2 tmpvar_15;
  tmpvar_15.x = ((difLight_12 * 0.5) + 0.5);
  tmpvar_15.y = ((rimLight_11 * 0.5) + 0.5);
  lowp vec3 tmpvar_16;
  tmpvar_16 = texture2D (_RampTex, tmpvar_15).xyz;
  ramp_10 = tmpvar_16;
  col_9.xyz = ((tmpvar_2 * _LightColor0.xyz) * ramp_10);
  col_9.w = tmpvar_3;
  c_1 = col_9;
  c_1.xyz = (c_1.xyz + (tmpvar_2 * xlv_TEXCOORD1));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_mvp * _glesVertex);
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_2 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = tmpvar_6;
  mediump vec3 tmpvar_8;
  mediump vec4 normal_9;
  normal_9 = tmpvar_7;
  highp float vC_10;
  mediump vec3 x3_11;
  mediump vec3 x2_12;
  mediump vec3 x1_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal_9);
  x1_13.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal_9);
  x1_13.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal_9);
  x1_13.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal_9.xyzz * normal_9.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2_12.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2_12.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2_12.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal_9.x * normal_9.x) - (normal_9.y * normal_9.y));
  vC_10 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC_10);
  x3_11 = tmpvar_22;
  tmpvar_8 = ((x1_13 + x2_12) + x3_11);
  shlight_1 = tmpvar_8;
  tmpvar_3 = shlight_1;
  highp vec3 tmpvar_23;
  tmpvar_23 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosX0 - tmpvar_23.x);
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_4LightPosY0 - tmpvar_23.y);
  highp vec4 tmpvar_26;
  tmpvar_26 = (unity_4LightPosZ0 - tmpvar_23.z);
  highp vec4 tmpvar_27;
  tmpvar_27 = (((tmpvar_24 * tmpvar_24) + (tmpvar_25 * tmpvar_25)) + (tmpvar_26 * tmpvar_26));
  highp vec4 tmpvar_28;
  tmpvar_28 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_24 * tmpvar_6.x) + (tmpvar_25 * tmpvar_6.y)) + (tmpvar_26 * tmpvar_6.z)) * inversesqrt(tmpvar_27))) * (1.0/((1.0 + (tmpvar_27 * unity_4LightAtten0)))));
  highp vec3 tmpvar_29;
  tmpvar_29 = (tmpvar_3 + ((((unity_LightColor[0].xyz * tmpvar_28.x) + (unity_LightColor[1].xyz * tmpvar_28.y)) + (unity_LightColor[2].xyz * tmpvar_28.z)) + (unity_LightColor[3].xyz * tmpvar_28.w)));
  tmpvar_3 = tmpvar_29;
  highp vec4 o_30;
  highp vec4 tmpvar_31;
  tmpvar_31 = (tmpvar_4 * 0.5);
  highp vec2 tmpvar_32;
  tmpvar_32.x = tmpvar_31.x;
  tmpvar_32.y = (tmpvar_31.y * _ProjectionParams.x);
  o_30.xy = (tmpvar_32 + tmpvar_31.w);
  o_30.zw = tmpvar_4.zw;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = o_30;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform sampler2D _RampTex;
uniform highp float _MySliderValue;
uniform highp vec4 _AmbientColor;
uniform highp vec4 _EmissiveColor;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = pow ((_EmissiveColor + _AmbientColor), vec4(_MySliderValue));
  highp vec3 tmpvar_5;
  tmpvar_5 = tmpvar_4.xyz;
  tmpvar_2 = tmpvar_5;
  highp float tmpvar_6;
  tmpvar_6 = tmpvar_4.w;
  tmpvar_3 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize(xlv_TEXCOORD2);
  mediump vec3 viewDir_8;
  viewDir_8 = tmpvar_7;
  highp vec4 col_9;
  highp vec3 ramp_10;
  highp float rimLight_11;
  highp float difLight_12;
  lowp float tmpvar_13;
  tmpvar_13 = max (0.0, dot (xlv_TEXCOORD0, _WorldSpaceLightPos0.xyz));
  difLight_12 = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = max (0.0, dot (xlv_TEXCOORD0, viewDir_8));
  rimLight_11 = tmpvar_14;
  highp vec2 tmpvar_15;
  tmpvar_15.x = ((difLight_12 * 0.5) + 0.5);
  tmpvar_15.y = ((rimLight_11 * 0.5) + 0.5);
  lowp vec3 tmpvar_16;
  tmpvar_16 = texture2D (_RampTex, tmpvar_15).xyz;
  ramp_10 = tmpvar_16;
  col_9.xyz = ((tmpvar_2 * _LightColor0.xyz) * ramp_10);
  col_9.w = tmpvar_3;
  c_1 = col_9;
  c_1.xyz = (c_1.xyz + (tmpvar_2 * xlv_TEXCOORD1));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceCameraPos]
Vector 9 [_ProjectionParams]
Vector 10 [unity_4LightPosX0]
Vector 11 [unity_4LightPosY0]
Vector 12 [unity_4LightPosZ0]
Vector 13 [unity_4LightAtten0]
Vector 14 [unity_LightColor0]
Vector 15 [unity_LightColor1]
Vector 16 [unity_LightColor2]
Vector 17 [unity_LightColor3]
Vector 18 [unity_SHAr]
Vector 19 [unity_SHAg]
Vector 20 [unity_SHAb]
Vector 21 [unity_SHBr]
Vector 22 [unity_SHBg]
Vector 23 [unity_SHBb]
Vector 24 [unity_SHC]
Matrix 4 [_Object2World]
Vector 25 [unity_Scale]
Vector 26 [unity_NPOTScale]
"agal_vs
c27 1.0 0.0 0.5 0.0
[bc]
adaaaaaaadaaahacabaaaaoeaaaaaaaabjaaaappabaaaaaa mul r3.xyz, a1, c25.w
bcaaaaaaafaaabacadaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r5.x, r3.xyzz, c4
bdaaaaaaaeaaamacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r4.zw, a0, c5
bfaaaaaaacaaaeacaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa neg r2.z, r4.z
abaaaaaaacaaapacacaaaakkacaaaaaaalaaaaoeabaaaaaa add r2, r2.z, c11
bcaaaaaaaeaaaeacadaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r4.z, r3.xyzz, c5
bcaaaaaaadaaabacadaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r3.x, r3.xyzz, c6
bdaaaaaaadaaaiacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r3.w, a0, c4
adaaaaaaaaaaapacaeaaaakkacaaaaaaacaaaaoeacaaaaaa mul r0, r4.z, r2
bfaaaaaaabaaaiacadaaaappacaaaaaaaaaaaaaaaaaaaaaa neg r1.w, r3.w
abaaaaaaabaaapacabaaaappacaaaaaaakaaaaoeabaaaaaa add r1, r1.w, c10
bdaaaaaaaeaaadacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r4.xy, a0, c6
adaaaaaaacaaapacacaaaaoeacaaaaaaacaaaaoeacaaaaaa mul r2, r2, r2
aaaaaaaaafaaaeacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r5.z, r3.x
aaaaaaaaafaaacacaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r5.y, r4.z
aaaaaaaaafaaaiacblaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r5.w, c27.x
adaaaaaaagaaapacafaaaaaaacaaaaaaabaaaaoeacaaaaaa mul r6, r5.x, r1
abaaaaaaaaaaapacagaaaaoeacaaaaaaaaaaaaoeacaaaaaa add r0, r6, r0
adaaaaaaagaaapacabaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r6, r1, r1
abaaaaaaacaaapacagaaaaoeacaaaaaaacaaaaoeacaaaaaa add r2, r6, r2
bfaaaaaaabaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r1.x, r4.x
abaaaaaaabaaapacabaaaaaaacaaaaaaamaaaaoeabaaaaaa add r1, r1.x, c12
adaaaaaaagaaapacabaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r6, r1, r1
abaaaaaaacaaapacagaaaaoeacaaaaaaacaaaaoeacaaaaaa add r2, r6, r2
adaaaaaaagaaapacadaaaaaaacaaaaaaabaaaaoeacaaaaaa mul r6, r3.x, r1
abaaaaaaaaaaapacagaaaaoeacaaaaaaaaaaaaoeacaaaaaa add r0, r6, r0
adaaaaaaabaaapacacaaaaoeacaaaaaaanaaaaoeabaaaaaa mul r1, r2, c13
abaaaaaaabaaapacabaaaaoeacaaaaaablaaaaaaabaaaaaa add r1, r1, c27.x
aaaaaaaaaaaaaeaeadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov v0.z, r3.x
akaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r2.x, r2.x
akaaaaaaacaaacacacaaaaffacaaaaaaaaaaaaaaaaaaaaaa rsq r2.y, r2.y
akaaaaaaacaaaeacacaaaakkacaaaaaaaaaaaaaaaaaaaaaa rsq r2.z, r2.z
akaaaaaaacaaaiacacaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r2.w, r2.w
adaaaaaaaaaaapacaaaaaaoeacaaaaaaacaaaaoeacaaaaaa mul r0, r0, r2
bdaaaaaaacaaaeacafaaaaoeacaaaaaabeaaaaoeabaaaaaa dp4 r2.z, r5, c20
bdaaaaaaacaaacacafaaaaoeacaaaaaabdaaaaoeabaaaaaa dp4 r2.y, r5, c19
bdaaaaaaacaaabacafaaaaoeacaaaaaabcaaaaoeabaaaaaa dp4 r2.x, r5, c18
afaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r1.x, r1.x
afaaaaaaabaaacacabaaaaffacaaaaaaaaaaaaaaaaaaaaaa rcp r1.y, r1.y
afaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r1.w, r1.w
afaaaaaaabaaaeacabaaaakkacaaaaaaaaaaaaaaaaaaaaaa rcp r1.z, r1.z
ahaaaaaaaaaaapacaaaaaaoeacaaaaaablaaaaffabaaaaaa max r0, r0, c27.y
adaaaaaaaaaaapacaaaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r0, r0, r1
adaaaaaaabaaahacaaaaaaffacaaaaaaapaaaaoeabaaaaaa mul r1.xyz, r0.y, c15
adaaaaaaagaaahacaaaaaaaaacaaaaaaaoaaaaoeabaaaaaa mul r6.xyz, r0.x, c14
abaaaaaaabaaahacagaaaakeacaaaaaaabaaaakeacaaaaaa add r1.xyz, r6.xyzz, r1.xyzz
adaaaaaaaaaaahacaaaaaakkacaaaaaabaaaaaoeabaaaaaa mul r0.xyz, r0.z, c16
abaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa add r0.xyz, r0.xyzz, r1.xyzz
adaaaaaaabaaahacaaaaaappacaaaaaabbaaaaoeabaaaaaa mul r1.xyz, r0.w, c17
abaaaaaaabaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r1.xyz, r1.xyzz, r0.xyzz
adaaaaaaaaaaapacafaaaakeacaaaaaaafaaaacjacaaaaaa mul r0, r5.xyzz, r5.yzzx
adaaaaaaabaaaiacaeaaaakkacaaaaaaaeaaaakkacaaaaaa mul r1.w, r4.z, r4.z
bdaaaaaaafaaaiacaaaaaaoeacaaaaaabhaaaaoeabaaaaaa dp4 r5.w, r0, c23
bdaaaaaaafaaaeacaaaaaaoeacaaaaaabgaaaaoeabaaaaaa dp4 r5.z, r0, c22
bdaaaaaaafaaacacaaaaaaoeacaaaaaabfaaaaoeabaaaaaa dp4 r5.y, r0, c21
adaaaaaaagaaaiacafaaaaaaacaaaaaaafaaaaaaacaaaaaa mul r6.w, r5.x, r5.x
acaaaaaaabaaaiacagaaaappacaaaaaaabaaaappacaaaaaa sub r1.w, r6.w, r1.w
adaaaaaaaaaaahacabaaaappacaaaaaabiaaaaoeabaaaaaa mul r0.xyz, r1.w, c24
abaaaaaaacaaahacacaaaakeacaaaaaaafaaaapjacaaaaaa add r2.xyz, r2.xyzz, r5.yzww
abaaaaaaacaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa add r2.xyz, r2.xyzz, r0.xyzz
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 r0.w, a0, c3
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 r0.z, a0, c2
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 r0.x, a0, c0
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 r0.y, a0, c1
adaaaaaaafaaaoacaaaaaandacaaaaaablaaaakkabaaaaaa mul r5.yzw, r0.wxyw, c27.z
abaaaaaaabaaahaeacaaaakeacaaaaaaabaaaakeacaaaaaa add v1.xyz, r2.xyzz, r1.xyzz
adaaaaaaabaaacacafaaaakkacaaaaaaajaaaaaaabaaaaaa mul r1.y, r5.z, c9.x
aaaaaaaaabaaabacafaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r5.y
abaaaaaaabaaadacabaaaafeacaaaaaaafaaaappacaaaaaa add r1.xy, r1.xyyy, r5.w
aaaaaaaaadaaabacaeaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r3.x, r4.w
aaaaaaaaadaaacacaeaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r3.y, r4.y
adaaaaaaadaaadaeabaaaafeacaaaaaabkaaaaoeabaaaaaa mul v3.xy, r1.xyyy, c26
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
aaaaaaaaadaaamaeaaaaaaopacaaaaaaaaaaaaaaaaaaaaaa mov v3.zw, r0.wwzw
aaaaaaaaaaaaacaeaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov v0.y, r4.z
aaaaaaaaaaaaabaeafaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov v0.x, r5.x
bfaaaaaaagaaalacadaaaapdacaaaaaaaaaaaaaaaaaaaaaa neg r6.xyw, r3.wxww
abaaaaaaacaaahaeagaaaafdacaaaaaaaiaaaaoeabaaaaaa add v2.xyz, r6.wxyy, c8
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 32 [unity_4LightPosX0] 4
Vector 48 [unity_4LightPosY0] 4
Vector 64 [unity_4LightPosZ0] 4
Vector 80 [unity_4LightAtten0] 4
Vector 96 [unity_LightColor0] 4
Vector 112 [unity_LightColor1] 4
Vector 128 [unity_LightColor2] 4
Vector 144 [unity_LightColor3] 4
Vector 160 [unity_LightColor4] 4
Vector 176 [unity_LightColor5] 4
Vector 192 [unity_LightColor6] 4
Vector 208 [unity_LightColor7] 4
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "UnityPerCamera" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 52 instructions, 7 temp regs, 0 temp arrays:
// ALU 47 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedfmplmloicifhcggoapgjijnaabfbnfiiabaaaaaahianaaaaaeaaaaaa
daaaaaaaliaeaaaabaamaaaaniamaaaaebgpgodjiaaeaaaaiaaeaaaaaaacpopp
baaeaaaahaaaaaaaagaaceaaaaaagmaaaaaagmaaaaaaceaaabaagmaaaaaaaeaa
acaaabaaaaaaaaaaabaaacaaaiaaadaaaaaaaaaaabaacgaaahaaalaaaaaaaaaa
acaaaaaaaeaabcaaaaaaaaaaacaaamaaaeaabgaaaaaaaaaaacaabeaaabaabkaa
aaaaaaaaaaaaaaaaaaacpoppfbaaaaafblaaapkaaaaaiadpaaaaaaaaaaaaaadp
aaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaaciaacaaapjaafaaaaad
aaaaahiaaaaaffjabhaaoekaaeaaaaaeaaaaahiabgaaoekaaaaaaajaaaaaoeia
aeaaaaaeaaaaahiabiaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaahiabjaaoeka
aaaappjaaaaaoeiaacaaaaadacaaahoaaaaaoeibabaaoekaacaaaaadabaaapia
aaaaffibaeaaoekaafaaaaadacaaapiaabaaoeiaabaaoeiaacaaaaadadaaapia
aaaaaaibadaaoekaacaaaaadaaaaapiaaaaakkibafaaoekaaeaaaaaeacaaapia
adaaoeiaadaaoeiaacaaoeiaaeaaaaaeacaaapiaaaaaoeiaaaaaoeiaacaaoeia
ahaaaaacaeaaabiaacaaaaiaahaaaaacaeaaaciaacaaffiaahaaaaacaeaaaeia
acaakkiaahaaaaacaeaaaiiaacaappiaabaaaaacafaaabiablaaaakaaeaaaaae
acaaapiaacaaoeiaagaaoekaafaaaaiaafaaaaadafaaahiaacaaoejabkaappka
afaaaaadagaaahiaafaaffiabhaaoekaaeaaaaaeafaaaliabgaakekaafaaaaia
agaakeiaaeaaaaaeafaaahiabiaaoekaafaakkiaafaapeiaafaaaaadabaaapia
abaaoeiaafaaffiaaeaaaaaeabaaapiaadaaoeiaafaaaaiaabaaoeiaaeaaaaae
aaaaapiaaaaaoeiaafaakkiaabaaoeiaafaaaaadaaaaapiaaeaaoeiaaaaaoeia
alaaaaadaaaaapiaaaaaoeiablaaffkaagaaaaacabaaabiaacaaaaiaagaaaaac
abaaaciaacaaffiaagaaaaacabaaaeiaacaakkiaagaaaaacabaaaiiaacaappia
afaaaaadaaaaapiaaaaaoeiaabaaoeiaafaaaaadabaaahiaaaaaffiaaiaaoeka
aeaaaaaeabaaahiaahaaoekaaaaaaaiaabaaoeiaaeaaaaaeaaaaahiaajaaoeka
aaaakkiaabaaoeiaaeaaaaaeaaaaahiaakaaoekaaaaappiaaaaaoeiaabaaaaac
afaaaiiablaaaakaajaaaaadabaaabiaalaaoekaafaaoeiaajaaaaadabaaacia
amaaoekaafaaoeiaajaaaaadabaaaeiaanaaoekaafaaoeiaafaaaaadacaaapia
afaacjiaafaakeiaajaaaaadadaaabiaaoaaoekaacaaoeiaajaaaaadadaaacia
apaaoekaacaaoeiaajaaaaadadaaaeiabaaaoekaacaaoeiaacaaaaadabaaahia
abaaoeiaadaaoeiaafaaaaadaaaaaiiaafaaffiaafaaffiaaeaaaaaeaaaaaiia
afaaaaiaafaaaaiaaaaappibabaaaaacaaaaahoaafaaoeiaaeaaaaaeabaaahia
bbaaoekaaaaappiaabaaoeiaacaaaaadabaaahoaaaaaoeiaabaaoeiaafaaaaad
aaaaapiaaaaaffjabdaaoekaaeaaaaaeaaaaapiabcaaoekaaaaaaajaaaaaoeia
aeaaaaaeaaaaapiabeaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiabfaaoeka
aaaappjaaaaaoeiaafaaaaadabaaabiaaaaaffiaacaaaakaafaaaaadabaaaiia
abaaaaiablaakkkaafaaaaadabaaafiaaaaapeiablaakkkaacaaaaadadaaadoa
abaakkiaabaaomiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaac
aaaaammaaaaaoeiaabaaaaacadaaamoaaaaaoeiappppaaaafdeieefcfaahaaaa
eaaaabaaneabaaaafjaaaaaeegiocaaaaaaaaaaaagaaaaaafjaaaaaeegiocaaa
abaaaaaacnaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaa
aaaaaaaafpaaaaadhcbabaaaacaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaadhccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaa
adaaaaaagfaaaaadpccabaaaaeaaaaaagiaaaaacahaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaaihcaabaaaabaaaaaaegbcbaaaacaaaaaapgipcaaaacaaaaaa
beaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaaacaaaaaa
anaaaaaadcaaaaaklcaabaaaabaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaaa
abaaaaaaegaibaaaacaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaa
aoaaaaaakgakbaaaabaaaaaaegadbaaaabaaaaaadgaaaaafhccabaaaabaaaaaa
egacbaaaabaaaaaadgaaaaaficaabaaaabaaaaaaabeaaaaaaaaaiadpbbaaaaai
bcaabaaaacaaaaaaegiocaaaabaaaaaacgaaaaaaegaobaaaabaaaaaabbaaaaai
ccaabaaaacaaaaaaegiocaaaabaaaaaachaaaaaaegaobaaaabaaaaaabbaaaaai
ecaabaaaacaaaaaaegiocaaaabaaaaaaciaaaaaaegaobaaaabaaaaaadiaaaaah
pcaabaaaadaaaaaajgacbaaaabaaaaaaegakbaaaabaaaaaabbaaaaaibcaabaaa
aeaaaaaaegiocaaaabaaaaaacjaaaaaaegaobaaaadaaaaaabbaaaaaiccaabaaa
aeaaaaaaegiocaaaabaaaaaackaaaaaaegaobaaaadaaaaaabbaaaaaiecaabaaa
aeaaaaaaegiocaaaabaaaaaaclaaaaaaegaobaaaadaaaaaaaaaaaaahhcaabaaa
acaaaaaaegacbaaaacaaaaaaegacbaaaaeaaaaaadiaaaaahicaabaaaabaaaaaa
bkaabaaaabaaaaaabkaabaaaabaaaaaadcaaaaakicaabaaaabaaaaaaakaabaaa
abaaaaaaakaabaaaabaaaaaadkaabaiaebaaaaaaabaaaaaadcaaaaakhcaabaaa
acaaaaaaegiccaaaabaaaaaacmaaaaaapgapbaaaabaaaaaaegacbaaaacaaaaaa
diaaaaaihcaabaaaadaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaa
dcaaaaakhcaabaaaadaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaa
egacbaaaadaaaaaadcaaaaakhcaabaaaadaaaaaaegiccaaaacaaaaaaaoaaaaaa
kgbkbaaaaaaaaaaaegacbaaaadaaaaaadcaaaaakhcaabaaaadaaaaaaegiccaaa
acaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaadaaaaaaaaaaaaajpcaabaaa
aeaaaaaafgafbaiaebaaaaaaadaaaaaaegiocaaaabaaaaaaadaaaaaadiaaaaah
pcaabaaaafaaaaaafgafbaaaabaaaaaaegaobaaaaeaaaaaadiaaaaahpcaabaaa
aeaaaaaaegaobaaaaeaaaaaaegaobaaaaeaaaaaaaaaaaaajpcaabaaaagaaaaaa
agaabaiaebaaaaaaadaaaaaaegiocaaaabaaaaaaacaaaaaadcaaaaajpcaabaaa
afaaaaaaegaobaaaagaaaaaaagaabaaaabaaaaaaegaobaaaafaaaaaadcaaaaaj
pcaabaaaaeaaaaaaegaobaaaagaaaaaaegaobaaaagaaaaaaegaobaaaaeaaaaaa
aaaaaaajpcaabaaaagaaaaaakgakbaiaebaaaaaaadaaaaaaegiocaaaabaaaaaa
aeaaaaaaaaaaaaajhccabaaaadaaaaaaegacbaiaebaaaaaaadaaaaaaegiccaaa
aaaaaaaaaeaaaaaadcaaaaajpcaabaaaabaaaaaaegaobaaaagaaaaaakgakbaaa
abaaaaaaegaobaaaafaaaaaadcaaaaajpcaabaaaadaaaaaaegaobaaaagaaaaaa
egaobaaaagaaaaaaegaobaaaaeaaaaaaeeaaaaafpcaabaaaaeaaaaaaegaobaaa
adaaaaaadcaaaaanpcaabaaaadaaaaaaegaobaaaadaaaaaaegiocaaaabaaaaaa
afaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpaoaaaaakpcaabaaa
adaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpegaobaaaadaaaaaa
diaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaaegaobaaaaeaaaaaadeaaaaak
pcaabaaaabaaaaaaegaobaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaadaaaaaaegaobaaaabaaaaaa
diaaaaaihcaabaaaadaaaaaafgafbaaaabaaaaaaegiccaaaabaaaaaaahaaaaaa
dcaaaaakhcaabaaaadaaaaaaegiccaaaabaaaaaaagaaaaaaagaabaaaabaaaaaa
egacbaaaadaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaabaaaaaaaiaaaaaa
kgakbaaaabaaaaaaegacbaaaadaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
abaaaaaaajaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaaaaaaaaahhccabaaa
acaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaadiaaaaaiccaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakiacaaaaaaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaa
agahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaaf
mccabaaaaeaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaaeaaaaaakgakbaaa
abaaaaaamgaabaaaabaaaaaadoaaaaabejfdeheomaaaaaaaagaaaaaaaiaaaaaa
jiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
acaaaaaaahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaa
laaaaaaaabaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofe
aaeoepfcenebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaa
afaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
imaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaaimaaaaaaabaaaaaa
aaaaaaaaadaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaa
adaaaaaaahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 403
struct Input {
    highp vec2 uv_MainTex;
};
#line 426
struct v2f_surf {
    highp vec4 pos;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec3 viewDir;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform highp vec4 _EmissiveColor;
uniform highp vec4 _AmbientColor;
#line 401
uniform highp float _MySliderValue;
uniform sampler2D _RampTex;
#line 408
#line 435
#line 451
#line 96
highp vec3 Shade4PointLights( in highp vec4 lightPosX, in highp vec4 lightPosY, in highp vec4 lightPosZ, in highp vec3 lightColor0, in highp vec3 lightColor1, in highp vec3 lightColor2, in highp vec3 lightColor3, in highp vec4 lightAttenSq, in highp vec3 pos, in highp vec3 normal ) {
    highp vec4 toLightX = (lightPosX - pos.x);
    highp vec4 toLightY = (lightPosY - pos.y);
    #line 100
    highp vec4 toLightZ = (lightPosZ - pos.z);
    highp vec4 lengthSq = vec4( 0.0);
    lengthSq += (toLightX * toLightX);
    lengthSq += (toLightY * toLightY);
    #line 104
    lengthSq += (toLightZ * toLightZ);
    highp vec4 ndotl = vec4( 0.0);
    ndotl += (toLightX * normal.x);
    ndotl += (toLightY * normal.y);
    #line 108
    ndotl += (toLightZ * normal.z);
    highp vec4 corr = inversesqrt(lengthSq);
    ndotl = max( vec4( 0.0, 0.0, 0.0, 0.0), (ndotl * corr));
    highp vec4 atten = (1.0 / (1.0 + (lengthSq * lightAttenSq)));
    #line 112
    highp vec4 diff = (ndotl * atten);
    highp vec3 col = vec3( 0.0);
    col += (lightColor0 * diff.x);
    col += (lightColor1 * diff.y);
    #line 116
    col += (lightColor2 * diff.z);
    col += (lightColor3 * diff.w);
    return col;
}
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 87
highp vec3 WorldSpaceViewDir( in highp vec4 v ) {
    return (_WorldSpaceCameraPos.xyz - (_Object2World * v).xyz);
}
#line 435
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 439
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.normal = worldN;
    highp vec3 viewDirForLight = WorldSpaceViewDir( v.vertex);
    o.viewDir = viewDirForLight;
    #line 443
    highp vec3 shlight = ShadeSH9( vec4( worldN, 1.0));
    o.vlight = shlight;
    highp vec3 worldPos = (_Object2World * v.vertex).xyz;
    o.vlight += Shade4PointLights( unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0, unity_LightColor[0].xyz, unity_LightColor[1].xyz, unity_LightColor[2].xyz, unity_LightColor[3].xyz, unity_4LightAtten0, worldPos, worldN);
    #line 447
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    return o;
}

out lowp vec3 xlv_TEXCOORD0;
out lowp vec3 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.normal);
    xlv_TEXCOORD1 = vec3(xl_retval.vlight);
    xlv_TEXCOORD2 = vec3(xl_retval.viewDir);
    xlv_TEXCOORD3 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 403
struct Input {
    highp vec2 uv_MainTex;
};
#line 426
struct v2f_surf {
    highp vec4 pos;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec3 viewDir;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform highp vec4 _EmissiveColor;
uniform highp vec4 _AmbientColor;
#line 401
uniform highp float _MySliderValue;
uniform sampler2D _RampTex;
#line 408
#line 435
#line 451
#line 414
highp vec4 LightingBasicDiffuse( in SurfaceOutput s, in lowp vec3 lightDir, in mediump vec3 viewDir, in lowp float atten ) {
    #line 416
    highp float difLight = max( 0.0, dot( s.Normal, lightDir));
    highp float rimLight = max( 0.0, dot( s.Normal, viewDir));
    highp float dif_hLambert = ((difLight * 0.5) + 0.5);
    highp float rim_hLambert = ((rimLight * 0.5) + 0.5);
    #line 420
    highp vec3 ramp = texture( _RampTex, vec2( dif_hLambert, rim_hLambert)).xyz;
    highp vec4 col;
    col.xyz = ((s.Albedo * _LightColor0.xyz) * ramp);
    col.w = s.Alpha;
    #line 424
    return col;
}
#line 408
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec4 c = pow( (_EmissiveColor + _AmbientColor), vec4( _MySliderValue));
    o.Albedo = c.xyz;
    #line 412
    o.Alpha = c.w;
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    highp float dist = textureProj( _ShadowMapTexture, shadowCoord).x;
    mediump float lightShadowDataX = _LightShadowData.x;
    #line 397
    return max( float((dist > (shadowCoord.z / shadowCoord.w))), lightShadowDataX);
}
#line 451
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    #line 455
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    #line 459
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    surf( surfIN, o);
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    #line 463
    lowp vec4 c = vec4( 0.0);
    c = LightingBasicDiffuse( o, _WorldSpaceLightPos0.xyz, normalize(IN.viewDir), atten);
    c.xyz += (o.Albedo * IN.vlight);
    return c;
}
in lowp vec3 xlv_TEXCOORD0;
in lowp vec3 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.normal = vec3(xlv_TEXCOORD0);
    xlt_IN.vlight = vec3(xlv_TEXCOORD1);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD2);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_2 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal_8;
  normal_8 = tmpvar_6;
  highp float vC_9;
  mediump vec3 x3_10;
  mediump vec3 x2_11;
  mediump vec3 x1_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAr, normal_8);
  x1_12.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAg, normal_8);
  x1_12.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAb, normal_8);
  x1_12.z = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = (normal_8.xyzz * normal_8.yzzx);
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBr, tmpvar_16);
  x2_11.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBg, tmpvar_16);
  x2_11.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBb, tmpvar_16);
  x2_11.z = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = ((normal_8.x * normal_8.x) - (normal_8.y * normal_8.y));
  vC_9 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (unity_SHC.xyz * vC_9);
  x3_10 = tmpvar_21;
  tmpvar_7 = ((x1_12 + x2_11) + x3_10);
  shlight_1 = tmpvar_7;
  tmpvar_3 = shlight_1;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
varying highp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform sampler2D _RampTex;
uniform highp float _MySliderValue;
uniform highp vec4 _AmbientColor;
uniform highp vec4 _EmissiveColor;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = pow ((_EmissiveColor + _AmbientColor), vec4(_MySliderValue));
  highp vec3 tmpvar_5;
  tmpvar_5 = tmpvar_4.xyz;
  tmpvar_2 = tmpvar_5;
  highp float tmpvar_6;
  tmpvar_6 = tmpvar_4.w;
  tmpvar_3 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize(xlv_TEXCOORD2);
  mediump vec3 viewDir_8;
  viewDir_8 = tmpvar_7;
  highp vec4 col_9;
  highp vec3 ramp_10;
  highp float rimLight_11;
  highp float difLight_12;
  lowp float tmpvar_13;
  tmpvar_13 = max (0.0, dot (xlv_TEXCOORD0, _WorldSpaceLightPos0.xyz));
  difLight_12 = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = max (0.0, dot (xlv_TEXCOORD0, viewDir_8));
  rimLight_11 = tmpvar_14;
  highp vec2 tmpvar_15;
  tmpvar_15.x = ((difLight_12 * 0.5) + 0.5);
  tmpvar_15.y = ((rimLight_11 * 0.5) + 0.5);
  lowp vec3 tmpvar_16;
  tmpvar_16 = texture2D (_RampTex, tmpvar_15).xyz;
  ramp_10 = tmpvar_16;
  col_9.xyz = ((tmpvar_2 * _LightColor0.xyz) * ramp_10);
  col_9.w = tmpvar_3;
  c_1 = col_9;
  c_1.xyz = (c_1.xyz + (tmpvar_2 * xlv_TEXCOORD1));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 403
struct Input {
    highp vec2 uv_MainTex;
};
#line 426
struct v2f_surf {
    highp vec4 pos;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec3 viewDir;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform highp vec4 _EmissiveColor;
uniform highp vec4 _AmbientColor;
#line 401
uniform highp float _MySliderValue;
uniform sampler2D _RampTex;
#line 408
#line 435
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 87
highp vec3 WorldSpaceViewDir( in highp vec4 v ) {
    return (_WorldSpaceCameraPos.xyz - (_Object2World * v).xyz);
}
#line 435
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 439
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.normal = worldN;
    highp vec3 viewDirForLight = WorldSpaceViewDir( v.vertex);
    o.viewDir = viewDirForLight;
    #line 443
    highp vec3 shlight = ShadeSH9( vec4( worldN, 1.0));
    o.vlight = shlight;
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    #line 447
    return o;
}

out lowp vec3 xlv_TEXCOORD0;
out lowp vec3 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.normal);
    xlv_TEXCOORD1 = vec3(xl_retval.vlight);
    xlv_TEXCOORD2 = vec3(xl_retval.viewDir);
    xlv_TEXCOORD3 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_shadow2D(mediump sampler2DShadow s, vec3 coord) { return texture (s, coord); }
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 403
struct Input {
    highp vec2 uv_MainTex;
};
#line 426
struct v2f_surf {
    highp vec4 pos;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec3 viewDir;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform highp vec4 _EmissiveColor;
uniform highp vec4 _AmbientColor;
#line 401
uniform highp float _MySliderValue;
uniform sampler2D _RampTex;
#line 408
#line 435
#line 414
highp vec4 LightingBasicDiffuse( in SurfaceOutput s, in lowp vec3 lightDir, in mediump vec3 viewDir, in lowp float atten ) {
    #line 416
    highp float difLight = max( 0.0, dot( s.Normal, lightDir));
    highp float rimLight = max( 0.0, dot( s.Normal, viewDir));
    highp float dif_hLambert = ((difLight * 0.5) + 0.5);
    highp float rim_hLambert = ((rimLight * 0.5) + 0.5);
    #line 420
    highp vec3 ramp = texture( _RampTex, vec2( dif_hLambert, rim_hLambert)).xyz;
    highp vec4 col;
    col.xyz = ((s.Albedo * _LightColor0.xyz) * ramp);
    col.w = s.Alpha;
    #line 424
    return col;
}
#line 408
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec4 c = pow( (_EmissiveColor + _AmbientColor), vec4( _MySliderValue));
    o.Albedo = c.xyz;
    #line 412
    o.Alpha = c.w;
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    lowp float shadow = xll_shadow2D( _ShadowMapTexture, shadowCoord.xyz.xyz);
    shadow = (_LightShadowData.x + (shadow * (1.0 - _LightShadowData.x)));
    #line 397
    return shadow;
}
#line 449
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 451
    Input surfIN;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 455
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    #line 459
    surf( surfIN, o);
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    lowp vec4 c = vec4( 0.0);
    c = LightingBasicDiffuse( o, _WorldSpaceLightPos0.xyz, normalize(IN.viewDir), atten);
    #line 463
    c.xyz += (o.Albedo * IN.vlight);
    return c;
}
in lowp vec3 xlv_TEXCOORD0;
in lowp vec3 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.normal = vec3(xlv_TEXCOORD0);
    xlt_IN.vlight = vec3(xlv_TEXCOORD1);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD2);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD1 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp float _MySliderValue;
uniform highp vec4 _AmbientColor;
uniform highp vec4 _EmissiveColor;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform highp vec4 _LightShadowData;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = pow ((_EmissiveColor + _AmbientColor), vec4(_MySliderValue));
  highp vec3 tmpvar_5;
  tmpvar_5 = tmpvar_4.xyz;
  tmpvar_2 = tmpvar_5;
  highp float tmpvar_6;
  tmpvar_6 = tmpvar_4.w;
  tmpvar_3 = tmpvar_6;
  lowp float shadow_7;
  lowp float tmpvar_8;
  tmpvar_8 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD1.xyz);
  highp float tmpvar_9;
  tmpvar_9 = (_LightShadowData.x + (tmpvar_8 * (1.0 - _LightShadowData.x)));
  shadow_7 = tmpvar_9;
  c_1.xyz = (tmpvar_2 * min ((2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD0).xyz), vec3((shadow_7 * 2.0))));
  c_1.w = tmpvar_3;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 403
struct Input {
    highp vec2 uv_MainTex;
};
#line 426
struct v2f_surf {
    highp vec4 pos;
    highp vec2 lmap;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform highp vec4 _EmissiveColor;
uniform highp vec4 _AmbientColor;
#line 401
uniform highp float _MySliderValue;
uniform sampler2D _RampTex;
#line 408
#line 433
uniform highp vec4 unity_LightmapST;
uniform sampler2D unity_Lightmap;
#line 434
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 437
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    #line 442
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.lmap);
    xlv_TEXCOORD1 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_shadow2D(mediump sampler2DShadow s, vec3 coord) { return texture (s, coord); }
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 403
struct Input {
    highp vec2 uv_MainTex;
};
#line 426
struct v2f_surf {
    highp vec4 pos;
    highp vec2 lmap;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform highp vec4 _EmissiveColor;
uniform highp vec4 _AmbientColor;
#line 401
uniform highp float _MySliderValue;
uniform sampler2D _RampTex;
#line 408
#line 433
uniform highp vec4 unity_LightmapST;
uniform sampler2D unity_Lightmap;
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 408
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec4 c = pow( (_EmissiveColor + _AmbientColor), vec4( _MySliderValue));
    o.Albedo = c.xyz;
    #line 412
    o.Alpha = c.w;
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    lowp float shadow = xll_shadow2D( _ShadowMapTexture, shadowCoord.xyz.xyz);
    shadow = (_LightShadowData.x + (shadow * (1.0 - _LightShadowData.x)));
    #line 397
    return shadow;
}
#line 445
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 447
    Input surfIN;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 451
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    surf( surfIN, o);
    #line 455
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    lowp vec4 c = vec4( 0.0);
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    lowp vec3 lm = DecodeLightmap( lmtex);
    #line 459
    c.xyz += (o.Albedo * min( lm, vec3( (atten * 2.0))));
    c.w = o.Alpha;
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.lmap = vec2(xlv_TEXCOORD0);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD1);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_2 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal_8;
  normal_8 = tmpvar_6;
  highp float vC_9;
  mediump vec3 x3_10;
  mediump vec3 x2_11;
  mediump vec3 x1_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAr, normal_8);
  x1_12.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAg, normal_8);
  x1_12.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAb, normal_8);
  x1_12.z = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = (normal_8.xyzz * normal_8.yzzx);
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBr, tmpvar_16);
  x2_11.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBg, tmpvar_16);
  x2_11.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBb, tmpvar_16);
  x2_11.z = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = ((normal_8.x * normal_8.x) - (normal_8.y * normal_8.y));
  vC_9 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (unity_SHC.xyz * vC_9);
  x3_10 = tmpvar_21;
  tmpvar_7 = ((x1_12 + x2_11) + x3_10);
  shlight_1 = tmpvar_7;
  tmpvar_3 = shlight_1;
  highp vec3 tmpvar_22;
  tmpvar_22 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_4LightPosX0 - tmpvar_22.x);
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosY0 - tmpvar_22.y);
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_4LightPosZ0 - tmpvar_22.z);
  highp vec4 tmpvar_26;
  tmpvar_26 = (((tmpvar_23 * tmpvar_23) + (tmpvar_24 * tmpvar_24)) + (tmpvar_25 * tmpvar_25));
  highp vec4 tmpvar_27;
  tmpvar_27 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_23 * tmpvar_5.x) + (tmpvar_24 * tmpvar_5.y)) + (tmpvar_25 * tmpvar_5.z)) * inversesqrt(tmpvar_26))) * (1.0/((1.0 + (tmpvar_26 * unity_4LightAtten0)))));
  highp vec3 tmpvar_28;
  tmpvar_28 = (tmpvar_3 + ((((unity_LightColor[0].xyz * tmpvar_27.x) + (unity_LightColor[1].xyz * tmpvar_27.y)) + (unity_LightColor[2].xyz * tmpvar_27.z)) + (unity_LightColor[3].xyz * tmpvar_27.w)));
  tmpvar_3 = tmpvar_28;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
varying highp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform sampler2D _RampTex;
uniform highp float _MySliderValue;
uniform highp vec4 _AmbientColor;
uniform highp vec4 _EmissiveColor;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = pow ((_EmissiveColor + _AmbientColor), vec4(_MySliderValue));
  highp vec3 tmpvar_5;
  tmpvar_5 = tmpvar_4.xyz;
  tmpvar_2 = tmpvar_5;
  highp float tmpvar_6;
  tmpvar_6 = tmpvar_4.w;
  tmpvar_3 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize(xlv_TEXCOORD2);
  mediump vec3 viewDir_8;
  viewDir_8 = tmpvar_7;
  highp vec4 col_9;
  highp vec3 ramp_10;
  highp float rimLight_11;
  highp float difLight_12;
  lowp float tmpvar_13;
  tmpvar_13 = max (0.0, dot (xlv_TEXCOORD0, _WorldSpaceLightPos0.xyz));
  difLight_12 = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = max (0.0, dot (xlv_TEXCOORD0, viewDir_8));
  rimLight_11 = tmpvar_14;
  highp vec2 tmpvar_15;
  tmpvar_15.x = ((difLight_12 * 0.5) + 0.5);
  tmpvar_15.y = ((rimLight_11 * 0.5) + 0.5);
  lowp vec3 tmpvar_16;
  tmpvar_16 = texture2D (_RampTex, tmpvar_15).xyz;
  ramp_10 = tmpvar_16;
  col_9.xyz = ((tmpvar_2 * _LightColor0.xyz) * ramp_10);
  col_9.w = tmpvar_3;
  c_1 = col_9;
  c_1.xyz = (c_1.xyz + (tmpvar_2 * xlv_TEXCOORD1));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "VERTEXLIGHT_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 403
struct Input {
    highp vec2 uv_MainTex;
};
#line 426
struct v2f_surf {
    highp vec4 pos;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec3 viewDir;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform highp vec4 _EmissiveColor;
uniform highp vec4 _AmbientColor;
#line 401
uniform highp float _MySliderValue;
uniform sampler2D _RampTex;
#line 408
#line 435
#line 451
#line 96
highp vec3 Shade4PointLights( in highp vec4 lightPosX, in highp vec4 lightPosY, in highp vec4 lightPosZ, in highp vec3 lightColor0, in highp vec3 lightColor1, in highp vec3 lightColor2, in highp vec3 lightColor3, in highp vec4 lightAttenSq, in highp vec3 pos, in highp vec3 normal ) {
    highp vec4 toLightX = (lightPosX - pos.x);
    highp vec4 toLightY = (lightPosY - pos.y);
    #line 100
    highp vec4 toLightZ = (lightPosZ - pos.z);
    highp vec4 lengthSq = vec4( 0.0);
    lengthSq += (toLightX * toLightX);
    lengthSq += (toLightY * toLightY);
    #line 104
    lengthSq += (toLightZ * toLightZ);
    highp vec4 ndotl = vec4( 0.0);
    ndotl += (toLightX * normal.x);
    ndotl += (toLightY * normal.y);
    #line 108
    ndotl += (toLightZ * normal.z);
    highp vec4 corr = inversesqrt(lengthSq);
    ndotl = max( vec4( 0.0, 0.0, 0.0, 0.0), (ndotl * corr));
    highp vec4 atten = (1.0 / (1.0 + (lengthSq * lightAttenSq)));
    #line 112
    highp vec4 diff = (ndotl * atten);
    highp vec3 col = vec3( 0.0);
    col += (lightColor0 * diff.x);
    col += (lightColor1 * diff.y);
    #line 116
    col += (lightColor2 * diff.z);
    col += (lightColor3 * diff.w);
    return col;
}
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 87
highp vec3 WorldSpaceViewDir( in highp vec4 v ) {
    return (_WorldSpaceCameraPos.xyz - (_Object2World * v).xyz);
}
#line 435
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 439
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.normal = worldN;
    highp vec3 viewDirForLight = WorldSpaceViewDir( v.vertex);
    o.viewDir = viewDirForLight;
    #line 443
    highp vec3 shlight = ShadeSH9( vec4( worldN, 1.0));
    o.vlight = shlight;
    highp vec3 worldPos = (_Object2World * v.vertex).xyz;
    o.vlight += Shade4PointLights( unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0, unity_LightColor[0].xyz, unity_LightColor[1].xyz, unity_LightColor[2].xyz, unity_LightColor[3].xyz, unity_4LightAtten0, worldPos, worldN);
    #line 447
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    return o;
}

out lowp vec3 xlv_TEXCOORD0;
out lowp vec3 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.normal);
    xlv_TEXCOORD1 = vec3(xl_retval.vlight);
    xlv_TEXCOORD2 = vec3(xl_retval.viewDir);
    xlv_TEXCOORD3 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_shadow2D(mediump sampler2DShadow s, vec3 coord) { return texture (s, coord); }
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 403
struct Input {
    highp vec2 uv_MainTex;
};
#line 426
struct v2f_surf {
    highp vec4 pos;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec3 viewDir;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform highp vec4 _EmissiveColor;
uniform highp vec4 _AmbientColor;
#line 401
uniform highp float _MySliderValue;
uniform sampler2D _RampTex;
#line 408
#line 435
#line 451
#line 414
highp vec4 LightingBasicDiffuse( in SurfaceOutput s, in lowp vec3 lightDir, in mediump vec3 viewDir, in lowp float atten ) {
    #line 416
    highp float difLight = max( 0.0, dot( s.Normal, lightDir));
    highp float rimLight = max( 0.0, dot( s.Normal, viewDir));
    highp float dif_hLambert = ((difLight * 0.5) + 0.5);
    highp float rim_hLambert = ((rimLight * 0.5) + 0.5);
    #line 420
    highp vec3 ramp = texture( _RampTex, vec2( dif_hLambert, rim_hLambert)).xyz;
    highp vec4 col;
    col.xyz = ((s.Albedo * _LightColor0.xyz) * ramp);
    col.w = s.Alpha;
    #line 424
    return col;
}
#line 408
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec4 c = pow( (_EmissiveColor + _AmbientColor), vec4( _MySliderValue));
    o.Albedo = c.xyz;
    #line 412
    o.Alpha = c.w;
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    lowp float shadow = xll_shadow2D( _ShadowMapTexture, shadowCoord.xyz.xyz);
    shadow = (_LightShadowData.x + (shadow * (1.0 - _LightShadowData.x)));
    #line 397
    return shadow;
}
#line 451
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    #line 455
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    #line 459
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    surf( surfIN, o);
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    #line 463
    lowp vec4 c = vec4( 0.0);
    c = LightingBasicDiffuse( o, _WorldSpaceLightPos0.xyz, normalize(IN.viewDir), atten);
    c.xyz += (o.Albedo * IN.vlight);
    return c;
}
in lowp vec3 xlv_TEXCOORD0;
in lowp vec3 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.normal = vec3(xlv_TEXCOORD0);
    xlt_IN.vlight = vec3(xlv_TEXCOORD1);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD2);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

}
Program "fp" {
// Fragment combos: 4
//   opengl - ALU: 10 to 19, TEX: 1 to 2
//   d3d9 - ALU: 22 to 30, TEX: 1 to 2
//   d3d11 - ALU: 7 to 16, TEX: 1 to 2, FLOW: 1 to 1
//   d3d11_9x - ALU: 7 to 16, TEX: 1 to 2, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_EmissiveColor]
Vector 3 [_AmbientColor]
Float 4 [_MySliderValue]
SetTexture 0 [_RampTex] 2D
"!!ARBfp1.0
# 19 ALU, 1 TEX
PARAM c[6] = { program.local[0..4],
		{ 0, 0.5 } };
TEMP R0;
TEMP R1;
TEMP R2;
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[2];
DP3 R0.y, fragment.texcoord[0], R0;
DP3 R0.x, fragment.texcoord[0], c[0];
MAX R0.y, R0, c[5].x;
MAX R0.x, R0, c[5];
MOV R1, c[3];
ADD R1, R1, c[2];
POW R1.x, R1.x, c[4].x;
POW R1.z, R1.z, c[4].x;
POW R1.y, R1.y, c[4].x;
MAD R0.y, R0, c[5], c[5];
MAD R0.x, R0, c[5].y, c[5].y;
MUL R2.xyz, R1, c[1];
POW result.color.w, R1.w, c[4].x;
TEX R0.xyz, R0, texture[0], 2D;
MUL R0.xyz, R2, R0;
MAD result.color.xyz, R1, fragment.texcoord[1], R0;
END
# 19 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_EmissiveColor]
Vector 3 [_AmbientColor]
Float 4 [_MySliderValue]
SetTexture 0 [_RampTex] 2D
"ps_2_0
; 30 ALU, 1 TEX
dcl_2d s0
def c5, 0.00000000, 0.50000000, 0, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dp3_pp r0.x, t2, t2
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, t2
dp3_pp r1.x, t0, r0
max_pp r1.x, r1, c5
dp3_pp r0.x, t0, c0
max_pp r0.x, r0, c5
mad r0.y, r1.x, c5, c5
mad r0.x, r0, c5.y, c5.y
texld r1, r0, s0
mov r0, c2
add r2, c3, r0
pow r0.x, r2.x, c4.x
pow r3.w, r2.y, c4.x
mov r2.x, r0.x
pow r0.x, r2.z, c4.x
mov r2.z, r0.x
mov r2.y, r3.w
pow r0.w, r2.w, c4.x
mul_pp r3.xyz, r2, c1
mul r0.xyz, r3, r1
mad_pp r0.xyz, r2, t1, r0
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
ConstBuffer "$Globals" 96 // 84 used size, 6 vars
Vector 16 [_LightColor0] 4
Vector 48 [_EmissiveColor] 4
Vector 64 [_AmbientColor] 4
Float 80 [_MySliderValue]
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
SetTexture 0 [_RampTex] 2D 0
// 19 instructions, 3 temp regs, 0 temp arrays:
// ALU 16 float, 0 int, 0 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefieceddjhchphdgkkjlllmcnmcllagjnohnckcabaaaaaahmadaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcimacaaaaeaaaaaaakdaaaaaafjaaaaaeegiocaaa
aaaaaaaaagaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafkaaaaadaagabaaa
aaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaa
gcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacadaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaadaaaaaa
egbcbaaaadaaaaaaeeaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaah
hcaabaaaaaaaaaaaagaabaaaaaaaaaaaegbcbaaaadaaaaaabaaaaaahbcaabaaa
aaaaaaaaegbcbaaaabaaaaaaegacbaaaaaaaaaaadeaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaaaaadcaaaaajccaabaaaaaaaaaaaakaabaaa
aaaaaaaaabeaaaaaaaaaaadpabeaaaaaaaaaaadpbaaaaaaiecaabaaaaaaaaaaa
egbcbaaaabaaaaaaegiccaaaabaaaaaaaaaaaaaadeaaaaahecaabaaaaaaaaaaa
ckaabaaaaaaaaaaaabeaaaaaaaaaaaaadcaaaaajbcaabaaaaaaaaaaackaabaaa
aaaaaaaaabeaaaaaaaaaaadpabeaaaaaaaaaaadpefaaaaajpcaabaaaaaaaaaaa
egaabaaaaaaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaajpcaabaaa
abaaaaaaegiocaaaaaaaaaaaadaaaaaaegiocaaaaaaaaaaaaeaaaaaacpaaaaaf
pcaabaaaabaaaaaaegaobaaaabaaaaaadiaaaaaipcaabaaaabaaaaaaegaobaaa
abaaaaaaagiacaaaaaaaaaaaafaaaaaabjaaaaafpcaabaaaabaaaaaaegaobaaa
abaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaa
abaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegbcbaaaacaaaaaa
dgaaaaaficcabaaaaaaaaaaadkaabaaaabaaaaaadcaaaaajhccabaaaaaaaaaaa
egacbaaaacaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_EmissiveColor]
Vector 3 [_AmbientColor]
Float 4 [_MySliderValue]
SetTexture 0 [_RampTex] 2D
"agal_ps
c5 0.0 0.5 0.0 0.0
[bc]
bcaaaaaaaaaaabacacaaaaoeaeaaaaaaacaaaaoeaeaaaaaa dp3 r0.x, v2, v2
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaacaaaaoeaeaaaaaa mul r0.xyz, r0.x, v2
bcaaaaaaabaaabacaaaaaaoeaeaaaaaaaaaaaakeacaaaaaa dp3 r1.x, v0, r0.xyzz
ahaaaaaaabaaabacabaaaaaaacaaaaaaafaaaaoeabaaaaaa max r1.x, r1.x, c5
bcaaaaaaaaaaabacaaaaaaoeaeaaaaaaaaaaaaoeabaaaaaa dp3 r0.x, v0, c0
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaafaaaaoeabaaaaaa max r0.x, r0.x, c5
adaaaaaaaaaaacacabaaaaaaacaaaaaaafaaaaoeabaaaaaa mul r0.y, r1.x, c5
abaaaaaaaaaaacacaaaaaaffacaaaaaaafaaaaoeabaaaaaa add r0.y, r0.y, c5
adaaaaaaaaaaabacaaaaaaaaacaaaaaaafaaaaffabaaaaaa mul r0.x, r0.x, c5.y
abaaaaaaaaaaabacaaaaaaaaacaaaaaaafaaaaffabaaaaaa add r0.x, r0.x, c5.y
ciaaaaaaabaaapacaaaaaafeacaaaaaaaaaaaaaaafaababb tex r1, r0.xyyy, s0 <2d wrap linear point>
aaaaaaaaaaaaapacacaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0, c2
abaaaaaaacaaapacadaaaaoeabaaaaaaaaaaaaoeacaaaaaa add r2, c3, r0
alaaaaaaaaaaapacacaaaaaaacaaaaaaaeaaaaaaabaaaaaa pow r0, r2.x, c4.x
alaaaaaaadaaapacacaaaaffacaaaaaaaeaaaaaaabaaaaaa pow r3, r2.y, c4.x
aaaaaaaaacaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r2.x, r0.x
alaaaaaaaaaaapacacaaaakkacaaaaaaaeaaaaaaabaaaaaa pow r0, r2.z, c4.x
aaaaaaaaacaaaeacaaaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r2.z, r0.z
aaaaaaaaacaaacacadaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r2.y, r3.y
alaaaaaaaaaaapacacaaaappacaaaaaaaeaaaaaaabaaaaaa pow r0, r2.w, c4.x
adaaaaaaadaaahacacaaaakeacaaaaaaabaaaaoeabaaaaaa mul r3.xyz, r2.xyzz, c1
adaaaaaaaaaaahacadaaaakeacaaaaaaabaaaakeacaaaaaa mul r0.xyz, r3.xyzz, r1.xyzz
adaaaaaaabaaahacacaaaakeacaaaaaaabaaaaoeaeaaaaaa mul r1.xyz, r2.xyzz, v1
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
ConstBuffer "$Globals" 96 // 84 used size, 6 vars
Vector 16 [_LightColor0] 4
Vector 48 [_EmissiveColor] 4
Vector 64 [_AmbientColor] 4
Float 80 [_MySliderValue]
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
SetTexture 0 [_RampTex] 2D 0
// 19 instructions, 3 temp regs, 0 temp arrays:
// ALU 16 float, 0 int, 0 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedopbmkeajcnkkhcefocodnmcfnkafdpkhabaaaaaahmafaaaaaeaaaaaa
daaaaaaacmacaaaamaaeaaaaeiafaaaaebgpgodjpeabaaaapeabaaaaaaacpppp
kiabaaaaemaaaaaaadaaciaaaaaaemaaaaaaemaaabaaceaaaaaaemaaaaaaaaaa
aaaaabaaabaaaaaaaaaaaaaaaaaaadaaadaaabaaaaaaaaaaabaaaaaaabaaaeaa
aaaaaaaaaaacppppfbaaaaafafaaapkaaaaaaadpaaaaaaaaaaaaaaaaaaaaaaaa
bpaaaaacaaaaaaiaaaaachlabpaaaaacaaaaaaiaabaachlabpaaaaacaaaaaaia
acaachlabpaaaaacaaaaaajaaaaiapkaceaaaaacaaaachiaacaaoelaaiaaaaad
aaaacbiaaaaaoelaaaaaoeiaaeaaaaaeaaaaaciaaaaaaaiaafaaaakaafaaaaka
fiaaaaaeaaaaaciaaaaaaaiaaaaaffiaafaaaakaaiaaaaadaaaaceiaaaaaoela
aeaaoekaaeaaaaaeaaaaaiiaaaaakkiaafaaaakaafaaaakafiaaaaaeaaaaabia
aaaakkiaaaaappiaafaaaakaecaaaaadaaaaapiaaaaaoeiaaaaioekaabaaaaac
abaaapiaabaaoekaacaaaaadabaaapiaabaaoeiaacaaoekaapaaaaacacaaabia
abaaaaiaapaaaaacacaaaciaabaaffiaapaaaaacacaaaeiaabaakkiaapaaaaac
acaaaiiaabaappiaafaaaaadabaaapiaacaaoeiaadaaaakaaoaaaaacacaacbia
abaaaaiaaoaaaaacacaacciaabaaffiaaoaaaaacacaaceiaabaakkiaaoaaaaac
abaaciiaabaappiaafaaaaadadaaahiaacaaoeiaaaaaoekaafaaaaadacaachia
acaaoeiaabaaoelaaeaaaaaeabaachiaadaaoeiaaaaaoeiaacaaoeiaabaaaaac
aaaicpiaabaaoeiappppaaaafdeieefcimacaaaaeaaaaaaakdaaaaaafjaaaaae
egiocaaaaaaaaaaaagaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafkaaaaad
aagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaadhcbabaaa
abaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacadaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaa
adaaaaaaegbcbaaaadaaaaaaeeaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
diaaaaahhcaabaaaaaaaaaaaagaabaaaaaaaaaaaegbcbaaaadaaaaaabaaaaaah
bcaabaaaaaaaaaaaegbcbaaaabaaaaaaegacbaaaaaaaaaaadeaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaadcaaaaajccaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaaadpabeaaaaaaaaaaadpbaaaaaaiecaabaaa
aaaaaaaaegbcbaaaabaaaaaaegiccaaaabaaaaaaaaaaaaaadeaaaaahecaabaaa
aaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaaaadcaaaaajbcaabaaaaaaaaaaa
ckaabaaaaaaaaaaaabeaaaaaaaaaaadpabeaaaaaaaaaaadpefaaaaajpcaabaaa
aaaaaaaaegaabaaaaaaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaaj
pcaabaaaabaaaaaaegiocaaaaaaaaaaaadaaaaaaegiocaaaaaaaaaaaaeaaaaaa
cpaaaaafpcaabaaaabaaaaaaegaobaaaabaaaaaadiaaaaaipcaabaaaabaaaaaa
egaobaaaabaaaaaaagiacaaaaaaaaaaaafaaaaaabjaaaaafpcaabaaaabaaaaaa
egaobaaaabaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaabaaaaaaegiccaaa
aaaaaaaaabaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegbcbaaa
acaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaabaaaaaadcaaaaajhccabaaa
aaaaaaaaegacbaaaacaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab
ejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahahaaaa
heaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaaheaaaaaaacaaaaaa
aaaaaaaaadaaaaaaadaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_EmissiveColor]
Vector 1 [_AmbientColor]
Float 2 [_MySliderValue]
SetTexture 0 [unity_Lightmap] 2D
"!!ARBfp1.0
# 10 ALU, 1 TEX
PARAM c[4] = { program.local[0..2],
		{ 8 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MOV R1, c[1];
ADD R1, R1, c[0];
MUL R0.xyz, R0.w, R0;
POW R1.x, R1.x, c[2].x;
POW R1.z, R1.z, c[2].x;
POW R1.y, R1.y, c[2].x;
MUL R0.xyz, R0, R1;
MUL result.color.xyz, R0, c[3].x;
POW result.color.w, R1.w, c[2].x;
END
# 10 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_EmissiveColor]
Vector 1 [_AmbientColor]
Float 2 [_MySliderValue]
SetTexture 0 [unity_Lightmap] 2D
"ps_2_0
; 22 ALU, 1 TEX
dcl_2d s0
def c3, 8.00000000, 0, 0, 0
dcl t0.xy
texld r0, t0, s0
mov r1, c0
add r2, c1, r1
pow r3.x, r2.x, c2.x
mov r2.x, r3.x
pow r3.x, r2.y, c2.x
pow r1.w, r2.w, c2.x
mul_pp r1.xyz, r0.w, r0
pow r0.w, r2.z, c2.x
mov r2.z, r0.w
mov r2.y, r3.x
mul_pp r0.xyz, r1, r2
mul_pp r0.xyz, r0, c3.x
mov r0.w, r1
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
ConstBuffer "$Globals" 112 // 84 used size, 7 vars
Vector 48 [_EmissiveColor] 4
Vector 64 [_AmbientColor] 4
Float 80 [_MySliderValue]
BindCB "$Globals" 0
SetTexture 0 [unity_Lightmap] 2D 0
// 10 instructions, 2 temp regs, 0 temp arrays:
// ALU 7 float, 0 int, 0 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedcnedkeefkmmookachalmlhmopihglmdnabaaaaaabaacaaaaadaaaaaa
cmaaaaaaieaaaaaaliaaaaaaejfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcfaabaaaa
eaaaaaaafeaaaaaafjaaaaaeegiocaaaaaaaaaaaagaaaaaafkaaaaadaagabaaa
aaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaaaaaaaaaa
egacbaaaaaaaaaaapgapbaaaaaaaaaaaaaaaaaajpcaabaaaabaaaaaaegiocaaa
aaaaaaaaadaaaaaaegiocaaaaaaaaaaaaeaaaaaacpaaaaafpcaabaaaabaaaaaa
egaobaaaabaaaaaadiaaaaaipcaabaaaabaaaaaaegaobaaaabaaaaaaagiacaaa
aaaaaaaaafaaaaaabjaaaaafpcaabaaaabaaaaaaegaobaaaabaaaaaadiaaaaah
hccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaa
aaaaaaaadkaabaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_EmissiveColor]
Vector 1 [_AmbientColor]
Float 2 [_MySliderValue]
SetTexture 0 [unity_Lightmap] 2D
"agal_ps
c3 8.0 0.0 0.0 0.0
[bc]
ciaaaaaaaaaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r0, v0, s0 <2d wrap linear point>
aaaaaaaaabaaapacaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1, c0
abaaaaaaacaaapacabaaaaoeabaaaaaaabaaaaoeacaaaaaa add r2, c1, r1
alaaaaaaadaaapacacaaaaaaacaaaaaaacaaaaaaabaaaaaa pow r3, r2.x, c2.x
aaaaaaaaacaaabacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r2.x, r3.x
alaaaaaaadaaapacacaaaaffacaaaaaaacaaaaaaabaaaaaa pow r3, r2.y, c2.x
alaaaaaaabaaapacacaaaappacaaaaaaacaaaaaaabaaaaaa pow r1, r2.w, c2.x
adaaaaaaabaaahacaaaaaappacaaaaaaaaaaaakeacaaaaaa mul r1.xyz, r0.w, r0.xyzz
alaaaaaaaaaaapacacaaaakkacaaaaaaacaaaaaaabaaaaaa pow r0, r2.z, c2.x
aaaaaaaaacaaaeacaaaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r2.z, r0.z
aaaaaaaaacaaacacadaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r2.y, r3.y
adaaaaaaaaaaahacabaaaakeacaaaaaaacaaaakeacaaaaaa mul r0.xyz, r1.xyzz, r2.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaadaaaaaaabaaaaaa mul r0.xyz, r0.xyzz, c3.x
aaaaaaaaaaaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.w, r1.w
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
ConstBuffer "$Globals" 112 // 84 used size, 7 vars
Vector 48 [_EmissiveColor] 4
Vector 64 [_AmbientColor] 4
Float 80 [_MySliderValue]
BindCB "$Globals" 0
SetTexture 0 [unity_Lightmap] 2D 0
// 10 instructions, 2 temp regs, 0 temp arrays:
// ALU 7 float, 0 int, 0 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedejdinbabahmpfkbmobkejefbdnaanddfabaaaaaagaadaaaaaeaaaaaa
daaaaaaahmabaaaaneacaaaacmadaaaaebgpgodjeeabaaaaeeabaaaaaaacpppp
baabaaaadeaaaaaaabaaciaaaaaadeaaaaaadeaaabaaceaaaaaadeaaaaaaaaaa
aaaaadaaadaaaaaaaaaaaaaaaaacppppfbaaaaafadaaapkaaaaaaaebaaaaaaaa
aaaaaaaaaaaaaaaabpaaaaacaaaaaaiaaaaaadlabpaaaaacaaaaaajaaaaiapka
ecaaaaadaaaacpiaaaaaoelaaaaioekaafaaaaadaaaaciiaaaaappiaadaaaaka
afaaaaadaaaachiaaaaaoeiaaaaappiaabaaaaacabaaapiaaaaaoekaacaaaaad
abaaapiaabaaoeiaabaaoekaapaaaaacacaaabiaabaaaaiaapaaaaacacaaacia
abaaffiaapaaaaacacaaaeiaabaakkiaapaaaaacacaaaiiaabaappiaafaaaaad
abaaapiaacaaoeiaacaaaakaaoaaaaacacaacbiaabaaaaiaaoaaaaacacaaccia
abaaffiaaoaaaaacacaaceiaabaakkiaaoaaaaacabaaciiaabaappiaafaaaaad
abaachiaaaaaoeiaacaaoeiaabaaaaacaaaicpiaabaaoeiappppaaaafdeieefc
faabaaaaeaaaaaaafeaaaaaafjaaaaaeegiocaaaaaaaaaaaagaaaaaafkaaaaad
aagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaaddcbabaaa
abaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaaefaaaaajpcaabaaa
aaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaaaaaaaaajpcaabaaaabaaaaaa
egiocaaaaaaaaaaaadaaaaaaegiocaaaaaaaaaaaaeaaaaaacpaaaaafpcaabaaa
abaaaaaaegaobaaaabaaaaaadiaaaaaipcaabaaaabaaaaaaegaobaaaabaaaaaa
agiacaaaaaaaaaaaafaaaaaabjaaaaafpcaabaaaabaaaaaaegaobaaaabaaaaaa
diaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaf
iccabaaaaaaaaaaadkaabaaaabaaaaaadoaaaaabejfdeheofaaaaaaaacaaaaaa
aiaaaaaadiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_EmissiveColor]
Vector 3 [_AmbientColor]
Float 4 [_MySliderValue]
SetTexture 0 [_RampTex] 2D
"!!ARBfp1.0
# 19 ALU, 1 TEX
PARAM c[6] = { program.local[0..4],
		{ 0, 0.5 } };
TEMP R0;
TEMP R1;
TEMP R2;
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[2];
DP3 R0.y, fragment.texcoord[0], R0;
DP3 R0.x, fragment.texcoord[0], c[0];
MAX R0.y, R0, c[5].x;
MAX R0.x, R0, c[5];
MOV R1, c[3];
ADD R1, R1, c[2];
POW R1.x, R1.x, c[4].x;
POW R1.z, R1.z, c[4].x;
POW R1.y, R1.y, c[4].x;
MAD R0.y, R0, c[5], c[5];
MAD R0.x, R0, c[5].y, c[5].y;
MUL R2.xyz, R1, c[1];
POW result.color.w, R1.w, c[4].x;
TEX R0.xyz, R0, texture[0], 2D;
MUL R0.xyz, R2, R0;
MAD result.color.xyz, R1, fragment.texcoord[1], R0;
END
# 19 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_EmissiveColor]
Vector 3 [_AmbientColor]
Float 4 [_MySliderValue]
SetTexture 0 [_RampTex] 2D
"ps_2_0
; 30 ALU, 1 TEX
dcl_2d s0
def c5, 0.00000000, 0.50000000, 0, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dp3_pp r0.x, t2, t2
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, t2
dp3_pp r1.x, t0, r0
max_pp r1.x, r1, c5
dp3_pp r0.x, t0, c0
max_pp r0.x, r0, c5
mad r0.y, r1.x, c5, c5
mad r0.x, r0, c5.y, c5.y
texld r1, r0, s0
mov r0, c2
add r2, c3, r0
pow r0.x, r2.x, c4.x
pow r3.w, r2.y, c4.x
mov r2.x, r0.x
pow r0.x, r2.z, c4.x
mov r2.z, r0.x
mov r2.y, r3.w
pow r0.w, r2.w, c4.x
mul_pp r3.xyz, r2, c1
mul r0.xyz, r3, r1
mad_pp r0.xyz, r2, t1, r0
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
ConstBuffer "$Globals" 160 // 148 used size, 7 vars
Vector 16 [_LightColor0] 4
Vector 112 [_EmissiveColor] 4
Vector 128 [_AmbientColor] 4
Float 144 [_MySliderValue]
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
SetTexture 0 [_RampTex] 2D 0
// 19 instructions, 3 temp regs, 0 temp arrays:
// ALU 16 float, 0 int, 0 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedgpcogcilnojdigpffggdpnjhhknfdjfcabaaaaaajeadaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcimacaaaaeaaaaaaakdaaaaaafjaaaaaeegiocaaaaaaaaaaaakaaaaaa
fjaaaaaeegiocaaaabaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
adaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaadaaaaaaegbcbaaaadaaaaaa
eeaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaa
agaabaaaaaaaaaaaegbcbaaaadaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaa
abaaaaaaegacbaaaaaaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
abeaaaaaaaaaaaaadcaaaaajccaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaadpabeaaaaaaaaaaadpbaaaaaaiecaabaaaaaaaaaaaegbcbaaaabaaaaaa
egiccaaaabaaaaaaaaaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaa
abeaaaaaaaaaaaaadcaaaaajbcaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaa
aaaaaadpabeaaaaaaaaaaadpefaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaajpcaabaaaabaaaaaaegiocaaa
aaaaaaaaahaaaaaaegiocaaaaaaaaaaaaiaaaaaacpaaaaafpcaabaaaabaaaaaa
egaobaaaabaaaaaadiaaaaaipcaabaaaabaaaaaaegaobaaaabaaaaaaagiacaaa
aaaaaaaaajaaaaaabjaaaaafpcaabaaaabaaaaaaegaobaaaabaaaaaadiaaaaai
hcaabaaaacaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaah
hcaabaaaabaaaaaaegacbaaaabaaaaaaegbcbaaaacaaaaaadgaaaaaficcabaaa
aaaaaaaadkaabaaaabaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaaacaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_EmissiveColor]
Vector 3 [_AmbientColor]
Float 4 [_MySliderValue]
SetTexture 0 [_RampTex] 2D
"agal_ps
c5 0.0 0.5 0.0 0.0
[bc]
bcaaaaaaaaaaabacacaaaaoeaeaaaaaaacaaaaoeaeaaaaaa dp3 r0.x, v2, v2
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaacaaaaoeaeaaaaaa mul r0.xyz, r0.x, v2
bcaaaaaaabaaabacaaaaaaoeaeaaaaaaaaaaaakeacaaaaaa dp3 r1.x, v0, r0.xyzz
ahaaaaaaabaaabacabaaaaaaacaaaaaaafaaaaoeabaaaaaa max r1.x, r1.x, c5
bcaaaaaaaaaaabacaaaaaaoeaeaaaaaaaaaaaaoeabaaaaaa dp3 r0.x, v0, c0
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaafaaaaoeabaaaaaa max r0.x, r0.x, c5
adaaaaaaaaaaacacabaaaaaaacaaaaaaafaaaaoeabaaaaaa mul r0.y, r1.x, c5
abaaaaaaaaaaacacaaaaaaffacaaaaaaafaaaaoeabaaaaaa add r0.y, r0.y, c5
adaaaaaaaaaaabacaaaaaaaaacaaaaaaafaaaaffabaaaaaa mul r0.x, r0.x, c5.y
abaaaaaaaaaaabacaaaaaaaaacaaaaaaafaaaaffabaaaaaa add r0.x, r0.x, c5.y
ciaaaaaaabaaapacaaaaaafeacaaaaaaaaaaaaaaafaababb tex r1, r0.xyyy, s0 <2d wrap linear point>
aaaaaaaaaaaaapacacaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0, c2
abaaaaaaacaaapacadaaaaoeabaaaaaaaaaaaaoeacaaaaaa add r2, c3, r0
alaaaaaaaaaaapacacaaaaaaacaaaaaaaeaaaaaaabaaaaaa pow r0, r2.x, c4.x
alaaaaaaadaaapacacaaaaffacaaaaaaaeaaaaaaabaaaaaa pow r3, r2.y, c4.x
aaaaaaaaacaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r2.x, r0.x
alaaaaaaaaaaapacacaaaakkacaaaaaaaeaaaaaaabaaaaaa pow r0, r2.z, c4.x
aaaaaaaaacaaaeacaaaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r2.z, r0.z
aaaaaaaaacaaacacadaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r2.y, r3.y
alaaaaaaaaaaapacacaaaappacaaaaaaaeaaaaaaabaaaaaa pow r0, r2.w, c4.x
adaaaaaaadaaahacacaaaakeacaaaaaaabaaaaoeabaaaaaa mul r3.xyz, r2.xyzz, c1
adaaaaaaaaaaahacadaaaakeacaaaaaaabaaaakeacaaaaaa mul r0.xyz, r3.xyzz, r1.xyzz
adaaaaaaabaaahacacaaaakeacaaaaaaabaaaaoeaeaaaaaa mul r1.xyz, r2.xyzz, v1
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
ConstBuffer "$Globals" 160 // 148 used size, 7 vars
Vector 16 [_LightColor0] 4
Vector 112 [_EmissiveColor] 4
Vector 128 [_AmbientColor] 4
Float 144 [_MySliderValue]
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
SetTexture 0 [_RampTex] 2D 0
// 19 instructions, 3 temp regs, 0 temp arrays:
// ALU 16 float, 0 int, 0 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecediikfgmohifggcmigiagjdkkncbepclonabaaaaaajeafaaaaaeaaaaaa
daaaaaaacmacaaaamaaeaaaagaafaaaaebgpgodjpeabaaaapeabaaaaaaacpppp
kiabaaaaemaaaaaaadaaciaaaaaaemaaaaaaemaaabaaceaaaaaaemaaaaaaaaaa
aaaaabaaabaaaaaaaaaaaaaaaaaaahaaadaaabaaaaaaaaaaabaaaaaaabaaaeaa
aaaaaaaaaaacppppfbaaaaafafaaapkaaaaaaadpaaaaaaaaaaaaaaaaaaaaaaaa
bpaaaaacaaaaaaiaaaaachlabpaaaaacaaaaaaiaabaachlabpaaaaacaaaaaaia
acaachlabpaaaaacaaaaaajaaaaiapkaceaaaaacaaaachiaacaaoelaaiaaaaad
aaaacbiaaaaaoelaaaaaoeiaaeaaaaaeaaaaaciaaaaaaaiaafaaaakaafaaaaka
fiaaaaaeaaaaaciaaaaaaaiaaaaaffiaafaaaakaaiaaaaadaaaaceiaaaaaoela
aeaaoekaaeaaaaaeaaaaaiiaaaaakkiaafaaaakaafaaaakafiaaaaaeaaaaabia
aaaakkiaaaaappiaafaaaakaecaaaaadaaaaapiaaaaaoeiaaaaioekaabaaaaac
abaaapiaabaaoekaacaaaaadabaaapiaabaaoeiaacaaoekaapaaaaacacaaabia
abaaaaiaapaaaaacacaaaciaabaaffiaapaaaaacacaaaeiaabaakkiaapaaaaac
acaaaiiaabaappiaafaaaaadabaaapiaacaaoeiaadaaaakaaoaaaaacacaacbia
abaaaaiaaoaaaaacacaacciaabaaffiaaoaaaaacacaaceiaabaakkiaaoaaaaac
abaaciiaabaappiaafaaaaadadaaahiaacaaoeiaaaaaoekaafaaaaadacaachia
acaaoeiaabaaoelaaeaaaaaeabaachiaadaaoeiaaaaaoeiaacaaoeiaabaaaaac
aaaicpiaabaaoeiappppaaaafdeieefcimacaaaaeaaaaaaakdaaaaaafjaaaaae
egiocaaaaaaaaaaaakaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafkaaaaad
aagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaadhcbabaaa
abaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacadaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaa
adaaaaaaegbcbaaaadaaaaaaeeaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
diaaaaahhcaabaaaaaaaaaaaagaabaaaaaaaaaaaegbcbaaaadaaaaaabaaaaaah
bcaabaaaaaaaaaaaegbcbaaaabaaaaaaegacbaaaaaaaaaaadeaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaadcaaaaajccaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaaadpabeaaaaaaaaaaadpbaaaaaaiecaabaaa
aaaaaaaaegbcbaaaabaaaaaaegiccaaaabaaaaaaaaaaaaaadeaaaaahecaabaaa
aaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaaaadcaaaaajbcaabaaaaaaaaaaa
ckaabaaaaaaaaaaaabeaaaaaaaaaaadpabeaaaaaaaaaaadpefaaaaajpcaabaaa
aaaaaaaaegaabaaaaaaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaaj
pcaabaaaabaaaaaaegiocaaaaaaaaaaaahaaaaaaegiocaaaaaaaaaaaaiaaaaaa
cpaaaaafpcaabaaaabaaaaaaegaobaaaabaaaaaadiaaaaaipcaabaaaabaaaaaa
egaobaaaabaaaaaaagiacaaaaaaaaaaaajaaaaaabjaaaaafpcaabaaaabaaaaaa
egaobaaaabaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaabaaaaaaegiccaaa
aaaaaaaaabaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegbcbaaa
acaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaabaaaaaadcaaaaajhccabaaa
aaaaaaaaegacbaaaacaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab
ejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahahaaaa
imaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaaimaaaaaaacaaaaaa
aaaaaaaaadaaaaaaadaaaaaaahahaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
epfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_EmissiveColor]
Vector 1 [_AmbientColor]
Float 2 [_MySliderValue]
SetTexture 0 [_ShadowMapTexture] 2D
SetTexture 1 [unity_Lightmap] 2D
"!!ARBfp1.0
# 16 ALU, 2 TEX
PARAM c[4] = { program.local[0..2],
		{ 8, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[1], 2D;
TXP R1.x, fragment.texcoord[1], texture[0], 2D;
MUL R1.yzw, R0.w, R0.xxyz;
MUL R2.xyz, R0, R1.x;
MUL R0.xyz, R2, c[3].y;
MUL R1.yzw, R1, c[3].x;
MIN R2.xyz, R1.yzww, R0;
MOV R0, c[1];
ADD R0, R0, c[0];
MUL R1.xyz, R1.yzww, R1.x;
MAX R1.xyz, R2, R1;
POW R0.x, R0.x, c[2].x;
POW R0.y, R0.y, c[2].x;
POW R0.z, R0.z, c[2].x;
MUL result.color.xyz, R0, R1;
POW result.color.w, R0.w, c[2].x;
END
# 16 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_EmissiveColor]
Vector 1 [_AmbientColor]
Float 2 [_MySliderValue]
SetTexture 0 [_ShadowMapTexture] 2D
SetTexture 1 [unity_Lightmap] 2D
"ps_2_0
; 27 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c3, 8.00000000, 2.00000000, 0, 0
dcl t0.xy
dcl t1
texldp r3, t1, s0
texld r1, t0, s1
mul_pp r0.xyz, r1, r3.x
mul_pp r1.xyz, r1.w, r1
mul_pp r2.xyz, r1, c3.x
mul_pp r0.xyz, r0, c3.y
min_pp r0.xyz, r2, r0
mul_pp r2.xyz, r2, r3.x
mov r1, c0
add r1, c1, r1
max_pp r2.xyz, r0, r2
pow r0.x, r1.x, c2.x
mov r1.x, r0.x
pow r0.x, r1.y, c2.x
pow r4.x, r1.z, c2.x
pow r3.x, r1.w, c2.x
mov r1.y, r0.x
mov r1.z, r4.x
mul_pp r0.xyz, r1, r2
mov r0.w, r3.x
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
ConstBuffer "$Globals" 176 // 148 used size, 8 vars
Vector 112 [_EmissiveColor] 4
Vector 128 [_AmbientColor] 4
Float 144 [_MySliderValue]
BindCB "$Globals" 0
SetTexture 0 [_ShadowMapTexture] 2D 0
SetTexture 1 [unity_Lightmap] 2D 1
// 17 instructions, 2 temp regs, 0 temp arrays:
// ALU 13 float, 0 int, 0 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedppfebdmpphfididikljklofnmpnhfoleabaaaaaabmadaaaaadaaaaaa
cmaaaaaajmaaaaaanaaaaaaaejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefceeacaaaaeaaaaaaajbaaaaaa
fjaaaaaeegiocaaaaaaaaaaaakaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadlcbabaaaacaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaaaoaaaaahdcaabaaaaaaaaaaa
egbabaaaacaaaaaapgbpbaaaacaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaa
aaaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaahccaabaaaaaaaaaaa
akaabaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
abaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaadiaaaaahocaabaaaaaaaaaaa
fgafbaaaaaaaaaaaagajbaaaabaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaa
abaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaa
pgapbaaaabaaaaaaddaaaaahocaabaaaaaaaaaaafgaobaaaaaaaaaaaagajbaaa
abaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaa
deaaaaahhcaabaaaaaaaaaaajgahbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaaj
pcaabaaaabaaaaaaegiocaaaaaaaaaaaahaaaaaaegiocaaaaaaaaaaaaiaaaaaa
cpaaaaafpcaabaaaabaaaaaaegaobaaaabaaaaaadiaaaaaipcaabaaaabaaaaaa
egaobaaaabaaaaaaagiacaaaaaaaaaaaajaaaaaabjaaaaafpcaabaaaabaaaaaa
egaobaaaabaaaaaadiaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_EmissiveColor]
Vector 1 [_AmbientColor]
Float 2 [_MySliderValue]
SetTexture 0 [_ShadowMapTexture] 2D
SetTexture 1 [unity_Lightmap] 2D
"agal_ps
c3 8.0 2.0 0.0 0.0
[bc]
aeaaaaaaaaaaapacabaaaaoeaeaaaaaaabaaaappaeaaaaaa div r0, v1, v1.w
ciaaaaaaadaaapacaaaaaafeacaaaaaaaaaaaaaaafaababb tex r3, r0.xyyy, s0 <2d wrap linear point>
ciaaaaaaabaaapacaaaaaaoeaeaaaaaaabaaaaaaafaababb tex r1, v0, s1 <2d wrap linear point>
adaaaaaaaaaaahacabaaaakeacaaaaaaadaaaaaaacaaaaaa mul r0.xyz, r1.xyzz, r3.x
adaaaaaaabaaahacabaaaappacaaaaaaabaaaakeacaaaaaa mul r1.xyz, r1.w, r1.xyzz
adaaaaaaacaaahacabaaaakeacaaaaaaadaaaaaaabaaaaaa mul r2.xyz, r1.xyzz, c3.x
adaaaaaaaaaaahacaaaaaakeacaaaaaaadaaaaffabaaaaaa mul r0.xyz, r0.xyzz, c3.y
agaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa min r0.xyz, r2.xyzz, r0.xyzz
adaaaaaaacaaahacacaaaakeacaaaaaaadaaaaaaacaaaaaa mul r2.xyz, r2.xyzz, r3.x
aaaaaaaaabaaapacaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1, c0
abaaaaaaabaaapacabaaaaoeabaaaaaaabaaaaoeacaaaaaa add r1, c1, r1
ahaaaaaaacaaahacaaaaaakeacaaaaaaacaaaakeacaaaaaa max r2.xyz, r0.xyzz, r2.xyzz
alaaaaaaaaaaapacabaaaaaaacaaaaaaacaaaaaaabaaaaaa pow r0, r1.x, c2.x
aaaaaaaaabaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r0.x
alaaaaaaaaaaapacabaaaaffacaaaaaaacaaaaaaabaaaaaa pow r0, r1.y, c2.x
alaaaaaaaeaaapacabaaaakkacaaaaaaacaaaaaaabaaaaaa pow r4, r1.z, c2.x
alaaaaaaadaaapacabaaaappacaaaaaaacaaaaaaabaaaaaa pow r3, r1.w, c2.x
aaaaaaaaabaaacacaaaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r1.y, r0.y
aaaaaaaaabaaaeacaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r1.z, r4.z
adaaaaaaaaaaahacabaaaakeacaaaaaaacaaaakeacaaaaaa mul r0.xyz, r1.xyzz, r2.xyzz
aaaaaaaaaaaaaiacadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.w, r3.w
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
ConstBuffer "$Globals" 176 // 148 used size, 8 vars
Vector 112 [_EmissiveColor] 4
Vector 128 [_AmbientColor] 4
Float 144 [_MySliderValue]
BindCB "$Globals" 0
SetTexture 0 [_ShadowMapTexture] 2D 0
SetTexture 1 [unity_Lightmap] 2D 1
// 17 instructions, 2 temp regs, 0 temp arrays:
// ALU 13 float, 0 int, 0 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedngchjloencdiamfnloljpodinobnabekabaaaaaaaeafaaaaaeaaaaaa
daaaaaaabeacaaaagaaeaaaanaaeaaaaebgpgodjnmabaaaanmabaaaaaaacpppp
keabaaaadiaaaaaaabaacmaaaaaadiaaaaaadiaaacaaceaaaaaadiaaaaaaaaaa
abababaaaaaaahaaadaaaaaaaaaaaaaaaaacppppfbaaaaafadaaapkaaaaaaaeb
aaaaaaaaaaaaaaaaaaaaaaaabpaaaaacaaaaaaiaaaaaadlabpaaaaacaaaaaaia
abaaaplabpaaaaacaaaaaajaaaaiapkabpaaaaacaaaaaajaabaiapkaagaaaaac
aaaaaiiaabaapplaafaaaaadaaaaadiaaaaappiaabaaoelaecaaaaadaaaacpia
aaaaoeiaaaaioekaecaaaaadabaacpiaaaaaoelaabaioekaacaaaaadaaaaccia
aaaaaaiaaaaaaaiaafaaaaadaaaacoiaabaabliaaaaaffiaafaaaaadabaaciia
abaappiaadaaaakaafaaaaadabaachiaabaaoeiaabaappiaakaaaaadacaachia
aaaabliaabaaoeiaafaaaaadaaaachiaaaaaaaiaabaaoeiaalaaaaadabaachia
acaaoeiaaaaaoeiaabaaaaacaaaaapiaaaaaoekaacaaaaadaaaaapiaaaaaoeia
abaaoekaapaaaaacacaaabiaaaaaaaiaapaaaaacacaaaciaaaaaffiaapaaaaac
acaaaeiaaaaakkiaapaaaaacacaaaiiaaaaappiaafaaaaadaaaaapiaacaaoeia
acaaaakaaoaaaaacacaacbiaaaaaaaiaaoaaaaacacaacciaaaaaffiaaoaaaaac
acaaceiaaaaakkiaaoaaaaacaaaaciiaaaaappiaafaaaaadaaaachiaabaaoeia
acaaoeiaabaaaaacaaaicpiaaaaaoeiappppaaaafdeieefceeacaaaaeaaaaaaa
jbaaaaaafjaaaaaeegiocaaaaaaaaaaaakaaaaaafkaaaaadaagabaaaaaaaaaaa
fkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadlcbabaaa
acaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaaaoaaaaahdcaabaaa
aaaaaaaaegbabaaaacaaaaaapgbpbaaaacaaaaaaefaaaaajpcaabaaaaaaaaaaa
egaabaaaaaaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaahccaabaaa
aaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaa
egbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaadiaaaaahocaabaaa
aaaaaaaafgafbaaaaaaaaaaaagajbaaaabaaaaaadiaaaaahicaabaaaabaaaaaa
dkaabaaaabaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaaabaaaaaaegacbaaa
abaaaaaapgapbaaaabaaaaaaddaaaaahocaabaaaaaaaaaaafgaobaaaaaaaaaaa
agajbaaaabaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaaaaaaaaaaegacbaaa
abaaaaaadeaaaaahhcaabaaaaaaaaaaajgahbaaaaaaaaaaaegacbaaaabaaaaaa
aaaaaaajpcaabaaaabaaaaaaegiocaaaaaaaaaaaahaaaaaaegiocaaaaaaaaaaa
aiaaaaaacpaaaaafpcaabaaaabaaaaaaegaobaaaabaaaaaadiaaaaaipcaabaaa
abaaaaaaegaobaaaabaaaaaaagiacaaaaaaaaaaaajaaaaaabjaaaaafpcaabaaa
abaaaaaaegaobaaaabaaaaaadiaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaabaaaaaadoaaaaab
ejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaa
fmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaapalaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaa
caaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgf
heaaklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES3"
}

}
	}
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardAdd" }
		ZWrite Off Blend One One Fog { Color (0,0,0,0) }
Program "vp" {
// Vertex combos: 5
//   opengl - ALU: 13 to 18
//   d3d9 - ALU: 13 to 18
//   d3d11 - ALU: 13 to 22, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 13 to 22, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Vector 15 [unity_Scale]
Matrix 9 [_LightMatrix0]
"!!ARBvp1.0
# 17 ALU
PARAM c[16] = { program.local[0],
		state.matrix.mvp,
		program.local[5..15] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[15].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[3].z, R0, c[11];
DP4 result.texcoord[3].y, R0, c[10];
DP4 result.texcoord[3].x, R0, c[9];
DP3 result.texcoord[0].z, R1, c[7];
DP3 result.texcoord[0].y, R1, c[6];
DP3 result.texcoord[0].x, R1, c[5];
ADD result.texcoord[1].xyz, -R0, c[14];
ADD result.texcoord[2].xyz, -R0, c[13];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 17 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 14 [unity_Scale]
Matrix 8 [_LightMatrix0]
"vs_2_0
; 17 ALU
dcl_position0 v0
dcl_normal0 v1
mul r1.xyz, v1, c14.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 oT3.z, r0, c10
dp4 oT3.y, r0, c9
dp4 oT3.x, r0, c8
dp3 oT0.z, r1, c6
dp3 oT0.y, r1, c5
dp3 oT0.x, r1, c4
add oT1.xyz, -r0, c13
add oT2.xyz, -r0, c12
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "$Globals" 160 // 112 used size, 7 vars
Matrix 48 [_LightMatrix0] 4
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 23 instructions, 2 temp regs, 0 temp arrays:
// ALU 22 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedkpdpikmmhibdaldmjhldhblcnnenakepabaaaaaaiaafaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcoeadaaaaeaaaabaa
pjaaaaaafjaaaaaeegiocaaaaaaaaaaaahaaaaaafjaaaaaeegiocaaaabaaaaaa
afaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagiaaaaac
acaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
hcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaai
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
lcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaa
abaaaaaadcaaaaakhccabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaa
aaaaaaaaegadbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaaaaaaaaajhccabaaaacaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaa
acaaaaaaaaaaaaaaaaaaaaajhccabaaaadaaaaaaegacbaiaebaaaaaaaaaaaaaa
egiccaaaabaaaaaaaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaadaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
amaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaa
aeaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaaagaabaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaaaaaaaa
afaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaaeaaaaaa
egiccaaaaaaaaaaaagaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "POINT" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform sampler2D _RampTex;
uniform highp float _MySliderValue;
uniform highp vec4 _AmbientColor;
uniform highp vec4 _EmissiveColor;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = pow ((_EmissiveColor + _AmbientColor), vec4(_MySliderValue));
  highp vec3 tmpvar_6;
  tmpvar_6 = tmpvar_5.xyz;
  tmpvar_3 = tmpvar_6;
  highp float tmpvar_7;
  tmpvar_7 = tmpvar_5.w;
  tmpvar_4 = tmpvar_7;
  mediump vec3 tmpvar_8;
  tmpvar_8 = normalize(xlv_TEXCOORD1);
  lightDir_2 = tmpvar_8;
  highp vec4 col_9;
  highp vec3 ramp_10;
  highp float rimLight_11;
  highp float difLight_12;
  lowp float tmpvar_13;
  tmpvar_13 = max (0.0, dot (xlv_TEXCOORD0, lightDir_2));
  difLight_12 = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = max (0.0, dot (xlv_TEXCOORD0, normalize(xlv_TEXCOORD2)));
  rimLight_11 = tmpvar_14;
  highp vec2 tmpvar_15;
  tmpvar_15.x = ((difLight_12 * 0.5) + 0.5);
  tmpvar_15.y = ((rimLight_11 * 0.5) + 0.5);
  lowp vec3 tmpvar_16;
  tmpvar_16 = texture2D (_RampTex, tmpvar_15).xyz;
  ramp_10 = tmpvar_16;
  col_9.xyz = ((tmpvar_3 * _LightColor0.xyz) * ramp_10);
  col_9.w = tmpvar_4;
  c_1.xyz = col_9.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "POINT" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform sampler2D _RampTex;
uniform highp float _MySliderValue;
uniform highp vec4 _AmbientColor;
uniform highp vec4 _EmissiveColor;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = pow ((_EmissiveColor + _AmbientColor), vec4(_MySliderValue));
  highp vec3 tmpvar_6;
  tmpvar_6 = tmpvar_5.xyz;
  tmpvar_3 = tmpvar_6;
  highp float tmpvar_7;
  tmpvar_7 = tmpvar_5.w;
  tmpvar_4 = tmpvar_7;
  mediump vec3 tmpvar_8;
  tmpvar_8 = normalize(xlv_TEXCOORD1);
  lightDir_2 = tmpvar_8;
  highp vec4 col_9;
  highp vec3 ramp_10;
  highp float rimLight_11;
  highp float difLight_12;
  lowp float tmpvar_13;
  tmpvar_13 = max (0.0, dot (xlv_TEXCOORD0, lightDir_2));
  difLight_12 = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = max (0.0, dot (xlv_TEXCOORD0, normalize(xlv_TEXCOORD2)));
  rimLight_11 = tmpvar_14;
  highp vec2 tmpvar_15;
  tmpvar_15.x = ((difLight_12 * 0.5) + 0.5);
  tmpvar_15.y = ((rimLight_11 * 0.5) + 0.5);
  lowp vec3 tmpvar_16;
  tmpvar_16 = texture2D (_RampTex, tmpvar_15).xyz;
  ramp_10 = tmpvar_16;
  col_9.xyz = ((tmpvar_3 * _LightColor0.xyz) * ramp_10);
  col_9.w = tmpvar_4;
  c_1.xyz = col_9.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 14 [unity_Scale]
Matrix 8 [_LightMatrix0]
"agal_vs
[bc]
adaaaaaaabaaahacabaaaaoeaaaaaaaaaoaaaappabaaaaaa mul r1.xyz, a1, c14.w
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
bdaaaaaaadaaaeaeaaaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 v3.z, r0, c10
bdaaaaaaadaaacaeaaaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 v3.y, r0, c9
bdaaaaaaadaaabaeaaaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 v3.x, r0, c8
bcaaaaaaaaaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v0.z, r1.xyzz, c6
bcaaaaaaaaaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v0.y, r1.xyzz, c5
bcaaaaaaaaaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v0.x, r1.xyzz, c4
bfaaaaaaabaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r1.xyz, r0.xyzz
abaaaaaaabaaahaeabaaaakeacaaaaaaanaaaaoeabaaaaaa add v1.xyz, r1.xyzz, c13
bfaaaaaaaaaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r0.xyz, r0.xyzz
abaaaaaaacaaahaeaaaaaakeacaaaaaaamaaaaoeabaaaaaa add v2.xyz, r0.xyzz, c12
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "$Globals" 160 // 112 used size, 7 vars
Matrix 48 [_LightMatrix0] 4
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 23 instructions, 2 temp regs, 0 temp arrays:
// ALU 22 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedhfgkeolaighpdpbkhmnggmiojhkigebhabaaaaaaneahaaaaaeaaaaaa
daaaaaaaiaacaaaagmagaaaadeahaaaaebgpgodjeiacaaaaeiacaaaaaaacpopp
niabaaaahaaaaaaaagaaceaaaaaagmaaaaaagmaaaaaaceaaabaagmaaaaaaadaa
aeaaabaaaaaaaaaaabaaaeaaabaaafaaaaaaaaaaacaaaaaaabaaagaaaaaaaaaa
adaaaaaaaeaaahaaaaaaaaaaadaaamaaaeaaalaaaaaaaaaaadaabeaaabaaapaa
aaaaaaaaaaaaaaaaaaacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaacafaaacia
acaaapjaafaaaaadaaaaahiaacaaoejaapaappkaafaaaaadabaaahiaaaaaffia
amaaoekaaeaaaaaeaaaaaliaalaakekaaaaaaaiaabaakeiaaeaaaaaeaaaaahoa
anaaoekaaaaakkiaaaaapeiaafaaaaadaaaaahiaaaaaffjaamaaoekaaeaaaaae
aaaaahiaalaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaahiaanaaoekaaaaakkja
aaaaoeiaaeaaaaaeaaaaahiaaoaaoekaaaaappjaaaaaoeiaacaaaaadabaaahoa
aaaaoeibagaaoekaacaaaaadacaaahoaaaaaoeibafaaoekaafaaaaadaaaaapia
aaaaffjaamaaoekaaeaaaaaeaaaaapiaalaaoekaaaaaaajaaaaaoeiaaeaaaaae
aaaaapiaanaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaaoaaoekaaaaappja
aaaaoeiaafaaaaadabaaahiaaaaaffiaacaaoekaaeaaaaaeabaaahiaabaaoeka
aaaaaaiaabaaoeiaaeaaaaaeaaaaahiaadaaoekaaaaakkiaabaaoeiaaeaaaaae
adaaahoaaeaaoekaaaaappiaaaaaoeiaafaaaaadaaaaapiaaaaaffjaaiaaoeka
aeaaaaaeaaaaapiaahaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaajaaoeka
aaaakkjaaaaaoeiaaeaaaaaeaaaaapiaakaaoekaaaaappjaaaaaoeiaaeaaaaae
aaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiappppaaaa
fdeieefcoeadaaaaeaaaabaapjaaaaaafjaaaaaeegiocaaaaaaaaaaaahaaaaaa
fjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaa
fjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaad
hcbabaaaacaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaa
adaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaa
adaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaa
agaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaaabaaaaaaegiccaaa
adaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadiaaaaaihcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaajhccabaaaacaaaaaaegacbaia
ebaaaaaaaaaaaaaaegiccaaaacaaaaaaaaaaaaaaaaaaaaajhccabaaaadaaaaaa
egacbaiaebaaaaaaaaaaaaaaegiccaaaabaaaaaaaeaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaanaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaa
aaaaaaaaegiccaaaaaaaaaaaaeaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
aaaaaaaaadaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaaaaaaaaaafaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaakhccabaaaaeaaaaaaegiccaaaaaaaaaaaagaaaaaapgapbaaaaaaaaaaa
egacbaaaaaaaaaaadoaaaaabejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "POINT" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 397
struct Input {
    highp vec2 uv_MainTex;
};
#line 420
struct v2f_surf {
    highp vec4 pos;
    lowp vec3 normal;
    mediump vec3 lightDir;
    mediump vec3 viewDir;
    highp vec3 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform highp vec4 _EmissiveColor;
uniform highp vec4 _AmbientColor;
uniform highp float _MySliderValue;
uniform sampler2D _RampTex;
#line 402
#line 429
#line 442
#line 77
highp vec3 WorldSpaceLightDir( in highp vec4 v ) {
    highp vec3 worldPos = (_Object2World * v).xyz;
    return (_WorldSpaceLightPos0.xyz - worldPos);
}
#line 87
highp vec3 WorldSpaceViewDir( in highp vec4 v ) {
    return (_WorldSpaceCameraPos.xyz - (_Object2World * v).xyz);
}
#line 429
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 433
    o.normal = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    highp vec3 lightDir = WorldSpaceLightDir( v.vertex);
    o.lightDir = lightDir;
    highp vec3 viewDirForLight = WorldSpaceViewDir( v.vertex);
    #line 437
    o.viewDir = viewDirForLight;
    o._LightCoord = (_LightMatrix0 * (_Object2World * v.vertex)).xyz;
    return o;
}

out lowp vec3 xlv_TEXCOORD0;
out mediump vec3 xlv_TEXCOORD1;
out mediump vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.normal);
    xlv_TEXCOORD1 = vec3(xl_retval.lightDir);
    xlv_TEXCOORD2 = vec3(xl_retval.viewDir);
    xlv_TEXCOORD3 = vec3(xl_retval._LightCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 397
struct Input {
    highp vec2 uv_MainTex;
};
#line 420
struct v2f_surf {
    highp vec4 pos;
    lowp vec3 normal;
    mediump vec3 lightDir;
    mediump vec3 viewDir;
    highp vec3 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform highp vec4 _EmissiveColor;
uniform highp vec4 _AmbientColor;
uniform highp float _MySliderValue;
uniform sampler2D _RampTex;
#line 402
#line 429
#line 442
#line 408
highp vec4 LightingBasicDiffuse( in SurfaceOutput s, in lowp vec3 lightDir, in mediump vec3 viewDir, in lowp float atten ) {
    #line 410
    highp float difLight = max( 0.0, dot( s.Normal, lightDir));
    highp float rimLight = max( 0.0, dot( s.Normal, viewDir));
    highp float dif_hLambert = ((difLight * 0.5) + 0.5);
    highp float rim_hLambert = ((rimLight * 0.5) + 0.5);
    #line 414
    highp vec3 ramp = texture( _RampTex, vec2( dif_hLambert, rim_hLambert)).xyz;
    highp vec4 col;
    col.xyz = ((s.Albedo * _LightColor0.xyz) * ramp);
    col.w = s.Alpha;
    #line 418
    return col;
}
#line 402
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec4 c = pow( (_EmissiveColor + _AmbientColor), vec4( _MySliderValue));
    o.Albedo = c.xyz;
    #line 406
    o.Alpha = c.w;
}
#line 442
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    #line 446
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    #line 450
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    surf( surfIN, o);
    lowp vec3 lightDir = normalize(IN.lightDir);
    #line 454
    lowp vec4 c = LightingBasicDiffuse( o, lightDir, normalize(IN.viewDir), (texture( _LightTexture0, vec2( dot( IN._LightCoord, IN._LightCoord))).w * 1.0));
    c.w = 0.0;
    return c;
}
in lowp vec3 xlv_TEXCOORD0;
in mediump vec3 xlv_TEXCOORD1;
in mediump vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.normal = vec3(xlv_TEXCOORD0);
    xlt_IN.lightDir = vec3(xlv_TEXCOORD1);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD2);
    xlt_IN._LightCoord = vec3(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Vector 11 [unity_Scale]
"!!ARBvp1.0
# 13 ALU
PARAM c[12] = { program.local[0],
		state.matrix.mvp,
		program.local[5..11] };
TEMP R0;
MUL R0.xyz, vertex.normal, c[11].w;
DP3 result.texcoord[0].z, R0, c[7];
DP3 result.texcoord[0].y, R0, c[6];
DP3 result.texcoord[0].x, R0, c[5];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[1].xyz, c[10];
ADD result.texcoord[2].xyz, -R0, c[9];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 13 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceCameraPos]
Vector 9 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 10 [unity_Scale]
"vs_2_0
; 13 ALU
dcl_position0 v0
dcl_normal0 v1
mul r0.xyz, v1, c10.w
dp3 oT0.z, r0, c6
dp3 oT0.y, r0, c5
dp3 oT0.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov oT1.xyz, c9
add oT2.xyz, -r0, c8
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "UnityPerCamera" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 15 instructions, 2 temp regs, 0 temp arrays:
// ALU 13 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedcmfnpgfpjhdclnjcpneifbleojngbbgoabaaaaaabaaeaaaaadaaaaaa
cmaaaaaapeaaaaaahmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoiaaaaaaaaeaaaaaa
aiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaaheaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
imacaaaaeaaaabaakdaaaaaafjaaaaaeegiocaaaaaaaaaaaafaaaaaafjaaaaae
egiocaaaabaaaaaaabaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaad
hccabaaaadaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaa
acaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaacaaaaaaamaaaaaa
agaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaaabaaaaaaegiccaaa
acaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaaghccabaaa
acaaaaaaegiccaaaabaaaaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
acaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egacbaaaaaaaaaaaaaaaaaajhccabaaaadaaaaaaegacbaiaebaaaaaaaaaaaaaa
egiccaaaaaaaaaaaaeaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES


#ifdef VERTEX

varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform sampler2D _RampTex;
uniform highp float _MySliderValue;
uniform highp vec4 _AmbientColor;
uniform highp vec4 _EmissiveColor;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = pow ((_EmissiveColor + _AmbientColor), vec4(_MySliderValue));
  highp vec3 tmpvar_6;
  tmpvar_6 = tmpvar_5.xyz;
  tmpvar_3 = tmpvar_6;
  highp float tmpvar_7;
  tmpvar_7 = tmpvar_5.w;
  tmpvar_4 = tmpvar_7;
  lightDir_2 = xlv_TEXCOORD1;
  highp vec4 col_8;
  highp vec3 ramp_9;
  highp float rimLight_10;
  highp float difLight_11;
  lowp float tmpvar_12;
  tmpvar_12 = max (0.0, dot (xlv_TEXCOORD0, lightDir_2));
  difLight_11 = tmpvar_12;
  mediump float tmpvar_13;
  tmpvar_13 = max (0.0, dot (xlv_TEXCOORD0, normalize(xlv_TEXCOORD2)));
  rimLight_10 = tmpvar_13;
  highp vec2 tmpvar_14;
  tmpvar_14.x = ((difLight_11 * 0.5) + 0.5);
  tmpvar_14.y = ((rimLight_10 * 0.5) + 0.5);
  lowp vec3 tmpvar_15;
  tmpvar_15 = texture2D (_RampTex, tmpvar_14).xyz;
  ramp_9 = tmpvar_15;
  col_8.xyz = ((tmpvar_3 * _LightColor0.xyz) * ramp_9);
  col_8.w = tmpvar_4;
  c_1.xyz = col_8.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" }
"!!GLES


#ifdef VERTEX

varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform sampler2D _RampTex;
uniform highp float _MySliderValue;
uniform highp vec4 _AmbientColor;
uniform highp vec4 _EmissiveColor;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = pow ((_EmissiveColor + _AmbientColor), vec4(_MySliderValue));
  highp vec3 tmpvar_6;
  tmpvar_6 = tmpvar_5.xyz;
  tmpvar_3 = tmpvar_6;
  highp float tmpvar_7;
  tmpvar_7 = tmpvar_5.w;
  tmpvar_4 = tmpvar_7;
  lightDir_2 = xlv_TEXCOORD1;
  highp vec4 col_8;
  highp vec3 ramp_9;
  highp float rimLight_10;
  highp float difLight_11;
  lowp float tmpvar_12;
  tmpvar_12 = max (0.0, dot (xlv_TEXCOORD0, lightDir_2));
  difLight_11 = tmpvar_12;
  mediump float tmpvar_13;
  tmpvar_13 = max (0.0, dot (xlv_TEXCOORD0, normalize(xlv_TEXCOORD2)));
  rimLight_10 = tmpvar_13;
  highp vec2 tmpvar_14;
  tmpvar_14.x = ((difLight_11 * 0.5) + 0.5);
  tmpvar_14.y = ((rimLight_10 * 0.5) + 0.5);
  lowp vec3 tmpvar_15;
  tmpvar_15 = texture2D (_RampTex, tmpvar_14).xyz;
  ramp_9 = tmpvar_15;
  col_8.xyz = ((tmpvar_3 * _LightColor0.xyz) * ramp_9);
  col_8.w = tmpvar_4;
  c_1.xyz = col_8.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceCameraPos]
Vector 9 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 10 [unity_Scale]
"agal_vs
[bc]
adaaaaaaaaaaahacabaaaaoeaaaaaaaaakaaaappabaaaaaa mul r0.xyz, a1, c10.w
bcaaaaaaaaaaaeaeaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v0.z, r0.xyzz, c6
bcaaaaaaaaaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v0.y, r0.xyzz, c5
bcaaaaaaaaaaabaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v0.x, r0.xyzz, c4
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
aaaaaaaaabaaahaeajaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.xyz, c9
bfaaaaaaaaaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r0.xyz, r0.xyzz
abaaaaaaacaaahaeaaaaaakeacaaaaaaaiaaaaoeabaaaaaa add v2.xyz, r0.xyzz, c8
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "UnityPerCamera" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 15 instructions, 2 temp regs, 0 temp arrays:
// ALU 13 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedincnhipofnfhdlhaedapddnmejdcdfnmabaaaaaalmafaaaaaeaaaaaa
daaaaaaaniabaaaagmaeaaaadeafaaaaebgpgodjkaabaaaakaabaaaaaaacpopp
dmabaaaageaaaaaaafaaceaaaaaagaaaaaaagaaaaaaaceaaabaagaaaaaaaaeaa
abaaabaaaaaaaaaaabaaaaaaabaaacaaaaaaaaaaacaaaaaaaeaaadaaaaaaaaaa
acaaamaaaeaaahaaaaaaaaaaacaabeaaabaaalaaaaaaaaaaaaaaaaaaaaacpopp
bpaaaaacafaaaaiaaaaaapjabpaaaaacafaaaciaacaaapjaafaaaaadaaaaahia
acaaoejaalaappkaafaaaaadabaaahiaaaaaffiaaiaaoekaaeaaaaaeaaaaalia
ahaakekaaaaaaaiaabaakeiaaeaaaaaeaaaaahoaajaaoekaaaaakkiaaaaapeia
afaaaaadaaaaahiaaaaaffjaaiaaoekaaeaaaaaeaaaaahiaahaaoekaaaaaaaja
aaaaoeiaaeaaaaaeaaaaahiaajaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaahia
akaaoekaaaaappjaaaaaoeiaacaaaaadacaaahoaaaaaoeibabaaoekaafaaaaad
aaaaapiaaaaaffjaaeaaoekaaeaaaaaeaaaaapiaadaaoekaaaaaaajaaaaaoeia
aeaaaaaeaaaaapiaafaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaagaaoeka
aaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaac
aaaaammaaaaaoeiaabaaaaacabaaahoaacaaoekappppaaaafdeieefcimacaaaa
eaaaabaakdaaaaaafjaaaaaeegiocaaaaaaaaaaaafaaaaaafjaaaaaeegiocaaa
abaaaaaaabaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaa
aaaaaaaafpaaaaadhcbabaaaacaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaadhccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaa
adaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaacaaaaaa
beaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaacaaaaaa
anaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaaa
aaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaaabaaaaaaegiccaaaacaaaaaa
aoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaaghccabaaaacaaaaaa
egiccaaaabaaaaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaaaaaaaaajhccabaaaadaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaa
aaaaaaaaaeaaaaaadoaaaaabejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoiaaaaaaaaeaaaaaa
aiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaaheaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 395
struct Input {
    highp vec2 uv_MainTex;
};
#line 418
struct v2f_surf {
    highp vec4 pos;
    lowp vec3 normal;
    mediump vec3 lightDir;
    mediump vec3 viewDir;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _EmissiveColor;
uniform highp vec4 _AmbientColor;
#line 393
uniform highp float _MySliderValue;
uniform sampler2D _RampTex;
#line 400
#line 426
#line 438
#line 77
highp vec3 WorldSpaceLightDir( in highp vec4 v ) {
    highp vec3 worldPos = (_Object2World * v).xyz;
    return _WorldSpaceLightPos0.xyz;
}
#line 87
highp vec3 WorldSpaceViewDir( in highp vec4 v ) {
    return (_WorldSpaceCameraPos.xyz - (_Object2World * v).xyz);
}
#line 426
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 430
    o.normal = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    highp vec3 lightDir = WorldSpaceLightDir( v.vertex);
    o.lightDir = lightDir;
    highp vec3 viewDirForLight = WorldSpaceViewDir( v.vertex);
    #line 434
    o.viewDir = viewDirForLight;
    return o;
}

out lowp vec3 xlv_TEXCOORD0;
out mediump vec3 xlv_TEXCOORD1;
out mediump vec3 xlv_TEXCOORD2;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.normal);
    xlv_TEXCOORD1 = vec3(xl_retval.lightDir);
    xlv_TEXCOORD2 = vec3(xl_retval.viewDir);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 395
struct Input {
    highp vec2 uv_MainTex;
};
#line 418
struct v2f_surf {
    highp vec4 pos;
    lowp vec3 normal;
    mediump vec3 lightDir;
    mediump vec3 viewDir;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _EmissiveColor;
uniform highp vec4 _AmbientColor;
#line 393
uniform highp float _MySliderValue;
uniform sampler2D _RampTex;
#line 400
#line 426
#line 438
#line 406
highp vec4 LightingBasicDiffuse( in SurfaceOutput s, in lowp vec3 lightDir, in mediump vec3 viewDir, in lowp float atten ) {
    #line 408
    highp float difLight = max( 0.0, dot( s.Normal, lightDir));
    highp float rimLight = max( 0.0, dot( s.Normal, viewDir));
    highp float dif_hLambert = ((difLight * 0.5) + 0.5);
    highp float rim_hLambert = ((rimLight * 0.5) + 0.5);
    #line 412
    highp vec3 ramp = texture( _RampTex, vec2( dif_hLambert, rim_hLambert)).xyz;
    highp vec4 col;
    col.xyz = ((s.Albedo * _LightColor0.xyz) * ramp);
    col.w = s.Alpha;
    #line 416
    return col;
}
#line 400
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec4 c = pow( (_EmissiveColor + _AmbientColor), vec4( _MySliderValue));
    o.Albedo = c.xyz;
    #line 404
    o.Alpha = c.w;
}
#line 438
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    #line 442
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    #line 446
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    surf( surfIN, o);
    lowp vec3 lightDir = IN.lightDir;
    #line 450
    lowp vec4 c = LightingBasicDiffuse( o, lightDir, normalize(IN.viewDir), 1.0);
    c.w = 0.0;
    return c;
}
in lowp vec3 xlv_TEXCOORD0;
in mediump vec3 xlv_TEXCOORD1;
in mediump vec3 xlv_TEXCOORD2;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.normal = vec3(xlv_TEXCOORD0);
    xlt_IN.lightDir = vec3(xlv_TEXCOORD1);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD2);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Vector 15 [unity_Scale]
Matrix 9 [_LightMatrix0]
"!!ARBvp1.0
# 18 ALU
PARAM c[16] = { program.local[0],
		state.matrix.mvp,
		program.local[5..15] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[15].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[3].w, R0, c[12];
DP4 result.texcoord[3].z, R0, c[11];
DP4 result.texcoord[3].y, R0, c[10];
DP4 result.texcoord[3].x, R0, c[9];
DP3 result.texcoord[0].z, R1, c[7];
DP3 result.texcoord[0].y, R1, c[6];
DP3 result.texcoord[0].x, R1, c[5];
ADD result.texcoord[1].xyz, -R0, c[14];
ADD result.texcoord[2].xyz, -R0, c[13];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 18 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 14 [unity_Scale]
Matrix 8 [_LightMatrix0]
"vs_2_0
; 18 ALU
dcl_position0 v0
dcl_normal0 v1
mul r1.xyz, v1, c14.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 oT3.w, r0, c11
dp4 oT3.z, r0, c10
dp4 oT3.y, r0, c9
dp4 oT3.x, r0, c8
dp3 oT0.z, r1, c6
dp3 oT0.y, r1, c5
dp3 oT0.x, r1, c4
add oT1.xyz, -r0, c13
add oT2.xyz, -r0, c12
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "$Globals" 160 // 112 used size, 7 vars
Matrix 48 [_LightMatrix0] 4
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 23 instructions, 2 temp regs, 0 temp arrays:
// ALU 22 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedefflfkoeallplpncjaifjagcoilaijljabaaaaaaiaafaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcoeadaaaaeaaaabaa
pjaaaaaafjaaaaaeegiocaaaaaaaaaaaahaaaaaafjaaaaaeegiocaaaabaaaaaa
afaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagiaaaaac
acaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
hcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaai
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
lcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaa
abaaaaaadcaaaaakhccabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaa
aaaaaaaaegadbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaaaaaaaaajhccabaaaacaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaa
acaaaaaaaaaaaaaaaaaaaaajhccabaaaadaaaaaaegacbaiaebaaaaaaaaaaaaaa
egiccaaaabaaaaaaaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaadaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
amaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaaaaaaaaaa
aeaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaaaaaaaaaadaaaaaaagaabaaa
aaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaaaaaaaaa
afaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpccabaaaaeaaaaaa
egiocaaaaaaaaaaaagaaaaaapgapbaaaaaaaaaaaegaobaaaabaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform sampler2D _RampTex;
uniform highp float _MySliderValue;
uniform highp vec4 _AmbientColor;
uniform highp vec4 _EmissiveColor;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = pow ((_EmissiveColor + _AmbientColor), vec4(_MySliderValue));
  highp vec3 tmpvar_6;
  tmpvar_6 = tmpvar_5.xyz;
  tmpvar_3 = tmpvar_6;
  highp float tmpvar_7;
  tmpvar_7 = tmpvar_5.w;
  tmpvar_4 = tmpvar_7;
  mediump vec3 tmpvar_8;
  tmpvar_8 = normalize(xlv_TEXCOORD1);
  lightDir_2 = tmpvar_8;
  highp vec4 col_9;
  highp vec3 ramp_10;
  highp float rimLight_11;
  highp float difLight_12;
  lowp float tmpvar_13;
  tmpvar_13 = max (0.0, dot (xlv_TEXCOORD0, lightDir_2));
  difLight_12 = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = max (0.0, dot (xlv_TEXCOORD0, normalize(xlv_TEXCOORD2)));
  rimLight_11 = tmpvar_14;
  highp vec2 tmpvar_15;
  tmpvar_15.x = ((difLight_12 * 0.5) + 0.5);
  tmpvar_15.y = ((rimLight_11 * 0.5) + 0.5);
  lowp vec3 tmpvar_16;
  tmpvar_16 = texture2D (_RampTex, tmpvar_15).xyz;
  ramp_10 = tmpvar_16;
  col_9.xyz = ((tmpvar_3 * _LightColor0.xyz) * ramp_10);
  col_9.w = tmpvar_4;
  c_1.xyz = col_9.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "SPOT" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform sampler2D _RampTex;
uniform highp float _MySliderValue;
uniform highp vec4 _AmbientColor;
uniform highp vec4 _EmissiveColor;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = pow ((_EmissiveColor + _AmbientColor), vec4(_MySliderValue));
  highp vec3 tmpvar_6;
  tmpvar_6 = tmpvar_5.xyz;
  tmpvar_3 = tmpvar_6;
  highp float tmpvar_7;
  tmpvar_7 = tmpvar_5.w;
  tmpvar_4 = tmpvar_7;
  mediump vec3 tmpvar_8;
  tmpvar_8 = normalize(xlv_TEXCOORD1);
  lightDir_2 = tmpvar_8;
  highp vec4 col_9;
  highp vec3 ramp_10;
  highp float rimLight_11;
  highp float difLight_12;
  lowp float tmpvar_13;
  tmpvar_13 = max (0.0, dot (xlv_TEXCOORD0, lightDir_2));
  difLight_12 = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = max (0.0, dot (xlv_TEXCOORD0, normalize(xlv_TEXCOORD2)));
  rimLight_11 = tmpvar_14;
  highp vec2 tmpvar_15;
  tmpvar_15.x = ((difLight_12 * 0.5) + 0.5);
  tmpvar_15.y = ((rimLight_11 * 0.5) + 0.5);
  lowp vec3 tmpvar_16;
  tmpvar_16 = texture2D (_RampTex, tmpvar_15).xyz;
  ramp_10 = tmpvar_16;
  col_9.xyz = ((tmpvar_3 * _LightColor0.xyz) * ramp_10);
  col_9.w = tmpvar_4;
  c_1.xyz = col_9.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 14 [unity_Scale]
Matrix 8 [_LightMatrix0]
"agal_vs
[bc]
adaaaaaaabaaahacabaaaaoeaaaaaaaaaoaaaappabaaaaaa mul r1.xyz, a1, c14.w
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
bdaaaaaaadaaaiaeaaaaaaoeacaaaaaaalaaaaoeabaaaaaa dp4 v3.w, r0, c11
bdaaaaaaadaaaeaeaaaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 v3.z, r0, c10
bdaaaaaaadaaacaeaaaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 v3.y, r0, c9
bdaaaaaaadaaabaeaaaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 v3.x, r0, c8
bcaaaaaaaaaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v0.z, r1.xyzz, c6
bcaaaaaaaaaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v0.y, r1.xyzz, c5
bcaaaaaaaaaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v0.x, r1.xyzz, c4
bfaaaaaaabaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r1.xyz, r0.xyzz
abaaaaaaabaaahaeabaaaakeacaaaaaaanaaaaoeabaaaaaa add v1.xyz, r1.xyzz, c13
bfaaaaaaaaaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r0.xyz, r0.xyzz
abaaaaaaacaaahaeaaaaaakeacaaaaaaamaaaaoeabaaaaaa add v2.xyz, r0.xyzz, c12
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "$Globals" 160 // 112 used size, 7 vars
Matrix 48 [_LightMatrix0] 4
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 23 instructions, 2 temp regs, 0 temp arrays:
// ALU 22 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedeidkiappeageohfhmaobmelddankegkdabaaaaaaneahaaaaaeaaaaaa
daaaaaaaiaacaaaagmagaaaadeahaaaaebgpgodjeiacaaaaeiacaaaaaaacpopp
niabaaaahaaaaaaaagaaceaaaaaagmaaaaaagmaaaaaaceaaabaagmaaaaaaadaa
aeaaabaaaaaaaaaaabaaaeaaabaaafaaaaaaaaaaacaaaaaaabaaagaaaaaaaaaa
adaaaaaaaeaaahaaaaaaaaaaadaaamaaaeaaalaaaaaaaaaaadaabeaaabaaapaa
aaaaaaaaaaaaaaaaaaacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaacafaaacia
acaaapjaafaaaaadaaaaahiaacaaoejaapaappkaafaaaaadabaaahiaaaaaffia
amaaoekaaeaaaaaeaaaaaliaalaakekaaaaaaaiaabaakeiaaeaaaaaeaaaaahoa
anaaoekaaaaakkiaaaaapeiaafaaaaadaaaaahiaaaaaffjaamaaoekaaeaaaaae
aaaaahiaalaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaahiaanaaoekaaaaakkja
aaaaoeiaaeaaaaaeaaaaahiaaoaaoekaaaaappjaaaaaoeiaacaaaaadabaaahoa
aaaaoeibagaaoekaacaaaaadacaaahoaaaaaoeibafaaoekaafaaaaadaaaaapia
aaaaffjaamaaoekaaeaaaaaeaaaaapiaalaaoekaaaaaaajaaaaaoeiaaeaaaaae
aaaaapiaanaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaaoaaoekaaaaappja
aaaaoeiaafaaaaadabaaapiaaaaaffiaacaaoekaaeaaaaaeabaaapiaabaaoeka
aaaaaaiaabaaoeiaaeaaaaaeabaaapiaadaaoekaaaaakkiaabaaoeiaaeaaaaae
adaaapoaaeaaoekaaaaappiaabaaoeiaafaaaaadaaaaapiaaaaaffjaaiaaoeka
aeaaaaaeaaaaapiaahaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaajaaoeka
aaaakkjaaaaaoeiaaeaaaaaeaaaaapiaakaaoekaaaaappjaaaaaoeiaaeaaaaae
aaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiappppaaaa
fdeieefcoeadaaaaeaaaabaapjaaaaaafjaaaaaeegiocaaaaaaaaaaaahaaaaaa
fjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaa
fjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaad
hcbabaaaacaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
pccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaa
adaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaa
adaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaa
agaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaaabaaaaaaegiccaaa
adaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadiaaaaaihcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaajhccabaaaacaaaaaaegacbaia
ebaaaaaaaaaaaaaaegiccaaaacaaaaaaaaaaaaaaaaaaaaajhccabaaaadaaaaaa
egacbaiaebaaaaaaaaaaaaaaegiccaaaabaaaaaaaeaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaanaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaa
aaaaaaaaegiocaaaaaaaaaaaaeaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaa
aaaaaaaaadaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaa
abaaaaaaegiocaaaaaaaaaaaafaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaa
dcaaaaakpccabaaaaeaaaaaaegiocaaaaaaaaaaaagaaaaaapgapbaaaaaaaaaaa
egaobaaaabaaaaaadoaaaaabejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "SPOT" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
};
#line 429
struct v2f_surf {
    highp vec4 pos;
    lowp vec3 normal;
    mediump vec3 lightDir;
    mediump vec3 viewDir;
    highp vec4 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _LightTextureB0;
#line 398
#line 402
uniform highp vec4 _EmissiveColor;
uniform highp vec4 _AmbientColor;
uniform highp float _MySliderValue;
uniform sampler2D _RampTex;
#line 411
#line 438
#line 451
#line 77
highp vec3 WorldSpaceLightDir( in highp vec4 v ) {
    highp vec3 worldPos = (_Object2World * v).xyz;
    return (_WorldSpaceLightPos0.xyz - worldPos);
}
#line 87
highp vec3 WorldSpaceViewDir( in highp vec4 v ) {
    return (_WorldSpaceCameraPos.xyz - (_Object2World * v).xyz);
}
#line 438
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 442
    o.normal = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    highp vec3 lightDir = WorldSpaceLightDir( v.vertex);
    o.lightDir = lightDir;
    highp vec3 viewDirForLight = WorldSpaceViewDir( v.vertex);
    #line 446
    o.viewDir = viewDirForLight;
    o._LightCoord = (_LightMatrix0 * (_Object2World * v.vertex));
    return o;
}

out lowp vec3 xlv_TEXCOORD0;
out mediump vec3 xlv_TEXCOORD1;
out mediump vec3 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.normal);
    xlv_TEXCOORD1 = vec3(xl_retval.lightDir);
    xlv_TEXCOORD2 = vec3(xl_retval.viewDir);
    xlv_TEXCOORD3 = vec4(xl_retval._LightCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
};
#line 429
struct v2f_surf {
    highp vec4 pos;
    lowp vec3 normal;
    mediump vec3 lightDir;
    mediump vec3 viewDir;
    highp vec4 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _LightTextureB0;
#line 398
#line 402
uniform highp vec4 _EmissiveColor;
uniform highp vec4 _AmbientColor;
uniform highp float _MySliderValue;
uniform sampler2D _RampTex;
#line 411
#line 438
#line 451
#line 417
highp vec4 LightingBasicDiffuse( in SurfaceOutput s, in lowp vec3 lightDir, in mediump vec3 viewDir, in lowp float atten ) {
    #line 419
    highp float difLight = max( 0.0, dot( s.Normal, lightDir));
    highp float rimLight = max( 0.0, dot( s.Normal, viewDir));
    highp float dif_hLambert = ((difLight * 0.5) + 0.5);
    highp float rim_hLambert = ((rimLight * 0.5) + 0.5);
    #line 423
    highp vec3 ramp = texture( _RampTex, vec2( dif_hLambert, rim_hLambert)).xyz;
    highp vec4 col;
    col.xyz = ((s.Albedo * _LightColor0.xyz) * ramp);
    col.w = s.Alpha;
    #line 427
    return col;
}
#line 398
lowp float UnitySpotAttenuate( in highp vec3 LightCoord ) {
    return texture( _LightTextureB0, vec2( dot( LightCoord, LightCoord))).w;
}
#line 394
lowp float UnitySpotCookie( in highp vec4 LightCoord ) {
    return texture( _LightTexture0, ((LightCoord.xy / LightCoord.w) + 0.5)).w;
}
#line 411
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec4 c = pow( (_EmissiveColor + _AmbientColor), vec4( _MySliderValue));
    o.Albedo = c.xyz;
    #line 415
    o.Alpha = c.w;
}
#line 451
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    #line 455
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    #line 459
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    surf( surfIN, o);
    lowp vec3 lightDir = normalize(IN.lightDir);
    #line 463
    lowp vec4 c = LightingBasicDiffuse( o, lightDir, normalize(IN.viewDir), (((float((IN._LightCoord.z > 0.0)) * UnitySpotCookie( IN._LightCoord)) * UnitySpotAttenuate( IN._LightCoord.xyz)) * 1.0));
    c.w = 0.0;
    return c;
}
in lowp vec3 xlv_TEXCOORD0;
in mediump vec3 xlv_TEXCOORD1;
in mediump vec3 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.normal = vec3(xlv_TEXCOORD0);
    xlt_IN.lightDir = vec3(xlv_TEXCOORD1);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD2);
    xlt_IN._LightCoord = vec4(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Vector 15 [unity_Scale]
Matrix 9 [_LightMatrix0]
"!!ARBvp1.0
# 17 ALU
PARAM c[16] = { program.local[0],
		state.matrix.mvp,
		program.local[5..15] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[15].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[3].z, R0, c[11];
DP4 result.texcoord[3].y, R0, c[10];
DP4 result.texcoord[3].x, R0, c[9];
DP3 result.texcoord[0].z, R1, c[7];
DP3 result.texcoord[0].y, R1, c[6];
DP3 result.texcoord[0].x, R1, c[5];
ADD result.texcoord[1].xyz, -R0, c[14];
ADD result.texcoord[2].xyz, -R0, c[13];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 17 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 14 [unity_Scale]
Matrix 8 [_LightMatrix0]
"vs_2_0
; 17 ALU
dcl_position0 v0
dcl_normal0 v1
mul r1.xyz, v1, c14.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 oT3.z, r0, c10
dp4 oT3.y, r0, c9
dp4 oT3.x, r0, c8
dp3 oT0.z, r1, c6
dp3 oT0.y, r1, c5
dp3 oT0.x, r1, c4
add oT1.xyz, -r0, c13
add oT2.xyz, -r0, c12
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "$Globals" 160 // 112 used size, 7 vars
Matrix 48 [_LightMatrix0] 4
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 23 instructions, 2 temp regs, 0 temp arrays:
// ALU 22 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedkpdpikmmhibdaldmjhldhblcnnenakepabaaaaaaiaafaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcoeadaaaaeaaaabaa
pjaaaaaafjaaaaaeegiocaaaaaaaaaaaahaaaaaafjaaaaaeegiocaaaabaaaaaa
afaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagiaaaaac
acaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
hcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaai
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
lcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaa
abaaaaaadcaaaaakhccabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaa
aaaaaaaaegadbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaaaaaaaaajhccabaaaacaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaa
acaaaaaaaaaaaaaaaaaaaaajhccabaaaadaaaaaaegacbaiaebaaaaaaaaaaaaaa
egiccaaaabaaaaaaaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaadaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
amaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaa
aeaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaaagaabaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaaaaaaaa
afaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaaeaaaaaa
egiccaaaaaaaaaaaagaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform sampler2D _RampTex;
uniform highp float _MySliderValue;
uniform highp vec4 _AmbientColor;
uniform highp vec4 _EmissiveColor;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = pow ((_EmissiveColor + _AmbientColor), vec4(_MySliderValue));
  highp vec3 tmpvar_6;
  tmpvar_6 = tmpvar_5.xyz;
  tmpvar_3 = tmpvar_6;
  highp float tmpvar_7;
  tmpvar_7 = tmpvar_5.w;
  tmpvar_4 = tmpvar_7;
  mediump vec3 tmpvar_8;
  tmpvar_8 = normalize(xlv_TEXCOORD1);
  lightDir_2 = tmpvar_8;
  highp vec4 col_9;
  highp vec3 ramp_10;
  highp float rimLight_11;
  highp float difLight_12;
  lowp float tmpvar_13;
  tmpvar_13 = max (0.0, dot (xlv_TEXCOORD0, lightDir_2));
  difLight_12 = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = max (0.0, dot (xlv_TEXCOORD0, normalize(xlv_TEXCOORD2)));
  rimLight_11 = tmpvar_14;
  highp vec2 tmpvar_15;
  tmpvar_15.x = ((difLight_12 * 0.5) + 0.5);
  tmpvar_15.y = ((rimLight_11 * 0.5) + 0.5);
  lowp vec3 tmpvar_16;
  tmpvar_16 = texture2D (_RampTex, tmpvar_15).xyz;
  ramp_10 = tmpvar_16;
  col_9.xyz = ((tmpvar_3 * _LightColor0.xyz) * ramp_10);
  col_9.w = tmpvar_4;
  c_1.xyz = col_9.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "POINT_COOKIE" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform sampler2D _RampTex;
uniform highp float _MySliderValue;
uniform highp vec4 _AmbientColor;
uniform highp vec4 _EmissiveColor;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = pow ((_EmissiveColor + _AmbientColor), vec4(_MySliderValue));
  highp vec3 tmpvar_6;
  tmpvar_6 = tmpvar_5.xyz;
  tmpvar_3 = tmpvar_6;
  highp float tmpvar_7;
  tmpvar_7 = tmpvar_5.w;
  tmpvar_4 = tmpvar_7;
  mediump vec3 tmpvar_8;
  tmpvar_8 = normalize(xlv_TEXCOORD1);
  lightDir_2 = tmpvar_8;
  highp vec4 col_9;
  highp vec3 ramp_10;
  highp float rimLight_11;
  highp float difLight_12;
  lowp float tmpvar_13;
  tmpvar_13 = max (0.0, dot (xlv_TEXCOORD0, lightDir_2));
  difLight_12 = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = max (0.0, dot (xlv_TEXCOORD0, normalize(xlv_TEXCOORD2)));
  rimLight_11 = tmpvar_14;
  highp vec2 tmpvar_15;
  tmpvar_15.x = ((difLight_12 * 0.5) + 0.5);
  tmpvar_15.y = ((rimLight_11 * 0.5) + 0.5);
  lowp vec3 tmpvar_16;
  tmpvar_16 = texture2D (_RampTex, tmpvar_15).xyz;
  ramp_10 = tmpvar_16;
  col_9.xyz = ((tmpvar_3 * _LightColor0.xyz) * ramp_10);
  col_9.w = tmpvar_4;
  c_1.xyz = col_9.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 14 [unity_Scale]
Matrix 8 [_LightMatrix0]
"agal_vs
[bc]
adaaaaaaabaaahacabaaaaoeaaaaaaaaaoaaaappabaaaaaa mul r1.xyz, a1, c14.w
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
bdaaaaaaadaaaeaeaaaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 v3.z, r0, c10
bdaaaaaaadaaacaeaaaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 v3.y, r0, c9
bdaaaaaaadaaabaeaaaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 v3.x, r0, c8
bcaaaaaaaaaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v0.z, r1.xyzz, c6
bcaaaaaaaaaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v0.y, r1.xyzz, c5
bcaaaaaaaaaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v0.x, r1.xyzz, c4
bfaaaaaaabaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r1.xyz, r0.xyzz
abaaaaaaabaaahaeabaaaakeacaaaaaaanaaaaoeabaaaaaa add v1.xyz, r1.xyzz, c13
bfaaaaaaaaaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r0.xyz, r0.xyzz
abaaaaaaacaaahaeaaaaaakeacaaaaaaamaaaaoeabaaaaaa add v2.xyz, r0.xyzz, c12
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "$Globals" 160 // 112 used size, 7 vars
Matrix 48 [_LightMatrix0] 4
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 23 instructions, 2 temp regs, 0 temp arrays:
// ALU 22 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedhfgkeolaighpdpbkhmnggmiojhkigebhabaaaaaaneahaaaaaeaaaaaa
daaaaaaaiaacaaaagmagaaaadeahaaaaebgpgodjeiacaaaaeiacaaaaaaacpopp
niabaaaahaaaaaaaagaaceaaaaaagmaaaaaagmaaaaaaceaaabaagmaaaaaaadaa
aeaaabaaaaaaaaaaabaaaeaaabaaafaaaaaaaaaaacaaaaaaabaaagaaaaaaaaaa
adaaaaaaaeaaahaaaaaaaaaaadaaamaaaeaaalaaaaaaaaaaadaabeaaabaaapaa
aaaaaaaaaaaaaaaaaaacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaacafaaacia
acaaapjaafaaaaadaaaaahiaacaaoejaapaappkaafaaaaadabaaahiaaaaaffia
amaaoekaaeaaaaaeaaaaaliaalaakekaaaaaaaiaabaakeiaaeaaaaaeaaaaahoa
anaaoekaaaaakkiaaaaapeiaafaaaaadaaaaahiaaaaaffjaamaaoekaaeaaaaae
aaaaahiaalaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaahiaanaaoekaaaaakkja
aaaaoeiaaeaaaaaeaaaaahiaaoaaoekaaaaappjaaaaaoeiaacaaaaadabaaahoa
aaaaoeibagaaoekaacaaaaadacaaahoaaaaaoeibafaaoekaafaaaaadaaaaapia
aaaaffjaamaaoekaaeaaaaaeaaaaapiaalaaoekaaaaaaajaaaaaoeiaaeaaaaae
aaaaapiaanaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaaoaaoekaaaaappja
aaaaoeiaafaaaaadabaaahiaaaaaffiaacaaoekaaeaaaaaeabaaahiaabaaoeka
aaaaaaiaabaaoeiaaeaaaaaeaaaaahiaadaaoekaaaaakkiaabaaoeiaaeaaaaae
adaaahoaaeaaoekaaaaappiaaaaaoeiaafaaaaadaaaaapiaaaaaffjaaiaaoeka
aeaaaaaeaaaaapiaahaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaajaaoeka
aaaakkjaaaaaoeiaaeaaaaaeaaaaapiaakaaoekaaaaappjaaaaaoeiaaeaaaaae
aaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiappppaaaa
fdeieefcoeadaaaaeaaaabaapjaaaaaafjaaaaaeegiocaaaaaaaaaaaahaaaaaa
fjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaa
fjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaad
hcbabaaaacaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaa
adaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaa
adaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaa
agaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaaabaaaaaaegiccaaa
adaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadiaaaaaihcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaajhccabaaaacaaaaaaegacbaia
ebaaaaaaaaaaaaaaegiccaaaacaaaaaaaaaaaaaaaaaaaaajhccabaaaadaaaaaa
egacbaiaebaaaaaaaaaaaaaaegiccaaaabaaaaaaaeaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaanaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaa
aaaaaaaaegiccaaaaaaaaaaaaeaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
aaaaaaaaadaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaaaaaaaaaafaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaakhccabaaaaeaaaaaaegiccaaaaaaaaaaaagaaaaaapgapbaaaaaaaaaaa
egacbaaaaaaaaaaadoaaaaabejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "POINT_COOKIE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 398
struct Input {
    highp vec2 uv_MainTex;
};
#line 421
struct v2f_surf {
    highp vec4 pos;
    lowp vec3 normal;
    mediump vec3 lightDir;
    mediump vec3 viewDir;
    highp vec3 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform samplerCube _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _LightTextureB0;
uniform highp vec4 _EmissiveColor;
uniform highp vec4 _AmbientColor;
uniform highp float _MySliderValue;
#line 397
uniform sampler2D _RampTex;
#line 403
#line 430
#line 443
#line 77
highp vec3 WorldSpaceLightDir( in highp vec4 v ) {
    highp vec3 worldPos = (_Object2World * v).xyz;
    return (_WorldSpaceLightPos0.xyz - worldPos);
}
#line 87
highp vec3 WorldSpaceViewDir( in highp vec4 v ) {
    return (_WorldSpaceCameraPos.xyz - (_Object2World * v).xyz);
}
#line 430
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 434
    o.normal = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    highp vec3 lightDir = WorldSpaceLightDir( v.vertex);
    o.lightDir = lightDir;
    highp vec3 viewDirForLight = WorldSpaceViewDir( v.vertex);
    #line 438
    o.viewDir = viewDirForLight;
    o._LightCoord = (_LightMatrix0 * (_Object2World * v.vertex)).xyz;
    return o;
}

out lowp vec3 xlv_TEXCOORD0;
out mediump vec3 xlv_TEXCOORD1;
out mediump vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.normal);
    xlv_TEXCOORD1 = vec3(xl_retval.lightDir);
    xlv_TEXCOORD2 = vec3(xl_retval.viewDir);
    xlv_TEXCOORD3 = vec3(xl_retval._LightCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 398
struct Input {
    highp vec2 uv_MainTex;
};
#line 421
struct v2f_surf {
    highp vec4 pos;
    lowp vec3 normal;
    mediump vec3 lightDir;
    mediump vec3 viewDir;
    highp vec3 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform samplerCube _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _LightTextureB0;
uniform highp vec4 _EmissiveColor;
uniform highp vec4 _AmbientColor;
uniform highp float _MySliderValue;
#line 397
uniform sampler2D _RampTex;
#line 403
#line 430
#line 443
#line 409
highp vec4 LightingBasicDiffuse( in SurfaceOutput s, in lowp vec3 lightDir, in mediump vec3 viewDir, in lowp float atten ) {
    #line 411
    highp float difLight = max( 0.0, dot( s.Normal, lightDir));
    highp float rimLight = max( 0.0, dot( s.Normal, viewDir));
    highp float dif_hLambert = ((difLight * 0.5) + 0.5);
    highp float rim_hLambert = ((rimLight * 0.5) + 0.5);
    #line 415
    highp vec3 ramp = texture( _RampTex, vec2( dif_hLambert, rim_hLambert)).xyz;
    highp vec4 col;
    col.xyz = ((s.Albedo * _LightColor0.xyz) * ramp);
    col.w = s.Alpha;
    #line 419
    return col;
}
#line 403
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec4 c = pow( (_EmissiveColor + _AmbientColor), vec4( _MySliderValue));
    o.Albedo = c.xyz;
    #line 407
    o.Alpha = c.w;
}
#line 443
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    #line 447
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    #line 451
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    surf( surfIN, o);
    lowp vec3 lightDir = normalize(IN.lightDir);
    #line 455
    lowp vec4 c = LightingBasicDiffuse( o, lightDir, normalize(IN.viewDir), ((texture( _LightTextureB0, vec2( dot( IN._LightCoord, IN._LightCoord))).w * texture( _LightTexture0, IN._LightCoord).w) * 1.0));
    c.w = 0.0;
    return c;
}
in lowp vec3 xlv_TEXCOORD0;
in mediump vec3 xlv_TEXCOORD1;
in mediump vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.normal = vec3(xlv_TEXCOORD0);
    xlt_IN.lightDir = vec3(xlv_TEXCOORD1);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD2);
    xlt_IN._LightCoord = vec3(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Vector 15 [unity_Scale]
Matrix 9 [_LightMatrix0]
"!!ARBvp1.0
# 16 ALU
PARAM c[16] = { program.local[0],
		state.matrix.mvp,
		program.local[5..15] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[15].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[3].y, R0, c[10];
DP4 result.texcoord[3].x, R0, c[9];
DP3 result.texcoord[0].z, R1, c[7];
DP3 result.texcoord[0].y, R1, c[6];
DP3 result.texcoord[0].x, R1, c[5];
MOV result.texcoord[1].xyz, c[14];
ADD result.texcoord[2].xyz, -R0, c[13];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 16 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 14 [unity_Scale]
Matrix 8 [_LightMatrix0]
"vs_2_0
; 16 ALU
dcl_position0 v0
dcl_normal0 v1
mul r1.xyz, v1, c14.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 oT3.y, r0, c9
dp4 oT3.x, r0, c8
dp3 oT0.z, r1, c6
dp3 oT0.y, r1, c5
dp3 oT0.x, r1, c4
mov oT1.xyz, c13
add oT2.xyz, -r0, c12
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "$Globals" 160 // 112 used size, 7 vars
Matrix 48 [_LightMatrix0] 4
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 23 instructions, 2 temp regs, 0 temp arrays:
// ALU 21 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecediehajnnfhjdoaaajjnflelkkbpkifcggabaaaaaaheafaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadamaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcniadaaaaeaaaabaa
pgaaaaaafjaaaaaeegiocaaaaaaaaaaaahaaaaaafjaaaaaeegiocaaaabaaaaaa
afaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaaddccabaaaaeaaaaaagiaaaaac
acaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
hcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaai
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
lcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaa
abaaaaaadcaaaaakhccabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaa
aaaaaaaaegadbaaaaaaaaaaadgaaaaaghccabaaaacaaaaaaegiccaaaacaaaaaa
aaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaaj
hccabaaaadaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaaabaaaaaaaeaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaanaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaoaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaidcaabaaa
abaaaaaafgafbaaaaaaaaaaaegiacaaaaaaaaaaaaeaaaaaadcaaaaakdcaabaaa
aaaaaaaaegiacaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaaegaabaaaabaaaaaa
dcaaaaakdcaabaaaaaaaaaaaegiacaaaaaaaaaaaafaaaaaakgakbaaaaaaaaaaa
egaabaaaaaaaaaaadcaaaaakdccabaaaaeaaaaaaegiacaaaaaaaaaaaagaaaaaa
pgapbaaaaaaaaaaaegaabaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform sampler2D _RampTex;
uniform highp float _MySliderValue;
uniform highp vec4 _AmbientColor;
uniform highp vec4 _EmissiveColor;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = pow ((_EmissiveColor + _AmbientColor), vec4(_MySliderValue));
  highp vec3 tmpvar_6;
  tmpvar_6 = tmpvar_5.xyz;
  tmpvar_3 = tmpvar_6;
  highp float tmpvar_7;
  tmpvar_7 = tmpvar_5.w;
  tmpvar_4 = tmpvar_7;
  lightDir_2 = xlv_TEXCOORD1;
  highp vec4 col_8;
  highp vec3 ramp_9;
  highp float rimLight_10;
  highp float difLight_11;
  lowp float tmpvar_12;
  tmpvar_12 = max (0.0, dot (xlv_TEXCOORD0, lightDir_2));
  difLight_11 = tmpvar_12;
  mediump float tmpvar_13;
  tmpvar_13 = max (0.0, dot (xlv_TEXCOORD0, normalize(xlv_TEXCOORD2)));
  rimLight_10 = tmpvar_13;
  highp vec2 tmpvar_14;
  tmpvar_14.x = ((difLight_11 * 0.5) + 0.5);
  tmpvar_14.y = ((rimLight_10 * 0.5) + 0.5);
  lowp vec3 tmpvar_15;
  tmpvar_15 = texture2D (_RampTex, tmpvar_14).xyz;
  ramp_9 = tmpvar_15;
  col_8.xyz = ((tmpvar_3 * _LightColor0.xyz) * ramp_9);
  col_8.w = tmpvar_4;
  c_1.xyz = col_8.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD0;
uniform sampler2D _RampTex;
uniform highp float _MySliderValue;
uniform highp vec4 _AmbientColor;
uniform highp vec4 _EmissiveColor;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = pow ((_EmissiveColor + _AmbientColor), vec4(_MySliderValue));
  highp vec3 tmpvar_6;
  tmpvar_6 = tmpvar_5.xyz;
  tmpvar_3 = tmpvar_6;
  highp float tmpvar_7;
  tmpvar_7 = tmpvar_5.w;
  tmpvar_4 = tmpvar_7;
  lightDir_2 = xlv_TEXCOORD1;
  highp vec4 col_8;
  highp vec3 ramp_9;
  highp float rimLight_10;
  highp float difLight_11;
  lowp float tmpvar_12;
  tmpvar_12 = max (0.0, dot (xlv_TEXCOORD0, lightDir_2));
  difLight_11 = tmpvar_12;
  mediump float tmpvar_13;
  tmpvar_13 = max (0.0, dot (xlv_TEXCOORD0, normalize(xlv_TEXCOORD2)));
  rimLight_10 = tmpvar_13;
  highp vec2 tmpvar_14;
  tmpvar_14.x = ((difLight_11 * 0.5) + 0.5);
  tmpvar_14.y = ((rimLight_10 * 0.5) + 0.5);
  lowp vec3 tmpvar_15;
  tmpvar_15 = texture2D (_RampTex, tmpvar_14).xyz;
  ramp_9 = tmpvar_15;
  col_8.xyz = ((tmpvar_3 * _LightColor0.xyz) * ramp_9);
  col_8.w = tmpvar_4;
  c_1.xyz = col_8.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 14 [unity_Scale]
Matrix 8 [_LightMatrix0]
"agal_vs
[bc]
adaaaaaaabaaahacabaaaaoeaaaaaaaaaoaaaappabaaaaaa mul r1.xyz, a1, c14.w
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
bdaaaaaaadaaacaeaaaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 v3.y, r0, c9
bdaaaaaaadaaabaeaaaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 v3.x, r0, c8
bcaaaaaaaaaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v0.z, r1.xyzz, c6
bcaaaaaaaaaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v0.y, r1.xyzz, c5
bcaaaaaaaaaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v0.x, r1.xyzz, c4
aaaaaaaaabaaahaeanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.xyz, c13
bfaaaaaaaaaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r0.xyz, r0.xyzz
abaaaaaaacaaahaeaaaaaakeacaaaaaaamaaaaoeabaaaaaa add v2.xyz, r0.xyzz, c12
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.zw, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "$Globals" 160 // 112 used size, 7 vars
Matrix 48 [_LightMatrix0] 4
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 23 instructions, 2 temp regs, 0 temp arrays:
// ALU 21 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedcejdkamcgcifmkcgjojpanefangekeljabaaaaaameahaaaaaeaaaaaa
daaaaaaahmacaaaafmagaaaaceahaaaaebgpgodjeeacaaaaeeacaaaaaaacpopp
neabaaaahaaaaaaaagaaceaaaaaagmaaaaaagmaaaaaaceaaabaagmaaaaaaadaa
aeaaabaaaaaaaaaaabaaaeaaabaaafaaaaaaaaaaacaaaaaaabaaagaaaaaaaaaa
adaaaaaaaeaaahaaaaaaaaaaadaaamaaaeaaalaaaaaaaaaaadaabeaaabaaapaa
aaaaaaaaaaaaaaaaaaacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaacafaaacia
acaaapjaafaaaaadaaaaahiaacaaoejaapaappkaafaaaaadabaaahiaaaaaffia
amaaoekaaeaaaaaeaaaaaliaalaakekaaaaaaaiaabaakeiaaeaaaaaeaaaaahoa
anaaoekaaaaakkiaaaaapeiaafaaaaadaaaaahiaaaaaffjaamaaoekaaeaaaaae
aaaaahiaalaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaahiaanaaoekaaaaakkja
aaaaoeiaaeaaaaaeaaaaahiaaoaaoekaaaaappjaaaaaoeiaacaaaaadacaaahoa
aaaaoeibafaaoekaafaaaaadaaaaapiaaaaaffjaamaaoekaaeaaaaaeaaaaapia
alaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaanaaoekaaaaakkjaaaaaoeia
aeaaaaaeaaaaapiaaoaaoekaaaaappjaaaaaoeiaafaaaaadabaaadiaaaaaffia
acaaoekaaeaaaaaeaaaaadiaabaaoekaaaaaaaiaabaaoeiaaeaaaaaeaaaaadia
adaaoekaaaaakkiaaaaaoeiaaeaaaaaeadaaadoaaeaaoekaaaaappiaaaaaoeia
afaaaaadaaaaapiaaaaaffjaaiaaoekaaeaaaaaeaaaaapiaahaaoekaaaaaaaja
aaaaoeiaaeaaaaaeaaaaapiaajaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapia
akaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeia
abaaaaacaaaaammaaaaaoeiaabaaaaacabaaahoaagaaoekappppaaaafdeieefc
niadaaaaeaaaabaapgaaaaaafjaaaaaeegiocaaaaaaaaaaaahaaaaaafjaaaaae
egiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaafjaaaaae
egiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaa
gfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaaddccabaaa
aeaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaa
beaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaa
aaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaaabaaaaaaegiccaaaadaaaaaa
aoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaaghccabaaaacaaaaaa
egiccaaaacaaaaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaaaaaaaaajhccabaaaadaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaa
abaaaaaaaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
adaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaamaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaidcaabaaaabaaaaaafgafbaaaaaaaaaaaegiacaaaaaaaaaaaaeaaaaaa
dcaaaaakdcaabaaaaaaaaaaaegiacaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaa
egaabaaaabaaaaaadcaaaaakdcaabaaaaaaaaaaaegiacaaaaaaaaaaaafaaaaaa
kgakbaaaaaaaaaaaegaabaaaaaaaaaaadcaaaaakdccabaaaaeaaaaaaegiacaaa
aaaaaaaaagaaaaaapgapbaaaaaaaaaaaegaabaaaaaaaaaaadoaaaaabejfdeheo
maaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakjaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaadaaaaaaapaaaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaaaeaaaaaa
apaaaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
ahaiaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaaimaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaaimaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 397
struct Input {
    highp vec2 uv_MainTex;
};
#line 420
struct v2f_surf {
    highp vec4 pos;
    lowp vec3 normal;
    mediump vec3 lightDir;
    mediump vec3 viewDir;
    highp vec2 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform highp vec4 _EmissiveColor;
uniform highp vec4 _AmbientColor;
uniform highp float _MySliderValue;
uniform sampler2D _RampTex;
#line 402
#line 429
#line 442
#line 77
highp vec3 WorldSpaceLightDir( in highp vec4 v ) {
    highp vec3 worldPos = (_Object2World * v).xyz;
    return _WorldSpaceLightPos0.xyz;
}
#line 87
highp vec3 WorldSpaceViewDir( in highp vec4 v ) {
    return (_WorldSpaceCameraPos.xyz - (_Object2World * v).xyz);
}
#line 429
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 433
    o.normal = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    highp vec3 lightDir = WorldSpaceLightDir( v.vertex);
    o.lightDir = lightDir;
    highp vec3 viewDirForLight = WorldSpaceViewDir( v.vertex);
    #line 437
    o.viewDir = viewDirForLight;
    o._LightCoord = (_LightMatrix0 * (_Object2World * v.vertex)).xy;
    return o;
}

out lowp vec3 xlv_TEXCOORD0;
out mediump vec3 xlv_TEXCOORD1;
out mediump vec3 xlv_TEXCOORD2;
out highp vec2 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.normal);
    xlv_TEXCOORD1 = vec3(xl_retval.lightDir);
    xlv_TEXCOORD2 = vec3(xl_retval.viewDir);
    xlv_TEXCOORD3 = vec2(xl_retval._LightCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 397
struct Input {
    highp vec2 uv_MainTex;
};
#line 420
struct v2f_surf {
    highp vec4 pos;
    lowp vec3 normal;
    mediump vec3 lightDir;
    mediump vec3 viewDir;
    highp vec2 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform highp vec4 _EmissiveColor;
uniform highp vec4 _AmbientColor;
uniform highp float _MySliderValue;
uniform sampler2D _RampTex;
#line 402
#line 429
#line 442
#line 408
highp vec4 LightingBasicDiffuse( in SurfaceOutput s, in lowp vec3 lightDir, in mediump vec3 viewDir, in lowp float atten ) {
    #line 410
    highp float difLight = max( 0.0, dot( s.Normal, lightDir));
    highp float rimLight = max( 0.0, dot( s.Normal, viewDir));
    highp float dif_hLambert = ((difLight * 0.5) + 0.5);
    highp float rim_hLambert = ((rimLight * 0.5) + 0.5);
    #line 414
    highp vec3 ramp = texture( _RampTex, vec2( dif_hLambert, rim_hLambert)).xyz;
    highp vec4 col;
    col.xyz = ((s.Albedo * _LightColor0.xyz) * ramp);
    col.w = s.Alpha;
    #line 418
    return col;
}
#line 402
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec4 c = pow( (_EmissiveColor + _AmbientColor), vec4( _MySliderValue));
    o.Albedo = c.xyz;
    #line 406
    o.Alpha = c.w;
}
#line 442
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    #line 446
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    #line 450
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    surf( surfIN, o);
    lowp vec3 lightDir = IN.lightDir;
    #line 454
    lowp vec4 c = LightingBasicDiffuse( o, lightDir, normalize(IN.viewDir), (texture( _LightTexture0, IN._LightCoord).w * 1.0));
    c.w = 0.0;
    return c;
}
in lowp vec3 xlv_TEXCOORD0;
in mediump vec3 xlv_TEXCOORD1;
in mediump vec3 xlv_TEXCOORD2;
in highp vec2 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.normal = vec3(xlv_TEXCOORD0);
    xlt_IN.lightDir = vec3(xlv_TEXCOORD1);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD2);
    xlt_IN._LightCoord = vec2(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

}
Program "fp" {
// Fragment combos: 5
//   opengl - ALU: 19 to 21, TEX: 1 to 1
//   d3d9 - ALU: 28 to 30, TEX: 1 to 1
//   d3d11 - ALU: 15 to 18, TEX: 1 to 1, FLOW: 1 to 1
//   d3d11_9x - ALU: 15 to 18, TEX: 1 to 1, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_EmissiveColor]
Vector 2 [_AmbientColor]
Float 3 [_MySliderValue]
SetTexture 0 [_RampTex] 2D
"!!ARBfp1.0
# 21 ALU, 1 TEX
PARAM c[5] = { program.local[0..3],
		{ 0, 0.5 } };
TEMP R0;
TEMP R1;
DP3 R0.y, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.y, R0.y;
MUL R1.xyz, R0.y, fragment.texcoord[2];
DP3 R0.w, fragment.texcoord[0], R1;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[1];
DP3 R0.x, fragment.texcoord[0], R0;
MAX R0.y, R0.w, c[4].x;
MAX R0.x, R0, c[4];
MOV R1.xyz, c[2];
ADD R1.xyz, R1, c[1];
MAD R0.y, R0, c[4], c[4];
MAD R0.x, R0, c[4].y, c[4].y;
POW R1.x, R1.x, c[3].x;
POW R1.z, R1.z, c[3].x;
POW R1.y, R1.y, c[3].x;
MUL R1.xyz, R1, c[0];
MOV result.color.w, c[4].x;
TEX R0.xyz, R0, texture[0], 2D;
MUL result.color.xyz, R1, R0;
END
# 21 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_EmissiveColor]
Vector 2 [_AmbientColor]
Float 3 [_MySliderValue]
SetTexture 0 [_RampTex] 2D
"ps_2_0
; 30 ALU, 1 TEX
dcl_2d s0
def c4, 0.00000000, 0.50000000, 0, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dp3_pp r1.x, t2, t2
dp3_pp r0.x, t1, t1
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, t2
dp3_pp r1.x, t0, r1
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, t1
dp3_pp r0.x, t0, r0
max_pp r1.x, r1, c4
mad r0.y, r1.x, c4, c4
mov r1.xyz, c1
add r2.xyz, c2, r1
pow r1.x, r2.x, c3.x
mov r2.x, r1.x
pow r1.w, r2.z, c3.x
pow r3.x, r2.y, c3.x
max_pp r0.x, r0, c4
mad r0.x, r0, c4.y, c4.y
mov r2.z, r1.w
mov r2.y, r3.x
mul_pp r1.xyz, r2, c0
texld r0, r0, s0
mul r0.xyz, r1, r0
mov_pp r0.w, c4.x
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "POINT" }
ConstBuffer "$Globals" 160 // 148 used size, 7 vars
Vector 16 [_LightColor0] 4
Vector 112 [_EmissiveColor] 4
Vector 128 [_AmbientColor] 4
Float 144 [_MySliderValue]
BindCB "$Globals" 0
SetTexture 0 [_RampTex] 2D 0
// 21 instructions, 2 temp regs, 0 temp arrays:
// ALU 18 float, 0 int, 0 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedkidbjpibghlajidpklbbacnkebdjigleabaaaaaakiadaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefckaacaaaaeaaaaaaakiaaaaaafjaaaaaeegiocaaaaaaaaaaaakaaaaaa
fkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaad
hcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaabaaaaaahbcaabaaaaaaaaaaa
egbcbaaaacaaaaaaegbcbaaaacaaaaaaeeaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaaagaabaaaaaaaaaaaegbcbaaaacaaaaaa
baaaaaahbcaabaaaaaaaaaaaegbcbaaaabaaaaaaegacbaaaaaaaaaaadeaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaadcaaaaajbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaadpabeaaaaaaaaaaadpbaaaaaah
ecaabaaaaaaaaaaaegbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaafecaabaaa
aaaaaaaackaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaakgakbaaaaaaaaaaa
egbcbaaaadaaaaaabaaaaaahecaabaaaaaaaaaaaegbcbaaaabaaaaaaegacbaaa
abaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaaaa
dcaaaaajccaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaadpabeaaaaa
aaaaaadpefaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaaaaaaaaajhcaabaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaa
egiccaaaaaaaaaaaaiaaaaaacpaaaaafhcaabaaaabaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaagiacaaaaaaaaaaaajaaaaaa
bjaaaaafhcaabaaaabaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaa
egacbaaaabaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaahhccabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaa
aaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "POINT" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "POINT" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_EmissiveColor]
Vector 2 [_AmbientColor]
Float 3 [_MySliderValue]
SetTexture 0 [_RampTex] 2D
"agal_ps
c4 0.0 0.5 0.0 0.0
[bc]
bcaaaaaaabaaabacacaaaaoeaeaaaaaaacaaaaoeaeaaaaaa dp3 r1.x, v2, v2
bcaaaaaaaaaaabacabaaaaoeaeaaaaaaabaaaaoeaeaaaaaa dp3 r0.x, v1, v1
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
adaaaaaaabaaahacabaaaaaaacaaaaaaacaaaaoeaeaaaaaa mul r1.xyz, r1.x, v2
bcaaaaaaabaaabacaaaaaaoeaeaaaaaaabaaaakeacaaaaaa dp3 r1.x, v0, r1.xyzz
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaabaaaaoeaeaaaaaa mul r0.xyz, r0.x, v1
bcaaaaaaaaaaabacaaaaaaoeaeaaaaaaaaaaaakeacaaaaaa dp3 r0.x, v0, r0.xyzz
ahaaaaaaabaaabacabaaaaaaacaaaaaaaeaaaaoeabaaaaaa max r1.x, r1.x, c4
adaaaaaaaaaaacacabaaaaaaacaaaaaaaeaaaaoeabaaaaaa mul r0.y, r1.x, c4
abaaaaaaaaaaacacaaaaaaffacaaaaaaaeaaaaoeabaaaaaa add r0.y, r0.y, c4
aaaaaaaaabaaahacabaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c1
abaaaaaaacaaahacacaaaaoeabaaaaaaabaaaakeacaaaaaa add r2.xyz, c2, r1.xyzz
alaaaaaaabaaapacacaaaaaaacaaaaaaadaaaaaaabaaaaaa pow r1, r2.x, c3.x
aaaaaaaaacaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r2.x, r1.x
alaaaaaaabaaapacacaaaakkacaaaaaaadaaaaaaabaaaaaa pow r1, r2.z, c3.x
alaaaaaaadaaapacacaaaaffacaaaaaaadaaaaaaabaaaaaa pow r3, r2.y, c3.x
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaaoeabaaaaaa max r0.x, r0.x, c4
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaaffabaaaaaa mul r0.x, r0.x, c4.y
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaaffabaaaaaa add r0.x, r0.x, c4.y
aaaaaaaaacaaaeacabaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r2.z, r1.z
aaaaaaaaacaaacacadaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r2.y, r3.y
adaaaaaaabaaahacacaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r1.xyz, r2.xyzz, c0
ciaaaaaaaaaaapacaaaaaafeacaaaaaaaaaaaaaaafaababb tex r0, r0.xyyy, s0 <2d wrap linear point>
adaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r1.xyzz, r0.xyzz
aaaaaaaaaaaaaiacaeaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c4.x
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { "POINT" }
ConstBuffer "$Globals" 160 // 148 used size, 7 vars
Vector 16 [_LightColor0] 4
Vector 112 [_EmissiveColor] 4
Vector 128 [_AmbientColor] 4
Float 144 [_MySliderValue]
BindCB "$Globals" 0
SetTexture 0 [_RampTex] 2D 0
// 21 instructions, 2 temp regs, 0 temp arrays:
// ALU 18 float, 0 int, 0 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedibkmjiikjjfdejagecfjbpkoinlljmodabaaaaaaiiafaaaaaeaaaaaa
daaaaaaaamacaaaaleaeaaaafeafaaaaebgpgodjneabaaaaneabaaaaaaacpppp
jeabaaaaeaaaaaaaacaaciaaaaaaeaaaaaaaeaaaabaaceaaaaaaeaaaaaaaaaaa
aaaaabaaabaaaaaaaaaaaaaaaaaaahaaadaaabaaaaaaaaaaaaacppppfbaaaaaf
aeaaapkaaaaaaadpaaaaaaaaaaaaaaaaaaaaaaaabpaaaaacaaaaaaiaaaaachla
bpaaaaacaaaaaaiaabaachlabpaaaaacaaaaaaiaacaachlabpaaaaacaaaaaaja
aaaiapkaceaaaaacaaaachiaabaaoelaaiaaaaadaaaacbiaaaaaoelaaaaaoeia
aeaaaaaeaaaaaciaaaaaaaiaaeaaaakaaeaaaakafiaaaaaeaaaaabiaaaaaaaia
aaaaffiaaeaaaakaceaaaaacabaachiaacaaoelaaiaaaaadaaaaceiaaaaaoela
abaaoeiaaeaaaaaeaaaaaiiaaaaakkiaaeaaaakaaeaaaakafiaaaaaeaaaaacia
aaaakkiaaaaappiaaeaaaakaecaaaaadaaaaapiaaaaaoeiaaaaioekaabaaaaac
abaaahiaabaaoekaacaaaaadabaaahiaabaaoeiaacaaoekaapaaaaacacaaabia
abaaaaiaapaaaaacacaaaciaabaaffiaapaaaaacacaaaeiaabaakkiaafaaaaad
abaaahiaacaaoeiaadaaaakaaoaaaaacacaacbiaabaaaaiaaoaaaaacacaaccia
abaaffiaaoaaaaacacaaceiaabaakkiaafaaaaadabaaahiaacaaoeiaaaaaoeka
afaaaaadaaaachiaaaaaoeiaabaaoeiaabaaaaacaaaaciiaaeaaffkaabaaaaac
aaaicpiaaaaaoeiappppaaaafdeieefckaacaaaaeaaaaaaakiaaaaaafjaaaaae
egiocaaaaaaaaaaaakaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaa
gcbaaaadhcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaa
baaaaaahbcaabaaaaaaaaaaaegbcbaaaacaaaaaaegbcbaaaacaaaaaaeeaaaaaf
bcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaagaabaaa
aaaaaaaaegbcbaaaacaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaabaaaaaa
egacbaaaaaaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaaaadcaaaaajbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaadp
abeaaaaaaaaaaadpbaaaaaahecaabaaaaaaaaaaaegbcbaaaadaaaaaaegbcbaaa
adaaaaaaeeaaaaafecaabaaaaaaaaaaackaabaaaaaaaaaaadiaaaaahhcaabaaa
abaaaaaakgakbaaaaaaaaaaaegbcbaaaadaaaaaabaaaaaahecaabaaaaaaaaaaa
egbcbaaaabaaaaaaegacbaaaabaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaa
aaaaaaaaabeaaaaaaaaaaaaadcaaaaajccaabaaaaaaaaaaackaabaaaaaaaaaaa
abeaaaaaaaaaaadpabeaaaaaaaaaaadpefaaaaajpcaabaaaaaaaaaaaegaabaaa
aaaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaajhcaabaaaabaaaaaa
egiccaaaaaaaaaaaahaaaaaaegiccaaaaaaaaaaaaiaaaaaacpaaaaafhcaabaaa
abaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaa
agiacaaaaaaaaaaaajaaaaaabjaaaaafhcaabaaaabaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaabaaaaaa
diaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaf
iccabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaabejfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahahaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahahaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { "POINT" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_EmissiveColor]
Vector 2 [_AmbientColor]
Float 3 [_MySliderValue]
SetTexture 0 [_RampTex] 2D
"!!ARBfp1.0
# 19 ALU, 1 TEX
PARAM c[5] = { program.local[0..3],
		{ 0, 0.5 } };
TEMP R0;
TEMP R1;
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.x, R0.x;
MUL R1.xyz, R0.x, fragment.texcoord[2];
MOV R0.xyz, fragment.texcoord[1];
DP3 R0.x, fragment.texcoord[0], R0;
DP3 R0.w, fragment.texcoord[0], R1;
MAX R0.y, R0.w, c[4].x;
MAX R0.x, R0, c[4];
MOV R1.xyz, c[2];
ADD R1.xyz, R1, c[1];
MAD R0.y, R0, c[4], c[4];
MAD R0.x, R0, c[4].y, c[4].y;
POW R1.x, R1.x, c[3].x;
POW R1.z, R1.z, c[3].x;
POW R1.y, R1.y, c[3].x;
MUL R1.xyz, R1, c[0];
MOV result.color.w, c[4].x;
TEX R0.xyz, R0, texture[0], 2D;
MUL result.color.xyz, R1, R0;
END
# 19 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_EmissiveColor]
Vector 2 [_AmbientColor]
Float 3 [_MySliderValue]
SetTexture 0 [_RampTex] 2D
"ps_2_0
; 28 ALU, 1 TEX
dcl_2d s0
def c4, 0.00000000, 0.50000000, 0, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
mov_pp r1.xyz, t1
dp3_pp r1.x, t0, r1
dp3_pp r0.x, t2, t2
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, t2
dp3_pp r0.x, t0, r0
max_pp r0.x, r0, c4
max_pp r1.x, r1, c4
mad r0.y, r0.x, c4, c4
mad r0.x, r1, c4.y, c4.y
mov r1.xyz, c1
add r2.xyz, c2, r1
pow r1.x, r2.x, c3.x
mov r2.x, r1.x
pow r1.w, r2.z, c3.x
pow r3.x, r2.y, c3.x
mov r2.z, r1.w
mov r2.y, r3.x
mul_pp r1.xyz, r2, c0
texld r0, r0, s0
mul r0.xyz, r1, r0
mov_pp r0.w, c4.x
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" }
ConstBuffer "$Globals" 96 // 84 used size, 6 vars
Vector 16 [_LightColor0] 4
Vector 48 [_EmissiveColor] 4
Vector 64 [_AmbientColor] 4
Float 80 [_MySliderValue]
BindCB "$Globals" 0
SetTexture 0 [_RampTex] 2D 0
// 18 instructions, 2 temp regs, 0 temp arrays:
// ALU 15 float, 0 int, 0 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedhiiodpkgaklhkpojmjpndfndhbffennaabaaaaaaeeadaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcfeacaaaaeaaaaaaajfaaaaaafjaaaaaeegiocaaa
aaaaaaaaagaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaad
hcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaabaaaaaah
bcaabaaaaaaaaaaaegbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaagaabaaaaaaaaaaa
egbcbaaaadaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaabaaaaaaegacbaaa
aaaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaa
dcaaaaajccaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaadpabeaaaaa
aaaaaadpbaaaaaahecaabaaaaaaaaaaaegbcbaaaabaaaaaaegbcbaaaacaaaaaa
deaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaaaadcaaaaaj
bcaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaadpabeaaaaaaaaaaadp
efaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaaaaaaaaajhcaabaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaaegiccaaa
aaaaaaaaaeaaaaaacpaaaaafhcaabaaaabaaaaaaegacbaaaabaaaaaadiaaaaai
hcaabaaaabaaaaaaegacbaaaabaaaaaaagiacaaaaaaaaaaaafaaaaaabjaaaaaf
hcaabaaaabaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaa
abaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaahhccabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_EmissiveColor]
Vector 2 [_AmbientColor]
Float 3 [_MySliderValue]
SetTexture 0 [_RampTex] 2D
"agal_ps
c4 0.0 0.5 0.0 0.0
[bc]
aaaaaaaaabaaahacabaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, v1
bcaaaaaaabaaabacaaaaaaoeaeaaaaaaabaaaakeacaaaaaa dp3 r1.x, v0, r1.xyzz
bcaaaaaaaaaaabacacaaaaoeaeaaaaaaacaaaaoeaeaaaaaa dp3 r0.x, v2, v2
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaacaaaaoeaeaaaaaa mul r0.xyz, r0.x, v2
bcaaaaaaaaaaabacaaaaaaoeaeaaaaaaaaaaaakeacaaaaaa dp3 r0.x, v0, r0.xyzz
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaaoeabaaaaaa max r0.x, r0.x, c4
ahaaaaaaabaaabacabaaaaaaacaaaaaaaeaaaaoeabaaaaaa max r1.x, r1.x, c4
adaaaaaaaaaaacacaaaaaaaaacaaaaaaaeaaaaoeabaaaaaa mul r0.y, r0.x, c4
abaaaaaaaaaaacacaaaaaaffacaaaaaaaeaaaaoeabaaaaaa add r0.y, r0.y, c4
adaaaaaaaaaaabacabaaaaaaacaaaaaaaeaaaaffabaaaaaa mul r0.x, r1.x, c4.y
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaaffabaaaaaa add r0.x, r0.x, c4.y
aaaaaaaaabaaahacabaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c1
abaaaaaaacaaahacacaaaaoeabaaaaaaabaaaakeacaaaaaa add r2.xyz, c2, r1.xyzz
alaaaaaaabaaapacacaaaaaaacaaaaaaadaaaaaaabaaaaaa pow r1, r2.x, c3.x
aaaaaaaaacaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r2.x, r1.x
alaaaaaaabaaapacacaaaakkacaaaaaaadaaaaaaabaaaaaa pow r1, r2.z, c3.x
alaaaaaaadaaapacacaaaaffacaaaaaaadaaaaaaabaaaaaa pow r3, r2.y, c3.x
aaaaaaaaacaaaeacabaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r2.z, r1.z
aaaaaaaaacaaacacadaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r2.y, r3.y
adaaaaaaabaaahacacaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r1.xyz, r2.xyzz, c0
ciaaaaaaaaaaapacaaaaaafeacaaaaaaaaaaaaaaafaababb tex r0, r0.xyyy, s0 <2d wrap linear point>
adaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r1.xyzz, r0.xyzz
aaaaaaaaaaaaaiacaeaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c4.x
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" }
ConstBuffer "$Globals" 96 // 84 used size, 6 vars
Vector 16 [_LightColor0] 4
Vector 48 [_EmissiveColor] 4
Vector 64 [_AmbientColor] 4
Float 80 [_MySliderValue]
BindCB "$Globals" 0
SetTexture 0 [_RampTex] 2D 0
// 18 instructions, 2 temp regs, 0 temp arrays:
// ALU 15 float, 0 int, 0 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedbajfppkojngbecphfamfbbbcaaekppcfabaaaaaaceafaaaaaeaaaaaa
daaaaaaaamacaaaagiaeaaaapaaeaaaaebgpgodjneabaaaaneabaaaaaaacpppp
jeabaaaaeaaaaaaaacaaciaaaaaaeaaaaaaaeaaaabaaceaaaaaaeaaaaaaaaaaa
aaaaabaaabaaaaaaaaaaaaaaaaaaadaaadaaabaaaaaaaaaaaaacppppfbaaaaaf
aeaaapkaaaaaaadpaaaaaaaaaaaaaaaaaaaaaaaabpaaaaacaaaaaaiaaaaachla
bpaaaaacaaaaaaiaabaachlabpaaaaacaaaaaaiaacaachlabpaaaaacaaaaaaja
aaaiapkaabaaaaacaaaaahiaabaaoekaacaaaaadaaaaahiaaaaaoeiaacaaoeka
apaaaaacabaaabiaaaaaaaiaapaaaaacabaaaciaaaaaffiaapaaaaacabaaaeia
aaaakkiaafaaaaadaaaaahiaabaaoeiaadaaaakaaoaaaaacabaacbiaaaaaaaia
aoaaaaacabaacciaaaaaffiaaoaaaaacabaaceiaaaaakkiaafaaaaadaaaaahia
abaaoeiaaaaaoekaceaaaaacabaachiaacaaoelaaiaaaaadaaaaciiaaaaaoela
abaaoeiaaeaaaaaeabaaabiaaaaappiaaeaaaakaaeaaaakafiaaaaaeabaaacia
aaaappiaabaaaaiaaeaaaakaabaaaaacacaaahiaaaaaoelaaiaaaaadaaaaciia
acaaoeiaabaaoelaaeaaaaaeabaaaeiaaaaappiaaeaaaakaaeaaaakafiaaaaae
abaaabiaaaaappiaabaakkiaaeaaaakaecaaaaadabaaapiaabaaoeiaaaaioeka
afaaaaadaaaachiaaaaaoeiaabaaoeiaabaaaaacaaaaaiiaaeaaffkaabaaaaac
aaaicpiaaaaaoeiappppaaaafdeieefcfeacaaaaeaaaaaaajfaaaaaafjaaaaae
egiocaaaaaaaaaaaagaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaa
gcbaaaadhcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaa
baaaaaahbcaabaaaaaaaaaaaegbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaaf
bcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaagaabaaa
aaaaaaaaegbcbaaaadaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaabaaaaaa
egacbaaaaaaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaaaadcaaaaajccaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaadp
abeaaaaaaaaaaadpbaaaaaahecaabaaaaaaaaaaaegbcbaaaabaaaaaaegbcbaaa
acaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaaaa
dcaaaaajbcaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaadpabeaaaaa
aaaaaadpefaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaaaaaaaaajhcaabaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaa
egiccaaaaaaaaaaaaeaaaaaacpaaaaafhcaabaaaabaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaagiacaaaaaaaaaaaafaaaaaa
bjaaaaafhcaabaaaabaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaa
egacbaaaabaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaahhccabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaa
aaaaaaaadoaaaaabejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaahahaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaa
heaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaa
caaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgf
heaaklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_EmissiveColor]
Vector 2 [_AmbientColor]
Float 3 [_MySliderValue]
SetTexture 2 [_RampTex] 2D
"!!ARBfp1.0
# 21 ALU, 1 TEX
PARAM c[5] = { program.local[0..3],
		{ 0, 0.5 } };
TEMP R0;
TEMP R1;
DP3 R0.y, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.y, R0.y;
MUL R1.xyz, R0.y, fragment.texcoord[2];
DP3 R0.w, fragment.texcoord[0], R1;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[1];
DP3 R0.x, fragment.texcoord[0], R0;
MAX R0.y, R0.w, c[4].x;
MAX R0.x, R0, c[4];
MOV R1.xyz, c[2];
ADD R1.xyz, R1, c[1];
MAD R0.y, R0, c[4], c[4];
MAD R0.x, R0, c[4].y, c[4].y;
POW R1.x, R1.x, c[3].x;
POW R1.z, R1.z, c[3].x;
POW R1.y, R1.y, c[3].x;
MUL R1.xyz, R1, c[0];
MOV result.color.w, c[4].x;
TEX R0.xyz, R0, texture[2], 2D;
MUL result.color.xyz, R1, R0;
END
# 21 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_EmissiveColor]
Vector 2 [_AmbientColor]
Float 3 [_MySliderValue]
SetTexture 2 [_RampTex] 2D
"ps_2_0
; 30 ALU, 1 TEX
dcl_2d s2
def c4, 0.00000000, 0.50000000, 0, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dp3_pp r1.x, t2, t2
dp3_pp r0.x, t1, t1
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, t2
dp3_pp r1.x, t0, r1
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, t1
dp3_pp r0.x, t0, r0
max_pp r1.x, r1, c4
mad r0.y, r1.x, c4, c4
mov r1.xyz, c1
add r2.xyz, c2, r1
pow r1.x, r2.x, c3.x
mov r2.x, r1.x
pow r1.w, r2.z, c3.x
pow r3.x, r2.y, c3.x
max_pp r0.x, r0, c4
mad r0.x, r0, c4.y, c4.y
mov r2.z, r1.w
mov r2.y, r3.x
mul_pp r1.xyz, r2, c0
texld r0, r0, s2
mul r0.xyz, r1, r0
mov_pp r0.w, c4.x
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "SPOT" }
ConstBuffer "$Globals" 160 // 148 used size, 7 vars
Vector 16 [_LightColor0] 4
Vector 112 [_EmissiveColor] 4
Vector 128 [_AmbientColor] 4
Float 144 [_MySliderValue]
BindCB "$Globals" 0
SetTexture 0 [_RampTex] 2D 0
// 21 instructions, 2 temp regs, 0 temp arrays:
// ALU 18 float, 0 int, 0 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedbialpppihlofeammggmgbfjkpinfobfnabaaaaaakiadaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefckaacaaaaeaaaaaaakiaaaaaafjaaaaaeegiocaaaaaaaaaaaakaaaaaa
fkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaad
hcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaabaaaaaahbcaabaaaaaaaaaaa
egbcbaaaacaaaaaaegbcbaaaacaaaaaaeeaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaaagaabaaaaaaaaaaaegbcbaaaacaaaaaa
baaaaaahbcaabaaaaaaaaaaaegbcbaaaabaaaaaaegacbaaaaaaaaaaadeaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaadcaaaaajbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaadpabeaaaaaaaaaaadpbaaaaaah
ecaabaaaaaaaaaaaegbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaafecaabaaa
aaaaaaaackaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaakgakbaaaaaaaaaaa
egbcbaaaadaaaaaabaaaaaahecaabaaaaaaaaaaaegbcbaaaabaaaaaaegacbaaa
abaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaaaa
dcaaaaajccaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaadpabeaaaaa
aaaaaadpefaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaaaaaaaaajhcaabaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaa
egiccaaaaaaaaaaaaiaaaaaacpaaaaafhcaabaaaabaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaagiacaaaaaaaaaaaajaaaaaa
bjaaaaafhcaabaaaabaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaa
egacbaaaabaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaahhccabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaa
aaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "SPOT" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_EmissiveColor]
Vector 2 [_AmbientColor]
Float 3 [_MySliderValue]
SetTexture 2 [_RampTex] 2D
"agal_ps
c4 0.0 0.5 0.0 0.0
[bc]
bcaaaaaaabaaabacacaaaaoeaeaaaaaaacaaaaoeaeaaaaaa dp3 r1.x, v2, v2
bcaaaaaaaaaaabacabaaaaoeaeaaaaaaabaaaaoeaeaaaaaa dp3 r0.x, v1, v1
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
adaaaaaaabaaahacabaaaaaaacaaaaaaacaaaaoeaeaaaaaa mul r1.xyz, r1.x, v2
bcaaaaaaabaaabacaaaaaaoeaeaaaaaaabaaaakeacaaaaaa dp3 r1.x, v0, r1.xyzz
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaabaaaaoeaeaaaaaa mul r0.xyz, r0.x, v1
bcaaaaaaaaaaabacaaaaaaoeaeaaaaaaaaaaaakeacaaaaaa dp3 r0.x, v0, r0.xyzz
ahaaaaaaabaaabacabaaaaaaacaaaaaaaeaaaaoeabaaaaaa max r1.x, r1.x, c4
adaaaaaaaaaaacacabaaaaaaacaaaaaaaeaaaaoeabaaaaaa mul r0.y, r1.x, c4
abaaaaaaaaaaacacaaaaaaffacaaaaaaaeaaaaoeabaaaaaa add r0.y, r0.y, c4
aaaaaaaaabaaahacabaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c1
abaaaaaaacaaahacacaaaaoeabaaaaaaabaaaakeacaaaaaa add r2.xyz, c2, r1.xyzz
alaaaaaaabaaapacacaaaaaaacaaaaaaadaaaaaaabaaaaaa pow r1, r2.x, c3.x
aaaaaaaaacaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r2.x, r1.x
alaaaaaaabaaapacacaaaakkacaaaaaaadaaaaaaabaaaaaa pow r1, r2.z, c3.x
alaaaaaaadaaapacacaaaaffacaaaaaaadaaaaaaabaaaaaa pow r3, r2.y, c3.x
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaaoeabaaaaaa max r0.x, r0.x, c4
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaaffabaaaaaa mul r0.x, r0.x, c4.y
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaaffabaaaaaa add r0.x, r0.x, c4.y
aaaaaaaaacaaaeacabaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r2.z, r1.z
aaaaaaaaacaaacacadaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r2.y, r3.y
adaaaaaaabaaahacacaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r1.xyz, r2.xyzz, c0
ciaaaaaaaaaaapacaaaaaafeacaaaaaaacaaaaaaafaababb tex r0, r0.xyyy, s2 <2d wrap linear point>
adaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r1.xyzz, r0.xyzz
aaaaaaaaaaaaaiacaeaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c4.x
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { "SPOT" }
ConstBuffer "$Globals" 160 // 148 used size, 7 vars
Vector 16 [_LightColor0] 4
Vector 112 [_EmissiveColor] 4
Vector 128 [_AmbientColor] 4
Float 144 [_MySliderValue]
BindCB "$Globals" 0
SetTexture 0 [_RampTex] 2D 0
// 21 instructions, 2 temp regs, 0 temp arrays:
// ALU 18 float, 0 int, 0 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedpnnhgkcdbmfpbamkcgheifaiiknglclgabaaaaaaiiafaaaaaeaaaaaa
daaaaaaaamacaaaaleaeaaaafeafaaaaebgpgodjneabaaaaneabaaaaaaacpppp
jeabaaaaeaaaaaaaacaaciaaaaaaeaaaaaaaeaaaabaaceaaaaaaeaaaaaaaaaaa
aaaaabaaabaaaaaaaaaaaaaaaaaaahaaadaaabaaaaaaaaaaaaacppppfbaaaaaf
aeaaapkaaaaaaadpaaaaaaaaaaaaaaaaaaaaaaaabpaaaaacaaaaaaiaaaaachla
bpaaaaacaaaaaaiaabaachlabpaaaaacaaaaaaiaacaachlabpaaaaacaaaaaaja
aaaiapkaceaaaaacaaaachiaabaaoelaaiaaaaadaaaacbiaaaaaoelaaaaaoeia
aeaaaaaeaaaaaciaaaaaaaiaaeaaaakaaeaaaakafiaaaaaeaaaaabiaaaaaaaia
aaaaffiaaeaaaakaceaaaaacabaachiaacaaoelaaiaaaaadaaaaceiaaaaaoela
abaaoeiaaeaaaaaeaaaaaiiaaaaakkiaaeaaaakaaeaaaakafiaaaaaeaaaaacia
aaaakkiaaaaappiaaeaaaakaecaaaaadaaaaapiaaaaaoeiaaaaioekaabaaaaac
abaaahiaabaaoekaacaaaaadabaaahiaabaaoeiaacaaoekaapaaaaacacaaabia
abaaaaiaapaaaaacacaaaciaabaaffiaapaaaaacacaaaeiaabaakkiaafaaaaad
abaaahiaacaaoeiaadaaaakaaoaaaaacacaacbiaabaaaaiaaoaaaaacacaaccia
abaaffiaaoaaaaacacaaceiaabaakkiaafaaaaadabaaahiaacaaoeiaaaaaoeka
afaaaaadaaaachiaaaaaoeiaabaaoeiaabaaaaacaaaaaiiaaeaaffkaabaaaaac
aaaicpiaaaaaoeiappppaaaafdeieefckaacaaaaeaaaaaaakiaaaaaafjaaaaae
egiocaaaaaaaaaaaakaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaa
gcbaaaadhcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaa
baaaaaahbcaabaaaaaaaaaaaegbcbaaaacaaaaaaegbcbaaaacaaaaaaeeaaaaaf
bcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaagaabaaa
aaaaaaaaegbcbaaaacaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaabaaaaaa
egacbaaaaaaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaaaadcaaaaajbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaadp
abeaaaaaaaaaaadpbaaaaaahecaabaaaaaaaaaaaegbcbaaaadaaaaaaegbcbaaa
adaaaaaaeeaaaaafecaabaaaaaaaaaaackaabaaaaaaaaaaadiaaaaahhcaabaaa
abaaaaaakgakbaaaaaaaaaaaegbcbaaaadaaaaaabaaaaaahecaabaaaaaaaaaaa
egbcbaaaabaaaaaaegacbaaaabaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaa
aaaaaaaaabeaaaaaaaaaaaaadcaaaaajccaabaaaaaaaaaaackaabaaaaaaaaaaa
abeaaaaaaaaaaadpabeaaaaaaaaaaadpefaaaaajpcaabaaaaaaaaaaaegaabaaa
aaaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaajhcaabaaaabaaaaaa
egiccaaaaaaaaaaaahaaaaaaegiccaaaaaaaaaaaaiaaaaaacpaaaaafhcaabaaa
abaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaa
agiacaaaaaaaaaaaajaaaaaabjaaaaafhcaabaaaabaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaabaaaaaa
diaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaf
iccabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaabejfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahahaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahahaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { "SPOT" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_EmissiveColor]
Vector 2 [_AmbientColor]
Float 3 [_MySliderValue]
SetTexture 0 [_RampTex] 2D
"!!ARBfp1.0
# 21 ALU, 1 TEX
PARAM c[5] = { program.local[0..3],
		{ 0, 0.5 } };
TEMP R0;
TEMP R1;
DP3 R0.y, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.y, R0.y;
MUL R1.xyz, R0.y, fragment.texcoord[2];
DP3 R0.w, fragment.texcoord[0], R1;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[1];
DP3 R0.x, fragment.texcoord[0], R0;
MAX R0.y, R0.w, c[4].x;
MAX R0.x, R0, c[4];
MOV R1.xyz, c[2];
ADD R1.xyz, R1, c[1];
MAD R0.y, R0, c[4], c[4];
MAD R0.x, R0, c[4].y, c[4].y;
POW R1.x, R1.x, c[3].x;
POW R1.z, R1.z, c[3].x;
POW R1.y, R1.y, c[3].x;
MUL R1.xyz, R1, c[0];
MOV result.color.w, c[4].x;
TEX R0.xyz, R0, texture[0], 2D;
MUL result.color.xyz, R1, R0;
END
# 21 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_EmissiveColor]
Vector 2 [_AmbientColor]
Float 3 [_MySliderValue]
SetTexture 0 [_RampTex] 2D
"ps_2_0
; 30 ALU, 1 TEX
dcl_2d s0
def c4, 0.00000000, 0.50000000, 0, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dp3_pp r1.x, t2, t2
dp3_pp r0.x, t1, t1
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, t2
dp3_pp r1.x, t0, r1
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, t1
dp3_pp r0.x, t0, r0
max_pp r1.x, r1, c4
mad r0.y, r1.x, c4, c4
mov r1.xyz, c1
add r2.xyz, c2, r1
pow r1.x, r2.x, c3.x
mov r2.x, r1.x
pow r1.w, r2.z, c3.x
pow r3.x, r2.y, c3.x
max_pp r0.x, r0, c4
mad r0.x, r0, c4.y, c4.y
mov r2.z, r1.w
mov r2.y, r3.x
mul_pp r1.xyz, r2, c0
texld r0, r0, s0
mul r0.xyz, r1, r0
mov_pp r0.w, c4.x
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" }
ConstBuffer "$Globals" 160 // 148 used size, 7 vars
Vector 16 [_LightColor0] 4
Vector 112 [_EmissiveColor] 4
Vector 128 [_AmbientColor] 4
Float 144 [_MySliderValue]
BindCB "$Globals" 0
SetTexture 0 [_RampTex] 2D 0
// 21 instructions, 2 temp regs, 0 temp arrays:
// ALU 18 float, 0 int, 0 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedkidbjpibghlajidpklbbacnkebdjigleabaaaaaakiadaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefckaacaaaaeaaaaaaakiaaaaaafjaaaaaeegiocaaaaaaaaaaaakaaaaaa
fkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaad
hcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaabaaaaaahbcaabaaaaaaaaaaa
egbcbaaaacaaaaaaegbcbaaaacaaaaaaeeaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaaagaabaaaaaaaaaaaegbcbaaaacaaaaaa
baaaaaahbcaabaaaaaaaaaaaegbcbaaaabaaaaaaegacbaaaaaaaaaaadeaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaadcaaaaajbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaadpabeaaaaaaaaaaadpbaaaaaah
ecaabaaaaaaaaaaaegbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaafecaabaaa
aaaaaaaackaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaakgakbaaaaaaaaaaa
egbcbaaaadaaaaaabaaaaaahecaabaaaaaaaaaaaegbcbaaaabaaaaaaegacbaaa
abaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaaaa
dcaaaaajccaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaadpabeaaaaa
aaaaaadpefaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaaaaaaaaajhcaabaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaa
egiccaaaaaaaaaaaaiaaaaaacpaaaaafhcaabaaaabaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaagiacaaaaaaaaaaaajaaaaaa
bjaaaaafhcaabaaaabaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaa
egacbaaaabaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaahhccabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaa
aaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "POINT_COOKIE" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_EmissiveColor]
Vector 2 [_AmbientColor]
Float 3 [_MySliderValue]
SetTexture 0 [_RampTex] 2D
"agal_ps
c4 0.0 0.5 0.0 0.0
[bc]
bcaaaaaaabaaabacacaaaaoeaeaaaaaaacaaaaoeaeaaaaaa dp3 r1.x, v2, v2
bcaaaaaaaaaaabacabaaaaoeaeaaaaaaabaaaaoeaeaaaaaa dp3 r0.x, v1, v1
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
adaaaaaaabaaahacabaaaaaaacaaaaaaacaaaaoeaeaaaaaa mul r1.xyz, r1.x, v2
bcaaaaaaabaaabacaaaaaaoeaeaaaaaaabaaaakeacaaaaaa dp3 r1.x, v0, r1.xyzz
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaabaaaaoeaeaaaaaa mul r0.xyz, r0.x, v1
bcaaaaaaaaaaabacaaaaaaoeaeaaaaaaaaaaaakeacaaaaaa dp3 r0.x, v0, r0.xyzz
ahaaaaaaabaaabacabaaaaaaacaaaaaaaeaaaaoeabaaaaaa max r1.x, r1.x, c4
adaaaaaaaaaaacacabaaaaaaacaaaaaaaeaaaaoeabaaaaaa mul r0.y, r1.x, c4
abaaaaaaaaaaacacaaaaaaffacaaaaaaaeaaaaoeabaaaaaa add r0.y, r0.y, c4
aaaaaaaaabaaahacabaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c1
abaaaaaaacaaahacacaaaaoeabaaaaaaabaaaakeacaaaaaa add r2.xyz, c2, r1.xyzz
alaaaaaaabaaapacacaaaaaaacaaaaaaadaaaaaaabaaaaaa pow r1, r2.x, c3.x
aaaaaaaaacaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r2.x, r1.x
alaaaaaaabaaapacacaaaakkacaaaaaaadaaaaaaabaaaaaa pow r1, r2.z, c3.x
alaaaaaaadaaapacacaaaaffacaaaaaaadaaaaaaabaaaaaa pow r3, r2.y, c3.x
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaaoeabaaaaaa max r0.x, r0.x, c4
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaaffabaaaaaa mul r0.x, r0.x, c4.y
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaaffabaaaaaa add r0.x, r0.x, c4.y
aaaaaaaaacaaaeacabaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r2.z, r1.z
aaaaaaaaacaaacacadaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r2.y, r3.y
adaaaaaaabaaahacacaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r1.xyz, r2.xyzz, c0
ciaaaaaaaaaaapacaaaaaafeacaaaaaaaaaaaaaaafaababb tex r0, r0.xyyy, s0 <2d wrap linear point>
adaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r1.xyzz, r0.xyzz
aaaaaaaaaaaaaiacaeaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c4.x
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { "POINT_COOKIE" }
ConstBuffer "$Globals" 160 // 148 used size, 7 vars
Vector 16 [_LightColor0] 4
Vector 112 [_EmissiveColor] 4
Vector 128 [_AmbientColor] 4
Float 144 [_MySliderValue]
BindCB "$Globals" 0
SetTexture 0 [_RampTex] 2D 0
// 21 instructions, 2 temp regs, 0 temp arrays:
// ALU 18 float, 0 int, 0 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedibkmjiikjjfdejagecfjbpkoinlljmodabaaaaaaiiafaaaaaeaaaaaa
daaaaaaaamacaaaaleaeaaaafeafaaaaebgpgodjneabaaaaneabaaaaaaacpppp
jeabaaaaeaaaaaaaacaaciaaaaaaeaaaaaaaeaaaabaaceaaaaaaeaaaaaaaaaaa
aaaaabaaabaaaaaaaaaaaaaaaaaaahaaadaaabaaaaaaaaaaaaacppppfbaaaaaf
aeaaapkaaaaaaadpaaaaaaaaaaaaaaaaaaaaaaaabpaaaaacaaaaaaiaaaaachla
bpaaaaacaaaaaaiaabaachlabpaaaaacaaaaaaiaacaachlabpaaaaacaaaaaaja
aaaiapkaceaaaaacaaaachiaabaaoelaaiaaaaadaaaacbiaaaaaoelaaaaaoeia
aeaaaaaeaaaaaciaaaaaaaiaaeaaaakaaeaaaakafiaaaaaeaaaaabiaaaaaaaia
aaaaffiaaeaaaakaceaaaaacabaachiaacaaoelaaiaaaaadaaaaceiaaaaaoela
abaaoeiaaeaaaaaeaaaaaiiaaaaakkiaaeaaaakaaeaaaakafiaaaaaeaaaaacia
aaaakkiaaaaappiaaeaaaakaecaaaaadaaaaapiaaaaaoeiaaaaioekaabaaaaac
abaaahiaabaaoekaacaaaaadabaaahiaabaaoeiaacaaoekaapaaaaacacaaabia
abaaaaiaapaaaaacacaaaciaabaaffiaapaaaaacacaaaeiaabaakkiaafaaaaad
abaaahiaacaaoeiaadaaaakaaoaaaaacacaacbiaabaaaaiaaoaaaaacacaaccia
abaaffiaaoaaaaacacaaceiaabaakkiaafaaaaadabaaahiaacaaoeiaaaaaoeka
afaaaaadaaaachiaaaaaoeiaabaaoeiaabaaaaacaaaaciiaaeaaffkaabaaaaac
aaaicpiaaaaaoeiappppaaaafdeieefckaacaaaaeaaaaaaakiaaaaaafjaaaaae
egiocaaaaaaaaaaaakaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaa
gcbaaaadhcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaa
baaaaaahbcaabaaaaaaaaaaaegbcbaaaacaaaaaaegbcbaaaacaaaaaaeeaaaaaf
bcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaagaabaaa
aaaaaaaaegbcbaaaacaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaabaaaaaa
egacbaaaaaaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaaaadcaaaaajbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaadp
abeaaaaaaaaaaadpbaaaaaahecaabaaaaaaaaaaaegbcbaaaadaaaaaaegbcbaaa
adaaaaaaeeaaaaafecaabaaaaaaaaaaackaabaaaaaaaaaaadiaaaaahhcaabaaa
abaaaaaakgakbaaaaaaaaaaaegbcbaaaadaaaaaabaaaaaahecaabaaaaaaaaaaa
egbcbaaaabaaaaaaegacbaaaabaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaa
aaaaaaaaabeaaaaaaaaaaaaadcaaaaajccaabaaaaaaaaaaackaabaaaaaaaaaaa
abeaaaaaaaaaaadpabeaaaaaaaaaaadpefaaaaajpcaabaaaaaaaaaaaegaabaaa
aaaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaajhcaabaaaabaaaaaa
egiccaaaaaaaaaaaahaaaaaaegiccaaaaaaaaaaaaiaaaaaacpaaaaafhcaabaaa
abaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaa
agiacaaaaaaaaaaaajaaaaaabjaaaaafhcaabaaaabaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaabaaaaaa
diaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaf
iccabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaabejfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahahaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahahaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { "POINT_COOKIE" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_EmissiveColor]
Vector 2 [_AmbientColor]
Float 3 [_MySliderValue]
SetTexture 0 [_RampTex] 2D
"!!ARBfp1.0
# 19 ALU, 1 TEX
PARAM c[5] = { program.local[0..3],
		{ 0, 0.5 } };
TEMP R0;
TEMP R1;
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.x, R0.x;
MUL R1.xyz, R0.x, fragment.texcoord[2];
MOV R0.xyz, fragment.texcoord[1];
DP3 R0.x, fragment.texcoord[0], R0;
DP3 R0.w, fragment.texcoord[0], R1;
MAX R0.y, R0.w, c[4].x;
MAX R0.x, R0, c[4];
MOV R1.xyz, c[2];
ADD R1.xyz, R1, c[1];
MAD R0.y, R0, c[4], c[4];
MAD R0.x, R0, c[4].y, c[4].y;
POW R1.x, R1.x, c[3].x;
POW R1.z, R1.z, c[3].x;
POW R1.y, R1.y, c[3].x;
MUL R1.xyz, R1, c[0];
MOV result.color.w, c[4].x;
TEX R0.xyz, R0, texture[0], 2D;
MUL result.color.xyz, R1, R0;
END
# 19 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_EmissiveColor]
Vector 2 [_AmbientColor]
Float 3 [_MySliderValue]
SetTexture 0 [_RampTex] 2D
"ps_2_0
; 28 ALU, 1 TEX
dcl_2d s0
def c4, 0.00000000, 0.50000000, 0, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
mov_pp r1.xyz, t1
dp3_pp r1.x, t0, r1
dp3_pp r0.x, t2, t2
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, t2
dp3_pp r0.x, t0, r0
max_pp r0.x, r0, c4
max_pp r1.x, r1, c4
mad r0.y, r0.x, c4, c4
mad r0.x, r1, c4.y, c4.y
mov r1.xyz, c1
add r2.xyz, c2, r1
pow r1.x, r2.x, c3.x
mov r2.x, r1.x
pow r1.w, r2.z, c3.x
pow r3.x, r2.y, c3.x
mov r2.z, r1.w
mov r2.y, r3.x
mul_pp r1.xyz, r2, c0
texld r0, r0, s0
mul r0.xyz, r1, r0
mov_pp r0.w, c4.x
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL_COOKIE" }
ConstBuffer "$Globals" 160 // 148 used size, 7 vars
Vector 16 [_LightColor0] 4
Vector 112 [_EmissiveColor] 4
Vector 128 [_AmbientColor] 4
Float 144 [_MySliderValue]
BindCB "$Globals" 0
SetTexture 0 [_RampTex] 2D 0
// 18 instructions, 2 temp regs, 0 temp arrays:
// ALU 15 float, 0 int, 0 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedopbickdhibgnopeiakjicilhoepaipjoabaaaaaafmadaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcfeacaaaaeaaaaaaajfaaaaaafjaaaaaeegiocaaaaaaaaaaaakaaaaaa
fkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaad
hcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaabaaaaaahbcaabaaaaaaaaaaa
egbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaaagaabaaaaaaaaaaaegbcbaaaadaaaaaa
baaaaaahbcaabaaaaaaaaaaaegbcbaaaabaaaaaaegacbaaaaaaaaaaadeaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaadcaaaaajccaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaadpabeaaaaaaaaaaadpbaaaaaah
ecaabaaaaaaaaaaaegbcbaaaabaaaaaaegbcbaaaacaaaaaadeaaaaahecaabaaa
aaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaaaadcaaaaajbcaabaaaaaaaaaaa
ckaabaaaaaaaaaaaabeaaaaaaaaaaadpabeaaaaaaaaaaadpefaaaaajpcaabaaa
aaaaaaaaegaabaaaaaaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaaj
hcaabaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaaegiccaaaaaaaaaaaaiaaaaaa
cpaaaaafhcaabaaaabaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaa
egacbaaaabaaaaaaagiacaaaaaaaaaaaajaaaaaabjaaaaafhcaabaaaabaaaaaa
egacbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaa
aaaaaaaaabaaaaaadiaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_EmissiveColor]
Vector 2 [_AmbientColor]
Float 3 [_MySliderValue]
SetTexture 0 [_RampTex] 2D
"agal_ps
c4 0.0 0.5 0.0 0.0
[bc]
aaaaaaaaabaaahacabaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, v1
bcaaaaaaabaaabacaaaaaaoeaeaaaaaaabaaaakeacaaaaaa dp3 r1.x, v0, r1.xyzz
bcaaaaaaaaaaabacacaaaaoeaeaaaaaaacaaaaoeaeaaaaaa dp3 r0.x, v2, v2
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaacaaaaoeaeaaaaaa mul r0.xyz, r0.x, v2
bcaaaaaaaaaaabacaaaaaaoeaeaaaaaaaaaaaakeacaaaaaa dp3 r0.x, v0, r0.xyzz
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaaoeabaaaaaa max r0.x, r0.x, c4
ahaaaaaaabaaabacabaaaaaaacaaaaaaaeaaaaoeabaaaaaa max r1.x, r1.x, c4
adaaaaaaaaaaacacaaaaaaaaacaaaaaaaeaaaaoeabaaaaaa mul r0.y, r0.x, c4
abaaaaaaaaaaacacaaaaaaffacaaaaaaaeaaaaoeabaaaaaa add r0.y, r0.y, c4
adaaaaaaaaaaabacabaaaaaaacaaaaaaaeaaaaffabaaaaaa mul r0.x, r1.x, c4.y
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaaffabaaaaaa add r0.x, r0.x, c4.y
aaaaaaaaabaaahacabaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c1
abaaaaaaacaaahacacaaaaoeabaaaaaaabaaaakeacaaaaaa add r2.xyz, c2, r1.xyzz
alaaaaaaabaaapacacaaaaaaacaaaaaaadaaaaaaabaaaaaa pow r1, r2.x, c3.x
aaaaaaaaacaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r2.x, r1.x
alaaaaaaabaaapacacaaaakkacaaaaaaadaaaaaaabaaaaaa pow r1, r2.z, c3.x
alaaaaaaadaaapacacaaaaffacaaaaaaadaaaaaaabaaaaaa pow r3, r2.y, c3.x
aaaaaaaaacaaaeacabaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r2.z, r1.z
aaaaaaaaacaaacacadaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r2.y, r3.y
adaaaaaaabaaahacacaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r1.xyz, r2.xyzz, c0
ciaaaaaaaaaaapacaaaaaafeacaaaaaaaaaaaaaaafaababb tex r0, r0.xyyy, s0 <2d wrap linear point>
adaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r1.xyzz, r0.xyzz
aaaaaaaaaaaaaiacaeaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c4.x
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL_COOKIE" }
ConstBuffer "$Globals" 160 // 148 used size, 7 vars
Vector 16 [_LightColor0] 4
Vector 112 [_EmissiveColor] 4
Vector 128 [_AmbientColor] 4
Float 144 [_MySliderValue]
BindCB "$Globals" 0
SetTexture 0 [_RampTex] 2D 0
// 18 instructions, 2 temp regs, 0 temp arrays:
// ALU 15 float, 0 int, 0 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedeihhppoafgagmomllpdnbggmfgkbfmpnabaaaaaadmafaaaaaeaaaaaa
daaaaaaaamacaaaagiaeaaaaaiafaaaaebgpgodjneabaaaaneabaaaaaaacpppp
jeabaaaaeaaaaaaaacaaciaaaaaaeaaaaaaaeaaaabaaceaaaaaaeaaaaaaaaaaa
aaaaabaaabaaaaaaaaaaaaaaaaaaahaaadaaabaaaaaaaaaaaaacppppfbaaaaaf
aeaaapkaaaaaaadpaaaaaaaaaaaaaaaaaaaaaaaabpaaaaacaaaaaaiaaaaachla
bpaaaaacaaaaaaiaabaachlabpaaaaacaaaaaaiaacaachlabpaaaaacaaaaaaja
aaaiapkaabaaaaacaaaaahiaabaaoekaacaaaaadaaaaahiaaaaaoeiaacaaoeka
apaaaaacabaaabiaaaaaaaiaapaaaaacabaaaciaaaaaffiaapaaaaacabaaaeia
aaaakkiaafaaaaadaaaaahiaabaaoeiaadaaaakaaoaaaaacabaacbiaaaaaaaia
aoaaaaacabaacciaaaaaffiaaoaaaaacabaaceiaaaaakkiaafaaaaadaaaaahia
abaaoeiaaaaaoekaceaaaaacabaachiaacaaoelaaiaaaaadaaaaciiaaaaaoela
abaaoeiaaeaaaaaeabaaabiaaaaappiaaeaaaakaaeaaaakafiaaaaaeabaaacia
aaaappiaabaaaaiaaeaaaakaabaaaaacacaaahiaaaaaoelaaiaaaaadaaaaciia
acaaoeiaabaaoelaaeaaaaaeabaaaeiaaaaappiaaeaaaakaaeaaaakafiaaaaae
abaaabiaaaaappiaabaakkiaaeaaaakaecaaaaadabaaapiaabaaoeiaaaaioeka
afaaaaadaaaachiaaaaaoeiaabaaoeiaabaaaaacaaaaciiaaeaaffkaabaaaaac
aaaicpiaaaaaoeiappppaaaafdeieefcfeacaaaaeaaaaaaajfaaaaaafjaaaaae
egiocaaaaaaaaaaaakaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaa
gcbaaaadhcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaa
baaaaaahbcaabaaaaaaaaaaaegbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaaf
bcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaagaabaaa
aaaaaaaaegbcbaaaadaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaabaaaaaa
egacbaaaaaaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaaaadcaaaaajccaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaadp
abeaaaaaaaaaaadpbaaaaaahecaabaaaaaaaaaaaegbcbaaaabaaaaaaegbcbaaa
acaaaaaadeaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaaaa
dcaaaaajbcaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaadpabeaaaaa
aaaaaadpefaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaaaaaaaaajhcaabaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaa
egiccaaaaaaaaaaaaiaaaaaacpaaaaafhcaabaaaabaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaagiacaaaaaaaaaaaajaaaaaa
bjaaaaafhcaabaaaabaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaa
egacbaaaabaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaahhccabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaa
aaaaaaaadoaaaaabejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaahahaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaa
imaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaimaaaaaaadaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaadaaaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES3"
}

}
	}

#LINE 50

	} 
	FallBack "Diffuse"
}
