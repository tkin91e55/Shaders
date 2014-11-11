//reference from cg tutorial in navidia, tutorial 2 simple shader, but failed
Shader "Custom/SimpleShader" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		//#pragma vertex C2E1v_green

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};
		
		struct C2E1v_Output {

  float4 _position : POSITION;
  float4 _color    : COLOR;

};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		
		
		C2E1v_Output C2E1v_green(float2 position : POSITION)
{

  C2E1v_Output OUT;

  OUT._position = float4(position, 0, 1);

  OUT._color    = float4(0, 1, 0, 1);  // RGBA green

  return OUT;

}
		
		ENDCG
	} 
	FallBack "Diffuse"
}
