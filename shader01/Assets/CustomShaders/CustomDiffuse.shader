Shader "Custom/BasicDiffuse" {
	Properties {
		_EmissiveColor ("Emissive Color", Color) = (1,1,1,1)
		_AmbientColor  ("Ambient Color", Color) = (1,1,1,1)
		_MySliderValue ("This is a Slider", Range(0,10)) = 2.5
		//add ramp texuture:
		_RampTex ("Ramp Texture", 2D) = "white"{} 
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		//#pragma surface surf Lambert
		#pragma surface surf BassicDiffuse

		float4 _EmissiveColor;
		float4 _AmbientColor;
		float _MySliderValue; 
		//add ramp texture:
		sampler2D _RampTex;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			float4 c = pow((_EmissiveColor + _AmbientColor), _MySliderValue);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		
		//由上可以看出，经过surf函数，计算输出了s的Albedo（反射率）和Alpha（透明度）。
		//Lighting($theNameYouWant)
	inline float4 LightingBassicDiffuse (SurfaceOutput s, fixed3 lightDir, fixed atten)
       	{
       	  	float difLight = max(0, dot (s.Normal, lightDir));
       	  	//HLambert: Add this line  
            float hLambert = difLight * 0.5 + 0.5;  
            //add ramp texture:
            float3 ramp = tex2D(_RampTex, float2(hLambert)).rgb; 
            
       	  	float4 col;
       	  	
       	  	//col.rgb = s.Albedo * _LightColor0.rgb * (difLight * atten * 2);
       	  	//HLambert: Modify this line
       	  	//col.rgb = s.Albedo * _LightColor0.rgb * (hLambert * atten * 2);
       	  	//Add ramp texture:
       	  	col.rgb = s.Albedo * _LightColor0.rgb * (ramp); 
       	  	col.a = s.Alpha;
       	  	return col;
	}
		ENDCG
	} 
	FallBack "Diffuse"
}