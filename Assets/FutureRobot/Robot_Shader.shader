Shader "Custom/Robot_Shader" {

	
	Properties {
        _TexStatic ("Static", 2D) = "white" {}
        _TexDynamic ("Dynamic", 2D) = "white" {}
		_AlphaValue("Alpha", float) = 0.01
		_Offset("DynamicOffset", float) = 0.0

		_ColorFactor("ColorFactor", float) = 1
    }
    SubShader {
        Tags { "RenderType"="Fade" }
        LOD 200
       
        CGPROGRAM
        #pragma surface surf Lambert
       
        sampler2D _TexStatic;
        sampler2D _TexDynamic;
 
        float _AlphaValue;
		float _Offset;
		float _ColorFactor;
 

        struct Input {
            float2 uv_TexStatic;
            float2 uv_TexDynamic;
			//float4 xy_Position : POSITION;
			float3 worldPos;
        };
 
        void surf (Input IN, inout SurfaceOutput o) {
            
               
            //o.Albedo = tex2D(_TexStatic, IN.uv_TexStatic).rgb * tex2D(_TexDynamic, IN.uv_TexDynamic).rgb;\
			//float2 UV_Dynamic = IN.uv_TexDynamic;
			//UV_Dynamic += (0, _Offset); 

			
			//_Offset = IN.xy_Position.x;
			float utmp = IN.worldPos.x / 2.0;
			float vtmp = IN.worldPos.y / 2.0;

			float ut = 0.7071 * utmp + 0.7071 * vtmp;
			float vt = 0.7071 * utmp - 0.7071 * vtmp;

			o.Albedo = _ColorFactor * (0.6 * tex2D(_TexDynamic, float2(ut, vt)).rgb + 0.4 * tex2D(_TexStatic, IN.uv_TexStatic).rgb);
			//o.Albedo = 0.6 * tex2D(_TexDynamic, float2(IN.uv_TexDynamic.x, IN.uv_TexDynamic.y + _Offset)).rgb + 0.4 * tex2D(_TexStatic, IN.uv_TexStatic).rgb;
            o.Alpha = 0.01;// _AlphaValue;
			//o.Albedo = float3(1,_Color, 1);
			//o.Alpha = _AlphaValue;
        }
        ENDCG
    }
    FallBack "Diffuse"
	

	/*
	Properties {
        _TexStatic ("Static", 2D) = "white" {}
        _TexDynamic ("Dynamic", 2D) = "white" {}
		_AlphaValue("Alpha", float) = 0.5
		_Offset("DynamicOffset", float) = 0.0

		_Color("Color", float) = 1
 
    }
    SubShader {
        Tags { "RenderType"="Fade" }
        LOD 200
       
        CGPROGRAM
        #pragma surface surf Lambert
        #pragma exclude_renderers ps3 flash
       
       
        sampler2D _TexStatic;
        sampler2D _TexDynamic;
 
        float _AlphaValue;
		float _Offset;
		float _Color;
 

        struct Input {
            float2 uv_TexStatic;
            float2 uv_TexDynamic;
        };


        void vert (inout appdata_full v, out Input o) {
          UNITY_INITIALIZE_OUTPUT(Input,o);
          o.incline = abs(v.normal.y);
        }
 
        void surf (Input IN, inout SurfaceOutput o) {      
            float Alti = IN.worldPos.y/_TotalMetres;
               
            float4 resultCol =
            // Above topLimit, 100% topTexture
               Alti >= _TopLimit ? tex2D(_TexTop, IN.uv_TexTop)
            // Below botLimit, 100% botTexture
            : (Alti <= -_BotLimit ? tex2D(_TexBot, IN.uv_TexTop)
            // Between sideLimit and -sideLimit, 100% sideTexture
            : (Alti <= _MidLimit  Alti >= -_MidLimit ? tex2D(_TexMid, IN.uv_TexTop)
            // Above 0 outside thresholds, blend between side and top
            : (Alti > 0 ? lerp(tex2D(_TexTop, IN.uv_TexTop), tex2D(_TexMid, IN.uv_TexTop),
                                 1 - ((Alti - _MidLimit) / (_TopLimit - _MidLimit)))
            // Below 0, outside thresholds, blend between side and bot
            : lerp(tex2D(_TexBot, IN.uv_TexTop), tex2D(_TexMid, IN.uv_TexTop),
                1 - ((abs(Alti) - _MidLimit) / (abs(_BotLimit) - _MidLimit))))));
               
            o.Albedo = resultCol.rgb;
            o.Alpha = resultCol.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
	*/
}
